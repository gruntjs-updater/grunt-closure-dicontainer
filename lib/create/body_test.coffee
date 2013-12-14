body = require './body'

suite 'body', ->

  diContainerName = null
  resolve = null
  types = null
  typeParser = null
  grunt = null
  factory = null
  resolved = null

  setup ->
    diContainerName = 'app.DiContainer'
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
    factory = body diContainerName, resolve, typeParser, grunt
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
      app.DiContainer.prototype.resolveAppA = function() {
        this.appB = new app.B;
        this.appA = new app.A(this.appB);
        return this.appA;
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
      app.DiContainer.prototype.resolveAppA = function() {
        this.appB = new app.B;
        this.appA = new app.A(this.appB, this.appB);
        return this.appA;
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
      app.DiContainer.prototype.resolveAppIAmNotExists = function() {
        return this.appIAmNotExists;
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