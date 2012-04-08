module.exports = ->
  (req, res, next) ->
    if not (req.session.currentUser)
      req.flash 'error', 'Please login.'
      res.redirect '/login'
      return
    next()