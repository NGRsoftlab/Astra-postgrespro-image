#!/usr/bin/env bash

set -Eeo pipefail

[[ ${DEBUG} != 'ON' ]] || set -x

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
# Check to see if this file is being run or
# sourced from another script
# RETURN:
#   0 or 1
#############################################
_is_sourced() {
  # https://unix.stackexchange.com/a/215279
  [[ ${#FUNCNAME[@]} -ge 2 ]] \
    && [[ ${FUNCNAME[0]} == '_is_sourced' ]] \
    && [[ ${FUNCNAME[1]} == 'source' ]]
}

#############################################
# Check arguments for an option that would cause postgres to stop
# RETURN:
#   0 or 1
#############################################
_pg_want_help() {
  local arg
  for arg; do
    case "$arg" in
      # postgres --help | grep 'then exit'
      # leaving out -C on purpose since it always fails and is unhelpful:
      # postgres: could not access the server configuration file "/var/lib/postgresql/data/postgresql.conf": No such file or directory
      -'?' | --help | --describe-config | -V | --version)
        return 0
        ;;
    esac
  done
  return 1
}

#############################################
# Will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
# "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature
# USAGE:
#   file_env VAR [DEFAULT]
#   ie: file_env 'XYZ_DB_PASSWORD' 'example'
# RETURN:
#   Filled value of type KEY=VALUE
#############################################
file_env() {
  local var fileVar def
  var="${1}"
  fileVar="${var}_FILE"
  def="${2:-}"

  if [[ "${!var:-}" ]] && [[ "${!fileVar:-}" ]]; then
    logger_fail "both ${var} and ${f}ileVar are set (but are exclusive)"
  fi
  local val="$def"
  if [[ "${!var:-}" ]]; then
    val="${!var}"
  elif [[ "${!fileVar:-}" ]]; then
    val="$(<"${!fileVar}")"
  fi
  export "$var"="$val"
  unset "${f}ileVar"
}

#############################################
# Loads various settings that are used elsewhere in the script
# This should be called before any other functions
# RETURN:
#   0 in success or stderr
#############################################
docker_setup_env() {
  file_env 'POSTGRES_PASSWORD'
  file_env 'POSTGRES_USER' 'postgres'
  file_env 'POSTGRES_DB' "${POSTGRES_USER}"
  file_env 'POSTGRES_INITDB_ARGS'
  : "${POSTGRES_HOST_AUTH_METHOD:=}"

  declare -g DATABASE_ALREADY_EXISTS
  : "${DATABASE_ALREADY_EXISTS:=}"
  ## Look specifically for PG_VERSION, as it is expected in the DB dir
  if [[ -s "${PGDATA}/PG_VERSION" ]]; then
    DATABASE_ALREADY_EXISTS='true'
  fi
}

#############################################
# Used to create initial postgres directories and
# if run as root, ensure ownership to the "postgres" user
# RETURN:
#   0 in success or stderr
#############################################
docker_create_db_directories() {
  local user
  user="$(id -u)"

  mkdir -p "${PGDATA}"
  ## Ignore failure since there are cases where we can't chmod (and PostgreSQL might fail later anyhow - it's picky about permissions of this directory)
  chmod 00700 "${PGDATA}" || :

  ## Ignore failure since it will be fine when using the image provided directory; see also https://github.com/docker-library/postgres/pull/289
  mkdir -p /var/run/postgresql || :
  chmod 03775 /var/run/postgresql || :

  ## Create the transaction log directory before initdb is run so the directory is owned by the correct user
  if [[ -n ${POSTGRES_INITDB_WALDIR:-} ]]; then
    mkdir -p "${POSTGRES_INITDB_WALDIR}"
    [[ ${user} -ne 0 ]] || find "${POSTGRES_INITDB_WALDIR}" \! -user postgres -exec chown postgres '{}' +
    chmod 700 "${POSTGRES_INITDB_WALDIR}"
  fi

  ## Allow the container to be started with `--user`
  [[ ${user} -ne 0 ]] || find "${PGDATA}" \! -user postgres -exec chown postgres '{}' +
  [[ ${user} -ne 0 ]] || find /var/run/postgresql \! -user postgres -exec chown postgres '{}' +
}

#############################################
# Print large warning if POSTGRES_PASSWORD is long
# Warning if POSTGRES_PASSWORD is empty(and set default password) and POSTGRES_HOST_AUTH_METHOD is not 'trust'
# Print large warning if POSTGRES_HOST_AUTH_METHOD is set to 'trust'
# Assumes database is not set up, ie: [ -z "$DATABASE_ALREADY_EXISTS" ]
# OUTPUT:
#   Write to stdout
#############################################
docker_verify_minimum_env() {
  case "${PG_MAJOR:-}" in
    13)
      # https://github.com/postgres/postgres/commit/67a472d71c98c3d2fa322a1b4013080b20720b98
      # check password first so we can output the warning before postgres
      # messes it up
      if [[ ${#POSTGRES_PASSWORD} -ge 100 ]]; then
        logger_warning_message 'The supplied POSTGRES_PASSWORD is 100+ characters'
        logger_warning_message 'This will not work if used via PGPASSWORD with "psql"'
        logger_warning_message 'https://www.postgresql.org/message-id/flat/E1Rqxp2-0004Qt-PL%40wrigleys.postgresql.org (BUG #6412)'
        logger_warning_message 'https://github.com/docker-library/postgres/issues/507'
      fi
      ;;
  esac
  if [[ -z ${POSTGRES_PASSWORD} ]] && [[ 'trust' != "${POSTGRES_HOST_AUTH_METHOD}" ]]; then
    POSTGRES_PASSWORD="NGRSoftlab"
    logger_warning_message "DEFAULT PASSWORD WAS USED!"
    logger_warning_message "MOST IMPORTANT TO CHANGE TO YOUR PRIVATE PASSWORD!"
    export POSTGRES_PASSWORD
  fi
  if [[ 'trust' == "${POSTGRES_HOST_AUTH_METHOD}" ]]; then
    logger_warning_message 'POSTGRES_HOST_AUTH_METHOD has been set to "trust"'
    logger_warning_message 'This will allow anyone with access to the Postgres port to access your database without a password'
    logger_warning_message 'This will allow anyone with access to the Postgres port to access your database without a password, even if POSTGRES_PASSWORD is set'
    logger_warning_message 'See PostgreSQL documentation about "trust": https://www.postgresql.org/docs/current/auth-trust.html'
    logger_warning_message 'It is not recommended to use POSTGRES_HOST_AUTH_METHOD=trust'
    logger_warning_message 'Replace it with "-e POSTGRES_PASSWORD=password" instead to set a password in "docker run"'
  fi
}

#############################################
# Initialize empty PGDATA directory with new database via 'initdb'
# Arguments to `initdb` can be passed via POSTGRES_INITDB_ARGS or as arguments to this function
# `initdb` automatically creates the "postgres", "template0", and "template1" dbnames
# this is also where the database user is created, specified by `POSTGRES_USER` env
# OUTPUT:
#   Write to stdout
#############################################
docker_init_database_dir() {
  ## "initdb" is particular about the current user existing in "/etc/passwd", so we use "nss_wrapper" to fake that if necessary
  ## see https://github.com/docker-library/postgres/pull/253, https://github.com/docker-library/postgres/issues/359, https://cwrap.org/nss_wrapper.html
  local uid
  uid="$(id -u)"
  if ! getent passwd "${uid}" &>/dev/null; then
    ## see if we can find a suitable "libnss_wrapper.so" (https://salsa.debian.org/sssd-team/nss-wrapper/-/commit/b9925a653a54e24d09d9b498a2d913729f7abb15)
    local wrapper
    for wrapper in {/usr,}/lib{/*,}/libnss_wrapper.so; do
      if [[ -s ${wrapper} ]]; then
        NSS_WRAPPER_PASSWD="$(mktemp)"
        NSS_WRAPPER_GROUP="$(mktemp)"
        export LD_PRELOAD="${wrapper}" NSS_WRAPPER_PASSWD NSS_WRAPPER_GROUP
        local gid
        gid="$(id -g)"
        printf 'postgres:x:%s:%s:PostgreSQL:%s:/bin/false\n' "${uid}" "${gid}" "${PGDATA}" >"${NSS_WRAPPER_PASSWD}"
        printf 'postgres:x:%s:\n' "${gid}" >"${NSS_WRAPPER_GROUP}"
        break
      fi
    done
  fi

  if [[ -n ${POSTGRES_INITDB_WALDIR:-} ]]; then
    set -- --waldir "${POSTGRES_INITDB_WALDIR}" "$@"
  fi

  export DB_LOCALE="${LOCALE:-en_US.UTF8}"
  ## --pwfile refuses to handle a properly-empty file (hence the "\n"): https://github.com/docker-library/postgres/issues/1025
  eval 'initdb --username="${POSTGRES_USER}" --encoding=unicode --locale=${DB_LOCALE} --pwfile=<(printf "%s\n" "${POSTGRES_PASSWORD}") '"${POSTGRES_INITDB_ARGS}"' "$@"'

  # unset/cleanup "nss_wrapper" bits
  if [[ ${LD_PRELOAD:-} == */libnss_wrapper.so ]]; then
    rm -f "${NSS_WRAPPER_PASSWD}" "${NSS_WRAPPER_GROUP}"
    unset LD_PRELOAD NSS_WRAPPER_PASSWD NSS_WRAPPER_GROUP
  fi
}

#############################################
# Append POSTGRES_HOST_AUTH_METHOD to pg_hba.conf for "host" connections
# all arguments will be passed along as arguments to `postgres` for
# getting the value of 'password_encryption'
# OUTPUT:
#   Write to stdout
#############################################
pg_setup_hba_conf() {
  # default authentication method is scram-sha-256
  if [[ $1 == 'postgres' ]]; then
    shift
  fi
  local auth
  # check the default/configured encryption and use that as the auth method
  auth="$(postgres -C password_encryption "$@")"
  : "${POSTGRES_HOST_AUTH_METHOD:=$auth}"
  {
    printf '\n'
    if [[ 'trust' == "${POSTGRES_HOST_AUTH_METHOD}" ]]; then
      printf '# warning trust is enabled for all connections\n'
      printf '# see https://www.postgresql.org/docs/17/auth-trust.html\n'
    fi
    printf 'host all all all %s\n' "${POSTGRES_HOST_AUTH_METHOD}"
  } >>"${PGDATA}/pg_hba.conf"
}

#############################################
# Start socket-only postgresql server for setting up or running scripts
# all arguments will be passed along as arguments to `postgres` (via pg_ctl)
# OUTPUT:
#   Write to stdout
#############################################
docker_temp_server_start() {
  if [ "$1" = 'postgres' ]; then
    shift
  fi

  # internal start of server in order to allow setup using psql client
  # does not listen on external TCP/IP and waits until start finishes
  set -- "$@" -c listen_addresses='' -p "${PGPORT:-5432}"

  # unset NOTIFY_SOCKET so the temporary server doesn't prematurely notify
  # any process supervisor.
  # shellcheck disable=SC1007
  NOTIFY_SOCKET= \
    PGUSER="${PGUSER:-$POSTGRES_USER}" \
    pg_ctl -D "${PGDATA}" \
    -o "$(printf '%q ' "$@")" \
    -w start
}

#############################################
# Create initial database
# uses environment variables for input: POSTGRES_DB
# OUTPUT:
#   Write to stdout
#############################################
docker_setup_db() {
  local DB_ALREADY_EXISTS
  DB_ALREADY_EXISTS="$(
    # shellcheck disable=SC2097,SC1007,SC2098
    POSTGRES_DB= docker_process_sql --dbname postgres --set db="${POSTGRES_DB}" --tuples-only <<-'EOSQL'
      SELECT 1 FROM pg_database WHERE datname = :'db' ;
EOSQL
  )"
  if [[ -z ${DB_ALREADY_EXISTS} ]]; then
    # shellcheck disable=SC2097,SC1007,SC2098
    POSTGRES_DB= docker_process_sql --dbname postgres --set db="${POSTGRES_DB}" <<-'EOSQL'
      CREATE DATABASE :"db" ;
EOSQL
    printf '\n'
  fi
}

#############################################
# Execute sql script, passed via stdin (or -f flag of psql)
# USAGE:
#   docker_process_sql [psql-cli-args]
#   ie: docker_process_sql --dbname=mydb <<<'INSERT ...'
#   ie: docker_process_sql -f my-file.sql
#   ie: docker_process_sql <my-file.sql
# OUTPUT:
#   Write to stdout
#############################################
docker_process_sql() {
  local query_runner=(psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" --no-password --no-psqlrc)
  if [[ -n ${POSTGRES_DB} ]]; then
    query_runner+=(--dbname "${POSTGRES_DB}")
  fi

  # shellcheck disable=SC1007
  PGHOST= PGHOSTADDR= "${query_runner[@]}" "$@"
}

#############################################
# Process initializer files, based on file extensions and permissions
# USAGE:
#   docker_process_init_files [file [file [...]]]
#   ie: docker_process_init_files /always-initdb.d/*
# OUTPUT:
#   Write to stdout
#############################################
docker_process_init_files() {
  # psql here for backwards compatibility "${psql[@]}"
  # shellcheck disable=SC2034
  psql=(docker_process_sql)

  printf '\n'
  local f
  for f; do
    case "${f}" in
      *.sh)
        # https://github.com/docker-library/postgres/issues/450#issuecomment-393167936
        # https://github.com/docker-library/postgres/pull/452
        if [[ -x ${f} ]]; then
          logger_info_message "${0}: running ${f}"
          "${f}"
        else
          logger_info_message "${0}: sourcing ${f}"
          # shellcheck disable=SC1090
          . "${f}"
        fi
        ;;
      *.sql)
        logger_info_message "${0}: running ${f}"
        docker_process_sql -f "${f}"
        printf '\n'
        ;;
      *.sql.gz)
        logger_info_message "${0}: running ${f}"
        gunzip -c "${f}" | docker_process_sql
        printf '\n'
        ;;
      *.sql.xz)
        logger_info_message "${0}: running ${f}"
        xzcat "${f}" | docker_process_sql
        printf '\n'
        ;;
      *.sql.zst)
        logger_info_message "${0}: running ${f}"
        zstd -dc "${f}" | docker_process_sql
        printf '\n'
        ;;
      *)
        logger_warning_message "${0}: ignoring ${f}"
        ;;
    esac
    printf '\n'
  done
}

