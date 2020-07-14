#!/bin/bash

PGDATA="/var/1C/postgresql-10/data"

docker volume create 1c-data

docker container run -d --network=host --hostname=1c-postgresql --name=1c-postgresql \
                     --restart=always                       \
                     -e "POSTGRES_USER=sirius"            \
                     -e "POSTGRES_PASSWORD=pYd8ie9I"        \
                     -e "PGDATA=$PGDATA" \
                     --mount source=1c-data,target="$PGDATA" \
                     oslyak/1c-postgresql


