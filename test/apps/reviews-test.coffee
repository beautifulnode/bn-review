assert  = require 'assert'
request = require 'request'
app     = require '../../server'

describe "reviews", ->
  describe "GET /reviews ", ->
    body = null
    before (done) ->
      options =
        uri: "http://localhost:#{app.settings.port}/reviews"
      request options, (err, response, _body) ->
        body = _body
        done()
    it "has title", ->
      assert.hasTag body, '//head/title', 'Foo'