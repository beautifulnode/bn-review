gravatar = require __dirname + '/lib/gravatar'
bnImageUrl = gravatar('tom@beautifulnode.com')

helpers = (app) ->
  app.dynamicHelpers
    bnImageUrl: -> bnImageUrl
    menu: (tab) ->
      [
        {name: 'Top Modules', href: '/', class: if tab is 'modules' then 'active' else ''}
        {name: 'Reviews', href: '/reviews', class: if tab is 'reviews' then 'active' else ''}
        {name: 'About', href: '/about', class: if tab is 'about' then 'active' else ''} 
      ]
    loggedIn: (req, res)->
      if req.session.currentUser? then true else false
    #gravatar: (email) -> gravatar(email)
module.exports = helpers
  