###*
  @param {Function} createIntro
  @param {Function} createBody
  @param {Function} createOutro
  @return {string} Generated DI container source code.
###
module.exports = (createIntro, createBody, createOutro) ->

  ->
    body = createBody()
    introSrc = createIntro body.requiredNamespaces

    introSrc + body.src + createOutro()