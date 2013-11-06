esprima = require 'esprima'
doctrine = require 'doctrine'

module.exports = (deps, readFileSync) ->

  (type) ->
    file = deps[type]
    # TODO: error if file isn't is in deps
    src = readFileSync file, 'utf8'
    # TODO: error if file not found
    annotation = getAnnotation src, type
    # TODO: error if type annotation not found, via TDD ofc
    arguments: getArguments annotation

getAnnotation = (src, type) ->
  typeIndex = src.indexOf "#{type} ="
  # TODO: error if type not found, via TDD ofc
  srcWhereLastCommentIsTypeAnnotation = src.slice 0, typeIndex
  syntax = esprima.parse srcWhereLastCommentIsTypeAnnotation,
    range: true
    comment: true
  syntax.comments[syntax.comments.length - 1].value

getArguments = (annotation) ->
  parsed = doctrine.parse "/*#{annotation}*/", unwrap: true
  # # TODO: error if error
  for tag in parsed.tags
    continue if tag.title != 'param'
    tag.type.name