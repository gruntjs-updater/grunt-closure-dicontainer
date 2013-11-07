module.exports = (diContainerClassName, resolve, typeParser, grunt) ->

  ->
    required = []
    src = ''
    # TODO: typeParser cache for all

    createFactory = (type) ->
      """
        /**
         * Factory for #{type}.
         * @return {#{type}}
         */
        #{diContainerClassName}.prototype.#{camelizeType type} = function() {
          #{createFactoryBody type}
        };
      """

    createFactoryBody = (type) ->
      lines = []
      yetCreatedTypes = []

      walk = (type, resolving) ->
        if resolving.indexOf(type) > -1
          circularDep = resolving.concat(type).join ' -> '
          fail grunt, "Can not resolve circular dependency: #{circularDep}."
          return
        resolving.push type

        return if yetCreatedTypes.indexOf(type) != -1
        yetCreatedTypes.push type

        # TODO: When transient, prevent repeated types in array.
        required.push type

        definition = typeParser type
        return if !definition

        for argument in definition.arguments
          walk argument, resolving.slice 0

        args = createArguments definition.arguments
        lines.push "var #{camelizeType type} = new #{type}#{args};"

      walk type, []

      lines.push "return #{camelizeType type};"
      lines.join '\n  '

    createArguments = (args) ->
      return '' if !args.length
      "(#{(camelizeType arg for arg in args).join ', '})"

    for type in resolve
      src += createFactory type

    required: required
    src: src

###*
  @param {string} type For example: foo.bla.Bar
  @return {string} For example: fooBlaBar
###
camelizeType = (type) ->
  camelized = ''
  for chunk, i in type.split '.'
    if i
      camelized += chunk.charAt(0).toUpperCase() + chunk.slice 1
    else
      camelized += chunk
  camelized

fail = (grunt, message) ->
  grunt.log.error message
  grunt.fail.warn 'Factory creating failed.'