Require = require('covershot').require.bind(null, require)

chai = require "chai"
expect = chai.expect
assert = chai.assert
path = require "path"

mudnames = Require "../lib/mudnames"
###
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
###
describe('mudname get class lists', () ->
  it('should give the available class list', (done) ->
    mudnames.getList((list) ->
      assert.isArray list
      assert.lengthOf list, 22
    )
  )
  it('should give the available class list from a specific directory', (done) ->
    options = {}
    mudnames.getList(options, (list) ->
      assert.isArray list
      assert.lengthOf list, 2
    )
  )
)

describe('mudname generate one name', () ->
  it('should generate a random name', (done) ->
    mudnames.generate((name) ->
      assert.typeOf name, "String"
      assert.isTrue name.length > 0
    )
  )
  it('should generate a name from a defined class', () ->
    mudnames.generate('alver-1', (name) ->
      assert.typeOf name, "String"
      assert.isTrue name.length > 0
    )
  )
)

