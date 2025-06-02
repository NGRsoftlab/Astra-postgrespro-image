#!/usr/bin/env bash

set -Eeuo pipefail

## Check receiving args on exists
: "${1:?}"

postgres_set_env() {
  local POSTGRES_VERSION FULL_VERSION POSTGRES_REVISION POSTGRES_MAJOR_MINOR_VERSION

  POSTGRES_VERSION="${1}"

  ## Update cache
  apt-env.sh apt-get update -qq

  ## Search version on repository if received version is approximately
  FULL_VERSION=$(apt-cache show postgrespro-"${POSTGRES_VERSION}"-server \
    | grep -E '^Version:' \
    | sort -rV \
    | head -n1 \
    | awk '{print $2}' || echo '')

  ## Define variables for /etc/environment
  POSTGRES_REVISION="${FULL_VERSION}"
  POSTGRES_MAJOR_MINOR_VERSION=$(postgres --version | tr -d '[:space:][:alpha:],()')

  ## Filling /etc/environment
  {
    echo "POSTGRES_REVISION=${POSTGRES_REVISION}"
    echo "BEGIN_BUILD_IN_EPOCH=$(date '+%s')"
    echo "POSTGRES_MAJOR_MINOR_VERSION=${POSTGRES_MAJOR_MINOR_VERSION}"
  } >>/etc/environment
}

postgres_set_env "${1}"

exit 0
