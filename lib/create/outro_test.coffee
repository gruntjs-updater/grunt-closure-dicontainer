createOutro = require './outro'

suite 'createOutro', ->

  test 'should return code', ->
    assert.deepEqual createOutro('app.DiContainer')(), """
      /**
       * Dispose all instances.
       */
      app.DiContainer.prototype.disposeInternal = function() {
        // TODO:
        //  dispose disposable this.types
        //  this.types = null;
        goog.base(this, 'disposeInternal');
      };
    """