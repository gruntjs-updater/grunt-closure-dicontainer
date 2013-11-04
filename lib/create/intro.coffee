module.exports = (factoryNamespace, classNamespace) ->

  createGoogRequire = (namespace) ->
    "goog.require('#{namespace}');"

  (requiredNamespaces) ->
    """
      // This file was autogenerated by grunt-closure-dicontainer task.
      // Please do not edit.
      goog.provide('#{factoryNamespace}');

      goog.require('goog.Disposable');
      #{requiredNamespaces.map(createGoogRequire).join '\n'}

      /**
       * Factory for #{classNamespace}.
       * @param {Object=} config Server side generated app config.
       * @return {#{classNamespace}}
       */
      #{factoryNamespace} = function(config) {
        return new #{classNamespace}(config);
      };

      /**
       * DI container.
       *
       * @param {Object=} config Server side generated app config.
       * @constructor
       * @extends {goog.Disposable}
       */
      #{classNamespace} = function(config) {
        goog.base(this);
        this.config = config;
      };
      goog.inherits(#{classNamespace}, goog.Disposable);

      /**
       * @type {Object}
       */
      #{classNamespace}.prototype.config = null;

    """