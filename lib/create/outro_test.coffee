outro = require './outro'

suite 'outro', ->

  test 'should generate outro', ->
    src = outro 'app.DiContainer'
    assert.equal src(), """
      /**
       * @private
       */
      app.DiContainer.prototype.getRuleFor = function(type) {
        var rule;
        for (var i = 0; i < this.rules.length; i++) {
          rule = this.rules[i];
          if (rule.resolve == type) break;
        }
        rule = rule || {};
        rule['with'] = rule['with'] || {};
        return rule;
      };

      /**
       * @param {!Function} type
       * @param {Array=} args
       * @return {?}
       * @private
       */
      app.DiContainer.prototype.createInstance = function(type, args) {
        var createArgs = [type];
        if (args) createArgs.push.apply(createArgs, args);
        return goog.functions.create.apply(null, createArgs);
      };

      /**
       * @param {Object} rule
       * @return {boolean}
       * @private
       */
      app.DiContainer.prototype.ruleIsWellConfigured = function(rule) {
        if (rule['with'] || rule.by || rule.as) {
          if (rule['with']) goog.asserts.assertObject(rule['with'],
            'DI container: rule.with property must be type of object.');
          if (rule['as']) goog.asserts.assertObject(rule.as,
            'DI container: rule.as property must be type of object.');
          if (rule['by']) goog.asserts.assertFunction(rule.by,
            'DI container: rule.by property must be type of function.');
          return true;
        }
        return false;
      };

      /**
       * @param {Object} newRule
       * @return {boolean}
       * @private
       */
      app.DiContainer.prototype.ruleNotYetConfigured = function(newRule) {
        return !this.rules.some(function(rule) {
          return rule.resolve == newRule.resolve;
        });
      };"""