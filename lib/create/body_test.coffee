createBody = require './body'

suite 'createBody', ->

  diContainerClassName = null
  resolve = null
  types = null
  typeParser = null
  grunt = null
  factory = null
  resolved = null

  setup ->
    diContainerClassName = 'app.DiContainer'
    resolve = ['app.A']
    types =
      'app.A':
        arguments: ['app.B']
      'app.B':
        arguments: []
    typeParser = (type) ->
      types[type]
    grunt =
      log: error: ->
      fail: warn: ->
    factory = null
    resolved = null

  resolveFactory = ->
    factory = createBody diContainerClassName, resolve, typeParser, grunt
    resolved = factory()

  arrangeErrorWarnCalls = (errorMessage) ->
    calls = ''
    grunt.log.error = (message) ->
      assert.equal message, errorMessage if errorMessage
      calls += 'error'
    grunt.fail.warn = (message) ->
      assert.equal message, 'Factory creating failed.'
      calls += 'warn'
    -> calls

  assertErrorAndWarnCalls = (calls) ->
    assert.equal calls(), 'errorwarn'

  test 'should resolve dependencies', ->
    resolveFactory()
    assert.equal resolved.src, """
      /**
       * Factory for app.A.
       * @return {app.A}
       */
      app.DiContainer.prototype.appA = function() {
        var appB = new app.B;
        var appA = new app.A(appB);
        return appA;
      };
    """

  test 'should return the same instance', ->
    types['app.A'] = arguments: ['app.B', 'app.B']
    resolveFactory()
    assert.equal resolved.src, """
      /**
       * Factory for app.A.
       * @return {app.A}
       */
      app.DiContainer.prototype.appA = function() {
        var appB = new app.B;
        var appA = new app.A(appB, appB);
        return appA;
      };
    """

  test 'should create required', ->
    resolveFactory()
    assert.deepEqual resolved.required, ['app.A', 'app.B']

  test 'should do not generate code for missing type definition', ->
    resolve = ['app.iAmNotExists']
    resolveFactory()
    assert.equal resolved.src, """
      /**
       * Factory for app.iAmNotExists.
       * @return {app.iAmNotExists}
       */
      app.DiContainer.prototype.appIAmNotExists = function() {
        return appIAmNotExists;
      };
    """

  test 'should handle circular dependency', ->
    calls = arrangeErrorWarnCalls """
      Can not resolve circular dependency: app.A -> app.B -> app.A.
    """
    types =
      'app.A':
        arguments: ['app.B']
      'app.B':
        arguments: ['app.A']
    resolveFactory()
    assertErrorAndWarnCalls calls