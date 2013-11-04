var camelizeNamespace, generateBody;

module.exports = function(classNamespace, resolve) {
  return function() {
    var body, namespace, required, _i, _len;
    required = [];
    body = '';
    for (_i = 0, _len = resolve.length; _i < _len; _i++) {
      namespace = resolve[_i];
      body += "\n/**\n * Factory for " + namespace + ".\n * @return {" + namespace + "}\n */\n" + classNamespace + ".prototype." + (camelizeNamespace(namespace)) + " = function() {\n  " + (generateBody()) + "\n};";
    }
    return {
      required: required,
      body: body
    };
  };
};

/**
  @param {string} namespace For example: foo.bla.Bar
  @return {string} For example: fooBlaBar
*/


camelizeNamespace = function(namespace) {
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

generateBody = function() {};
