intro = require './intro'

suite 'intro', ->

  diContainerName = null
  requiredNamespaces = null

  setup ->
    diContainerName = 'app.DiContainer'
    requiredNamespaces = ['Foo', 'Bla']

  test 'should generate intro with sorted requires', ->
    src = intro(diContainerName) requiredNamespaces
    assert.equal src, """
      // This file was autogenerated by grunt-closure-dicontainer task.
      // Please do not edit.
      goog.provide('app.DiContainer');

      goog.require('Bla');
      goog.require('Foo');

      /**
       * @constructor
       * @final
       */
      app.DiContainer = function() {
        this.rules = [];
      };

      /**
       * Resolving rules for DI Container.
       * - resolve: Type or array of types going to be resolved.
       * - as: Which type should be returned instead.
       * - with: Named values for arguments we know in runtime therefore have
       *      to be configured in runtime too.
       * - by: A factory method for custom resolving.
       *
       * @typedef {{
       *   resolve: (Object),
       *   as: (Object|undefined),
       *   with: (Object|undefined),
       *   by: (Function|undefined)
       * }}
       */
      app.DiContainer.Rule;

      /**
       * @type {Array.<app.DiContainer.Rule>}
       * @private
       */
      app.DiContainer.prototype.rules;

      /**
       * @param {Array.<app.DiContainer.Rule>} rules
       */
      app.DiContainer.prototype.configure = function(rules) {
        this.rules.push.apply(this.rules, rules);
      };
    """