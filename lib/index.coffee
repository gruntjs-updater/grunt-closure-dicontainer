di = require 'di'

###
  @param {Object} options Grunt options.
  @param {Object} deps Key is fully qualified name and value is filepath.
  @return {string} Container source code in JavaScript.
###
module.exports = (options, deps) ->
  'src'

# var module = {
#   // 'car': ['type', Car],
#   // 'engine': ['factory', createPetrolEngine],
#   // 'power': ['value', 1184] // probably Bugatti Veyron
# };
# new di.Injector([module]).invoke(function(car) {
#   car.start();
# var output = '';
# for property in options.resolve {
#   fullqualifiedName = options.resolve[property];
#   output += makeCode(property, fullqualifiedName, deps);
# }

# makeCode = (property, fullqualifiedName, deps) ->
#   property =