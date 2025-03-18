#!/usr/bin/env bash

set -e
set -u

POSTGRES_APP="psql --username ${POSTGRES_USER}"

create_user_with_password() {
  local user="${1}"
  local password="${2}"

  echo "Creating database role: '${user}'"

  ${POSTGRES_APP} <<-EOSQL
  CREATE USER ${user} WITH CREATEDB PASSWORD '${password}';
EOSQL
}

create_user_with_password "${DOCKER_DATABASE_USER}" "${DOCKER_DATABASE_PASSWORD}"
create_user_with_password "${ABUBA_DATABASE_USER}" "${ABUBA_DATABASE_PASSWORD}"
