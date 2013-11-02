###
  grunt-closure-dicontainer
  https://github.com/este/grunt-closure-dicontainer

  Copyright (c) 2013 Daniel Steigerwald
  Licensed under the MIT license.
###

module.exports = (grunt) ->

  # dicontainer = require '../lib/dicontainer'

  grunt.registerMultiTask 'closure_dicontainer', 'DI Container for Google Closure with automatic registration and strongly typed object graph resolving.', ->

    options = @options
      ###
        Object to define what should be resolved. Key is property and value
        is name with full namespace.
      ###
      resolve:
        app: 'este.App'

    # content = dicontainer(options.depsPath, options.prefix, options.resolve)
    # grunt.file.write options.outputFile, content
    # grunt.log.writeln 'File ' + options.outputFile.yellow + ' created.'

    @files.forEach (f) ->
      src = f.src.filter((filepath) ->
        return true if grunt.file.exists filepath
        grunt.log.warn "Source file \"#{filepath}\" not found."
        false
      ).map((filepath) ->
        grunt.file.read filepath
        # TODO: resolve paths and make some global deps structure
      ).join()

      grunt.file.write f.dest, 'src'
      grunt.log.writeln "File \"#{f.dest}\" created."