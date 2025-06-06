#!/usr/bin/env python3
# -*- coding: utf-8 -*-

# Copyright (c) 2017, Psiphon Inc.
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

'''
Pulls and massages our translations from Transifex.

Install uv: https://github.com/astral-sh/uv?tab=readme-ov-file#installation

Then:
$ uv run transifex_pull.py

To do a brute-force upgrade of dependencies:
$ rm -rf .venv uv.lock
Then run again.
'''


import transifexlib


DEFAULT_LANGS = {
    'am': 'am',         # Amharic
    'ar': 'ar',         # Arabic
    'az@latin': 'az',   # Azerbaijani
    'be': 'be',         # Belarusian
    'bn': 'bn',         # Bengali
    'bo': 'bo',         # Tibetan
    'de': 'de',         # German
    'el_GR': 'el',      # Greek
    'es': 'es',         # Spanish
    'fa': 'fa',         # Farsi/Persian
    'fa_AF': 'fa_AF',   # Persian (Afghanistan)
    'fi_FI': 'fi',      # Finnish
    'fr': 'fr',         # French
    'hi': 'hi',         # Hindi
    'he': 'he',         # Hebrew
    'hr': 'hr',         # Croation
    'id': 'id',         # Indonesian
    'it': 'it',         # Italian
    'kk': 'kk',         # Kazak
    'km': 'km',         # Khmer
    'ko': 'ko',         # Korean
    'ky': 'ky',         # Kyrgyz
    'my': 'my',         # Burmese
    'nb_NO': 'nb',      # Norwegian
    'nl': 'nl',         # Dutch
    'om': 'om',         # Afaan Oromoo
    'pt_BR': 'pt_BR',   # Portuguese-Brazil
    'pt_PT': 'pt_PT',   # Portuguese-Portugal
    'ru': 'ru',         # Russian
    #'sn': 'sn',         # Shona
    'sw': 'sw',         # Swahili
    'tg': 'tg',         # Tajik
    'th': 'th',         # Thai
    'ti': 'ti',         # Tigrinya
    'tk': 'tk',         # Turkmen
    'tr': 'tr',         # Turkish
    #'ug': 'ug@Latn',    # Uighur (latin script)
    'uk': 'uk',         # Ukrainian
    'ur': 'ur',         # Urdu
    'uz': 'uz@Latn',    # Uzbek (latin script)
    #'uz@Cyrl': 'uz@Cyrl',    # Uzbek (latin script)
    'vi': 'vi',         # Vietnamese
    'zh': 'zh',         # Chinese (simplified)
    'zh_TW': 'zh_TW'    # Chinese (traditional)
}


def pull_translations():
    transifexlib.process_resource(
        'https://www.transifex.com/otf/Psiphon3/website-strings/',
        DEFAULT_LANGS,
        '../_locales/en/messages.json',
        lambda lang: f'../_locales/{lang}/messages.json',
        None) # no mutator
    print('website-strings DONE')


def go():
    pull_translations()
    print('FINISHED')


if __name__ == '__main__':
    go()
