require('coffee-script');

var express = require('express'),
  redis = require('redis'),
  appConfig = require('./apps/config')
  RedisStore = require('connect-redis')(express);

var client = null;

// it would be nice to figure out a better
// way to do this...
if (process.env.NODE_ENV == 'production') {
  client = redis.createClient(appConfig.production.redis.port, appConfig.production.redis.host);
  client.auth(appConfig.production.redis.password);
} else {
  client = redis.createClient();
}

var app = module.exports = express.createServer();

// Configuration
app.configure(function(){
  app.set('views', __dirname + '/views');
  app.set('view engine', 'jade');
  app.set('port', 3000)
  app.use(express.cookieParser());
  app.use(express.session({
    store: new RedisStore({
      client: client 
    }),
    secret: "WhoWhatWhenWhereWhyEverybody"
  }));
  app.use(express.bodyParser());
  app.use(express.methodOverride());
  app.use(app.router);
  app.use(express.static(__dirname + '/public'));
});

app.configure('development', function(){
  app.use(express.errorHandler({ dumpExceptions: true, showStack: true }));
});

app.configure('test', function(){
  app.set('port', 3001)
});

app.configure('production', function(){
  app.use(express.errorHandler());
});

// helpers
require('./apps/helpers')(app)
// Routes
app.get('/about', function(req, res) {
  res.render('about', {title: 'About Beautiful Node - A module review site for the nodejs community'})
});

require('./apps/sessions/routes')(app)
require('./apps/users/routes')(app)
require('./apps/modules/routes')(app)
require('./apps/reviews/routes')(app)

app.listen(app.settings.port, function(){
  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);
});
