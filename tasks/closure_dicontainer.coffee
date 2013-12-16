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

      # DI container class name. Remember to require it in app.main:
      # goog.require('app.DiContainer');
      name: 'app.DiContainer'

      # Types to be resolved with autogenerated factory.
      # How to use it: new app.DiContainer().resolveApp();
      # NOTE: We can not define types to be resolved at runtime, because
      # goog.require has to be defined at design time. Preloading all
      # possible requires is not a viable for performance reasons.
      resolve: ['App']

      # Prefix for deps.js.
      prefix: '../../../../'

    @files.forEach (file) =>
      deps = getDeps file
      container = dicontainer options, deps, grunt
      return if @errorCount
      grunt.file.write file.dest, container.code
      updateDeps file, container.required, options.prefix, options.name
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
      deps[namespace] = unrelativize file for namespace in namespaces
      return
    eval grunt.file.read file

  # Remove '../../../../'.
  unrelativize = (file) ->
    file.replace /\.\.\//g, ''

  updateDeps = (file, required, prefix, name) ->
    depsPath = file.src[0]
    src = grunt.file.read depsPath
    line = [
      "goog.addDependency('#{prefix}#{file.dest}', "
      "['#{name}'], "
      "['#{required.join '\', \''}']);"
    ].join ''
    return if src.indexOf(line) > -1

    src += line + '\n'
    grunt.file.write depsPath, src
    grunt.log.writeln "File \"#{depsPath}\" created."