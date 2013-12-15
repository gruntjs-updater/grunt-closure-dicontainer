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
    """