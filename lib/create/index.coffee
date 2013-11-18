###*
  @param {Function} createIntro
  @param {Function} createBody
  @return {string} Generated DI container source code.
###
module.exports = (createIntro, createBody) ->

  ->
    body = createBody()
    code = [
      createIntro body.required
      body.src
    ].join '\n\n'

    code: code
    required: body.required