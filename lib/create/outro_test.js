var createOutro;

createOutro = require('./outro');

suite('createOutro', function() {
  var classNamespace;
  classNamespace = null;
  setup(function() {
    return classNamespace = 'ap.DiContainer';
  });
  return test('should return code', function() {
    return assert.deepEqual(createOutro(classNamespace)(), "\n/**\n * Dispose all instances.\n */\nap.DiContainer.prototype.disposeInternal = function() {\n  // TODO: implement\n  // this.instances.forEach(function(instance) {\n  //   instance.dispose();\n  // });\n  // this.instances = null;\n  goog.base(this, 'disposeInternal');\n};");
  });
});
