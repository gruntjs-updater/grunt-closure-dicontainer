module.exports = (classNamespace, resolve) ->

  ->
    required = []
    body = ''

    for namespace in resolve
      body += """


        /**
         * Factory for #{namespace}.
         * @return {#{namespace}}
         */
        #{classNamespace}.prototype.#{camelizeNamespace namespace} = function() {
          #{generateBody()}
        };"""

    required: required
    body: body

###*
  @param {string} namespace For example: foo.bla.Bar
  @return {string} For example: fooBlaBar
###
camelizeNamespace = (namespace) ->
  name = ''
  for chunk, i in namespace.split '.'
    if i
      name += chunk.charAt(0).toUpperCase() + chunk.slice 1
    else
      name += chunk
  name

generateBody = ->
  # [
  #   'var appB = new app.B;'
  #   'var appA = new app.A(appB);'
  #   'return appA;'
  # ].join '\n  '