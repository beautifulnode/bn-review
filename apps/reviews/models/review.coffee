resourceful = require 'resourceful'
appConfig = require __dirname + '/../../config'
ghm = require("github-flavored-markdown")
moment = require 'moment'
gravatar = require __dirname + '/../../lib/gravatar'

Review = resourceful.define 'review', ->
  @use 'couchdb', 
    uri: 'couchdb://nodejitsudb809450223798.iriscouch.com:5984/bn3'
    auth:
      username: 'admin'
      password: 'admin'
  @string 'module'
  @string 'contents'
  @string 'phrase'
  @string 'memeUrl'
  @string 'author'
  @string 'authorImageUrl'
  @timestamps

Review::html = -> ghm.parse @contents
Review::timeAgo = -> moment(@ctime).fromNow()
Review::link = -> "#{@_id}-#{@slug}"
Review.build = (review, cb) ->
  review.slug = review.module.toLowerCase().replace(/\s+/g,'-') + review.phrase.toLowerCase().replace(/\s+/g,'-')
  review.author = review.author || 'tom@jackhq.com'
  review.authorImageUrl = gravatar(review.author)
  
  # TODO generate imageUrl Link
  Review.create review, (err, review) ->
    review.save (err) ->
      console.log err if err?
      cb null, review if cb?

unless process.env.NODE_ENV is 'production'
  Review.find module: 'Foo', (err, reviews) ->
    unless reviews?[0]?
      Review.build
        module: 'Foo'
        contents: "### I give this module a High Five\n\nhttp://google.com"
        phrase: 'AWESOME SAUCE'

module.exports = Review