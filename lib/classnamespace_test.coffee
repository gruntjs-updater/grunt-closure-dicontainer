classNamespace = require './classnamespace'

suite 'classNamespace', ->

  test 'should camelize last namespace', ->
    namespace = classNamespace 'app'
    assert.equal namespace, 'App'

    namespace = classNamespace 'este.app'
    assert.equal namespace, 'este.App'

    namespace = classNamespace 'foo.este.app'
    assert.equal namespace, 'foo.este.App'