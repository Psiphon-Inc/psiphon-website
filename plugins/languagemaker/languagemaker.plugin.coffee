###
Creates virtual documents for additional languages based on the documents that
exist for the default language.

If a given document already really exists on disk, it won't be overwritten.
###


# Export Plugin
module.exports = (BasePlugin) ->

  path = require('path')
  fs = require('fs')

  # Define Plugin
  class LanguageMaker extends BasePlugin
    # Plugin Name
    name: 'languagemaker'

    # Default configuration
    config:
      defaultLanguage: 'en'
      languages: []  # if left empty, @docpad.config.templateData.languages will be used
      rootToDocumentsPathFragment: 'src/documents'

    # This is to prevent/detect recursive firings of ContextualizeAfter event
    contextualizeAfterLock: false

    populateCollections: (opts, next) ->
      # Prepare
      docpad = @docpad
      docpad.log 'debug', 'languagemaker: making language files'

      database = docpad.getDatabase()

      config = @config

      if Array.isArray(config.languages) and config.languages.length == 0
        config.languages = docpad.config.templateData.languages

      if not Array.isArray(config.languages) or not config.languages.length > 0
        throw 'languagemaker: no languages to make'

      pathStart = path.normalize "#{config.defaultLanguage}/"

      docpad.getCollection('documents').findAll({relativePath: $startsWith: pathStart}).forEach (document) ->
        config.languages.forEach (lang) ->
          return if lang == config.defaultLanguage

          relativePath = document.get('relativePath').replace(pathStart, path.normalize("#{lang}/"))

          # Don't overwrite the file if it already exists
          if docpad.getCollection('documents').findOne({ relativePath: relativePath })
            docpad.log 'info', 'languagemaker: file already exists, so not making '+ relativePath
            return

          # Create the new virtual document
          newDoc = @docpad.createDocument(
            isDocument: true
            encoding: 'utf8'
            relativePath: relativePath
            data: fs.readFileSync(path.resolve(
                                    process.cwd(),
                                    config.rootToDocumentsPathFragment,
                                    document.get('relativePath')))
            meta:
              language: lang
            )

          database.add newDoc

      next()
