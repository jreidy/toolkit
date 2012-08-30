spawn = require('child_process').spawn
should = require 'should'
util = require 'util'
{ app, SqliteStore } = require '../lib/server'
{ Location } = app.Models


describe 'Location', ->
  store = null

  describe 'get', ->
    beforeEach (done) ->
      store = new SqliteStore ":memory:", done
      app.setDB store

    it 'should return err when there is no location record match that email', (done)->
      callback = (err, location) ->
        err.message.should.equal "no match location"
        should.strictEqual undefined, location
        done()

      Location.getByEmail 'not.exist@gree.co.jp', callback

    it "should able to store after create", (done) ->
      Location.create "xingkui.wang@gree.co.jp", "China, Beijing", "", "1336030510637", ""

      success = (locations) ->
        locations.should.have.length 1
        done()
      Location.all success

    it 'should able to fetch a location after create', (done) ->
      Location.create "xingkui.wang@gree.co.jp", "China, Beijing", "", "1336030510637", ""

      callback = (err, location) ->
        location.email.should.equal 'xingkui.wang@gree.co.jp'
        done()
      Location.getByEmail 'xingkui.wang@gree.co.jp', callback

    it "should able to create a location when save it but there is no record in db previously", (done) ->
      location = new Location 'xingkui.wang@gree.co.jp', "", "China, Beijing", "1336030510637", ""
      location.save ->
        callback = (err, location) ->
          location.email.should.equal 'xingkui.wang@gree.co.jp'
          location.current.should.equal 'China, Beijing'
          location.home.should.equal ''
          done()
        Location.getByEmail 'xingkui.wang@gree.co.jp', callback

    it "should able to update a location when it's already exist", (done) ->
      Location.create "xingkui.wang@gree.co.jp", "", "China, Beijing", "1336030510637", "", ->
        location = new Location 'xingkui.wang@gree.co.jp', "", "Japan, Tokyo", "1336030510637", ""
        location.save ->
          callback = (err, location) ->
            location.email.should.equal 'xingkui.wang@gree.co.jp'
            location.current.should.equal 'Japan, Tokyo'
            location.home.should.equal ''
            done()
          Location.getByEmail 'xingkui.wang@gree.co.jp', callback

    it "should able to update travel status", (done) ->
      Location.create "xingkui.wang@gree.co.jp", "", "China, Beijing", "1336030510637", "", ->
        location = new Location 'xingkui.wang@gree.co.jp', "", "Japan, Tokyo", "1336030510637", "traveling"
        location.save ->
          callback = (err, location) ->
            location.email.should.equal 'xingkui.wang@gree.co.jp'
            location.current.should.equal 'Japan, Tokyo'
            location.home.should.equal ''
            location.status.should.equal 'traveling'
            done()
          Location.getByEmail 'xingkui.wang@gree.co.jp', callback
        
