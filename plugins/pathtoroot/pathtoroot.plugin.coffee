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
                # Start with the URL of the document that will contain the relative links
                documentUrl = document.get('url')

                pathToRoot = getPathToRoot(documentUrl)
                #console.log documentUrl + ' ' + pathToRoot
                document.set('pathToRoot', pathToRoot)
            return next()


# Returns the relative path from the given URL to the root.
# Will return '.' if already at root, otherwise some combination of '..'
getPathToRoot = (absolute_url) ->
    # Count how many '..' we'll need to get to the root
    depth = absolute_url.split('/').length - 1 # leading / gives us one extra

    if depth == 1
        # We're already at the root
        return '.'

    pathToRoot = []
    pathToRoot.push('..') for i in [0..depth-2]
    return pathToRoot.join('/')


test = () ->
    assert = require('assert')
    assert.equal(getPathToRoot('/'), '.')
    assert.equal(getPathToRoot('/aa.html'), '.')
    assert.equal(getPathToRoot('/aa/bb.html'), '..')
    assert.equal(getPathToRoot('/aa/bb/cc.html'), '../..')
    assert.equal(getPathToRoot('/aa/bb/dd/cc.html'), '../../..')
    console.log('tests complete')

module.exports.test = test
