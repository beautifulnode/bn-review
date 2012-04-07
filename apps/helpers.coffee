gravatar = require __dirname + '/lib/gravatar'
bnImageUrl = gravatar('tom@beautifulnode.com')

helpers = (app) ->
  app.dynamicHelpers
    bnImageUrl: -> bnImageUrl
module.exports = helpers
  