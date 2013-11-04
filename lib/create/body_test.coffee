createBody = require './body'

suite 'createBody', ->

  classNamespace = null
  resolve = null
  body = null

  setup ->
    classNamespace = 'app.DiContainer'
    resolve = ['app.feature.A']
    body = createBody(classNamespace, resolve)()

  test 'should return code', ->
    assert.deepEqual body.src, """

      /**
       * Factory for app.feature.A.
       * @return {app.feature.A}
       */
      app.DiContainer.prototype.appFeatureA = function() {
        var xyzBla = new xyz.Bla;
        var xyzFoo = new xyz.Foo(xyzBla);
        return xyzFoo;
      };

    """

  # test 'should return requiredNamespaces', ->
  #   assert.deepEqual body.requiredNamespaces, ['app.feature.A', 'app.feature.B']