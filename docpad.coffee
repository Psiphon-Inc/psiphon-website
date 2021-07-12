# DocPad Configuration File
# http://docpad.org/docs/config

url = require('url')
cheerio = require('cheerio')
helpers = require('./helpers')
process = require('process')


docpadConfig = {

  # =================================
  # Template Data
  # These are variables that will be accessible via our templates
  # To access one of these within our templates, refer to the FAQ: https://github.com/bevry/docpad/wiki/FAQ

  templateData:
    # Specify some site properties
    site:
      # The production url of our website
      url: 'https://psiphon.ca/'

      # The website description meta (for SEO).
      # Individual pages should set their own if needed. Otherwise we won't
      # have one.
      description: ''

      # The website keywords (for SEO) -- array of keyword strings
      # Individual pages should set their own if needed. Otherwise we won't
      # have one.
      keywords: ''

      companyName: "Psiphon Inc."

      # The website contact email
      email: "info@psiphon.ca"

      # Styles
      styles: [
        "/styles/twitter-bootstrap.css"
        "/vendor/highlightjs.css"
        "/vendor/slabtext.css"
        "/styles/style.css"
      ]

      # Scripts
      scripts: [
        "/vendor/modernizr-2.6.2.min.js"
        "/vendor/respond-1.3.0.min.js"
        "/vendor/jquery-1.10.2.min.js"
        "/vendor/jquery.slabtext.min.js"
        "/vendor/twitter-bootstrap/dist/js/bootstrap.min.js"
        "/vendor/caja/html-css-sanitizer-minified.js"
        "/scripts/script.js"
      ]
      externalScripts: [
        {
          src: "https://widget.psi.cash/v1/psicash.js"
          attrs: 'async defer data-cfasync="false"'
        }
      ]


    # Enabled languages
    # This is the order in which they will be displayed in the language picker
    # NOTE: Do NOT remove languages unless you're sure they're not linked to from store descriptions, privacy policies, etc.
    languages: ['en', 'fa', 'ar', 'zh', 'am', 'az', 'be', 'bn', 'bo', 'de', 'el', 'es', 'fa_AF', 'fi', 'fr', 'he', 'hi', 'hr', 'id', 'it', 'kk', 'km', 'ko', 'ky', 'my', 'nb', 'nl', 'om', 'pt_BR', 'pt_PT', 'ru', 'sw', 'tg', 'th', 'ti', 'tk', 'tr', 'uk', 'ur', 'uz', 'vi', 'zh_TW']
    # Even if this array is modified during generation, the full list will always
    # be available in @all_languages.

    rtl_languages: ['ar', 'fa', 'fa_AF', 'he', 'ur']

    # Translation file location.
    translation_files:
      am: './_locales/am/messages.json'
      ar: './_locales/ar/messages.json'
      az: './_locales/az/messages.json'
      be: './_locales/be/messages.json'
      bn: './_locales/bn/messages.json'
      bo: './_locales/bo/messages.json'
      de: './_locales/de/messages.json'
      el: './_locales/el/messages.json'
      en: './_locales/en/messages.json'
      es: './_locales/es/messages.json'
      fa: './_locales/fa/messages.json'
      fa_AF: './_locales/fa_AF/messages.json'
      fi: './_locales/fi/messages.json'
      fr: './_locales/fr/messages.json'
      he: './_locales/he/messages.json'
      hi: './_locales/hi/messages.json'
      hr: './_locales/hr/messages.json'
      id: './_locales/id/messages.json'
      it: './_locales/it/messages.json'
      kk: './_locales/kk/messages.json'
      km: './_locales/km/messages.json'
      ko: './_locales/ko/messages.json'
      ky: './_locales/ky/messages.json'
      my: './_locales/my/messages.json'
      nb: './_locales/nb/messages.json'
      nl: './_locales/nl/messages.json'
      om: './_locales/om/messages.json'
      pt_BR: './_locales/pt_BR/messages.json'
      pt_PT: './_locales/pt_PT/messages.json'
      ru: './_locales/ru/messages.json'
      sw: './_locales/sw/messages.json'
      tg: './_locales/tg/messages.json'
      th: './_locales/th/messages.json'
      ti: './_locales/ti/messages.json'
      tk: './_locales/tk/messages.json'
      tr: './_locales/tr/messages.json'
      uk: './_locales/uk/messages.json'
      ur: './_locales/ur/messages.json'
      uz: './_locales/uz@Latn/messages.json'
      vi: './_locales/vi/messages.json'
      zh: './_locales/zh/messages.json'
      zh_TW: './_locales/zh_TW/messages.json'

    # Translations will be loaded into this object.
    translations: {}

    # Info about all pages
    # This would be largely unnecessary if we could put metadata on layouts
    pageInfo:
      'download':
        filename: '/download.html'
        title_key: 'download-title'
        nav_title_key: 'download-nav-title'

      'faq':
        filename: '/faq.html'
        title_key: 'faq-title'
        nav_title_key: 'faq-nav-title'

      'sponsor':
        filename: '/sponsor.html'
        title_key: 'sponsor-title'
        nav_title_key: 'sponsor-nav-title'

      'blog-index':
        filename: '/blog/index.html'
        title_key: 'blog-index-title'
        nav_title_key: 'blog-index-nav-title'

      'privacy':
        filename: '/privacy.html'
        title_key: 'privacy-title'
        nav_title_key: 'privacy-nav-title'

      'license':
        filename: '/license.html'
        title_key: 'license-title'
        nav_title_key: 'license-nav-title'

      'open-source':
        filename: '/open-source.html'
        title_key: 'open-source-title'
        nav_title_key: 'open-source-nav-title'

      'privacy-bulletin':
        filename: '/privacy-bulletin.html'
        title_key: 'privacy-bulletin-title'
        nav_title_key: 'privacy-bulletin-nav-title'

      'about':
        filename: '/about.html'
        title_key: 'about-title'
        nav_title_key: 'about-nav-title'

      'psiphon-guide':
        filename: '/psiphon-guide.html'
        title_key: 'psiphon-guide-title'
        nav_title_key: 'psiphon-guide-nav-title'

    navLayout: [
      { name: 'download' }
      {
        name: 'resources',
        nav_title_key: 'resources-nav-title'
        subnav: [
          { name: 'psiphon-guide' }
          { name: 'faq' }
          { name: 'blog-index' }
          { name: 'privacy' }
          { name: 'license' }
          { name: 'open-source' }
          { name: 'about' }
        ]
      }
      # { name: 'sponsor', additional_classes: ['show-if-not-sponsored', 'hidden'] }
    ]

    downloads:
      windows: '/psiphon3.exe'
      android: '/PsiphonAndroid.apk'
      email: 'get@psiphon3.com'
      playstore: 'https://play.google.com/store/apps/details?id=com.psiphon3'
      playstorePro: 'https://play.google.com/store/apps/details?id=com.psiphon3.subscription'
      playstoreDevPage: 'https://play.google.com/store/apps/developer?id=Psiphon+Inc.'
      iosBrowserAppStore: 'https://apps.apple.com/app/psiphon-browser/id1193362444'
      iosVpnAppStore: 'https://apps.apple.com/app/psiphon/id1276263909'
      macosVpnAppStore: 'https://apps.apple.com/app/psiphon/id1276263909'

    # -----------------------------
    # Helper Functions

    # `document` argument is optional -- if not supplied, @document will be used
    getPageInfoKeyFromDocument: (document) ->
      if not document
        document = @document

      path = require 'path'
      return document.relativeBase.split(path.sep).slice(1).join('-')

    # `name` is optional. If not defined, current document will be used.
    # Throws exception if `name` not found and throwIfNotFound is true.
    getPageInfo: (name, throwIfNotFound = true) ->
      name = name or @getPageInfoKeyFromDocument()

      if name not of @pageInfo
        if throwIfNotFound
          err = "@getPageInfo from '#{arguments.callee.caller}': bad page name: '#{name}'"
          console.log err
          throw err
        else
          return null
      return @pageInfo[name]

    # The title might need to be translated from a string key.
    # `document` argument is optional -- if not supplied, @document will be used
    getTitle: (document) ->
      if not document
        document = @document

      # An explicit page title should only be present in rare circumstances, as
      # it will not be in the string table and so no get translated normally.
      # The only current use for this is blog post titles.
      if document.title?
        return document.title

      title_key = document.title_key
      if not title_key?
        title_key = @getPageInfo(@getPageInfoKeyFromDocument(document)).title_key

      if title_key?
        return @tt title_key

      throw "#{document.name} has no title"
      return ''

    # Get the prepared site/document title
    # Often we would like to specify particular formatting to our page's title
    # we can apply that formatting here
    getPreparedMetaTitle: ->
      if @document.meta_title_key
        title = @tt(@document.meta_title_key)
      else
        title = @getTitle()

      if title
        return "Psiphon | #{title}"
      else
        # if our document does not have it's own title, then we should just use the site's title
        return "Psiphon"

    # Get the prepared site/document description
    getPreparedDescription: ->
      # if we have a document description, then we should use that, otherwise use the site's description
      if @document.description_key
        return @tt(@document.description_key)
      else
        return @site.description

    # Get the prepared site/document keywords
    getPreparedKeywords: ->
      # Merge the document keywords with the site keywords
      if @document.keywords_keys
        page_keywords = @document.keywords_keys.map((kk) => @tt(kk))
        return page_keywords.concat(@site.keywords).join(',')
      else
        return @site.keywords.join(',')

    # Translate the given key into the language of the current document.
    # Fails back to English if the key is not found.
    tt: (key) ->
      fallback_language = 'en'
      if @translations[@document.language][key]?
        return @translations[@document.language][key].message
      else if @translations[fallback_language][key]?
        return @translations[fallback_language][key].message
      console.log "bad translation key: #{key}"
      throw "bad translation key: #{key}"

    # Translate the desired URL into a language-specific URL.
    # If there is no language-specific URL, then the English or non-language-specific
    # fallback will be used.
    ttURL: (key) ->
      fallback_language = 'en'

      key_decomposition = key.match /^(.+)\.([^\.]+)$/
      key_url_stem = key_decomposition[1]
      key_url_ext = key_decomposition[2]

      target_url = "#{key_url_stem}.#{@document.language}.#{key_url_ext}"
      fallback_url = "#{key_url_stem}.#{fallback_language}.#{key_url_ext}"
      no_lang_fallback_url = key
      fallback_url_found = no
      no_lang_fallback_url_found = no

      # Look for a translated file
      for file in @getCollection('files').toJSON()
        if file.url == target_url
          # Translated file exists
          return file.url
        else if file.url == fallback_url
          # Found the fallback -- remember for later
          fallback_url_found = yes
        else if file.url == no_lang_fallback_url
          # Found the no-lang fallback -- remember for later
          no_lang_fallback_url_found = yes

      if not fallback_url_found and not no_lang_fallback_url_found
        throw "bad translation for URL: #{key}"

      if fallback_url_found then fallback_url else no_lang_fallback_url


    # `document` argument is optional -- if not supplied, @document will be used
    isRTL: (document=null) ->
      if not document
        document = @document
      document.language in @rtl_languages


    # `document` argument is optional -- if not supplied, @document will be used
    ifRTL: (rtlValue, ltrValue='', document=null) ->
      if @isRTL(document) then rtlValue else ltrValue


    languageLabel: (languageCode) ->
      map =
        "am": "አማርኛ"
        "ar": "العربية"
        "az": "azərbaycan dili"
        "be": "Беларуская"
        "bn": "বাংলা"
        "bo": "བོད་ཡིག"
        "cs": "Čeština"
        "de": "Deutsch"
        "el": "Ελληνικά"
        "en": "English"
        "es": "Español"
        "et": "Eesti"
        "fa": "فارسی"
        "fa_AF": "ﻑﺍﺮﺳی ﺩﺭی"
        "fi": "Suomi"
        "fr": "Français"
        "he": "עברית"
        "hi": "हिन्दी"
        "hr": "Hrvatski"
        "hu": "Magyar"
        "id": "Bahasa Indonesia"
        "it": "Italiano"
        "kk": "қазақ тілі"
        "km": "ភាសាខ្មែរ"
        "ko": "한국말"
        "ky": "Кыргызча"
        "my": "မြန်မာဘာသာ"
        "nb": "Norsk (bokmål)"
        "nl": "Nederlands"
        "om": "Afaan Oromo"
        "pl": "Polski"
        "pt_BR": "Português (Brasil)"
        "pt_PT": "Português (Portugal)"
        "ru": "Русский"
        "sv": "Svenska"
        "sw": "Kiswahili"
        "tg": "Тоҷикӣ"
        "th": "ภาษาไทย"
        "ti": "ትግርኛ"
        "tk": "Türkmençe"
        "tr": "Türkçe"
        "ug@Latn": "Uyghurche"
        "uk": "Українська"
        "ur": "اُردُو"
        "uz": "O'zbekcha"
        "uz@Cyrl": "Ўзбекча"
        "uz@Latn": "O'zbekcha"
        "vi": "Tiếng Việt"
        "zh": "简体中文"
        "zh_TW": "繁体中文"
      if map[languageCode]
        map[languageCode]
      else
        languageCode


    # Given a full or partial `url`, returns a full URL in the desired language.
    # If `targetLang` is not provided, the full URL will be in the current document's
    # language; otherwise the full URL will be in the specified language.
    # Note that `url` must start with '/'.
    # Examples (ignoring `pathToRoot` considerations):
    #   `getFullTranslatedURL('/download.html')` will return `/zh/download.html` if the current document language is 'zh'.
    #   `getFullTranslatedURL('/en/download.html')` will return `/zh/download.html` if the current document language is 'zh'.
    #   `getFullTranslatedURL('/download.html', 'kk')` will return `/kk/download.html`.
    #   `getFullTranslatedURL('/en/download.html', 'kk')` will return `/kk/download.html`.
    # ASSUMPTION: Only URLs that will be translated will be passed in. There is
    # no check to verify that this resulting URL is for a valid document.
    getFullTranslatedURL: (url, targetLang) ->
      if url[0] != '/'
        throw "url must start with '/': #{url}"

      targetLang = targetLang || @document.language || 'en'

      urlSplit = url.split('/').slice(1) # slicing off the initial empty string (due to leading '/'')

      # If `url` has a language in its path, remove it.
      urlLang = urlSplit[0]
      if urlLang in @all_languages
        url = '/' + urlSplit.slice(1).join('/')

      fullTranslatedURL = "#{@document.pathToRoot}/#{targetLang}#{url}"
      return fullTranslatedURL


    # Returns a formatted date
    formatDate: (date) ->
      # Note that Node does not have the ability to properly localize dates, so
      # we're just ouputting a standard date string and then letting browser
      # code do the actual localization.
      return date.toISOString()


    getIdForDocument: (document) ->
      hostname = url.parse(@site.url).hostname
      date = document.date.toISOString().split('T')[0]
      path = document.url
      "tag:#{hostname},#{date}:#{path}"


    # Makes URLs in blog feed content absolute.
    fixBlogFeedUrls: (content) ->
      baseUrl = @site.url
      regex = /^(http|https|ftp|mailto):/
      $ = cheerio.load(content)
      $('img').each ->
        $img = $(@)
        src = $img.attr('src')
        $img.attr('src', url.resolve(baseUrl, src)) unless regex.test(src)
      $('a').each ->
        $a = $(@)
        href = $a.attr('href')
        $a.attr('href', url.resolve(baseUrl, href)) unless regex.test(href)
      return $.html()


    # Makes necessary modifications to a rendered blog post to make it suitable
    # for inclusion in the blog Atom/RSS feed.
    preparePostForBlogFeed: (contentRendered) ->
      #$ = cheerio.load(contentRendered)
      #contentRendered = $('article').html()
      return @fixBlogFeedUrls(contentRendered)


    # Simply exposes url.resolve
    urlResolve: (from, to) ->
      url.resolve(from, to)


  # =================================
  # Collections
  # These are special collections that our website makes available to us

  collections:
    # NOTE: This isn't just provide a collection of pages -- it's also (primarily)
    # used to derive the language from the page path and set it as the default
    # metadata.
    # Derived from: https://gist.github.com/balupton/4166806
    pages: (database) ->
      lang_dirs = ('/'+lang+'/' for lang in @config.templateData.languages)
      lang_regex = ('^'+lang_dir for lang_dir in lang_dirs).join('|')

      @getCollection('documents').createChildCollection()
        .setFilter 'search', (model) ->
          return false if not model.get('url')

          lang_match = model.get('url').match(lang_regex)
          return false if not lang_match

          lang = lang_match[0].replace(/^\/|\/$/g, '')
          model.setMetaDefaults { language: lang }
          true

    posts: (database) ->
      database.findAllLive({layout: '_/blog/post'}, [date:-1])


  # =================================
  # Plugins

  plugins:
    fattrimmer:
      fat: [
        /\/_/  # files and directories with leading underscore
        /^\/vendor\/twitter-bootstrap\/(?!dist\/)/  # Twitter Bootstrap files that aren't in the "dist" folder
      ]


  # =================================
  # DocPad Events

  # Here we can define handlers for events that DocPad fires
  # You can find a full listing of events on the DocPad Wiki
  events:

    renderBefore: (opts, next) ->
      # Load the translations from locale JSON files.
      fs = require 'fs'

      for lang of opts.templateData.translation_files
        langJSON = fs.readFileSync opts.templateData.translation_files[lang]
        try
          opts.templateData.translations[lang] = JSON.parse(langJSON)
        catch error
          # `docpad.log` doesn't seem to properly output something here
          console.log "\n\nERROR: Language JSON fail: #{lang}: #{error}\n"
          throw error

      next()

    renderDocument: (opts) ->
      helpers.handleRenderDocument(opts)

    docpadReady: (opts) ->
      opts.docpad.config.templateData.all_languages = opts.docpad.config.templateData.languages

      # We have a magic environment parameter that allows us to split the language
      # generation into pieces, thereby limiting memory usage. For example,
      # `--env languagesplit_2_5` will split the language list into 5 parts, and
      # only generate the languages in the 2nd part.
      if not opts.docpad.config.env
        @docpad.log('Not splitting languages: no env')
        return @

      SPLIT_REGEX = /languagesplit_(\d+)_(\d+)/
      splitMatch = opts.docpad.config.env.match(SPLIT_REGEX)
      if not splitMatch
        @docpad.log('Not splitting languages: no languagesplit')
        return @

      currLangSplit = parseInt(splitMatch[1]) - 1 # zero-based
      totalLangSplits = parseInt(splitMatch[2])

      if not totalLangSplits > opts.docpad.config.templateData.languages.length
        @docpad.fatal('docpadReady: cannot have more splits than languages')
        process.exit(1)
        return @

      if not currLangSplit > totalLangSplits
        @docpad.fatal('docpadReady: currLangSplit > totalLangSplits')
        process.exit(1)
        return @

      # Adapted from https://stackoverflow.com/a/2136090/729729
      strideSlice = (arr, start, stride) ->
        out = []
        i = start
        while i < arr.length
          out.push arr[i]
          i += stride
        out
      chunkify = (list, chunkSize) ->
        out = []
        i = 0
        while i < chunkSize
          out.push strideSlice(list, i, chunkSize)
          i++
        out

      langChunks = chunkify(opts.docpad.config.templateData.languages, totalLangSplits)

      langs = langChunks[currLangSplit]

      @docpad.log('Splitting languages; #langs:', opts.docpad.config.templateData.languages.length, '#splits:', totalLangSplits, 'currentSplit:', currLangSplit+1, 'currentLangs:', langs)

      if langs.length == 0
        @docpad.log('docpadReady: no languages to generate, probably because the splits are too small (so maybe we are done!)')
        process.exit(0)
        return @

      opts.docpad.config.templateData.languages = langs

      @

  # =================================
  # DocPad Environments

  environments:
    fastbuild:
      enabledPlugins:
        languagemaker: false

  # =================================
  # Other DocPad config

  ignoreCustomPatterns: /\.orig$|^_/
}


# Export our DocPad Configuration
module.exports = docpadConfig
