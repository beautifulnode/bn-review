crypto = require 'crypto'

routes = (app) ->
  app.get '/', (req, res) ->
    res.render "#{__dirname}/views/index", 
      title: 'Top Modules'
      , bnImage: crypto.createHash('md5').update('tom@beautifulnode.com').digest('hex')
  app.get '/posts', (req, res) ->
    res.render "#{__dirname}/views/index", title: 'Bar', bnImage: crypto.createHash('md5').update('tom@beautifulnode.com').digest('hex')

module.exports = routes