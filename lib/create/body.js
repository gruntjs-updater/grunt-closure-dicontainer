module.exports = function() {
  return function() {
    return {
      requiredNamespaces: ['xyz.Bla', 'xyz.Foo'],
      src: "\n/**\n * Factory for xyz.Foo.\n * @return {xyz.Foo}\n */\napp.DiContainer.prototype.xyzFoo = function() {\n  var xyzBla = new xyz.Bla;\n  var xyzFoo = new xyz.Foo(xyzBla);\n  return xyzFoo;\n};\n"
    };
  };
};
