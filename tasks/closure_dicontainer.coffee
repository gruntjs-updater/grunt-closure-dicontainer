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
      ###
        Object to define what should be resolved. Key is property and value
        is name with full namespace.
      ###
      resolve:
        app: 'este.App'

    @files.forEach (file) ->
      deps = getDeps file
      dest = dicontainer deps, options
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