###
For each English document, this plugin creates virtual documents at the root that serve
as language redirectors -- when hit, they'll send visitors to the appropriate language
page.

If a given document already really exists on disk, it won't be overwritten.
###


# Export Plugin
module.exports = (BasePlugin) ->

  path = require('path')
  {TaskGroup} = require('taskgroup')

  # Define Plugin
  class LanguageRedirector extends BasePlugin
    # Plugin Name
    name: 'languageredirector'

    # Default configuration
    config:
      defaultLanguage: 'en'
      languageRedirectLayout: '_/language-redirect'

    populateCollections: (opts, next) ->
      # We will add language-redirect pages for each language-specific page.

      # Prepare
      docpad = @docpad
      config = @config

      docpad.log 'debug', 'langredirectmaker: generating language-redirect documents'

      pathStart = path.normalize "#{config.defaultLanguage}/"

      tasks = new TaskGroup(concurrency: 1).done (err) ->
        return next(err)

      docpad.getCollection('documents').findAll({relativePath: $startsWith: pathStart}).forEach (document) ->
        tasks.addTask (complete) ->
          # document.get('relativePath') is like 'en/blog/index.html.eco'
          relativePath = document.get('relativePath').replace(pathStart, '')
          # relativePath is like 'blog/index.html.eco'
          # See the comment in languagemaker.plugin.coffee for an explanation of this
          redirectOutPath = relativePath.split('.').slice(0, 2).join('.')
          # redirectOutPath is like 'blog/index.html'

          docpad.log 'debug', "langredirectmaker: generating language-redirect document: '#{redirectOutPath}'"

          # Don't clobber an existing document
          if docpad.getCollection('documents').findOne({ relativePath: $startsWith: redirectOutPath.replace('\\', '/') })
            docpad.log 'info', "langredirectmaker: file already exists, so not making '#{redirectOutPath}'"
            return complete()

          # Create the new virtual document
          newDoc = docpad.createDocument(
            isDocument: true
            encoding: 'utf8'
            relativePath: redirectOutPath
            meta:
              layout: config.languageRedirectLayout
              targetFilename: '/'+redirectOutPath.replace('\\', '/')
              language: 'en'
            )

          newDoc.action 'load', (err) ->
            if err
              return complete(err)
            docpad.getDatabase().add newDoc

            docpad.log 'debug', "langredirectmaker: finished creating redirect for document: #{document.get('relativePath')}"

            return complete()

      tasks.run()

      # chain
      return @

