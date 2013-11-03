di = require 'di'

###
  @param {Object} options Grunt options.
  @param {Object} deps Key is fully qualified name and value is filepath.
  @return {string} Container source code in JavaScript.
###
module.exports = (options, deps) ->

  # type, factory, value
  module =
    classNamespace: ['value', require('./classnamespace')(options.namespace)]
    config: ['value', options.config]
    deps: ['value', deps]
    factories: ['value', options.factories]
    factoryNamespace: ['value', options.namespace]
    generator: ['factory', require './generator']
    intro: ['value', require './generators/intro']
    # types: ['value', options.types]

  src = null

  new di.Injector([module]).invoke (generator) ->
    src = generator()

  src