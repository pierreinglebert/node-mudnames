Require = require('covershot').require.bind(null, require)

chai = require "chai"
expect = chai.expect
assert = chai.assert
path = require "path"

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
describe('mudname get dictionary lists', () ->
  it('should give the available class list', (done) ->
    mudnames = Require("../lib/mudnames")()
    mudnames.getList((list) ->
      assert.lengthOf Object.keys(list), 22
      done()
    )
  )
  it('should give the available class list from a specific directory', (done) ->
    options = {path: __dirname + path.sep + 'fixtures' + path.sep + 'data'}
    mudnames = Require("../lib/mudnames")(options)
    mudnames.getList((list) ->
      assert.lengthOf Object.keys(list), 2
      done()
    )
  )
)

describe('mudname generate one name', () ->
  it('should generate a random name', (done) ->
    mudnames = Require("../lib/mudnames")()
    mudnames.generateOne("random", (name) ->
      assert.typeOf name, "String"
      assert.isTrue name.length > 0
      done()
    )
  )
  it('should generate a name from a defined class', (done) ->
    mudnames = Require("../lib/mudnames")()
    mudnames.generateOne('alver-1', (name) ->
      assert.typeOf name, "String"
      assert.isTrue name.length > 0
      done()
    )
  )
  it('should generate 4 names randomly', (done) ->
    mudnames = Require("../lib/mudnames")()
    mudnames.generate('random', 4, (names) ->
      assert.isArray names
      assert.lengthOf names, 4
      done()
    )
  )
  it('should generate 3 names from a defined class', (done) ->
    mudnames = Require("../lib/mudnames")()
    mudnames.generate('alver-1', 3, (names) ->
      assert.isArray names
      assert.lengthOf names, 3
      done()
    )
  )
)
