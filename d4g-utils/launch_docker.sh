#!/bin/bash

source $1

# Check if the postgres-demo container exists
if docker container inspect postgres-demo >/dev/null 2>&1; then
    # Remove the postgres-demo container
    docker container rm -f postgres-demo
fi

# Launch the postgres container
docker run --name postgres-demo \
 -p $DATABASE_PORT:5432\
 -e POSTGRES_PASSWORD=$DATABASE_PASSWORD \
 -e POSTGRES_USER=$DATABASE_USER \
 -e POSTGRES_DB=$DATABASE_NAME \
 -d postgres:16-bookworm \


# Check if the webserver-healthcheck-demo container exists
if docker container inspect webserver-healthcheck-demo >/dev/null 2>&1; then
    # Remove the webserver-healthcheck-demo container
    docker container rm -f webserver-healthcheck-demo
fi

docker build -f Dockerfiles/server.Dockerfile -t webserver-healthcheck:latest . 
docker run -d -p 8080:8081 --env-file=$1 --name webserver-healthcheck-demo webserver-healthcheck

docker ps -a