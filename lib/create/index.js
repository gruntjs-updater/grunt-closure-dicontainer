/**
  @param {Function} resolver
  @param {Function} createIntro
  @param {Function} createOutro
  @return {string} Generated DI container source code.
*/

module.exports = function(resolver, createIntro, createOutro) {
  return function() {
    var resolved;
    resolved = resolver();
    return createIntro(resolved.required) + resolved.body + createOutro();
  };
};
