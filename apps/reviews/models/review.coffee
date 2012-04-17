mrclean = require 'mrclean'
resourceful = require 'resourceful'
appConfig = require __dirname + '/../../config'
ghm = require("github-flavored-markdown")
moment = require 'moment'
gravatar = require __dirname + '/../../lib/gravatar'
meme = require __dirname + '/../../lib/meme'

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
  @timestamps()

Review::html = -> 
  try    
    ghm.parse @contents
  catch err
    @contents

Review::timeAgo = -> moment(@ctime).fromNow()
Review::link = -> "#{@_id}-#{@slug}"
Review::canEdit = (email) ->
  if email is @author then true else false
Review::canDelete = (email) ->
  if email is @author then true else false

Review.build = (review, cb) ->
  review.contents = ghm.parse(review.contents).replace(/\n+/g, '')
  mrclean().clean review.contents, (err, clean) ->
    review.contents = clean
    review.slug = review.module.toLowerCase().replace(/\s+/g,'-') + review.phrase.toLowerCase().replace(/\s+/g,'-')
    review.author = review.author || 'tom@jackhq.com'
    review.authorImageUrl = gravatar(review.author)
    meme review.phrase, (err, url) ->
      review.memeUrl = url
      Review.create review, (err, review) ->
        review.save (err) ->
          console.log err if err?
          cb null, review if cb?

# unless process.env.NODE_ENV is 'production'
#   Review.find module: 'Foo', (err, reviews) ->
#     unless reviews?[0]?
#       Review.build
#         module: 'Foo'
#         contents: "### http://github.com/mikeal/request"
#         phrase: 'Request is TOO DAMN Smart'

module.exports = Review