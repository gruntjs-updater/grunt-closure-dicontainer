var diContainerClassName;

diContainerClassName = require('./dicontainerclassname');

suite('diContainerClassName', function() {
  return test('should camelize last name', function() {
    var name;
    name = diContainerClassName('app');
    assert.equal(name, 'App');
    name = diContainerClassName('este.app');
    assert.equal(name, 'este.App');
    name = diContainerClassName('foo.este.app');
    return assert.equal(name, 'foo.este.App');
  });
});
