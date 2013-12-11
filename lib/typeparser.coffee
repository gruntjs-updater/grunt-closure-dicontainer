esprima = require 'esprima'
doctrine = require 'doctrine'

module.exports = (deps, readFileSync, grunt) ->

  (type, resolving) ->
    file = deps[type]

    if !file
      fail grunt, """
        Missing '#{type}' in deps.js when resolving '#{resolving.join '\' then \''}'.
        Didn't you forget to provide type?

        goog.provide('#{type}');
      """
      return null

    try
      src = readFileSync file, 'utf8'
    catch e
      fail grunt, "File '#{file}' failed to load."
      return null

    annotation = getAnnotation file, src, type, grunt
    if !annotation
      return null

    arguments: getArguments annotation

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
  # For types without namespace.
  src.replace /var\s+$/g, ''

getArguments = (annotation) ->
  parsed = doctrine.parse "/*#{annotation}*/", unwrap: true
  fok = for tag in parsed.tags
    continue if tag.title != 'param'
    continue if tag.type.type == 'OptionalType'
    if tag.type.type == 'NonNullableType'
      tag.type.expression.name
    else
      tag.type.name

fail = (grunt, message) ->
  grunt.log.error message
  grunt.fail.warn 'Type parsing failed.'