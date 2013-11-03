di = require 'di'

###
  @param {Object} options Grunt options.
  @param {Object} deps Key is fully qualified name and value is filepath.
  @return {string} Container source code in JavaScript.
###
module.exports = (options, deps) ->

  # type, factory, value
  module =
    config: ['value', options.config]
    deps: ['value', deps]
    factories: ['value', options.factories]
    generator: ['factory', require './generator']
    intro: ['value', require './intro']
    namespace: ['value', options.namespace]
    # types: ['value', options.types]

  src = null

  new di.Injector([module]).invoke (generator) ->
    src = generator()

  src