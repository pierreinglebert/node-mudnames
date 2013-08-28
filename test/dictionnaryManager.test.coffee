Require = require('covershot').require.bind(null, require)

chai = require "chai"
expect = chai.expect
assert = chai.assert
path = require "path"

describe('DictionnaryManager::loadDictionnaries', () ->
  it(' should give an error if path doesnt exists', (done) ->
    dictionnaryManager = Require "../lib/dictionnaryManager"
    dictionnaryManager.loadDictionnaries('toto', (err) ->
      assert.isNotNull err
      done()
    )
  )
  it(' should give an error if pathname isnt a path', (done) ->
    dictionnaryManager = Require "../lib/dictionnaryManager"
    dictionnaryManager.loadDictionnaries(__filename, (err) ->
      assert.isNotNull err
      done()
    )
  )
)