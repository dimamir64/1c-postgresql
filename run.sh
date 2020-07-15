#!/bin/bash

PGDATA="/var/postgresql-1c/12/data"
PGLOG="/var/log/postgresql/"

docker volume create pg-12-data

[ -d "$PGLOG" ] || mkdir -p "$PGLOG"

echo "Local PGDATA=$PGDATA"
echo "Local PGLOG=$PGLOG"

docker container run --network=host --hostname=1c-postgresql --name=1c-postgresql \
                     --restart=always                           \
                     --detach                                   \
                     -e "POSTGRES_USER=sirius"                  \
                     -e "POSTGRES_PASSWORD=pYd8ie9I"            \
                     -e "PGDATA=$PGDATA"                        \
                     -e "PGLOG=$PGLOG"                          \
                     -v $PGLOG:$PGLOG                           \
                     --mount source=pg-12-data,target="$PGDATA" \
                     oslyak/1c-postgresql $@

#--detach  Run container in background and print container ID
#Remove it to see run log
