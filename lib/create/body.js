var createFactoryMethodName, generateFactory;

module.exports = function(classNamespace, resolve) {
  return function() {
    var requiredNamespaces, src;
    src = generateFactory(classNamespace, resolve);
    requiredNamespaces = ['xyz.Bla', 'xyz.Foo'];
    return {
      src: src,
      requiredNamespaces: requiredNamespaces
    };
  };
};

generateFactory = function(classNamespace, resolve) {
  var factoryMethodName, namespace, src, _i, _len;
  src = '';
  for (_i = 0, _len = resolve.length; _i < _len; _i++) {
    namespace = resolve[_i];
    factoryMethodName = createFactoryMethodName(namespace);
    src += "\n/**\n * Factory for " + namespace + ".\n * @return {" + namespace + "}\n */\n" + classNamespace + ".prototype." + factoryMethodName + " = function() {\n  var xyzBla = new xyz.Bla;\n  var xyzFoo = new xyz.Foo(xyzBla);\n  return xyzFoo;\n};\n";
  }
  return src;
};

/**
  @param {string} namespace For example: foo.bla.Bar
  @return {string} For example: fooBlaBar
*/


createFactoryMethodName = function(namespace) {
  var chunk, i, name, _i, _len, _ref;
  name = '';
  _ref = namespace.split('.');
  for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
    chunk = _ref[i];
    if (i) {
      name += chunk.charAt(0).toUpperCase() + chunk.slice(1);
    } else {
      name += chunk;
    }
  }
  return name;
};
