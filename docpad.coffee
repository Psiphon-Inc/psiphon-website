# DocPad Configuration File
# http://docpad.org/docs/config

url = require('url')
cheerio = require('cheerio')
helpers = require('./helpers')


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
      ]


    # Enabled languages
    # This is the order in which they will be displayed in the language picker
    languages: ['en', 'fa', 'ar', 'zh', 'az', 'de', 'el', 'es', 'fr', 'id', 'kk', 'ko', 'hr', 'nb', 'pt_PT', 'ru', 'th', 'tk', 'tr', 'ug@Latn', 'uz@cyrillic', 'uz@Latn', 'vi']

    # Translation file location.
    translation_files:
      en: './_locales/en/messages.json'
      fa: './_locales/fa/messages.json'
      ar: './_locales/ar/messages.json'
      zh: './_locales/zh/messages.json'
      ru: './_locales/ru/messages.json'
      'uz@cyrillic': './_locales/uz@cyrillic/messages.json'
      'uz@Latn': './_locales/uz@Latn/messages.json'
      tk: './_locales/tk/messages.json'
      th: './_locales/th/messages.json'
      az: './_locales/az/messages.json'
      'ug@Latn': './_locales/ug@Latn/messages.json'
      kk: './_locales/kk/messages.json'
      es: './_locales/es/messages.json'
      vi: './_locales/vi/messages.json'
      nb: './_locales/nb/messages.json'
      fr: './_locales/fr/messages.json'
      tr: './_locales/tr/messages.json'
      de: './_locales/de/messages.json'
      el: './_locales/el/messages.json'
      fi: './_locales/fi/messages.json'
      ko: './_locales/ko/messages.json'
      pt_PT: './_locales/pt_PT/messages.json'
      hr: './_locales/hr/messages.json'
      id: './_locales/id/messages.json'

    # Translations will be loaded into this object.
    translations: {}

    # Info about all pages
    # This would be largely unnecessary if we could put metadata on layouts
    pageInfo:
      'download':
        filename: '/download.html'
        title_key: 'download-title'
        nav_title_key: 'download-nav-title'

      'user-guide':
        filename: '/user-guide.html'
        title_key: 'user-guide-title'
        nav_title_key: 'user-guide-nav-title'

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

    navLayout: [
      { name: 'download' }
      {
        name: 'resources',
        nav_title_key: 'resources-nav-title'
        subnav: [
          { name: 'user-guide' }
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

    # -----------------------------
    # Helper Functions

    # `document` arugment is optional -- if not supplied, @document will be used
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
          throw "@getPageInfo from #{arguments.callee.caller}: bad page name: #{name}"
        else
          return null
      return @pageInfo[name]

    # The title might need to be translated from a string key.
    # `document` arugment is optional -- if not supplied, @document will be used
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
        return "#{@tt 'psiphon'} | #{title}"
      else
        # if our document does not have it's own title, then we should just use the site's title
        return "#{@tt 'psiphon'}"

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


    rtl_languages: ['ar', 'fa', 'he']


    # `document` arugment is optional -- if not supplied, @document will be used
    isRTL: (document=null) ->
      if not document
        document = @document
      document.language in @rtl_languages


    # `document` arugment is optional -- if not supplied, @document will be used
    ifRTL: (rtlValue, ltrValue='', document=null) ->
      if @isRTL(document) then rtlValue else ltrValue


    languageLabel: (languageCode) ->
      map =
        "ar": "العربية"
        "cs": "Čeština"
        "de": "Deutsch"
        "el": "Ελληνικά"
        "en": "English"
        "es": "Español"
        "et": "Eesti"
        "fa": "فارسی"
        "fi": "Suomi"
        "fr": "Français"
        "hr": "Hrvatski"
        "hu": "Magyar"
        "id": "Bahasa Indonesia"
        "it": "Italiano"
        "ko": "한국말"
        "nl": "Nederlands"
        "nb": "Norsk (bokmål)"
        "pl": "Polski"
        "pt_BR": "Português(Br)"
        "pt_PT": "Português(Pt)"
        "ru": "Русский"
        "sv": "Svenska"
        "zh": "中文"
        "uz@cyrillic": "Ўзбекча"
        "uz@Latn": "O'zbekcha"
        "tk": "Türkmençe"
        "th": "ภาษาไทย"
        "az": "azərbaycan dili"
        "ug@Latn": "Uyghurche"
        "kk": "қазақ тілі"
        "vi": "Tiếng Việt"
        "tr": "Türkçe"
      if map[languageCode]
        map[languageCode]
      else
        languageCode


    # Returns the translated document object if `document` is available as a
    # translation in `lang`, otherwise returns falsy.
    documentTranslated: (document, targetLang) ->
      # document url has a leading '/'
      LANG_SPLIT_INDEX = 1
      currLang = document.url.split('/')[LANG_SPLIT_INDEX]
      return no if currLang not in @languages

      translatedURL = ['/'+targetLang].concat(document.url.split('/')[LANG_SPLIT_INDEX+1...]).join('/')
      translatedDoc = @getCollection('documents').findAllLive({url: translatedURL}).toJSON()
      return translatedDoc[0] if translatedDoc.length > 0

      return no


    # Returns a formatted date
    formatDate: (date) ->
      # Note that Node does not have the ability to properly localize dates, so
      # we're just ouputting a standard date string and then letting browser
      # code do the actual localization.
      return date.toISOString()


    # Get the language appropriate absolute URL for a language-relative URL.
    # For example `getPathURL('/download.html')` might return `/en/download.html`.
    getPageURL: (partialURL) ->
      if partialURL[0] != '/'
        throw 'partialURL must be language-absolute: ' + partialURL

      # document url has a leading '/'
      LANG_SPLIT_INDEX = 1
      targetLang = @document.url.split('/')[LANG_SPLIT_INDEX]
      if targetLang not in @languages
        # Current document isn't language-specific. Default English.
        targetLang = 'en'

      translatedURL = '/' + targetLang + partialURL
      translatedDoc = @getCollection('documents').findAllLive({url: translatedURL}).toJSON()
      return @document.pathToRoot + translatedDoc[0].url if translatedDoc.length > 0

      # There's no language-specific version of this file. Just return the argument.
      return @document.pathToRoot + partialURL


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
      database.findAllLive({layout: 'blog/post'}, [date:-1])


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

    # Server Extend
    # Used to add our own custom routes to the server before the docpad routes are added
    serverExtend: (opts) ->
      # Extract the server from the options
      {server} = opts
      docpad = @docpad

      # As we are now running in an event,
      # ensure we are using the latest copy of the docpad configuraiton
      # and fetch our urls from it
      latestConfig = docpad.getConfig()
      oldUrls = latestConfig.templateData.site.oldUrls or []
      newUrl = latestConfig.templateData.site.url

      # Redirect any requests accessing one of our sites oldUrls to the new site url
      server.use (req,res,next) ->
        if req.headers.host in oldUrls
          res.redirect(newUrl+req.url, 301)
        else
          next()

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
