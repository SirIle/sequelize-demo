#!/bin/bash
BASEDIR=$(dirname ${BASH_SOURCE[0]})/..

echo $NODE_ENV

# Start the database with docker-compose
docker-compose up -d mariadb

# Wait until the database is running
while :
do
    docker-compose exec mariadb mysqladmin --user=root --password=ile status  >/dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        break
    fi
    sleep 1
done

# Create the database
docker-compose exec mariadb mysql --user=root --password=ile -e "create database if not exists ile"

# Synchronize the database tables and insert the test users
coffee $BASEDIR/scripts/initdb.coffee
