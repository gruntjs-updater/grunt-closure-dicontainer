module.exports = function(diContainerClassName) {
  return function() {
    return "/**\n * Dispose all instances.\n */\n" + diContainerClassName + ".prototype.disposeInternal = function() {\n  // TODO:\n  //  dispose disposable this.types\n  //  this.types = null;\n  goog.base(this, 'disposeInternal');\n};";
  };
};
