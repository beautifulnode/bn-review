User = require "#{__dirname}/../users/models/user"
view = (name) -> "#{__dirname}/views/#{name}"

routes = (app) ->
  app.get '/login', (req, res) ->
    res.render "#{__dirname}/views/login",
      title: 'Login'

  app.post '/sessions', (req, res) ->
    invalidLogin = ->
      req.flash 'error', 'Those credentials were incorrect. Please login again.'
      res.redirect '/login'
    # Logging in
    User.find username: req.body.username, (err, users) ->
      if users?[0]?
        users[0].authenticate req.body.password, (err, user) ->
          req.session.currentUser = req.body.username
          req.flash 'info', "You are now logged in as #{req.session.currentUser}."
          res.redirect '/'
          return
          invalidLogin()
      else
        invalidLogin()

  app.del '/sessions', (req, res) ->
    req.session.regenerate (err) ->
      req.flash 'info', 'You have been logged out.'
      res.redirect '/login'
  

module.exports = routes