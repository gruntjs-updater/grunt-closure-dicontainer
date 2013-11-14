typeParser = require './typeparser'

suite 'typeParser', ->

  deps = null
  readFileSync = null
  grunt = null

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
    grunt =
      log: error: ->
      fail: warn: ->

  parse = (type) ->
    typeParser(deps, readFileSync, grunt) type

  arrangeErrorWarnCalls = (errorMessage) ->
    calls = ''
    grunt.log.error = (message) ->
      assert.equal message, errorMessage if errorMessage
      calls += 'error'
    grunt.fail.warn = (message) ->
      assert.equal message, 'Type parsing failed.'
      calls += 'warn'
    -> calls

  assertNullResultWithErrorAndWarnCalls = (calls, parsed) ->
    assert.equal calls(), 'errorwarn'
    assert.isNull parsed

  test 'should parse app.A', ->
    parsed = parse 'app.A'
    assert.deepEqual parsed,
      arguments: ['app.B', 'app.B']

  test 'should parse app.B', ->
    parsed = parse 'app.B'
    assert.deepEqual parsed,
      arguments: []

  test 'should handle deps.js missing type definition', ->
    calls = arrangeErrorWarnCalls """
      Missing 'app.C' definition in deps.js file.
      You probably forgot to write 'goog.provide('app.C');'.
    """
    parsed = parse 'app.C'
    assertNullResultWithErrorAndWarnCalls calls, parsed

  test 'should handle missing file', ->
    calls = arrangeErrorWarnCalls "File 'app/a.js' failed to load."
    readFileSync = (file) -> throw new Error 'anything wrong'
    parsed = parse 'app.A'
    assertNullResultWithErrorAndWarnCalls calls, parsed

  test 'should handle missing type definition in source', ->
    calls = arrangeErrorWarnCalls "Type 'app.A' definition not found in file: 'app/a.js'."
    readFileSync = (file) -> """
      /**
       * @param {app.B} B
       * @param {app.B} B
       * @constructor
       */
      fok.A = function(b, b) {}
    """
    parsed = parse 'app.A'
    assertNullResultWithErrorAndWarnCalls calls, parsed

  test 'should handle esprima parser error', ->
    calls = arrangeErrorWarnCalls """
      Esprima failed to parse type 'app.A'.
      Line 2: Unexpected end of input
    """
    readFileSync = (file) -> """
      !
      app.A = function(b, b) {}
    """
    parsed = parse 'app.A'
    assertNullResultWithErrorAndWarnCalls calls, parsed

  test 'should handle missing any annotation in source', ->
    calls = arrangeErrorWarnCalls "Type 'app.A' annotation not found in file: 'app/a.js'."
    readFileSync = (file) -> """
      app.A = function(b, b) {}
    """
    parsed = parse 'app.A'
    assertNullResultWithErrorAndWarnCalls calls, parsed

  test 'should handle missing type annotation in source', ->
    calls = arrangeErrorWarnCalls "Type 'app.A' annotation not found in file: 'app/a.js'."
    readFileSync = (file) -> """
      /**
       * @type {string}
       */
      var a;
      app.A = function(b, b) {}
    """
    parsed = parse 'app.A'
    assertNullResultWithErrorAndWarnCalls calls, parsed

  # NOTE: It seems impossible to break parser. I tried almost any wrong syntax.
  # test 'should handle doctrine parser error', ->