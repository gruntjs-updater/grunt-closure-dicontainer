di = require 'di'
# getDeps = require '../getdeps'

###
  @param {string} depsPath
  @param {string} prefix
  @param {Object} resolve
  @return {string} Container source code in JavaScript.
###
module.exports = (depsPath, prefix, resolve) ->

  # # check and learn: http://docs.castleproject.org/Windsor.Registering-components.ashx
  # deps = getDeps(depsPath, prefix)
  # for property of resolve
  #   fullqualifiedName = resolve[property]

  #   # TODO: tady musi bejt vyhozenej error, grunt.error? a tohle musi jit uz
  #   # přes testy...
  #   console.log deps[fullqualifiedName]

  # # projít resolves
  # # pro každej key, value, vytvořit factory
  # # pro fullqualified name najdu soubor
  # # najdu 'foo.bla =' a nactu jeho anotace
  # # vytvorim app = new_ este.App ...
  # # _do ... přidám resolves
  'fokkk'

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