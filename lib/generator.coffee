###*
  @param {string} namespace
  @param {Function} intro
  @param {Object} deps
  @return {string} Generated DI container source code.
###
module.exports = (namespace, intro, deps) ->

  classNamespace = createClassNamespace namespace

  ->

    requiredNamespaces = []
    requiredNamespaces.push key for key, value of deps

    intro(namespace, classNamespace, requiredNamespaces) + """

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

###*
  @param {string} namespace
  @return {string}
###
createClassNamespace = (namespace) ->
  names = namespace.split '.'
  lastName = names.pop()
  lastName = lastName.charAt(0).toUpperCase() + lastName.slice 1
  names.push lastName
  names.join '.'