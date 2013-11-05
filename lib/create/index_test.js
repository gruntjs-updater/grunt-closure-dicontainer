var index;

index = require('./index');

suite('index', function() {
  var createBody, createIntro, createOutro, runGenerator;
  createIntro = null;
  createBody = null;
  createOutro = null;
  setup(function() {
    createIntro = function() {
      return 'intro';
    };
    createBody = function() {
      return {
        required: ['app.A', 'app.B'],
        src: 'body'
      };
    };
    return createOutro = function() {
      return 'outro';
    };
  });
  runGenerator = function() {
    return index(createIntro, createBody, createOutro)();
  };
  test('should call intro with params', function(done) {
    createIntro = function(p_required) {
      assert.deepEqual(p_required, ['app.A', 'app.B']);
      return done();
    };
    return runGenerator();
  });
  return test('should generate code', function() {
    return assert.equal(runGenerator(), 'intro\n\nbody\n\noutro');
  });
});
