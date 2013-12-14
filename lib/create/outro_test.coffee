outro = require './outro'

suite 'outro', ->

  test 'should generate outro', ->
    src = outro 'diContainerName'
    assert.equal src(), """
      /**
       * NOTE: Do not optimize it without dead code removal etc. check.
       * @protected
       */
      diContainerName.prototype.getRuleFor = function(type) {
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