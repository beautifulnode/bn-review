Review = require "#{__dirname}/models/review"
view = (name) -> "#{__dirname}/views/#{name}"

routes = (app) ->
  app.get '/reviews', (req, res) ->
    Review.all (err, reviews) ->
      res.render view('index'), title: 'Reviews', reviews: reviews
  app.get '/reviews/new', (req, res) ->
    res.render view('new'), title: 'New Review'
  app.post '/reviews', (req, res) ->
    Review.build req.body, (err, review) ->
      res.redirect '/reviews'
  app.get '/reviews/:link', (req, res) ->
    Review.get req.params.link.split('-').shift(), (err, review) ->
      res.render view('show'), title: review.link(), review: review
  app.get '/reviews/:link/edit', (req, res) ->
    Review.get req.params.link.split('-').shift(), (err, review) ->
      res.render view('edit'), title: "Edit - #{review.link()}", review: review
  app.put '/reviews/:link', (req, res) ->
    Review.get req.params.link.split('-').shift(), (err, review) ->
      review.update req.body, (err, review) ->
        res.render view('show'), title: review.link(), review: review
module.exports = routes