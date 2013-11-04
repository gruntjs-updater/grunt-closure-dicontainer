index = require './index'

suite 'index', ->

  resolver = null
  createIntro = null
  createOutro = null

  setup ->
    resolver = ->
      required: ['app.A', 'app.B']
      body: 'body'
    createIntro = -> 'intro'
    createOutro = -> 'outro'

  runGenerator = ->
    index(resolver, createIntro, createOutro)()

  test 'should call intro with params', (done) ->
    createIntro = (p_required) ->
      assert.deepEqual p_required, ['app.A', 'app.B']
      done()
    runGenerator()

  test 'should generate code', ->
    assert.equal runGenerator(), 'introbodyoutro'