// This file was autogenerated by grunt-closure-dicontainer task.
// Please do not edit.
goog.provide('app.DiContainer');

goog.require('este.App');
goog.require('este.Router');

/**
 * @param {Object=} data Server side data.
 * @constructor
 */
app.DiContainer = function(data) {
  if (data)
    this.data = data;
};

/**
 * @type {Object}
 */
app.DiContainer.prototype.data = null;

/**
 * Factory for este.App.
 * @return {este.App}
 */
app.DiContainer.prototype.esteApp = function() {
  this.esteRouter = new este.Router;
  this.esteApp = new este.App(this.esteRouter);
  return this.esteApp;
};