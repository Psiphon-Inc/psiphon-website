#!/usr/bin/env python

import subprocess

DOCPAD_ENV = 'production,static'
GENERATE_CHUNKS = 35


if __name__ == '__main__':
    # using check_output to suppress output

    subprocess.call('docpad clean --env %s' % (DOCPAD_ENV,), shell=True, stderr=subprocess.STDOUT)

    for chunk in range(1, GENERATE_CHUNKS+1):
        print 'Generating %d of %d' % (chunk, GENERATE_CHUNKS)
        subprocess.call(
            'docpad generate --cache --offline --env %s,languagesplit_%d_%d' % (DOCPAD_ENV, chunk, GENERATE_CHUNKS),
            shell=True, stderr=subprocess.STDOUT)

    print 'WEBSITE GENERATE DONE'
