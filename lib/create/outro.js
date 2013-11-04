module.exports = function(classNamespace) {
  return function() {
    return "\n/**\n * Dispose all instances.\n */\n" + classNamespace + ".prototype.disposeInternal = function() {\n  // TODO:\n  //  dispose disposable this.types\n  //  this.types = null;\n  goog.base(this, 'disposeInternal');\n};";
  };
};
