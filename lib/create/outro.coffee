module.exports = (diContainerClassName) ->

  ->
    """
      /**
       * Dispose all instances.
       */
      #{diContainerClassName}.prototype.disposeInternal = function() {
        // TODO:
        //  dispose disposable this.types
        //  this.types = null;
        goog.base(this, 'disposeInternal');
      };
    """