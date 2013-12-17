module.exports = (diContainerName, resolve, typeParser, grunt) ->

  ->
    required = {}
    src = []

    for typeExpression in resolve
      do (typeExpression, resolving = []) ->
        # TODO: Handle type expressions.
        type = typeExpression
        return if detectCircularDependency type, resolving, grunt
        return if detectWrongUsage type, diContainerName, resolving, grunt
        return if required[type]

        definition = typeParser type, resolving
        return if !definition

        required[type] = true
        resolving.push type

        factory = createFactoryFor type, definition.arguments, diContainerName,
          resolving.length > 1
        src.push factory

        for argument in definition.arguments
          continue if !argument.type
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
      Wrong DI container usage detected. Please do not use DI container as
      service locator. The only right place for DI container is
      composition root.

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
      var rule = /** @type {{
        resolve: (Object),
        as: (Object|undefined),
        #{createWithFor args}
        by: (Function|undefined)
      }} */ (this.getRuleFor(#{type}));
      return this.#{camelize type} || (this.#{camelize type} = new #{type}#{factorize args});
    };
  """
  # Remove empty lines.
  lines = (line for line in src.split '\n' when line.trim())
  lines.join '\n'

###*
  @param {Array} args
###
createWithFor = (args) ->
  return '' if !args.length
  lines = for arg in args
    "#{arg.name}: (#{arg.typeExpression}|undefined)"

  """
  with: ({
        #{lines.join ',\n\n      '}
      }),
  """

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
  lines = args.map (arg) ->
    line = "rule['with'].#{arg.name} || "
    if arg.type
      line += "this.resolve#{pascalize arg.type || ''}()"
    else
      line += "void 0"
    line

  """
  (
      #{lines.join ',\n\n    '}
    )
  """

fail = (grunt, message) ->
  grunt.log.error message
  grunt.fail.warn 'Factory creating failed.'