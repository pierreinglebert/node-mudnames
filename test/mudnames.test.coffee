Require = require('covershot').require.bind(null, require)

chai = require "chai"
expect = chai.expect
assert = chai.assert
path = require "path"

mudnames = Require "../lib/mudnames"

describe('mudnames constructor', () ->
  it('should construct without args', (done) ->
    mud = new mudnames
    assert.typeOf mud, "object"
    done()
  )

  it('should construct with data folder', (done) ->
    mud = new mudnames __dirname + path.sep + 'fixtures' + path.sep + 'data'
    done()
  )
)
