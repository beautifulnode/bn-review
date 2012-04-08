module.exports = 
  development:
    redis:
      host: 'localhost'
    couch:
      uri: 'couchdb://localhost:5984/bn3'
  production:
    redis: 
      port: 9124
      host: 'catfish.redistogo.com'
      password: 'e041495d97e146cf9bfcf383c0ebfd68'
    couch:
      uri: 'couchdb://nodejitsudb809450223798.iriscouch.com:5984/bn3'
      auth:
        username: 'admin'
        password: 'admin'
