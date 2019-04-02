#!/bin/bash

docker container run -it --network=host --hostname=1c-postgresql --name=1c-postgresql \
                     -e "POSTGRES_USER=postgres"            \
                     -e "POSTGRES_PASSWORD=password"        \
                     -e "PGDATA=/var/1C/postgresql-10/data" \
                     -e "LANG=ru_RU.UTF-8"                  \
                     -e "LANGUAGE=ru"                       \
                     oslyak/1c-postgresql
