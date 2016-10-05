#!/bin/sh
chown -R postgres "$PGDATA"

if [ -z "$(ls -A "$PGDATA")" ]; then
    sudo -H -u postgres -E -- initdb
    sed -ri "s/^#(listen_addresses\s*=\s*)\S+/\1'*'/" "$PGDATA"/postgresql.conf

    DATABASE_USER=${DATABASE_USER:-postgres}
    DATABASE_NAME=${DATABASE_NAME:-${DATABASE_USER}}
    DATABASE_PASSWORD=${DATABASE_PASSWORD:-${DATABASE_USER}}

    if [ "$DATABASE_PASSWORD" ]; then
      pass="PASSWORD '$DATABASE_PASSWORD'"
      authMethod=md5
    else
      echo "==============================="
      echo "!!! Use \$DATABASE_PASSWORD env var to secure your database !!!"
      echo "==============================="
      pass=
      authMethod=trust
    fi
    echo


    if [ "$DATABASE_NAME" != 'postgres' ]; then
      createSql="CREATE DATABASE \"$DATABASE_NAME\";"
      echo $createSql | sudo -H -u postgres -E -- postgres --single -jE
      echo
    fi

    if [ "$DATABASE_USER" != 'postgres' ]; then
      op=CREATE
    else
      op=ALTER
    fi

    userSql="$op USER \"${DATABASE_USER}\" WITH SUPERUSER $pass;"
    echo $userSql |  sudo -H -u postgres -E -- postgres --single -jE
    echo

    { echo; echo "host all all 0.0.0.0/0 $authMethod"; } >> "$PGDATA"/pg_hba.conf
fi

exec sudo -H -u postgres -E -- postgres $@