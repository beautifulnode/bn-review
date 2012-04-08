User = require "#{__dirname}/models/user"
view = (name) -> "#{__dirname}/views/#{name}"

routes = (app) ->
  app.get '/signup', (req, res) ->
    res.render view('new'), title: 'Signup Form'
  app.post '/users', (req, res) ->
    if req.body.password isnt req.body.confirmation
      return res.render view('new'), 
        title: 'Signup Form'
        flash: 'password and confirmation must match' 
    User.build req.body, (err, user) ->
      unless err?
        req.session.currentUser = user.username
        req.flash 'info', "You are now logged in as #{req.session.currentUser}."
        res.redirect '/'
        return
      res.render view('new'), title: 'Signup Form', flash: "Error Occured."

module.exports = routes