###
  grunt-closure-dicontainer
  https://github.com/este/grunt-closure-dicontainer

  Copyright (c) 2013 Daniel Steigerwald
  Licensed under the MIT license.
###

module.exports = (grunt) ->

  dicontainer = require '../lib'

  grunt.registerMultiTask 'closure_dicontainer', 'DI Container for Google Closure with automatic registration and strongly typed object graph resolving.', ->

    options = @options

      # Namespace for generated DI container.
      # Remember to require it in app.start: goog.require('app.diContainer');
      namespace: 'app.diContainer'

      # Default config. Can be overriden with app.diContainer factory.
      config:
        app:
          id: 'este-app'

      # Example: app.diContainer(config).esteApp().start()
      resolve: ['este.App']

      # TODO: lifestyle atd..
      # types:
      #   'este.App':
      #     arguments: ['$app.id']
      #   'este.storage.Base':
      #     bindTo:
      #       'este.storage.Rest':
      #         hasParent: 'goog.Fok'
      #       'este.storage.Rest'

    # TODO: validate passed options

    @files.forEach (file) ->
      deps = getDeps file
      dest = dicontainer options, deps
      grunt.file.write file.dest, dest
      grunt.log.writeln "File \"#{file.dest}\" created."

  getDeps = (file) ->
    deps = {}
    file.src.filter(notExistingFiles).forEach (file) -> addDeps deps, file
    deps

  notExistingFiles = (file) ->
    return true if grunt.file.exists file
    grunt.log.warn "Source file \"#{file}\" not found."
    false

  addDeps = (deps, file) ->
    goog = addDependency: (file, namespaces) ->
      deps[namespace] = absolutizePath file for namespace in namespaces
      return
    eval grunt.file.read file

  absolutizePath = (file) ->
    file.replace /\.\.\//g, ''