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
    createIntro: ['factory', require './create/intro']
    createBody: ['factory', require './create/body']
    createOutro: ['factory', require './create/outro']
    createAll: ['factory', require './create/all']
    # types: ['value', options.types]

  src = null

  new di.Injector([module]).invoke (createAll) ->
    src = createAll()

  src