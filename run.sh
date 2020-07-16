#!/bin/bash

PGDATA="/var/postgresql-1c/12/data"
PGLOG="/var/log/postgresql/"
PGPASS=$(head -n 1 pg_password.txt)

docker volume create pg-12-data

[ -d "$PGLOG" ] || sudo mkdir -p "$PGLOG"

echo "PGDATA=$PGDATA"
echo "PGLOG=$PGLOG"
echo "PGPASS=$PGPASS"

docker container run --network=host --hostname=1c-postgresql --name=1c-postgresql-12 \
                     --restart=always                           \
                     --detach                                   \
                     -e "POSTGRES_USER=sirius"                  \
                     -e "POSTGRES_PASSWORD=$PGPASS"             \
                     -e "PGDATA=$PGDATA"                        \
                     -e "PGLOG=$PGLOG"                          \
                     -v $PGLOG:$PGLOG                           \
                     --mount source=pg-12-data,target="$PGDATA" \
                     oslyak/1c-postgresql:12 $@

#--detach  Run container in background and print container ID
#Remove it to see run log
