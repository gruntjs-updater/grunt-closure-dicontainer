module.exports = (diContainerName, resolve, typeParser, grunt) ->

  ->
    required = {}
    src = []

    for type in resolve
      do (type, resolving = []) ->
        createPrivateFactory = !!resolving.length

        return if detectCircularDependency type, resolving, grunt
        return if detectWrongUsage type, diContainerName, resolving, grunt

        definition = typeParser type, resolving
        return if !definition

        src.push createFactoryFor type, definition.arguments, diContainerName,
          createPrivateFactory

        required[type] = true

        for argument in definition.arguments
          arguments.callee argument.type, resolving.slice 0
        return

    required: Object.keys required
    src: src.join '\n\n'

###*
  @param {string} type
  @param {Array.<string>} resolving
  @param {?} grunt
  @return {boolean}
###
detectCircularDependency = (type, resolving, grunt) ->
  if resolving.indexOf(type) > -1
    dependency = resolving.concat(type).join ' -> '
    fail grunt, """
      Can't create '#{type}' as it has circular dependency: #{dependency}.
    """
    return true
  resolving.push type
  false

###*
  @param {string} type
  @param {Array.<string>} diContainerName
  @param {Array.<string>} resolving
  @param {?} grunt
  @return {boolean}
###
detectWrongUsage = (type, diContainerName, resolving, grunt) ->
  if type == diContainerName
    fail grunt, """
      Wrong DI container usage detected. Don't use DI container as service locator.
      The only place where DI container should be used is composition root.
      blog.ploeh.dk/2010/02/03/ServiceLocatorisanAnti-Pattern.
      blog.ploeh.dk/2011/07/28/CompositionRoot
    """
    return true
  false

###*
  @param {*} type
  @param {Array.<Object>} args
  @param {string} diContainerName
  @param {boolean} isPrivate Why private? To prevent using DI container as
    service locator.
###
createFactoryFor = (type, args, diContainerName, isPrivate) ->
  src = """
    /**
     #{if !isPrivate then "* Factory for '#{type}'." else ''}
     * @return {#{type}}
     #{if isPrivate then '* @private' else ''}
     */
    #{diContainerName}.prototype.resolve#{pascalize type} = function() {
      this.#{camelize type} = this.#{camelize type} || new #{type}#{factorize args};
      return this.#{camelize type};
    };
  """
  # Remove empty lines.
  lines = (line for line in src.split '\n' when line != ' ')
  lines.join '\n'

###*
  @param {string} str foo.bla.Bar
  @return {string} fooBlaBar
###
camelize = (str) ->
  camelized = ''
  str.replace /[^\.]+/g, (m, i) ->
    char = m.charAt 0
    camelized += if i == 0 then char.toLowerCase() else char.toUpperCase()
    camelized += m.slice 1
  camelized

###*
  @param {string} str foo.bla.Bar
  @return {string} FooBlaBar
###
pascalize = (str) ->
  str = camelize str
  str.charAt(0).toUpperCase() + str.slice 1

###*
  @param {Array.<string>} args
  @return {string}
###
factorize = (args) ->
  return '' if !args.length
  args = args.map (arg) -> "this.resolve#{pascalize arg.type}();"
  """
  (
      #{args.join '\n\n'}
    )"""

fail = (grunt, message) ->
  grunt.log.error message
  grunt.fail.warn 'Factory creating failed.'