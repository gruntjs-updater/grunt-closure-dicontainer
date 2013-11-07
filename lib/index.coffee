di = require 'di'

###
  @param {Object} options Grunt options.
  @param {Object} deps Key is fully qualified name and value is filepath.
  @param {Object} grunt
  @return {string} Container source code in JavaScript.
###
module.exports = (options, deps, grunt) ->

  module =
    # types: ['value', options.types]
    config: ['value', options.config]
    create: ['factory', require './create']
    createBody: ['factory', require './create/body']
    createIntro: ['factory', require './create/intro']
    createOutro: ['factory', require './create/outro']
    deps: ['value', deps]
    diContainerClassName: ['value',require('./create/dicontainerclassname') options.factoryName]
    diContainerFactoryName: ['value', options.factoryName]
    grunt: ['value', grunt]
    readFileSync: ['value', require('fs').readFileSync]
    resolve: ['value', options.resolve]
    typeParser: ['factory', require './typeparser']

  diContainer = null
  new di.Injector([module]).invoke (create) ->
    diContainer = create()

  diContainer