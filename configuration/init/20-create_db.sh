#!/usr/bin/env bash

set -e
set -u

POSTGRES_APP="psql -v ON_ERROR_STOP=1 --username ${POSTGRES_USER}"

create_database_grant_privilege() {
  local database="${1}"
  local user="${2}"
  echo "Creating database '${database}' and granting privileges to '${user}'"
  ${POSTGRES_APP} <<-EOSQL
    CREATE DATABASE ${database} OWNER ${user};
    GRANT ALL PRIVILEGES ON DATABASE ${database} TO ${user};
EOSQL
}

create_database_grant_privilege "${DOCKER_DATABASE_NAME}" "${DOCKER_DATABASE_USER}"
create_database_grant_privilege "${ABUBA_DATABASE_NAME}" "${ABUBA_DATABASE_USER}"
