createBody = require './body'

suite 'createBody', ->

  diContainerClassName = null
  resolve = null
  resolver = null
  factory = null

  setup ->
    diContainerClassName = 'app.DiContainer'
    resolve = ['app.A']
    resolver = (type) ->
      types =
        'app.A':
          arguments: ['app.B', 'app.B']
        'app.B':
          arguments: []
      types[type]
    factory = createBody diContainerClassName, resolve, resolver

  test 'should create src', ->
    resolved = factory()
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
    resolved = factory()
    assert.deepEqual resolved.required, ['app.A', 'app.B']