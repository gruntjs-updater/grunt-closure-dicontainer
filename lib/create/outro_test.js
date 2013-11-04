var createOutro;

createOutro = require('./outro');

suite('createOutro', function() {
  var classNamespace;
  classNamespace = null;
  setup(function() {
    return classNamespace = 'ap.DiContainer';
  });
  return test('should return code', function() {
    return assert.deepEqual(createOutro(classNamespace)(), "\n/**\n * Dispose all instances.\n */\nap.DiContainer.prototype.disposeInternal = function() {\n  // TODO:\n  //  dispose disposable this.types\n  //  this.types = null;\n  goog.base(this, 'disposeInternal');\n};");
  });
});
