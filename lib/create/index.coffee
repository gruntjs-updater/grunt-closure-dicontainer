###*
  @param {Function} resolver
  @param {Function} createIntro
  @param {Function} createOutro
  @return {string} Generated DI container source code.
###
module.exports = (resolver, createIntro, createOutro) ->

  ->
    resolved = resolver()
    createIntro(resolved.required) + resolved.body + createOutro()