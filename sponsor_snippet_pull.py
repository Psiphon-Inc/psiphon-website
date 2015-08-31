#!/usr/bin/env python
# -*- coding: utf-8 -*-

# Copyright (c) 2015, Psiphon Inc.
# All rights reserved.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

"""
Tool to download, process, and distribute sponsor snippets.

Needed packages:
pip install --upgrade boto requests beautifulsoup4 html5lib python-dateutil pyopenssl ndg-httpsclient pyasn1

Conf file looks like:
    {
      "aws": {
        "access_id": "ABCD",
        "secret_key": "abcd"
      },
      "snippetJsonName": "index.json",
      "snippetHtmlName": "index.html",
      "snippets": [
        {
          "src": "http://sponsor.example.com/path/",
          "dst": {
            "bucket": "website-bucket",
            "prefix": "web/xyz/"
          }
        }
      ]
    }
"""


import subprocess
import os
import sys
import errno
import json
import base64
import boto
import argparse
import shutil
import requests
import datetime
import dateutil.parser
import dateutil.relativedelta
import dateutil.tz
from bs4 import BeautifulSoup


CONF_DIR_PREFIX = './snippet-pull'
EXTERNAL_FILE_PREFIX = 'external'
SPONSOR_SNIPPET_KEY_PREFIX = 'sponsor-snippet/'


def main(conf_file_path, silent):
    with open(conf_file_path) as conf_file:
        conf = json.load(conf_file)

    s3 = boto.connect_s3(
                conf['aws']['access_id'],
                conf['aws']['secret_key'])

    for snippet in conf['snippets']:
        while process_snippet(s3, snippet, conf, silent) is False:
            # Retry
            pass

        clean_up_snippet(s3, snippet, conf, silent)

    s3.close()


def basic_process_snippet(s3, snippet, conf, silent=False):
    """Returns True if successful, False if it should be retried, and raises
    Exception on error.
    Inlines images.
    """

    if not silent:
        print('processing %s' % (snippet['src'],))

    snippet_req = requests.get(snippet['src'])

    if not snippet_req.ok:
        raise Exception('Orig snippet request failed: %s %s for %s' % (
            snippet_req.status_code,
            snippet_req.reason,
            snippet_req.url))

    soup = BeautifulSoup(snippet_req.content, 'html5lib')

    for img in soup.find_all('img', src=True):
        img_req = requests.get(img['src'])
        b64img = base64.b64encode(img_req.content)
        data_uri = 'data:%s;base64,%s' % (img_req.headers['content-type'], b64img)
        img['src'] = data_uri

    snippet_out = unicode(soup.find('div')).encode('utf-8')

    key_name = '%s%s%s' % (
        snippet['dst']['prefix'],
        SPONSOR_SNIPPET_KEY_PREFIX,
        conf['snippetHtmlName'])

    if not silent:
        print('creating %s:%s' % (snippet['dst']['bucket'], key_name))

    bucket = s3.get_bucket(snippet['dst']['bucket'], validate=False)

    key = bucket.new_key(key_name)
    key.set_contents_from_string(snippet_out, policy='public-read')
    key.close()


def process_snippet(s3, snippet, conf, silent=False):
    """Returns True if successful, False if it should be retried, and raises
    Exception on error.
    Downloads images separately. Intended for proper sanitizing.
    """

    if not silent:
        print('processing %s' % (snippet['src'],))

    _rm_r(CONF_DIR_PREFIX)
    _makedirs(CONF_DIR_PREFIX)

    external_files_dir = os.path.join(CONF_DIR_PREFIX, EXTERNAL_FILE_PREFIX)
    _makedirs(external_files_dir)

    # There is a race condition between getting the snippet and getting the
    # images, so we're going to fetch the snippet before and after to make
    # sure it hasn't changed.

    pre_snippet_req = requests.get(snippet['src'])
    if not pre_snippet_req.ok:
        raise Exception('Orig snippet request failed: %s %s for %s' % (
            pre_snippet_req.status_code,
            pre_snippet_req.reason,
            pre_snippet_req.url))

    if not silent:
        print('pre_snippet_req obtained')

    # Download the images in the snippet using wget
    subprocess.check_output(
        'wget -E -H -k -p -P "%s" -A "jpg,jpeg,png,gif" -erobots=off "%s"' % (
            external_files_dir, snippet['src']),
        shell=True, stderr=subprocess.STDOUT)

    if not silent:
        print('external files downloaded')

    post_snippet_req = requests.get(snippet['src'])
    if not post_snippet_req.ok:
        raise Exception('Orig snippet request failed: %s %s for %s' % (
            post_snippet_req.status_code,
            post_snippet_req.reason,
            post_snippet_req.url))

    # Make sure we didn't start out with a different snippet than we ended with
    if pre_snippet_req.content != post_snippet_req.content:
        return False

    if not silent:
        print('post_snippet_req match okay')

    #
    # Send the data to S3
    #

    bucket = s3.get_bucket(snippet['dst']['bucket'], validate=False)

    # Send the images first -- better chance of failing to an okay state
    for root, dirs, files in os.walk(CONF_DIR_PREFIX):
        for name in files:
            filepath = os.path.join(root, name)
            key_name = '%s%s%s' % (
                snippet['dst']['prefix'],
                SPONSOR_SNIPPET_KEY_PREFIX,
                os.path.relpath(filepath, CONF_DIR_PREFIX).replace('\\', '/'))

            if not silent:
                print('creating %s:%s' % (snippet['dst']['bucket'], key_name))

            key = bucket.new_key(key_name)
            key.set_contents_from_filename(filepath, policy='public-read')
            key.close()

    key_name = '%s%s%s' % (
        snippet['dst']['prefix'],
        SPONSOR_SNIPPET_KEY_PREFIX,
        conf['snippetHtmlName'])

    if not silent:
        print('creating %s:%s' % (snippet['dst']['bucket'], key_name))

    key = bucket.new_key(key_name)
    key.set_contents_from_string(post_snippet_req.content, policy='public-read')
    key.close()

    _rm_r(CONF_DIR_PREFIX)

    return True


def clean_up_snippet(s3, snippet, conf, silent):
    """The external files (i.e., images) will have different names over time,
    so defunct files will build up if we don't clear them out.
    Deletes external files older than a day.
    """

    bucket = s3.get_bucket(snippet['dst']['bucket'], validate=False)
    for key in bucket.list(prefix=snippet['dst']['prefix']+SPONSOR_SNIPPET_KEY_PREFIX):
        now = datetime.datetime.now(dateutil.tz.tzutc())
        cull_date = now - dateutil.relativedelta.relativedelta(days=1)
        last_modified = dateutil.parser.parse(key.last_modified)
        if last_modified < cull_date:
            if not silent:
                print('deleting %s' % (key.name,))

            key.delete()
            key.close()


def _rm_r(path):
    if os.path.isdir(path):
        shutil.rmtree(path)
    elif os.path.exists(path):
        os.remove(path)


def _makedirs(path):
    try:
        os.makedirs(path)
    except OSError as ex:
        if ex.errno == errno.EEXIST and os.path.isdir(path):
            pass
        else:
            raise


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Update the sponsor snippets')
    parser.add_argument('--config', required=True, help='config JSON file to use')
    parser.add_argument('--cron', action='store_true', default=False, help='calling from cron; suppress output')
    args = parser.parse_args()

    main(args.config, args.cron)
