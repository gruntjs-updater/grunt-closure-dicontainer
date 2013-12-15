typeParser = require './typeparser'

suite 'typeParser', ->

  deps = null
  readFileSync = null
  grunt = null

  setup ->
    deps =
      'app.A': 'app/a.js'
      'B': 'app/b.js'
    readFileSync = (file) ->
      sources =
        'app/a.js': """
          /**
           * @param {B} b
           * @param {B} b
           * @constructor
           */
          app.A = function(b, b) {}
        """

        'app/b.js': """
          /**
           * @constructor
           */
          var B = function() {}
        """

        'app/c.js': """
          /**
           * @param {Foo=} foo
           * @constructor
           */
          app.C = function(foo) {}
        """

        'app/d.js': """
          /**
           * @param {!Foo} foo
           * @constructor
           */
          app.D = function(foo) {}
        """
      sources[file]
    grunt =
      log: error: ->
      fail: warn: ->

  parse = (type, resolving) ->
    typeParser(deps, readFileSync, grunt) type, resolving

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
      arguments: [
        name: 'b'
        type: 'B'
      ,
        name: 'b'
        type: 'B'
      ]

  test 'should parse B', ->
    parsed = parse 'B'
    assert.deepEqual parsed,
      arguments: []

  test 'should handle deps.js missing type definition', ->
    calls = arrangeErrorWarnCalls """
      Missing 'app.C' in deps.js when resolving 'foo' then 'bla'.
      Didn't you forget to provide type?

      goog.provide('app.C');
    """
    parsed = parse 'app.C', ['foo', 'bla']
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
       * @param {B} B
       * @param {B} B
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

  test 'should ignore optional types', ->
    deps['app.C'] = 'app/c.js'
    parsed = parse 'app.C'
    assert.deepEqual parsed,
      arguments: []

  test 'should handle NonNullableType types', ->
    deps['app.D'] = 'app/d.js'
    parsed = parse 'app.D'
    assert.deepEqual parsed,
      arguments: [
        name: 'foo'
        type: 'Foo'
      ]