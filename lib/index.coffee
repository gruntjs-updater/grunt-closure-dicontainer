di = require 'di'

###
  @param {Object} options Grunt options.
  @param {Object} grunt
  @param {Object} typesPaths Key is type and value its file path.
  @param {Object} requiredBy Key is type and value array of types requiring it.
  @return {Object} Container.
###
module.exports = (options, grunt, typesPaths, requiredBy) ->

  module =
    config: ['value', options.config]
    create: ['factory', require './create']
    createBody: ['factory', require './create/body']
    createIntro: ['factory', require './create/intro']
    createOutro: ['factory', require './create/outro']
    diContainerName: ['value', options.name]
    grunt: ['value', grunt]
    readFileSync: ['value', require('fs').readFileSync]
    requiredBy: ['value', requiredBy]
    resolve: ['value', options.resolve]
    typeParser: ['factory', require './typeparser']
    typesPaths: ['value', typesPaths]

  diContainer = null
  new di.Injector([module]).invoke (create) ->
    diContainer = create()

  diContainer