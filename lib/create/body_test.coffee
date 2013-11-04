createBody = require './body'

suite 'createBody', ->

  bodyFactory = null
  body = null

  setup ->
    bodyFactory = createBody()
    body = bodyFactory()

  # mam: factories, classNamespace, deps

  test 'should return requiredNamespaces', ->
    assert.deepEqual body.requiredNamespaces, ['xyz.Bla', 'xyz.Foo']

  test 'should return code', ->
    assert.deepEqual body.src, """

      /**
       * Factory for xyz.Foo.
       * @return {xyz.Foo}
       */
      app.DiContainer.prototype.xyzFoo = function() {
        var xyzBla = new xyz.Bla;
        var xyzFoo = new xyz.Foo(xyzBla);
        return xyzFoo;
      };

    """