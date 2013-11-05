var createOutro;

createOutro = require('./outro');

suite('createOutro', function() {
  return test('should return code', function() {
    return assert.deepEqual(createOutro('app.DiContainer')(), "/**\n * Dispose all instances.\n */\napp.DiContainer.prototype.disposeInternal = function() {\n  // TODO:\n  //  dispose disposable this.types\n  //  this.types = null;\n  goog.base(this, 'disposeInternal');\n};");
  });
});
