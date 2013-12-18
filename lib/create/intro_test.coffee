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
       * @type {Array}
       * @private
       */
      app.DiContainer.prototype.rules;

      /**
       * Configure resolving rules for DI Container.
       * @param {...Object} var_args
       *   - resolve: Type or array of types to be resolved.
       *   - as: Which type should be return instead.
       *   - with: Named values for arguments we know in runtime therefore have
       *      to be configured in runtime too.
       *   - by: A factory method for custom resolving.
       */
      app.DiContainer.prototype.configure = function(var_args) {
        for (var i = 0; i < arguments.length; i++) {
          var rule = arguments[i];
          goog.asserts.assertObject(rule,
            'DI container: Configuration rule has to be type of object.');
          goog.asserts.assertObject(rule.resolve,
            'DI container: Rule resolve property must be type of object.');
          goog.asserts.assert(this.ruleIsWellConfigured(rule),
            'DI container: Rule has to define at least one of these props: with, as, by.');
          goog.asserts.assert(!this.ruleWasYetConfigured(rule),
            'DI container: Rule resolve prop can be configured only once.');
          this.rules.push(rule);
        }
      };
    """