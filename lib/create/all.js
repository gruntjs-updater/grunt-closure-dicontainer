/**
  @param {Function} createIntro
  @param {Function} createBody
  @param {Function} createOutro
  @return {string} Generated DI container source code.
*/

module.exports = function(createIntro, createBody, createOutro) {
  return function() {
    var body;
    body = createBody();
    return createIntro(body.requiredNamespaces) + body.src + createOutro();
  };
};
