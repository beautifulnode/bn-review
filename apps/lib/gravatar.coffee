crypto = require 'crypto'
avatar = "http://www.gravatar.com/avatar"
hash = (email) ->
  crypto.createHash('md5').update(email).digest('hex')

module.exports = (email) -> "#{avatar}/#{hash(email)}"