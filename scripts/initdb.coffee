fs = require 'fs'
models = require '../models'

# Initialize the DB
models.sequelize.sync( force:true ).then ->
  fs.readFile 'testdata/users.json','utf-8', (err, data) ->
    users = JSON.parse data
    create user, (i==users.length-1) for user, i in users

# Close the connection after the last item has been processed
create = (user, last) ->
  models.user.create( user, include: [ models.address ] ).then ->
    models.sequelize.close() if last
