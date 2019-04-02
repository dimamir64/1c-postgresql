#!/usr/bin/env bash
set -e

[ -d "$PGDATA" ] || mkdir -p "$PGDATA"

chown -R postgres "$PGDATA"

if [ -z "$(ls -A "$PGDATA")" ]; then
  echo "$POSTGRES_PASSWORD" > /tmp/pgpass
  chmod 660 /tmp/pgpass
  chown postgres /tmp/pgpass
  gosu postgres initdb --username="$POSTGRES_USER" --pwfile=/tmp/pgpass $PGDATA
  rm -f /tmp/pgpass
fi

exec gosu postgres postgres -c config_file=/etc/postgresql/10/main/postgresql.conf -d1 --data_directory="$PGDATA"
