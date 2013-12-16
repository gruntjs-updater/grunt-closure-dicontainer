// This file was autogenerated by grunt-closure-dicontainer task.
// Please do not edit.
goog.provide('app.DiContainer');

goog.require('App');
goog.require('app.Router');

/**
 * @constructor
 * @final
 */
app.DiContainer = function() {
  this.rules = [];
};

/**
 * Resolving rules for DI Container.
 * - resolve: Type or array of types going to be resolved.
 * - as: Which type should be returned instead.
 * - with: Named values for arguments we know in runtime therefore have
 *      to be configured in runtime too.
 * - by: A factory method for custom resolving.
 *
 * @typedef {{
 *   resolve: (Object),
 *   as: (Object|undefined),
 *   with: (Object|undefined),
 *   by: (Function|undefined)
 * }}
 */
app.DiContainer.Rule;

/**
 * @type {Array.<app.DiContainer.Rule>}
 * @private
 */
app.DiContainer.prototype.rules;

/**
 * @param {Array.<app.DiContainer.Rule>} rules
 */
app.DiContainer.prototype.configure = function(rules) {
  this.rules.push.apply(this.rules, rules);
};

/**
 * Factory for 'App'.
 * @return {App}
 */
app.DiContainer.prototype.resolveApp = function() {
  var rule = /** @type {{
    resolve: (Object),
    as: (Object|undefined),
    'with': ({
      router: (app.Router|undefined)
    }),
    by: (Function|undefined)
  }} */ (this.getRuleFor(App));
  return this.app || (this.app = new App(
    rule['with'].router || this.resolveAppRouter()
  ));
};

/**
 * @return {app.Router}
 * @private
 */
app.DiContainer.prototype.resolveAppRouter = function() {
  var rule = /** @type {{
    resolve: (Object),
    as: (Object|undefined),
    by: (Function|undefined)
  }} */ (this.getRuleFor(app.Router));
  return this.appRouter || (this.appRouter = new app.Router);
};

/**
 * @private
 */
app.DiContainer.prototype.getRuleFor = function(type) {
  var rule;
  for (var i = 0; i < this.rules.length; i++) {
    rule = this.rules[i];
    if (rule.resolve == type) break;
  }
  rule = rule || {};
  rule['with'] = rule['with'] || {};
  return rule;
};