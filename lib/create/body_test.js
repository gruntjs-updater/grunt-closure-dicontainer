var createBody;

createBody = require('./body');

suite('createBody', function() {
  var body, classNamespace, resolve;
  classNamespace = null;
  resolve = null;
  body = null;
  setup(function() {
    classNamespace = 'app.DiContainer';
    resolve = ['app.feature.A'];
    return body = createBody(classNamespace, resolve)();
  });
  return test('should return code', function() {
    return assert.deepEqual(body.src, "\n/**\n * Factory for app.feature.A.\n * @return {app.feature.A}\n */\napp.DiContainer.prototype.appFeatureA = function() {\n  var xyzBla = new xyz.Bla;\n  var xyzFoo = new xyz.Foo(xyzBla);\n  return xyzFoo;\n};\n");
  });
});
