#!/usr/bin/env bash

set -e

[[ "${DEBUG}" != 'ON' ]] || set -x

## Set defaults for configuration variables
BINDIR="/opt/pgpro/${PG_VERSION_SUFFIX}/bin"
PGDATA="/var/lib/pgpro/${PG_VERSION_SUFFIX}/data"
PG_OOM_ADJUST_VALUE=0
PG_OOM_ADJUST_FILE=/proc/self/oom_score_adj
export PG_OOM_ADJUST_FILE PG_OOM_ADJUST_VALUE
export PG_OOM_AJUST_VALUE
PGLOG="$(dirname "${PGDATA}")/pgstartup-$(basename "${PGDATA}").log"
export PGLOG

#############################################
# Style format
# ARGUMENTS:
#   $1, it is receive style format (int)
# OUTPUTS:
#   Return to ANSI style with format \033[FORMAT;COLORm
#############################################
tty_escape() { printf "\033[%sm" "${1}"; }

#############################################
# Bold style colors
# ARGUMENTS:
#   $1, it is receive color (int)
# OUTPUTS:
#   Return to ANSI color with format \033[BOLD;COLORm
#############################################
tty_mkbold() { tty_escape "1;${1}"; }

#############################################
# Date format
# OUTPUTS:
#   Return to dynamic actual date format YYYY-MM-DD HH:MM:SS
#############################################
# shellcheck disable=SC2317  # Don't warn about unreachable commands in this file
logger_time() { date +%F' '%T; }

## Definite color variables
logger_tty_reset="$(tty_escape 0)"
logger_tty_red="$(tty_mkbold 31)"
logger_tty_green="$(tty_mkbold 32)"
logger_tty_yellow="$(tty_mkbold 33)"
logger_tty_blue="$(tty_mkbold 34)"

#############################################
## Log the given message at the given level.
#############################################
# Log template for all received.
# All logs are written to stdout with a timestamp.
# ARGUMENTS:
#   $1, the level with specific color style
# OUTPUTS:
#   Write to stdout
#############################################
logger_template() {
  local TIMESTAMP LEVELNAME COLOR TABS
  TIMESTAMP=$(logger_time)
  LEVELNAME="${1}"

  ## Prepare actions
  case "${LEVELNAME}" in
    "INFO")
      COLOR="${logger_tty_green}"
      TABS=0
      ;;
    "WARNING")
      COLOR="${logger_tty_yellow}"
      TABS=0
      ;;
    "ERROR")
      COLOR="${logger_tty_red}"
      TABS=0
      ;;
    *)
      echo "[timestamp: $(date +%F' '%T)] [level: ERROR] undefinded log name"
      exit 1
      ;;
  esac

  ## Translation to the left side of the received log name argument
  shift 1

  ## STDOUT
  printf "[timestamp ${logger_tty_blue}${TIMESTAMP}${logger_tty_reset}] [levelname ${COLOR}${LEVELNAME}${logger_tty_reset}] %${TABS}s %s\n" "$*"
}

#############################################
# Log the given message at level, INFO
# ARGUMENTS:
#   $*, the info text to be printed
# OUTPUTS:
#   Write to stdout
#############################################
logger_info_message() {
  local MESSAGE="$*"
  logger_template "INFO" "${MESSAGE}"
}

#############################################
# Log the given message at level, WARNING
# ARGUMENTS:
#   $*, the warning text to be printed
# OUTPUTS:
#   Write to stdout
#############################################
logger_warning_message() {
  local MESSAGE="$*"
  logger_template "WARNING" "${MESSAGE}"
}

#############################################
# Log the given message at level, ERROR
# ARGUMENTS:
#   $*, the error text to be printed
# OUTPUTS:
#   Write to stdout
#############################################
logger_error_message() {
  local MESSAGE="$*"
  logger_template "ERROR" "${MESSAGE}"
}

#############################################
# Log the given message at level, ERROR
# ARGUMENTS:
#   $*, the fail text to be printed
# OUTPUTS:
#   Write to stdout and exit with status 1
#############################################
logger_fail() {
  logger_error_message "$*"
  exit 1
}

#############################################
# Change connections action
# OUTPUTS:
#   Write to stdout
#############################################
allow_external_connections() {
  echo "host    all             all             0.0.0.0/0            trust" >>"/var/lib/pgpro/${PG_VERSION_SUFFIX}/data/pg_hba.conf"
  sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" "/var/lib/pgpro/${PG_VERSION_SUFFIX}/data/postgresql.conf"
}

#############################################
# Initialize database action
# OUTPUTS:
#   Write to stdout
#############################################
init_db() {
  if [[ -n ${PG_PASSWORD} ]]; then
    echo "${PG_PASSWORD}" >/tmp/pwfile
  else
    ### DEFAULT PASSWORD
    echo "NGRSoftlab" >/tmp/pwfile
    logger_warning_message "DEFAULT PASSWORD WAS USED!"
    logger_warning_message "MOST IMPORTANT TO CHANGE TO YOUR PRIVATE PASSWORD!"
  fi

  rm -rf "${PGDATA:?}/*"
  chown postgres "${PGDATA}"

  su -l postgres -c "initdb --pgdata=${PGDATA} \
        --encoding=unicode \
        --locale=${LOCALE} \
        --auth=trust \
        --pwfile=/tmp/pwfile"

  allow_external_connections
}

#############################################
# Start database action
# OUTPUTS:
#   Write to stdout
#############################################
start_cluster() {
  logger_info_message "starting cluster daemon for PostgresPro $("${BINDIR}"/postgres --version)"

  ## set -e is stalking the returned code
  su -l postgres -c "${BINDIR}/check-db-dir ${PGDATA}"

  echo ".......WoOoOoOoOoOoOoOoOoOoOoOob-WoOoOoOoOoOob-WoOoOoOoOoOoOoOoOoOoOoOob-WoOoOoOoOoOob......."

  su -l postgres -c "PG_OOM_ADJUST_FILE=-1000 PG_OOM_ADJUST_VALUE=${PG_OOM_ADJUST_VALUE} _ADJPATH=/opt/pgpro/${PG_VERSION_SUFFIX}/bin:/usr/bin:/usr/sbin:/bin:/sbin ${BINDIR}/postgres -D '${PGDATA}' "
}

#############################################
# Main entrypoint for init action
# OUTPUTS:
#   Write to stdout
#############################################
main() {
  if [[ -n ${1} ]]; then
    echo ".......WoOoOoOoOoOob-WoOoOoOoOoOoOoOoOoOoOoOob-WoOoOoOoOoOob-WoOoOoOoOoOoOoOoOoOoOoOob......."
    logger_info_message "starting container for PostgresPro $("${BINDIR}"/postgres --version)"

    if [[ -z $(ls -A "${PGDATA}") ]]; then
      logger_info_message "initializing cluster"
      init_db
    else
      logger_warning_message "cluster was found. Skipping init"
    fi

    start_cluster
  fi
}

## Start ep
main "${1}"
