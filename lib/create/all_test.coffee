createAll = require './all'

suite 'createAll', ->

  createIntro = null
  createBody = null
  createOutro = null

  setup ->
    createIntro = -> 'intro'
    createBody = ->
      requiredNamespaces: ['xyz.Bla', 'xyz.Foo']
      src: 'body'
    createOutro = -> 'outro'

  runGenerator = ->
    createAll(createIntro, createBody, createOutro)()

  test 'should call intro with params', (done) ->
    createIntro = (p_requiredNamespaces) ->
      assert.deepEqual p_requiredNamespaces, ['xyz.Bla', 'xyz.Foo']
      done()
    runGenerator()

  test 'should generate code', ->
    assert.equal runGenerator(), 'introbodyoutro'