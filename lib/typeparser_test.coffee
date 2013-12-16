typeParser = require './typeparser'

suite 'typeParser', ->

  deps = null
  sources = null
  readFileSync = null
  grunt = null

  setup ->
    deps =
      'app.A': 'app/a.js'
      'B': 'app/b.js'
    sources =
      'app/a.js': """
        /**
         * @param {B} b
         * @param {B} b
         * @constructor
         */
        app.A = function(
      """

      'app/b.js': """
        /**
         * @constructor
         */
        var B = function() {}
      """
    readFileSync = (file) ->
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

  arrangeType = (type, src) ->
    deps[type] = 'foo'
    sources['foo'] = src

  test 'should parse app.A', ->
    parsed = parse 'app.A'
    assert.deepEqual parsed,
      arguments: [
        name: 'b'
        typeExpression: 'B'
        type: 'B'
      ,
        name: 'b'
        typeExpression: 'B'
        type: 'B'
      ]

  test 'should parse B', ->
    parsed = parse 'B'
    assert.deepEqual parsed,
      arguments: []

  test 'should handle deps.js missing type definition', ->
    calls = arrangeErrorWarnCalls """
      Missing 'app.C' in deps.js when resolving 'foo'.
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
       * @param {B} b
       * @param {B} b
       * @constructor
       */
      fok.A = function(
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
      app.A = function(
    """
    parsed = parse 'app.A'
    assertNullResultWithErrorAndWarnCalls calls, parsed

  test 'should handle missing any annotation in source', ->
    calls = arrangeErrorWarnCalls "Type 'app.A' annotation not found in file: 'app/a.js'."
    readFileSync = (file) -> """
      app.A = function(
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
      app.A = function(
    """
    parsed = parse 'app.A'
    assertNullResultWithErrorAndWarnCalls calls, parsed

  test 'should ignore optional types', ->
    arrangeType 'app.C', """
      /**
       * @param {Foo=} foo
       * @constructor
       */
      app.C = function(
    """
    parsed = parse 'app.C'
    assert.deepEqual parsed,
      arguments: []

  test 'should handle NonNullableType types', ->
    arrangeType 'app.D', """
      /**
       * @param {!Foo} foo
       * @constructor
       */
      app.D = function(
    """
    parsed = parse 'app.D'
    assert.deepEqual parsed,
      arguments: [
        name: 'foo'
        typeExpression: '!Foo'
        type: 'Foo'
      ]

  test 'should ignore not yet resolvable', ->
    arrangeType 'Foo', """
      /**
       * @param {Array.<Element>} elements
       * @param {*} bla
       * @param {?} c
       * @param {function():number} d
       * @constructor
       */
      Foo = function(
    """
    parsed = parse 'Foo'
    assert.deepEqual parsed,
      arguments: [
        name: 'elements'
        typeExpression: 'Array.<Element>'
        type: null
      ,
        name: 'bla'
        typeExpression: '*'
        type: null
      ,
        name: 'c'
        typeExpression: '?'
        type: null
      ,
        name: 'd'
        typeExpression: 'function():number'
        type: null
      ]