module.exports = (classNamespace) ->

  ->
    """


      /**
       * Dispose all instances.
       */
      #{classNamespace}.prototype.disposeInternal = function() {
        // TODO: implement
        // this.instances.forEach(function(instance) {
        //   instance.dispose();
        // });
        // this.instances = null;
        goog.base(this, 'disposeInternal');
      };"""