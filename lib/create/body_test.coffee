createBody = require './body'

suite 'createBody', ->

  diContainerClassName = null
  resolve = null
  typeParser = null
  factory = null
  resolved = null

  setup ->
    diContainerClassName = 'app.DiContainer'
    resolve = ['app.A']
    typeParser = (type) ->
      types =
        'app.A':
          arguments: ['app.B', 'app.B']
        'app.B':
          arguments: []
      types[type]
    factory = null
    resolved = null

  resolveFactory = ->
    factory = createBody diContainerClassName, resolve, typeParser
    resolved = factory()

  test 'should create simple factory', ->
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

  test 'should handle falsy type definition', ->
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