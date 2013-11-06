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

      # DI container factory name.
      # Remember to require it in app.start: goog.require('app.diContainer');
      factoryName: 'app.diContainer'

      prefix: '../../../../'

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
      container = dicontainer options, deps
      grunt.file.write file.dest, container.code
      updateDeps file, container.required, options.prefix, options.factoryName
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
      deps[namespace] = fixPaths file for namespace in namespaces
      return
    eval grunt.file.read file

  fixPaths = (file) ->
    # ../../../../
    file.replace /\.\.\//g, ''

  updateDeps = (file, required, prefix, factoryName) ->
    depsPath = file.src[0]
    src = grunt.file.read depsPath
    line = [
      "goog.addDependency('#{prefix}#{file.dest}', "
      "['#{factoryName}'], "
      "['#{required.join '\', \''}']);"
    ].join ''
    return if src.indexOf(line) > -1

    src += '\n' + line
    grunt.file.write depsPath, src