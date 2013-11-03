module.exports = function(classNamespace) {
  return function() {
    return "\n/**\n * Dispose all instances.\n */\n" + classNamespace + ".prototype.disposeInternal = function() {\n  // TODO: implement\n  // this.instances.forEach(function(instance) {\n  //   instance.dispose();\n  // });\n  // this.instances = null;\n  goog.base(this, 'disposeInternal');\n};";
  };
};
