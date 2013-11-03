module.exports = (grunt) ->

  grunt.initConfig

    clean:
      options:
        force: true
      all:
        src: [
          '{lib,tasks}/**/*.js'
          'test/*.js'
          'tmp'
        ]

    coffee:
      options:
        bare: true
      all:
        files: [
          expand: true
          src: '{lib,tasks,test}/**/*.coffee'
          ext: '.js'
        ]

    esteUnitTests:
      all:
        src: '{lib,tasks}/**/*_test.js'

    # Configuration to be run (and then tested).
    closure_dicontainer:
      default_options:
        files:
          'tmp/default_options_dicontainer.js': 'test/fixtures/deps.js'

      # custom_options:
      #   files:
      #     'tmp/custom_options_dicontainer.js': 'test/fixtures/deps.js'
      #   options:
      #     values:
      #       foo: 'bla'
      #     types:
      #       app: 'este.App'
      #     factories:

    nodeunit:
      tests: [
        'test/*_test.js'
      ]

    esteWatch:
      options:
        livereload: enabled: false
        dirs: [
          '{lib,tasks,test}/**/'
        ]

      coffee: (filepath) ->
        files = [src: filepath, ext: '.js', expand: true]
        grunt.config ['coffee', 'all', 'files'], files
        ['coffee:all']

      js: (filepath) ->
        grunt.config ['esteUnitTests', 'all', 'src'], filepath
        # Because to test closure_dicontainer we need to reload task somehow,
        # and loadTasks does not help.
        ['esteUnitTests']

  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-nodeunit'
  grunt.loadNpmTasks 'grunt-este'
  grunt.loadNpmTasks 'grunt-este-watch'
  grunt.loadTasks 'tasks'

  grunt.registerTask 'default', ['build', 'esteUnitTests', 'run']
  grunt.registerTask 'build', ['clean', 'coffee']
  grunt.registerTask 'run', ['esteWatch']

  grunt.registerTask 'test', [
    'build'
    'esteUnitTests'
    'closure_dicontainer'
    'nodeunit'
  ]

  grunt.registerTask 'loadTasks', 'Need to load tasks after build', ->
