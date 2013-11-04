module.exports = (classNamespace, resolve) ->

  ->
    src = generateFactory classNamespace, resolve
    requiredNamespaces = ['xyz.Bla', 'xyz.Foo']

    src: src
    requiredNamespaces: requiredNamespaces

generateFactory = (classNamespace, resolve) ->
  src = ''
  for namespace in resolve
    factoryMethodName = createFactoryMethodName namespace
    src += """


      /**
       * Factory for #{namespace}.
       * @return {#{namespace}}
       */
      #{classNamespace}.prototype.#{factoryMethodName} = function() {
        var xyzBla = new xyz.Bla;
        var xyzFoo = new xyz.Foo(xyzBla);
        return xyzFoo;
      };

    """
  src

###*
  @param {string} namespace For example: foo.bla.Bar
  @return {string} For example: fooBlaBar
###
createFactoryMethodName = (namespace) ->
  name = ''
  for chunk, i in namespace.split '.'
    if i
      name += chunk.charAt(0).toUpperCase() + chunk.slice 1
    else
      name += chunk
  name