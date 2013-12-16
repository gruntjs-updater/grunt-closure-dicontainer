body = require './body'

suite 'body', ->

  diContainerName = null
  resolve = null
  types = null
  typeParser = null
  grunt = null
  factory = null
  resolved = null

  setup ->
    diContainerName = 'app.DiContainer'
    resolve = ['app.A']
    types =
      'app.A':
        arguments: [
          name: 'b'
          typeExpression: 'B'
          type: 'B'
        ,
          name: 'bb'
          typeExpression: 'B'
          type: 'B'
        ,
          name: 'c'
          typeExpression: 'Array.<string>'
          type: null
        ]
      'B':
        arguments: []
    typeParser = (type) ->
      types[type]
    grunt =
      log: error: ->
      fail: warn: ->
    factory = null
    resolved = null

  resolveFactory = ->
    factory = body diContainerName, resolve, typeParser, grunt
    resolved = factory()

  arrangeErrorWarnCalls = (errorMessage) ->
    calls = ''
    grunt.log.error = (message) ->
      assert.equal message, errorMessage if errorMessage
      calls += 'error'
    grunt.fail.warn = (message) ->
      assert.equal message, 'Factory creating failed.'
      calls += 'warn'
    -> calls

  assertErrorAndWarnCalls = (calls) ->
    assert.equal calls(), 'errorwarn'

  test 'should resolve dependencies', ->
    resolveFactory()
    assert.equal resolved.src, """
      /**
       * Factory for 'app.A'.
       * @return {app.A}
       */
      app.DiContainer.prototype.resolveAppA = function() {
        var rule = /** @type {{
          resolve: (Object),
          as: (Object|undefined),
          with: ({
            b: (B|undefined)
            bb: (B|undefined)
            c: (Array.<string>|undefined)
          }),
          by: (Function|undefined)
        }} */ (this.getRuleFor(app.A));
        this.appA = this.appA || new app.A(
          rule.with.b || this.resolveB(),
          rule.with.bb || this.resolveB(),
          rule.with.c
        );
        return this.appA;
      };

      /**
       * @return {B}
       * @private
       */
      app.DiContainer.prototype.resolveB = function() {
        var rule = /** @type {{
          resolve: (Object),
          as: (Object|undefined),
          by: (Function|undefined)
        }} */ (this.getRuleFor(B));
        this.b = this.b || new B;
        return this.b;
      };
    """

  # test 'should create required', ->
  #   resolveFactory()
  #   assert.deepEqual resolved.required, ['app.A', 'B']

  # test 'should create unique required', ->
  #   types =
  #     'app.A':
  #       arguments: [
  #         name: 'b'
  #         type: 'B'
  #       ,
  #         name: 'b'
  #         type: 'B'
  #       ]
  #     'B':
  #       arguments: []
  #   resolveFactory()
  #   assert.deepEqual resolved.required, ['app.A', 'B']

  # test 'should do not generate code for missing type definition', ->
  #   resolve = ['app.iAmNotExists']
  #   resolveFactory()
  #   assert.equal resolved.src, ""

  # test 'should detect circular dependency', ->
  #   calls = arrangeErrorWarnCalls """
  #     Can't create 'app.A' as it has circular dependency: app.A -> B -> app.A.
  #   """
  #   types =
  #     'app.A':
  #       arguments: [
  #         name: 'b'
  #         type: 'B'
  #       ]
  #     'B':
  #       arguments: [
  #         name: 'a'
  #         type: 'app.A'
  #       ]
  #   resolveFactory()
  #   assertErrorAndWarnCalls calls

  # test 'should detect wrong usage', ->
  #   calls = arrangeErrorWarnCalls """
  #     Wrong DI container usage detected. Don't use DI container as service locator.
  #     The only place where DI container should be used is composition root.
  #     blog.ploeh.dk/2010/02/03/ServiceLocatorisanAnti-Pattern.
  #     blog.ploeh.dk/2011/07/28/CompositionRoot
  #   """
  #   types =
  #     'app.A':
  #       arguments: [
  #         name: 'diContainer'
  #         type: 'app.DiContainer'
  #       ]
  #     'app.DiContainer':
  #       arguments: []
  #   resolveFactory()
  #   assertErrorAndWarnCalls calls