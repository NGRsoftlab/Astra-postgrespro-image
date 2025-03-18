#!/usr/bin/env bash

set -e
set -u

## Init license
for i in /sql-scripts/*.sql; do
  psql --username "${POSTGRES_USER}" -d "${ABUBA_DATABASE_NAME}" -f "${i}"
done
