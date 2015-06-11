###
Creates virtual documents for additional languages based on the documents that
exist for the default language.

If a given document already really exists on disk, it won't be overwritten.
###


# Export Plugin
module.exports = (BasePlugin) ->

  path = require('path')
  fs = require('fs')
  {TaskGroup} = require('taskgroup')

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
      config = @config

      docpad.log 'debug', 'languagemaker: making language files'

      if Array.isArray(config.languages) and config.languages.length == 0
        config.languages = docpad.config.templateData.languages

      if not Array.isArray(config.languages) or not config.languages.length > 0
        throw 'languagemaker: no languages to make'

      pathStart = path.normalize "#{config.defaultLanguage}/"

      tasks = new TaskGroup(concurrency: 0).done (err) ->
        return next(err)

      docpad.getCollection('documents').findAll({relativePath: $startsWith: pathStart}).forEach (document) ->
        config.languages.forEach (lang) ->
          tasks.addTask (complete) ->
            if lang == config.defaultLanguage
              return complete()

            relativePath = document.get('relativePath').replace(pathStart, path.normalize("#{lang}/"))

            # At this point in the Docpad generation process, the
            # `relativeOutPath` attribute hasn't been set. But it's the value we
            # want to use, since the document extensions might be different in
            # the different languages (e.g., `.html.md` vs. `.html`). So we'll
            # strip down to the last extension -- which is basically the output
            # extension -- and compare using that.
            # We're going to approach this the simple way: assume there are no
            # periods (`.`) in the path -- only in the extension. If this becomes
            # too simplistic in the future, we can probably split up the path
            # using a regex something like:
            #   match(/^(.+)(\/|\\)([^\/\\\.]+)(\.[^\.]+)/)
            relativeOutPath = relativePath.split('.').slice(0, 2).join('.')

            if docpad.getCollection('documents').findOne({ relativePath: $startsWith: relativeOutPath })
              docpad.log 'info', 'languagemaker: file already exists, so not making '+ relativePath
              return complete()

            # Create the new virtual document
            newDoc = docpad.createDocument(
              isDocument: true
              encoding: 'utf8'
              relativePath: relativePath
              data: fs.readFileSync(path.resolve(
                                      process.cwd(),
                                      config.rootToDocumentsPathFragment,
                                      document.get('relativePath')))
              meta:
                language: lang
                languagemakered: yes
              )

            newDoc.action 'load', (err) ->
              if err
                return complete(err)
              docpad.getDatabase().add newDoc
              return complete()

      tasks.run()

      # Chain
      return @
