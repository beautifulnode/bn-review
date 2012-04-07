resourceful = require 'resourceful'
User = resourceful.define 'user', ->
  @string 'username'
  # Temp do not go to production til this is resolved
  @string 'password'
  #@string 'hash'
  #@string 'key'
  @string 'email'
  @array 'roles'

  @timestamps

User::authorize = (password, cb) ->
  if password == @password
    cb null, this
  else
    cb new Error('Invalid Password'), null

User.build = (user, cb) ->
  console.log user
  # generate password stuff
  user.roles = ['user']
  User.create user, cb

unless process.env.NODE_ENV is 'production'
  User.build
    username: 'admin'
    password: 'admin'
    email: 'tom@jackhq.com'

module.exports = User