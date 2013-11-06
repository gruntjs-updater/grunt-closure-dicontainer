di = require 'di'

###
  @param {Object} options Grunt options.
  @param {Object} deps Key is fully qualified name and value is filepath.
  @return {string} Container source code in JavaScript.
###
module.exports = (options, deps) ->

  module =
    config: ['value', options.config]
    create: ['factory', require './create']
    createBody: ['factory', require './create/body']
    createIntro: ['factory', require './create/intro']
    createOutro: ['factory', require './create/outro']
    deps: ['value', deps]
    readFileSync: ['value', require('fs').readFileSync]
    diContainerClassName: ['value',
      require('./create/dicontainerclassname') options.factoryName]
    diContainerFactoryName: ['value', options.factoryName]
    resolve: ['value', options.resolve]
    typeParser: ['factory', require './typeparser']
    # types: ['value', options.types]

  src = null
  new di.Injector([module]).invoke (create) ->
    src = create()

  src