#############################################
# Stop postgresql server after done setting up user and running scripts
# OUTPUT:
#   Write to stdout
#############################################
docker_temp_server_stop() {
  PGUSER="${PGUSER:-postgres}" \
    pg_ctl -D "${PGDATA}" -m fast -w stop
}

#############################################
# Main entrypoint for init action
# OUTPUTS:
#   Write to stdout
#############################################
main() {
  ## If first arg looks like a flag, assume we want to run postgres server
  if [[ ${1:0:1} == '-' ]]; then
    set -- postgres "$@"
  fi

  # Check can be loaded '/etc/environment' as default?
  # shellcheck disable=SC2163
  if [[ -f /etc/environment ]]; then
    while IFS= read -r line; do
      [ -z "${line}" ] && continue
      case "${line}" in
        \#*) continue ;;
        *) export "${line}" ;;
      esac
    done </etc/environment
  fi

  if [[ $1 == 'postgres' ]] && ! _pg_want_help "$@"; then
    docker_setup_env
    ## Setup data directories and permissions (when run as root)
    docker_create_db_directories
    if [[ "$(id -u)" -eq '0' ]]; then
      # ## Set OOM killer priority
      # echo -1000 > "${PG_OOM_ADJUST_FILE}"

      # Then restart script as postgres user
      exec su-exec postgres "${BASH_SOURCE[@]}" "$@"
    fi

    # Check, can preview '/etc/issue'?
    if [[ -s /etc/issue ]] && [[ ! -t 0 ]]; then
      cat /etc/issue
    fi

    # only run initialization on an empty data directory
    if [[ -z ${DATABASE_ALREADY_EXISTS} ]]; then
      docker_verify_minimum_env

      # check dir permissions to reduce likelihood of half-initialized database
      ls /docker-entrypoint-initdb.d/ >/dev/null

      docker_init_database_dir
      pg_setup_hba_conf "$@"

      # PGPASSWORD is required for psql when authentication is required for 'local' connections via pg_hba.conf and is otherwise harmless
      # e.g. when '--auth=md5' or '--auth-local=md5' is used in POSTGRES_INITDB_ARGS
      export PGPASSWORD="${PGPASSWORD:-$POSTGRES_PASSWORD}"
      docker_temp_server_start "$@"

      docker_setup_db
      docker_process_init_files /docker-entrypoint-initdb.d/*

      docker_temp_server_stop
      unset PGPASSWORD

      echo ".......WoOoOoOoOoOob-WoOoOoOoOoOoOoOoOoOoOoOob-WoOoOoOoOoOob-WoOoOoOoOoOoOoOoOoOoOoOob......."
      logger_info_message "PostgreSQL init process complete"
      logger_info_message "Ready for start up PostgresPro $("${BINDIR}"/postgres --version)"
    else
      echo ".......WoOoOoOoOoOob-WoOoOoOoOoOoOoOoOoOoOoOob-WoOoOoOoOoOob-WoOoOoOoOoOoOoOoOoOoOoOob......."
      logger_warning_message "PostgreSQL Database directory appears to contain a database"
      logger_warning_message "Skipping initialization"
    fi

    ## set -e is stalking the returned code
    "${BINDIR}/check-db-dir" "${PGDATA}"
    echo ".......WoOoOoOoOoOoOoOoOoOoOoOob-WoOoOoOoOoOob-WoOoOoOoOoOoOoOoOoOoOoOob-WoOoOoOoOoOob......."
  fi

  PG_OOM_ADJUST_FILE=-1000 PG_OOM_ADJUST_VALUE="${PG_OOM_ADJUST_VALUE}" _ADJPATH="${BINDIR}:/usr/bin:/usr/sbin:/bin:/sbin" exec "$@"
}

## Start ep
if ! _is_sourced; then
  main "$@"
fi
