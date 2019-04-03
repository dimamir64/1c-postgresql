#!/usr/bin/env bash
set -e

[ -d "$PGDATA" ] || mkdir -p "$PGDATA"
chown -R postgres "$PGDATA"
chmod 700 "$PGDATA"

chown -R postgres "$PGDATA"

if [ -z "$(ls -A "$PGDATA")" ]; then
  echo "$POSTGRES_PASSWORD" > /tmp/pgpass
  chmod 660 /tmp/pgpass
  chown postgres /tmp/pgpass
  gosu postgres initdb --username="$POSTGRES_USER" --pwfile=/tmp/pgpass $PGDATA
  rm -f /tmp/pgpass
fi

# exec gosu postgres postgres -c config_file=/etc/postgresql/10/main/postgresql.conf -d5 --data_directory="$PGDATA"
if [ "$1" = 'postgres' ] && [ "$(id -u)" = '0' ]; then
  [ -d /var/run/postgresql ] || mkdir -p /var/run/postgresql && chown -R postgres /var/run/postgresql && chmod 775 /var/run/postgresql
  exec gosu postgres postgres
else
  "$@"
fi
