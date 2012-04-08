resourceful = require 'resourceful'
appConfig = require __dirname + '/../../config'
bcrypt = require 'bcrypt'
crypto = require 'crypto'

User = resourceful.define 'user', ->
  @use 'couchdb', appConfig[process.env.NODE_ENV or 'development'].couch
  @string 'username'
  @string 'hash'
  @string 'salt'
  @string 'email'
  @array 'roles'

  @timestamps

User::authorize = (password, cb) ->
  bcrypt.compare password, @hash, (err, res) ->
    unless err?
      cb(null, user)
    # else
    #   cb(new Error('INVALID PASSWORD'), null

User.build = (user, cb) ->
  # generate password stuff
  user.roles = ['user']
  bcrypt.genSalt 10, (err, salt) -> 
    user.salt = salt
    bcrypt.hash user.password, salt, (err, hash) -> 
      delete user.password
      user.hash = hash
      console.log user
      User.create user, cb 

unless process.env.NODE_ENV is 'production'
  User.build
    username: 'admin'
    password: 'admin'
    email: 'tom@jackhq.com'

module.exports = User