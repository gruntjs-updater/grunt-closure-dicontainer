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
        // TODO: implement
        // this.instances.forEach(function(instance) {
        //   instance.dispose();
        // });
        // this.instances = null;
        goog.base(this, 'disposeInternal');
      };"""