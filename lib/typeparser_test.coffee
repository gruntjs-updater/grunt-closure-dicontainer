typeParser = require './typeparser'

suite 'typeParser', ->

  deps = null
  readFileSync = null
  resolve = null

  setup ->
    deps =
      'app.A': 'app/a.js'
      'app.B': 'app/b.js'
    readFileSync = (file) ->
      sources =
        'app/a.js': """
          /**
           * @param {app.B} B
           * @param {app.B} B
           * @constructor
           */
          app.A = function(b, b) {}
        """

        'app/b.js': """
          /**
           * @constructor
           */
          app.B = function() {}
        """

      sources[file]
    resolve = typeParser deps, readFileSync

  test 'should resolve app.A', ->
    resolved = resolve 'app.A'
    assert.deepEqual resolved,
      arguments: ['app.B', 'app.B']

  test 'should resolve app.B', ->
    resolved = resolve 'app.B'
    assert.deepEqual resolved,
      arguments: []

  # test 'should throw exception? grunt error? or what', ->
  #   resolved = resolve 'app.bbb'
  #   assert.deepEqual resolved,
  #     arguments: []