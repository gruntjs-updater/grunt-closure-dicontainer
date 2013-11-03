var createBody;

createBody = require('./body');

suite('createBody', function() {
  var body, bodyFactory;
  bodyFactory = null;
  body = null;
  setup(function() {
    bodyFactory = createBody();
    return body = bodyFactory();
  });
  test('should return requiredNamespaces', function() {
    return assert.deepEqual(body.requiredNamespaces, ['xyz.Bla', 'xyz.Foo']);
  });
  return test('should return code', function() {
    return assert.deepEqual(body.src, "\n/**\n * Factory for xyz.Foo.\n * @return {xyz.Foo}\n */\napp.DiContainer.prototype.xyzFoo = function() {\n  var xyzBla = new xyz.Bla;\n  var xyzFoo = new xyz.Foo(xyzBla);\n  return xyzFoo;\n};\n");
  });
});
