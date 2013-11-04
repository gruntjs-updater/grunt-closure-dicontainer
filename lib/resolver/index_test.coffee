index = require './index'

suite 'index', ->

  classNamespace = null
  resolve = null
  factory = null

  setup ->
    classNamespace = 'app.DiContainer'
    resolve = ['app.A']
    factory = index classNamespace, resolve

  test 'should create body', ->
    resolved = factory()
    assert.equal resolved.body, """

      /**
       * Factory for app.A.
       * @return {app.A}
       */
      app.DiContainer.prototype.appA = function() {
        var appB = new app.B;
        var appA = new app.A(appB);
        return appA;
      };"""