var index;

index = require('./index');

suite('index', function() {
  var createIntro, createOutro, resolver, runGenerator;
  resolver = null;
  createIntro = null;
  createOutro = null;
  setup(function() {
    resolver = function() {
      return {
        required: ['app.A', 'app.B'],
        body: 'body'
      };
    };
    createIntro = function() {
      return 'intro';
    };
    return createOutro = function() {
      return 'outro';
    };
  });
  runGenerator = function() {
    return index(resolver, createIntro, createOutro)();
  };
  test('should call intro with params', function(done) {
    createIntro = function(p_required) {
      assert.deepEqual(p_required, ['app.A', 'app.B']);
      return done();
    };
    return runGenerator();
  });
  return test('should generate code', function() {
    return assert.equal(runGenerator(), 'introbodyoutro');
  });
});
