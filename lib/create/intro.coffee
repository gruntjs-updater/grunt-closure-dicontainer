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
       */
      #{diContainerName} = function() {
        this.rules = [];
      };

      /**
       * Resolving rules for DI Container.
       * - resolve: Type or array of types going to be resolved.
       * - as: Which type should be returned instead.
       * - with: Named values for arguments we know in runtime therefore have
       *      to be configured in runtime too.
       * - by: A factory method for custom resolving.
       * @typedef {{
       *   resolve: (Object),
       *   as: (Object|undefined),
       *   with: (Object|undefined),
       *   by: (Function|undefined)
       * }}
       */
      #{diContainerName}.Rule;

      /**
       * @type {Array.<#{diContainerName}.Rule>}
       * @protected
       */
      #{diContainerName}.prototype.rules;

      /**
       * @param {Array.<#{diContainerName}.Rule>} rules
       */
      #{diContainerName}.prototype.configure = function(rules) {
        this.rules.push.apply(this.rules, rules);
      };
    """