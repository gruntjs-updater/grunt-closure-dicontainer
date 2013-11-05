var createBody;

createBody = require('./body');

suite('createBody', function() {
  var diContainerClassName, factory, resolve, resolver;
  diContainerClassName = null;
  resolve = null;
  resolver = null;
  factory = null;
  setup(function() {
    diContainerClassName = 'app.DiContainer';
    resolve = ['app.A'];
    resolver = function(type) {
      var types;
      types = {
        'app.A': {
          "arguments": ['app.B']
        },
        'app.B': {
          "arguments": []
        }
      };
      return types[type];
    };
    return factory = createBody(diContainerClassName, resolve, resolver);
  });
  test('should create src', function() {
    var resolved;
    resolved = factory();
    return assert.equal(resolved.src, "/**\n * Factory for app.A.\n * @return {app.A}\n */\napp.DiContainer.prototype.appA = function() {\n  var appB = new app.B;\n  var appA = new app.A(appB);\n  return appA;\n};");
  });
  return test('should create required', function() {
    var resolved;
    resolved = factory();
    return assert.deepEqual(resolved.required, ['app.A', 'app.B']);
  });
});
