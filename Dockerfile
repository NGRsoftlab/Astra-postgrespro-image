## Definite image args
ARG image_registry
ARG image_name=astra
ARG image_version=1.8.2-slim

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                         Build image                         #
#              First stage, build static component            #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
FROM ${image_registry}${image_name}:${image_version} AS build-stage

SHELL ["/bin/bash", "-exo", "pipefail", "-c"]

## Def initial arg(will be replaced with docker build opt)
ARG postgrespro_link=https://repo.postgrespro.ru/std/std-15/keys/pgpro-repo-add.sh

## ENV for build args
ENV \
    TERM=linux \
    TZ=Etc/UTC \
## Set locale language
    LANG=en_US.UTF8

## Temporary directory for installer
WORKDIR /opt

## Copy '.c' file
COPY configuration/su-exec.c su-exec.c

## Compile su-exec
# hadolint ignore=DL3008, DL3027
RUN \
    --mount=type=bind,source=./scripts,target=/usr/local/sbin,readonly \
    apt-install.sh \
## Compile .c
        gcc \
        libc-dev \
    && gcc -Os -no-pie -static -std=gnu99 -s -Wall -Werror \
        -o /usr/local/bin/su-exec su-exec.c \
    && rm su-exec.c \
## Remove packages
    && apt-env.sh apt-remove.sh gcc libc-dev \
    && apt-clean.sh

## Download postgres component
# hadolint ignore=DL3008, DL3027
RUN \
    --mount=type=bind,source=./scripts,target=/usr/local/sbin,readonly \
    --mount=type=secret,id=pg_auth,target=/run/secrets/pg_auth \
    apt-install.sh \
## Download from source
        wget \
## Pass secrets
    && echo "machine $(grep address /run/secrets/pg_auth | cut -d= -f2) login $(grep username /run/secrets/pg_auth | cut -d= -f2) password $(grep password /run/secrets/pg_auth | cut -d= -f2)" > ~/.netrc \
    && wget --progress=dot:giga \
        "${postgrespro_link}" \
    && apt-env.sh sh pgpro-repo-add.sh \
    && rm pgpro-repo-add.sh \
    && rm ~/.netrc \
## Remove packages
    && apt-env.sh apt-remove.sh wget \
    && apt-clean.sh

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                     Environment image                       #
#   Second stage, install components and prepare environment  #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
FROM ${image_registry}${image_name}:${image_version} AS environment-stage

SHELL ["/bin/bash", "-exo", "pipefail", "-c"]

## Def initial arg(will be replaced with docker build opt)
ARG version=1.0.0
ARG postgrespro_package_suffix='std-15'

## ENV for build args
ENV \
    TERM=linux \
    TZ=Etc/UTC \
## Set locale language
    LANG=en_US.UTF8 \
## Set postgres variables
    PG_DIR="/var/lib/pgpro/${postgrespro_package_suffix}" \
    PG_VERSION_SUFFIX="${postgrespro_package_suffix}"

## https://github.com/hadolint/hadolint/wiki/DL3044
ENV \
    PGDATA="${PG_DIR}/data" \
    BINDIR="/opt/pgpro/${PG_VERSION_SUFFIX}/bin"
ENV PATH="${BINDIR}:${PATH}"

## Copy entrypoint file
COPY --chmod=0755 configuration/docker-entrypoint.sh /usr/local/bin/

## Copy from build stage
COPY --from=build-stage --chmod=0700 /usr/local/bin/su-exec /usr/local/bin/

## Copy issue
COPY docs/issue /etc/issue

## Temporary directory for installer
WORKDIR /tmp

## Install app base components
# hadolint ignore=DL3008, DL3027
RUN \
    --mount=type=bind,source=./scripts,target=/usr/local/sbin,readonly \
## Provide the key and Prevent spontaneous leakage
    --mount=type=bind,from=build-stage,source=/etc/apt/auth.conf.d,target=/etc/apt/auth.conf.d,readonly \
    --mount=type=bind,from=build-stage,source=/etc/apt/sources.list.d,target=/etc/apt/sources.list.d,readonly \
    --mount=type=bind,from=build-stage,source=/etc/apt/trusted.gpg.d/postgrespro.gpg,target=/etc/apt/trusted.gpg.d/postgrespro.gpg,readonly \
    groupadd -r postgres --gid=999 \
## https://salsa.debian.org/postgresql/postgresql-common/blob/997d842ee744687d99a2b2d95c1083a2615c79e8/debian/postgresql-common.postinst#L32-35
    && useradd -r -g postgres --uid=999 --home-dir="${PG_DIR}" --shell=/bin/bash postgres \
    && apt-install.sh \
## Init agent
        dumb-init \
## Establish free,ps and etc
        procps \
## Postgres ep import
        libnss-wrapper \
        xz-utils \
        zstd \
## https://www.postgresql.org/docs/16/app-psql.html#APP-PSQL-META-COMMAND-PSET-PAGER
## https://github.com/postgres/postgres/blob/REL_16_1/src/include/fe_utils/print.h#L25
## (if "less" is available, it gets used as the default pager for psql, and it only adds ~1.5MiB to our image size)
        less \
## Install postgres
    && apt-install.sh \
        postgrespro-"${PG_VERSION_SUFFIX}"-server \
        ## additional facilities for Postgres Pro
        postgrespro-"${PG_VERSION_SUFFIX}"-contrib \
## Set postgres build environment
    && postgres-set-environment.sh "${PG_VERSION_SUFFIX}" \
## Test postgres
    && postgres --version \
## Create ep dirs
    && mkdir /docker-entrypoint-initdb.d \
