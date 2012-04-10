resourceful = require 'resourceful'
appConfig = require __dirname + '/../../config'
bcrypt = require 'bcrypt'
crypto = require 'crypto'

User = resourceful.define 'user', ->
  @use 'couchdb', 
    uri: 'couchdb://nodejitsudb809450223798.iriscouch.com:5984/bn3'
    auth:
      username: 'admin'
      password: 'admin'

  @string 'username'
  @string 'hash'
  @string 'salt'
  @string 'email'
  @array 'roles'

  @timestamps()

User::authenticate = (password, cb) ->
  user = this
  bcrypt.compare password, @hash, (err, res) ->
    unless err?
      cb(null, user)
    else
      cb(new Error('INVALID PASSWORD'), null)

User.build = (user, cb) ->
  # generate password stuff
  user.roles = ['user']
  bcrypt.genSalt 10, (err, salt) -> 
    user.salt = salt
    bcrypt.hash user.password, salt, (err, hash) -> 
      # remove password entry
      delete user.password
      delete user.confirmation
      user.hash = hash
      User.create user, cb 

unless process.env.NODE_ENV is 'production'
  User.find username: 'admin', (err, users) ->
    unless users?[0]?
      User.build
        username: 'admin'
        password: 'admin'
        email: 'tom@jackhq.com'
        (e, user) -> user.save (err) -> 
          console.log err if err?

module.exports = User