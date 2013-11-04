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
    create: ['factory', require './create']
    createIntro: ['factory', require './create/intro']
    createOutro: ['factory', require './create/outro']
    deps: ['value', deps]
    factoryNamespace: ['value', options.namespace]
    resolve: ['value', options.resolve]
    resolver: ['factory', require './resolver']
    # types: ['value', options.types]

  src = null

  new di.Injector([module]).invoke (createAll) ->
    src = createAll()

  src