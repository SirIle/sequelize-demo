module.exports.startServer = () ->

  models = require '../../models'
  restify = require 'restify'
  os = require 'os'
  bunyan = require 'bunyan'
  log = bunyan.createLogger name: 'users', level: 'DEBUG'

  # Create a restify server
  server = restify.createServer()
  # Define the endpoint
  server.get '/users/:name', (req, res, next) ->
    # Fetch and return the user or an error
    res.header('Host', os.hostname() ) # For scaling demonstration
    models.user.findOne(
      where: [ userid: req.params.name ],
      include: [ models.address ],
      logging: log.debug.bind log).then (user) ->
        if !user then res.send new restify.NotFoundError 'user ' +
          req.params.name + ' not found'
        else res.send user
        next()
  # Start the server
  server.listen 8080, ->
    log.info '%s listening at %s', server.name, server.url
