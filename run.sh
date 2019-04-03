#!/bin/bash

PGDATA="/var/1C/postgresql-10/data"

# sudo [ -d "$PGDATA" ] || sudo mkdir -p "$PGDATA" && sudo chown $USER "$PGDATA"
docker volume create 1c-data

docker container run -dit --network=host --hostname=1c-postgresql --name=1c-postgresql \
                     --restart=always                       \
                     -e "POSTGRES_USER=postgres"            \
                     -e "POSTGRES_PASSWORD=password"        \
                     -e "PGDATA=$PGDATA" \
                     -e "LANG=ru_RU.UTF-8"                  \
                     -e "LANGUAGE=ru"                       \
                     --mount source=1c-data,target="$PGDATA" \
                     oslyak/1c-postgresql


