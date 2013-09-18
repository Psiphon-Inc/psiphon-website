#
# Copyright Adam Pritchard, Proven Security Solutions Inc. 2013
# MIT License : http://adampritchard.mit-license.org/
#


# Export Plugin
module.exports = (BasePlugin) ->
    # Define Plugin
    class PathToRoot extends BasePlugin
        # Plugin Name
        name: 'pathtoroot'

        # Parsing all files has finished
        renderBefore: (opts,next) ->
            # Prepare
            docpad = @docpad
            docpad.log 'debug', 'Creating paths to root'

            opts.templateData.relativeToRoot = (path) ->
              @document.pathToRoot + path

            documents = docpad.getCollection('documents')

            # Find documents
            documents.forEach (document) ->
                # Prepare
                documentUrl = document.get('url')
                depth = documentUrl.split('/').length - 1 # leading / gives us one extra
                pathToRoot = ['.']
                if depth > 1
                    pathToRoot.push('..') for i in [0..depth-2]
                #console.log documentUrl + ' ' + pathToRoot.join('/')
                document.set('pathToRoot', pathToRoot.join('/'))
            return next()
