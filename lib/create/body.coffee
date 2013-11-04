module.exports = ->

  ->
    requiredNamespaces: ['xyz.Bla', 'xyz.Foo']
    src: """

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