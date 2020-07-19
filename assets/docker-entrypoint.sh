#!/bin/bash
set -e

[ -d "$PGDATA" ] || mkdir -p "$PGDATA"
chown -R postgres "$PGDATA"
chmod 700 "$PGDATA"
PG_CONFIG=$PGDATA/postgresql.conf

if [ -z "$(ls -A "$PGDATA")" ]; then
  echo "$POSTGRES_PASSWORD" > /tmp/pgpass
  chmod 660 /tmp/pgpass
  chown postgres /tmp/pgpass
  gosu postgres initdb --username="$POSTGRES_USER" --pwfile=/tmp/pgpass $PGDATA
  rm -f /tmp/pgpass

  sed -Ei 's/^#?host\s*all\s*all\s*127.*/host    all             all             0.0.0.0\/0               trust/' $PGDATA/pg_hba.conf

  sed -Ei "s/^#?listen_addresses ?=.*/listen_addresses='*'/"                               $PG_CONFIG
  sed -Ei 's/^#?max_connections ?=.*/max_connections=1000/'                                $PG_CONFIG
  sed -Ei 's/^#?shared_buffers ?=.*/shared_buffers=6GB/'                                   $PG_CONFIG
  sed -Ei 's/^#?temp_buffers ?=.*/temp_buffers=256MB/'                                     $PG_CONFIG
  sed -Ei 's/^#?work_mem ?=.*/work_mem=768MB/'                                             $PG_CONFIG
  sed -Ei 's/^#?maintenance_work_mem ?=.*/maintenance_work_mem=2GB/'                       $PG_CONFIG
  sed -Ei 's/^#?max_files_per_process ?=.*/max_files_per_process=1000/'                    $PG_CONFIG
  sed -Ei 's/^#?bgwriter_delay ?=.*/bgwriter_delay=20ms/'                                  $PG_CONFIG
  sed -Ei 's/^#?bgwriter_lru_maxpages ?=.*/bgwriter_lru_maxpages=400/'                     $PG_CONFIG
  sed -Ei 's/^#?bgwriter_lru_multiplier ?=.*/bgwriter_lru_multiplier=4.0/'                 $PG_CONFIG
  sed -Ei 's/^#?effective_io_concurrency ?=.*/effective_io_concurrency=700/'               $PG_CONFIG
  sed -Ei 's/^#?max_worker_processes ?=.*/max_worker_processes=16/'                        $PG_CONFIG
  sed -Ei 's/^#?max_parallel_workers_per_gather ?=.*/max_parallel_workers_per_gather=8/'  $PG_CONFIG
  sed -Ei 's/^#?max_parallel_workers ?=.*/max_parallel_workers=16/'                        $PG_CONFIG
  sed -Ei 's/^#?max_parallel_maintenance_workers ?=.*/max_parallel_maintenance_workers=4/' $PG_CONFIG
  sed -Ei 's/^#?fsync ?=.*/fsync=on/'                                                      $PG_CONFIG
  sed -Ei 's/^#?synchronous_commit ?=.*/synchronous_commit=off/'                           $PG_CONFIG
  sed -Ei 's/^#?wal_buffers ?=.*/wal_buffers=16MB/'                                        $PG_CONFIG
  sed -Ei 's/^#?min_wal_size ?=.*/min_wal_size=4GB/'                                       $PG_CONFIG
  sed -Ei 's/^#?max_wal_size ?=.*/max_wal_size=16GB/'                                      $PG_CONFIG
  sed -Ei 's/^#?seq_page_cost ?=.*/seq_page_cost=0.3/'                                     $PG_CONFIG
  sed -Ei 's/^#?random_page_cost ?=.*/random_page_cost=0.3/'                               $PG_CONFIG
  sed -Ei 's/^#?effective_cache_size ?=.*/effective_cache_size=18GB/'                      $PG_CONFIG
  sed -Ei 's/^#?autovacuum ?=.*/autovacuum=on/'                                            $PG_CONFIG
  sed -Ei 's/^#?autovacuum_max_workers ?=.*/autovacuum_max_workers=6/'                     $PG_CONFIG
  sed -Ei 's/^#?autovacuum_naptime ?=.*/autovacuum_naptime=20s/'                           $PG_CONFIG
  sed -Ei 's/^#?row_security ?=.*/row_security=off/'                                       $PG_CONFIG
  sed -Ei 's/^#?max_locks_per_transaction ?=.*/max_locks_per_transaction=256/'             $PG_CONFIG
  sed -Ei 's/^#?escape_string_warning ?=.*/escape_string_warning=off/'                     $PG_CONFIG
  sed -Ei 's/^#?standard_conforming_strings ?=.*/standard_conforming_strings=off/'         $PG_CONFIG
fi


# exec gosu postgres /opt/pgpro/1c-12/bin/postgres -c config_file="$PG_CONFIG" -d5 --data_directory="$PGDATA"
if [ "$1" = 'postgres' ] && [ "$(id -u)" = '0' ]; then
  [ -d /var/run/postgresql ] || mkdir -p /var/run/postgresql && chown -R postgres /var/run/postgresql && chmod 775 /var/run/postgresql
  exec gosu postgres /opt/pgpro/1c-12/bin/postgres -D $PGDATA
else
  "$@"
fi
