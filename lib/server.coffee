express = require 'express'
util = require 'util'

class SqliteStore
  constructor: (filename="gree.sqlite3", @initDone) ->
    sqlite3 = require 'sqlite3'
    console.log "new SQLite3 Store"
    @db = new sqlite3.Database filename, @createTables

  createTables: =>
    console.log "create table"
    @db.run "CREATE TABLE IF NOT EXISTS location (email TEXT PRIMARY KEY, home TEXT, current TEXT, last_modify TEXT, status TEXT, interest TEXT, has_match TEXT, is_admin TEXT)", =>
        @initDone?()

  update: (email, home, current, last_modify, status, interest, has_match, is_admin, callback) ->
    sql = 'UPDATE location SET current=$current, home=$home, last_modify=$last_modify, status=$status, interest=$interest, has_match=$has_match, is_admin=$is_admin WHERE email=$email'
    @db.run sql,
      $current: current
      $home: home
      $last_modify: last_modify
      $email: email
      $status: status
      $interest: interest
      $has_match: has_match
      $is_admin: is_admin
    , callback

  select: (sql, callback) ->
    @db.all sql, callback

  get: (sql, param, callback) ->
    @db.get sql, param, callback

  insert: (sql, param, callback) ->
    @db.run sql, param, callback

  selectAll: (callback) ->
    sql = 'SELECT email, home, current, last_modify, status, interest, has_match, is_admin FROM location'
    @select sql, callback

  getByEmail: (email, callback) ->
    sql = "SELECT email, home, current, last_modify, status, interest, has_match, is_admin FROM location WHERE email=$email"
    @get sql, 
      $email: email
    , callback 

  create: (email, home, current, last_modify, status, interest, has_match, is_admin, callback) ->
    sql = "INSERT INTO location VALUES ($email, $home, $current, $last_modify, $status, $interest, $has_match, $is_admin)"
    @insert sql, 
      $email: email
      $home: home
      $current: current
      $last_modify: last_modify
      $status: status
      $interest: interest
      $has_match: has_match
      $is_admin: is_admin
    , callback

class MongoStore
  constructor: (@initDone) ->
    mongoose = require 'mongoose'
    console.log "new Mongo Store"
    # mongodb://nodejitsu:b5369381cafdb744f664341a368bdedc@flame.mongohq.com:27091/nodejitsudb595016457685 xingxui's mongo
    # mongodb://nodejitsu:718de49e0dfbb48ef7b0870c5317edfe@alex.mongohq.com:10061/nodejitsudb915284794144 jack's first db
    
    mongoose.connect("mongodb://nodejitsu:718de49e0dfbb48ef7b0870c5317edfe@alex.mongohq.com:10061/nodejitsudb915284794144")
    mongoose.connection.on "open", =>
      console.log "Connect Mongo success"
      @initDone?()
      @Loc = mongoose.model "Location", new mongoose.Schema
        email: String
        home: String
        current: String
        last_modify: String
        status: String
        interest: String
        has_match: String
        is_admin: String

  update: (email, home, current, last_modify, status, interest, has_match, is_admin, callback) ->
    @getByEmail email, (err, loc) ->
      unless err
        loc.email = email
        loc.home = home
        loc.current = current
        loc.last_modify = last_modify
        loc.status = status
        loc.interest = interest
        loc.has_match = has_match
        loc.is_admin = is_admin
        loc.save (err) ->
          unless err then callback() 

  selectAll: (callback) ->
    @Loc.find (err, todos) ->
      callback err, todos  

  getByEmail: (email, callback) ->
    @Loc.findOne 
      email: email
    , (err, loc) ->
      callback err, loc

  create: (email, home, current, last_modify, status, interest, has_match, is_admin, callback) ->
    loc = new @Loc
      email: email
      home: home
      current: current
      last_modify: last_modify
      status: status
      interest: interest
      has_match: has_match
      is_admin: is_admin
    loc.save (err) ->
      unless err then callback()


