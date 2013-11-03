###*
  @param {string} factoryNamespace
  @param {string} classNamespace
  @param {Function} intro
  @param {Object} deps
  @return {string} Generated DI container source code.
###
module.exports = (factoryNamespace, classNamespace, intro, deps) ->

  ->

    requiredNamespaces = []
    requiredNamespaces.push key for key, value of deps

    intro(factoryNamespace, classNamespace, requiredNamespaces) + """

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