## Overriding the default configuration location
    && mkdir -p /usr/share/postgresql \
    && dpkg-divert --add --rename --divert \
        "/usr/share/postgresql/postgresql.conf.sample.dpkg" \
        "${BINDIR%/*}/share/postgresql.conf.sample" \
    && cp -v /usr/share/postgresql/postgresql.conf.sample.dpkg /usr/share/postgresql/postgresql.conf.sample \
    && ln -sv /usr/share/postgresql/postgresql.conf.sample "${BINDIR%/*}/share/" \
    && sed -ri "s!^#?(listen_addresses)\s*=\s*\S+.*!\1 = '*'!" /usr/share/postgresql/postgresql.conf.sample \
    && grep -F "listen_addresses = '*'" /usr/share/postgresql/postgresql.conf.sample \
## Create postgres space dirs
    && install --verbose --directory --owner postgres --group postgres --mode 3777 /var/run/postgresql \
## Also create the postgres user's home directory with appropriate permissions
## See https://github.com/docker-library/postgres/issues/274
    && install --verbose --directory --owner postgres --group postgres --mode 1777 "${PG_DIR}" \
## This 1777 will be replaced by 0700 at runtime (allows semi-arbitrary "--user" values)
    && install --verbose --directory --owner postgres --group postgres --mode 1777 "${PGDATA}" \
    && install --verbose --directory --owner postgres --group postgres --mode 1777 "/etc/postgresql" \
## Remove unwanted binaries
    && rm-binary.sh \
        addgroup \
        adduser \
        delgroup \
        deluser \
        passwd \
        su \
        sulogin \
        update-passwd \
        useradd \
        userdel \
        usermod \
## Remove cache
    && apt-clean.sh

## Prune unused files
RUN \
    --mount=type=bind,source=./scripts,target=/usr/local/sbin,readonly \
    { \
        find /run/ -mindepth 1 -ls -delete || :; \
    } \
    && find /tmp/ ! -type d -ls -delete \
    && install -d -m 01777 /run/lock \
## Deduplication cleanup
    && dedup-clean.sh /usr/ \
## Def version container
    && echo "Build PostgresPro container version ${version}" >> /etc/issue \
## Test su-exec
    && su-exec nobody true \
## Get image package dump
    && mkdir -p /usr/share/rocks \
    && ( \
        echo "# os-release" && cat /etc/os-release \
        && echo "# dpkg-query" \
        && dpkg-query -f \
            '${db:Status-Abbrev},${binary:Package},${Version},${source:Package},${Source:Version}\n' \
            -W \
        ) >/usr/share/rocks/dpkg.query \
## Check can be preview /etc/issue
    && { \
        grep -qF 'cat /etc/issue' /etc/bash.bashrc \
        || echo 'cat /etc/issue' >> /etc/bash.bashrc; \
    }

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                        Final image                          #
#             Third stage, compact optimize layer             #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
FROM scratch

COPY --from=environment-stage / /

## Set base label
LABEL \
    maintainer="Vladislav Avdeev" \
    organization="NGRSoftlab"

## Def initial arg(will be replaced with docker build opt)
ARG postgrespro_package_suffix='std-15'
ARG postgrespro_version=15
ARG version=1.0.0

## ENV for build args
ENV \
    VERSION="${version}" \
    TERM=linux \
    TZ=Etc/UTC \
    TERM='xterm-256color' \
    DEBIAN_FRONTEND='noninteractive' \
## Set locale language
    LANG=en_US.UTF8 \
## Set postgres variables
    PG_USER=postgres \
    PG_DIR="/var/lib/pgpro/${postgrespro_package_suffix}" \
    PG_VERSION_SUFFIX="${postgrespro_package_suffix}" \
    PG_MAJOR="${postgrespro_version}"

## https://github.com/hadolint/hadolint/wiki/DL3044
ENV \
    PGDATA="${PG_DIR}/data" \
    BINDIR="/opt/pgpro/${PG_VERSION_SUFFIX}/bin" \
    PG_OOM_ADJUST_VALUE=0 \
    PG_OOM_ADJUST_FILE=/proc/self/oom_score_adj \
    PG_LOG="${PG_DIR}/pgstartup-data.log"
ENV PATH="${BINDIR}:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

## Set volume creates a mount point with the specified name and marks it as
## holding externally mounted volumes from native host or other containers
VOLUME "${PGDATA}"

## Be gentle and expose port
EXPOSE 5432/tcp

## Set base directory
WORKDIR "${PG_DIR}"

ENTRYPOINT [ "dumb-init", "docker-entrypoint.sh" ]

## Calls "Fast Shutdown mode" wherein new connections are disallowed and any
## in-progress transactions are aborted, allowing PostgreSQL to stop cleanly and
## flush tables to disk
#
## See https://www.postgresql.org/docs/current/server-shutdown.html for more details
## about available PostgreSQL server shutdown signals
#
## See also https://www.postgresql.org/docs/current/server-start.html for further
## justification of this as the default value, namely that the example (and
## shipped) systemd service files use the "Fast Shutdown mode" for service
## termination
STOPSIGNAL SIGINT

## An additional setting that is recommended for all users regardless of this
## value is the runtime "--stop-timeout" (or your orchestrator/runtime's
## equivalent) for controlling how long to wait between sending the defined
## STOPSIGNAL and sending SIGKILL
#
## The default in most runtimes (such as Docker) is 10 seconds, and the
## documentation at https://www.postgresql.org/docs/current/server-start.html notes
## that even 90 seconds may not be long enough in many instances

CMD [ "postgres" ]
