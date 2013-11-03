var createAll;

createAll = require('./all');

suite('createAll', function() {
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
        requiredNamespaces: ['xyz.Bla', 'xyz.Foo'],
        src: 'body'
      };
    };
    return createOutro = function() {
      return 'outro';
    };
  });
  runGenerator = function() {
    return createAll(createIntro, createBody, createOutro)();
  };
  test('should call intro with params', function(done) {
    createIntro = function(p_requiredNamespaces) {
      assert.deepEqual(p_requiredNamespaces, ['xyz.Bla', 'xyz.Foo']);
      return done();
    };
    return runGenerator();
  });
  return test('should generate code', function() {
    return assert.equal(runGenerator(), 'introbodyoutro');
  });
});
