module.exports = (diContainerName) ->

  createGoogRequire = (namespace) ->
    "goog.require('#{namespace}');"

  (requiredNamespaces) ->
    requiredNamespaces = requiredNamespaces.slice 0
    requiredNamespaces.sort()

    """
      // This file was autogenerated by grunt-closure-dicontainer task.
      // Please do not edit.
      goog.provide('#{diContainerName}');

      #{requiredNamespaces.map(createGoogRequire).join '\n'}

      /**
       * @constructor
       * @final
       */
      #{diContainerName} = function() {
        this.rules = [];
      };

      /**
       * @type {Array}
       * @private
       */
      #{diContainerName}.prototype.rules;

      /**
       * Configure resolving rules for DI Container.
       * @param {...Object} var_args
       *   - resolve: Type or array of types to be resolved.
       *   - as: Which type should be return instead.
       *   - with: Named values for arguments we know in runtime therefore have
       *      to be configured in runtime too.
       *   - by: A factory method for custom resolving.
       */
      #{diContainerName}.prototype.configure = function(var_args) {
        for (var i = 0; i < arguments.length; i++)
          this.rules.push(arguments[i]);
      };
    """