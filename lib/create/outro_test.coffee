createOutro = require './outro'

suite 'createOutro', ->

  classNamespace = null

  setup ->
    classNamespace = 'ap.DiContainer'

  test 'should return code', ->
    assert.deepEqual createOutro(classNamespace)(), """

      /**
       * Dispose all instances.
       */
      ap.DiContainer.prototype.disposeInternal = function() {
        // TODO:
        //  dispose disposable this.types
        //  this.types = null;
        goog.base(this, 'disposeInternal');
      };
    """