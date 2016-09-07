chai = require 'chai'
should = chai.should()
#sinon = require 'sinon'
restify = require 'restify-clients'
assert = require 'assert'
env = process.env.NODE_ENV or 'development'

client = restify.createJsonClient
  url: if env == 'development' then 'http://localhost:8080' \
    else 'http://localhost'
  headers: 'Host' : 'users-v1'

describe 'if the user exists', ->
  it 'returns http statuscode 200 and a JSON object for the user', (done) ->
    client.get '/users/user1', (err, req, res, obj) ->
      res.statusCode.should.equal 200
      obj.userid.should.equal 'user1'
      obj.age.should.be.at.least 30
      done()
describe 'if the user does not exist', ->
  it 'returns http statuscode 404', (done) ->
    client.get '/users/notfound', (err, req, res, obj) ->
      res.statusCode.should.equal 404
      done()
