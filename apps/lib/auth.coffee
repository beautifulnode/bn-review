module.exports = ->
  (req, res, next) ->
    console.log req.session
    if not (req.session.currentUser)
      req.flash 'error', 'Please login.'
      res.redirect '/login'
      return
    next()