
# Export Plugin
module.exports = (BasePlugin) ->
    # Define Plugin
    class FatTrimmer extends BasePlugin
        # Plugin Name
        name: 'fattrimmer'

        # Default configuration
        config:
            fat: []

        # Rendering is done, but writing hasn't happened yet.
        # Check for file that match criteria and exclude them from writing.
        writeBefore: (opts, next) ->
            # Prepare
            docpad = @docpad
            docpad.log 'debug', 'Trimming the fat'

            config = @config
            if not Array.isArray(config.fat)
                config.fat = if config.fat then [config.fat] else []

            opts.collection.forEach (document) ->
                return if not document.get('write')

                for fatCheck in config.fat
                    if document.get('url').match fatCheck
                        document.set('write', false)
                        return

            return next()
