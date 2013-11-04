module.exports = (classNamespace) ->

  ->
    """


      /**
       * Dispose all instances.
       */
      #{classNamespace}.prototype.disposeInternal = function() {
        // TODO:
        //  dispose disposable this.types
        //  this.types = null;
        goog.base(this, 'disposeInternal');
      };
    """