class Location
  @store: null
  @setDB: (store) ->
    console.log "Location.setDB"
    Location.store = store

  constructor: (@email, @home, @current, @last_modify, @status, @interest, @has_match, @is_admin) ->
    @email = @normalize @email 
    @home = @normalize @home 
    @current = @normalize @current
    @last_modify = @normalize @last_modify
    @status = @normalize @status
    @interest = @normalize @interest
    @has_match = @normalize @has_match
    @is_admin = @normalize @is_admin

  normalize: (item) ->
    if item && item isnt "undefined"
      return item
    else 
      return ""

  @all: (callback, error_callback) ->
    Location.store.selectAll Location.allCallback(callback, error_callback)

  @loadFromStoreRow: (row) ->
    l = new Location row.email, row.home, row.current, row.last_modify, row.status, row.interest, row.has_match, row.is_admin
    return l.json()

  json: ->
    email: @email
    home: @home
    current: @current
    last_modify: @last_modify
    status: @status
    interest: @interest
    has_match: @has_match
    is_admin: @is_admin

  @allCallback: (callback, error_callback) ->
    return (err, rows) ->
      unless err
        callback (Location.loadFromStoreRow row for row in rows)
      else
        error_callback err

  save: (callback) ->
    self = this
    Location.getByEmail @email, (err, location) ->
      if err?.message is "no match location"
        Location.create self.email, self.home, self.current, self.last_modify, self.status, self.interest, self.has_match, self.is_admin
        , callback
      else
        console.log "update"
        unless self.home
          self.home = location.home
        unless self.current
          self.current = location.current
        unless self.last_modify
          self.last_modify = location.last_modify
        unless self.status
          self.status = location.status
        unless self.interest
          self.interest = location.interest
        unless self.has_match
          self.has_match = location.has_match
        unless self.is_admin
          self.is_admin = location.is_admin
        Location.store.update self.email, self.home, self.current, self.last_modify, self.status, self.interest, self.has_match, self.is_admin, callback

  @getByEmail: (email, callback) ->
    Location.store.getByEmail email, (err, row) ->
      unless err
        if row
          callback err, Location.loadFromStoreRow(row)
        else
          callback {message: 'no match location'}
      else
        callback err

  @create: (email, home, current, last_modify, status, interest, has_match, is_admin, callback) ->
    Location.store.create email, home, current, last_modify, status, interest, has_match, is_admin, callback


# Create the development server.
app = express.createServer()

# So that express will not ignore post/put body
app.use(express.bodyParser())

# Allow CORS on everything, by setting coors headers before EVERY request.
app.all '*', (req, res, next) ->
  res.header 'Access-Control-Allow-Origin', req.headers.origin
  res.header 'Access-Control-Allow-Credentials', yes
  res.header 'Access-Control-Allow-Methods', 'POST, GET, PUT, DELETE, OPTIONS'
  next()

app.setupRoutes = (app) ->
  app.put "/locations/:id", (req, res) ->
    console.log "change #{req.params.id} location"
    email = req.params.id
    {current, last_modify, home, status, interest, has_match, is_admin} = req.body
    loc = new Location email, home, current, last_modify, status, interest, has_match, is_admin
    loc.save ->
      Location.getByEmail email, (err, location) ->
        res.json location
  
  app.get "/locations/:id", (req, res) ->
    console.log "get #{req.params.id} location"
    email = req.params.id
    Location.getByEmail email, (err, location) ->
      console.log err
      console.log location
      res.json location

  app.get "/locations", (req, res) ->
    success = (locations) ->
      res.json locations

    Location.all success

app.Models ={ Location }

app.setDB = (store) ->
  for modelName, model of app.Models
    model.setDB store

app.start = (path = __dirname + '/../public', port = process.env.PORT || 3000, useMongo) ->
  console.log "server path: #{path}, server port: #{port}, using Mongo: #{useMongo}"
  app.use(express.static(path))
  app.port = port
  app.listen port
  if useMongo
    console.log "using Mongo"
    app.store = new MongoStore
  else
    app.store = new SqliteStore
  app.setDB app.store
  app.setupRoutes app

# Ceate and export the app instance.
module.exports = { app, SqliteStore }
