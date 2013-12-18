module.exports = (diContainerName) ->

  ->
    """
      /**
       * @private
       */
      #{diContainerName}.prototype.getRuleFor = function(type) {
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
       * @param {Object} rule
       * @return {boolean}
       * @private
       */
      #{diContainerName}.prototype.ruleIsWellConfigured = function(rule) {
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
      #{diContainerName}.prototype.ruleWasYetConfigured = function(newRule) {
        return this.rules.some(function(rule) {
          return rule.resolve == newRule.resolve;
        });
      };
    """