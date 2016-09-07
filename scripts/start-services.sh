#!/bin/bash
docker-compose up -d service

# Wait until the service replies
while :
do
    curl -s http://localhost/users/notfound -H 'Host:users-v1' >/dev/null 2>&1
    if [[ $? -eq 0 ]]; then
        break
    fi
    sleep 1
done
