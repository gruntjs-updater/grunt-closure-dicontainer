esprima = require 'esprima'
doctrine = require 'doctrine'

module.exports = (readFileSync, grunt, typesPaths) ->

  (type) ->
    file = typesPaths[type]
    return null if !file

    try
      src = readFileSync file, 'utf8'
    catch e
      fail grunt, "File '#{file}' failed to load."
      return null

    annotation = getAnnotation file, src, type, grunt
    if !annotation
      return null

    getDefinition annotation, typesPaths

getAnnotation = (file, src, type, grunt) ->
  typeIndex = src.indexOf "#{type} ="

  if typeIndex == -1
    fail grunt, "Type '#{type}' definition not found in file: '#{file}'."
    return

  src = stripCodeAfterAnnotation src, typeIndex

  try
    syntax = esprima.parse src,
      range: true
      comment: true
      tokens: true
  catch e
    fail grunt, """
      Esprima failed to parse type '#{type}'.
      #{e.message}
    """
    return

  lastComment = syntax.comments[syntax.comments.length - 1]
  lastToken = syntax.tokens[syntax.tokens.length - 1]
  lastCommentBelongToType =
    lastComment && !lastToken ||
    (lastToken && lastComment.range[1] > lastToken.range[1])
  if !lastCommentBelongToType
    fail grunt, "Type '#{type}' annotation not found in file: '#{file}'."
    return

  lastComment.value

stripCodeAfterAnnotation = (src, typeIndex) ->
  src = src.slice 0, typeIndex
  # For namespace-less types.
  src.replace /var\s+$/g, ''

getDefinition = (annotation, typesPaths) ->
  parsed = doctrine.parse "/*#{annotation}*/", unwrap: true

  arguments: getArguments parsed.tags, typesPaths
  invokeAs: invokeAs parsed.tags

getArguments = (tags, typesPaths) ->
  for tag in tags
    continue if tag.title != 'param'
    continue if tag.type.type == 'OptionalType'

    name: tag.name
    typeExpression: doctrine.type.stringify tag.type, compact: true
    type: getArgumentType tag, typesPaths

getArgumentType = (tag, typesPaths) ->
  return null if tag.type.type not in [
    'NameExpression'
    'OptionalType'
    'NonNullableType'
  ]
  type = if tag.type.type == 'NameExpression'
    tag.type.name
  else
    tag.type.expression.name
  return null if !typesPaths[type]
  type

invokeAs = (tags) ->
  for tag in tags
    return 'class' if tag.title == 'constructor'
    return 'interface' if tag.title == 'interface'
    return 'function' if tag.title == 'type' && (
      tag.type.name == 'Function' ||
      tag.type.type == 'FunctionType')
  'value'

fail = (grunt, message) ->
  grunt.log.error message
  grunt.fail.warn 'Type parsing failed.'