var camelizeType;

module.exports = function(diContainerClassName, resolve, resolver) {
  return function() {
    var createArguments, createFactory, createFactoryBody, required, src, type, _i, _len;
    required = [];
    src = '';
    createFactory = function(type) {
      return "/**\n * Factory for " + type + ".\n * @return {" + type + "}\n */\n" + diContainerClassName + ".prototype." + (camelizeType(type)) + " = function() {\n  " + (createFactoryBody(type)) + "\n};";
    };
    createFactoryBody = function(type) {
      var lines, walk;
      lines = [];
      walk = function(type) {
        var args, argument, definition, _i, _len, _ref;
        required.push(type);
        definition = resolver(type);
        _ref = definition["arguments"];
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          argument = _ref[_i];
          walk(argument);
        }
        args = createArguments(definition["arguments"]);
        return lines.push("var " + (camelizeType(type)) + " = new " + type + args + ";");
      };
      walk(type);
      lines.push("return " + (camelizeType(type)) + ";");
      return lines.join('\n  ');
    };
    createArguments = function(args) {
      var arg;
      if (!args.length) {
        return '';
      }
      return "(" + (((function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = args.length; _i < _len; _i++) {
          arg = args[_i];
          _results.push(camelizeType(arg));
        }
        return _results;
      })()).join(', ')) + ")";
    };
    for (_i = 0, _len = resolve.length; _i < _len; _i++) {
      type = resolve[_i];
      src += createFactory(type);
    }
    return {
      required: required,
      src: src
    };
  };
};

/**
  @param {string} type For example: foo.bla.Bar
  @return {string} For example: fooBlaBar
*/


camelizeType = function(type) {
  var camelized, chunk, i, _i, _len, _ref;
  camelized = '';
  _ref = type.split('.');
  for (i = _i = 0, _len = _ref.length; _i < _len; i = ++_i) {
    chunk = _ref[i];
    if (i) {
      camelized += chunk.charAt(0).toUpperCase() + chunk.slice(1);
    } else {
      camelized += chunk;
    }
  }
  return camelized;
};
