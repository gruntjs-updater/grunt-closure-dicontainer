diContainerClassName = require './dicontainerclassname'

suite 'diContainerClassName', ->

  test 'should camelize last name', ->
    name = diContainerClassName 'app'
    assert.equal name, 'App'

    name = diContainerClassName 'este.app'
    assert.equal name, 'este.App'

    name = diContainerClassName 'foo.este.app'
    assert.equal name, 'foo.este.App'