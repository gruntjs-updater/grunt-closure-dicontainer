difflet = require 'difflet'
grunt = require 'grunt'

###
  ======== A Handy Little Nodeunit Reference ========
  https://github.com/caolan/nodeunit

  Test methods:
    test.expect(numAssertions)
    test.done()
  Test assertions:
    test.ok(value, [message])
    test.equal(actual, expected, [message])
    test.notEqual(actual, expected, [message])
    test.deepEqual(actual, expected, [message])
    test.notDeepEqual(actual, expected, [message])
    test.strictEqual(actual, expected, [message])
    test.notStrictEqual(actual, expected, [message])
    test.throws(block, [error], [message])
    test.doesNotThrow(block, [error], [message])
    test.ifError(value)
###

exports.closure_dicontainer =
  setUp: (done) ->
    # setup here if necessary
    done()

  default_options: (test) ->
    test.expect 1
    actual = grunt.file.read 'tmp/default_options_dicontainer.js'
    expected = grunt.file.read 'test/expected/default_options_dicontainer.js'
    # diff = difflet.compare actual, expected
    # console.log diff
    test.equal actual, expected
    test.done()