generator = require './generator'

suite 'generator', ->

  introMock = null
  factoryNamespace = null
  classNamespace = null
  deps = null

  setup ->
    introMock = -> 'intro'
    factoryNamespace = 'app.diContainer'
    classNamespace = 'app.DiContainer'
    deps =
      'xyz.Bla': 'test/fixtures/bla.js'
      'xyz.Foo': 'test/fixtures/foo.js'

  runGenerator = ->
    generator(factoryNamespace, classNamespace, introMock, deps)()

  test 'should call intro with params', (done) ->
    introMock = (p_factoryNamespace, p_classNamespace, p_requiredNamespaces) ->
      assert.equal p_factoryNamespace, factoryNamespace
      assert.equal p_classNamespace, classNamespace
      assert.deepEqual p_requiredNamespaces, ['xyz.Bla', 'xyz.Foo']
      done()
    runGenerator()

  test 'should generate base provides and requires', ->
    assert.equal runGenerator(), """
      intro
      /**
       * Factory for xyz.Foo.
       * @return {xyz.Foo}
       */
      app.DiContainer.prototype.xyzFoo = function() {
        var xyzBla = new xyz.Bla;
        var xyzFoo = new xyz.Foo(xyzBla);
        return xyzFoo;
      };

      /**
       * Dispose all instances.
       */
      app.DiContainer.prototype.disposeInternal = function() {
        // TODO: implement
        // this.instances.forEach(function(instance) {
        //   instance.dispose();
        // });
        // this.instances = null;
        goog.base(this, 'disposeInternal');
      };"""