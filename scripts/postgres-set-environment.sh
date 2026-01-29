#!/usr/bin/env bash

set -Eeuo pipefail

## Check receiving args on exists
: "${1:?}"

postgres_set_env() {
  local full_version postgres_major_minor_version

  local postgres_version="${1}"

  ## Update cache
  apt-env.sh apt-get update -qq

  ## Search version on repository if received version is approximately
  full_version=$(apt-cache show postgrespro-"${postgres_version}"-server \
    | grep -E '^Version:' \
    | sort -rV \
    | head -n1 \
    | awk '{print $2}' || echo '')

  ## Define variables for /etc/environment
  postgres_major_minor_version=$(postgres --version | tr -d '[:space:][:alpha:],()')

  ## Filling /etc/environment
  {
    echo "POSTGRES_REVISION=${full_version}"
    echo "BEGIN_BUILD_IN_EPOCH=$(date '+%s')"
    echo "POSTGRES_MAJOR_MINOR_VERSION=${postgres_major_minor_version}"
  } >>/etc/environment
}

postgres_set_env "${1}"

exit 0
