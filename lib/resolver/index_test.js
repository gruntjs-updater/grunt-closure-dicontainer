var index;

index = require('./index');

suite('index', function() {
  var classNamespace, factory, resolve;
  classNamespace = null;
  resolve = null;
  factory = null;
  setup(function() {
    classNamespace = 'app.DiContainer';
    resolve = ['app.A'];
    return factory = index(classNamespace, resolve);
  });
  return test('should create body', function() {
    var resolved;
    resolved = factory();
    return assert.equal(resolved.body, "\n/**\n * Factory for app.A.\n * @return {app.A}\n */\napp.DiContainer.prototype.appA = function() {\n  var appB = new app.B;\n  var appA = new app.A(appB);\n  return appA;\n};");
  });
});
