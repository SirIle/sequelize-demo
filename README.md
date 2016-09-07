# sequelize-demo

This is a short getting started guide, more information is in a blog post that
will be written later. The accompanying [presentation](./DynamicServicesWithCoffeeScript.pdf) contains the presentation that was
used during the live session.

## Pre-requisites

-   Docker and Docker Compose
    -   Docker for Mac (or Windows) should install everything needed
-   NodeJS and npm
-   Git
-   (Mac, this hasn't been tested on Windows, so may need a PR)

## Installing dependencies

After cloning, the dependencies need to be installed.

There are node-modules both on the root level and in the subdirectories, namely
`services/users`. Installing the dependencies can be done with `npm install`.

**Note:** If the global python is of version 3, something goes wrong when
installing the subdependencies for bunyan (see [this
issue](https://github.com/trentm/node-bunyan/issues/216)) which can be fixed by
installing the dependencies with setting the global python to be version 2
(2.7.12 as of when this doc was written).

## Running

Starting the database is done with `npm run db` which also installs the test
data (which can be found from `testdata`-folder) and waits until the database
has started.

Starting the local test server is done with `npm start` which starts the
service in watch mode using `nodemon`.

The service can be tested with

~~~bash
$ curl -s localhost:8080/users/user1 | jq
{
  "id": 1,
  "userid": "user1",
  "firstname": "Firstname1",
  "lastname": "Lastname1",
  "age": 30,
  "createdAt": "2016-09-07T20:49:20.000Z",
  "updatedAt": "2016-09-07T20:49:20.000Z",
  "addresses": [
    {
      "id": 1,
      "streetaddress": "Someroad 1 A",
      "zipcode": "12345",
      "createdAt": "2016-09-07T20:49:20.000Z",
      "updatedAt": "2016-09-07T20:49:20.000Z",
      "userId": 1
    },
    {
      "id": 2,
      "streetaddress": "Olderroad 2",
      "zipcode": "23456",
      "createdAt": "2016-09-07T20:49:20.000Z",
      "updatedAt": "2016-09-07T20:49:20.000Z",
      "userId": 1
    }
  ]
}
~~~

## Resetting the database

Database can be synced and the testdata reinserted with `npm run resetdb`.

## Tests and coverage report

The database needs to be running (`npm run db`) before running the tests. Tests
are run with `npm test` which starts a local service, runs the tests in the
`tests`-directory and writes the coverage report to `coverage` directory.
The test report can be viewed in a browser with
`open coverage/lcov-report/index.html`.

## TDD

Test driven development can be achieved by running `npm start` in one console
window and `npm run testwatch` in another. The latter command keeps running the
tests whenever a file is saved which should provide an extremely short
feedback cycle.

## Building the container

Container can be built with `npm run container`.

## Running the container and load-balancer

Running the container-based set-up is done with `npm run containers`.

The results can then be tested with

~~~bash
$ curl -is http://localhost/users/user1 -H 'Host:users-v1'
HTTP/1.1 200 OK
Host: a4e73073f800
Content-Type: application/json
Content-Length: 467
Date: Wed, 07 Sep 2016 21:13:18 GMT

{"id":1,"userid":"user1","firstname":"Firstname1","lastname":"Lastname1","age":30,
"createdAt":"2016-09-07T20:49:20.000Z","updatedAt":"2016-09-07T20:49:20.000Z",
"addresses":[{"id":1,"streetaddress":"Someroad 1 A","zipcode":"12345",
"createdAt":"2016-09-07T20:49:20.000Z", "updatedAt":"2016-09-07T20:49:20.000Z","userId":1},
{"id":2,"streetaddress":"Olderroad 2","zipcode":"23456","createdAt":"2016-09-07T20:49:20.000Z",
"updatedAt":"2016-09-07T20:49:20.000Z","userId":1}]}
~~~

### Scaling

The service can be scaled with `docker-compose scale users-v1=3` and when testing
with the previous command, the Host-header information should change with every
request.

## Shutting down

The containers can be stopped with `npm stop`.

## Running the whole build

With `npm run build` the following is done
-   `npm stop` (makes sure that all the services have been stopped)
-   `npm run container` (packages the service to a container)
-   `npm run db` (sets up the test database)
-   `npm run containers` (starts the services and load balancer)
-   `NODE_ENV=test npm test` (runs the tests against the containers)

After that the created image could be tagged and the image could be taken
into use somewhere down the runtime chain.
