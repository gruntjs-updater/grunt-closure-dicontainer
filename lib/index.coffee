di = require 'di'

###
  @param {Object} options Grunt options.
  @param {Object} deps Key is fully qualified name and value is filepath.
  @param {Object} grunt
  @return {Object} Container.
###
module.exports = (options, deps, grunt) ->

  module =
    config: ['value', options.config]
    create: ['factory', require './create']
    createBody: ['factory', require './create/body']
    createIntro: ['factory', require './create/intro']
    createOutro: ['factory', require './create/outro']
    deps: ['value', deps]
    diContainerName: ['value', options.name]
    grunt: ['value', grunt]
    readFileSync: ['value', require('fs').readFileSync]
    resolve: ['value', options.resolve]
    typeParser: ['factory', require './typeparser']

  diContainer = null
  new di.Injector([module]).invoke (create) ->
    diContainer = create()

  diContainer