Review = require "#{__dirname}/models/review"
auth = require "#{__dirname}/../lib/auth"
view = (name) -> "#{__dirname}/views/#{name}"

routes = (app) ->
  # GET /reviews/search
  app.get '/reviews/search', (req, res) ->
    Review.find { module: req.body.module }, (err, reviews) ->
      res.render view('index'), title: 'Reviews', reviews: (reviews or [])

  # GET /reviews
  app.get '/reviews', (req, res) ->
    Review.all (err, reviews) ->
      res.render view('index'), title: 'Reviews', reviews: (reviews or [])

  # GET /reviews/new
  app.get '/reviews/new', auth(), (req, res) ->
    res.render view('new'), title: 'New Review'

  # POST /reviews
  app.post '/reviews', auth(), (req, res) ->
    req.body.author = req.session.currentEmail
    Review.build req.body, (err, review) ->
      res.redirect '/reviews'

  # GET /reviews/:link
  app.get '/reviews/:link', (req, res) ->
    Review.get req.params.link.split('-').shift(), (err, review) ->
      res.render view('show'), title: review.link(), review: review, email: req.session.currentEmail

  # GET /reviews/:link/edit
  app.get '/reviews/:link/edit', auth(), (req, res) ->
    Review.get req.params.link.split('-').shift(), (err, review) ->
      if review.canEdit(req.session.currentEmail)
        res.render view('edit'), title: "Edit - #{review.link()}", review: review
      else
        res.redirect '/reviews', title: 'Reviews'

  # PUT /reviews/:link
  app.put '/reviews/:link', auth(), (req, res) ->
    Review.get req.params.link.split('-').shift(), (err, review) ->
      if review.canEdit(req.session.currentEmail)
        review.update req.body, (err, review) ->
          res.render view('show'), title: review.link(), review: review
      else
        res.redirect '/reviews', title: 'Reviews'

  # DELETE /reviews/:link
  app.del '/reviews/:link', auth(), (req, res) ->
    Review.get req.params.link.split('-').shift(), (err, review) ->
      if review.canDelete(req.session.currentEmail)
        review.destroy (err, result) ->
          res.redirect '/reviews'
      else
        res.redirect '/reviews', title: 'Reviews'

module.exports = routes