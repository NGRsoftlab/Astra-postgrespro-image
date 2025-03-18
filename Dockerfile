## Definite image args
ARG image_registry=***REMOVED***
ARG image_name=astra
ARG image_version=1.8.1

# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                         Base image                          #
#           First stage, install and build components         #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
FROM ${image_registry}${image_name}:${image_version}

SHELL ["/bin/bash", "-exo", "pipefail", "-c"]

## Set base label
LABEL \
    maintainer="Vladislav Avdeev" \
    organization="NGRSoftlab"

## Def initial arg(will be replaced with docker build opt)
ARG version=1.0.0
ARG postgrespro_link=https://repo.postgrespro.ru/std/std-15/keys/pgpro-repo-add.sh
ARG postgrespro_package_suffix='std-15'
ARG postgrespro_version=15

## ENV for build args
ENV \
    VERSION="${version}" \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    TERM=linux \
    TZ=Etc/UTC \
    MALLOC_ARENA_MAX=2 \
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

## Copy build scripts
COPY scripts/. /usr/local/sbin/

## Install build components
## Always use the latest version available for the current DEB distribution
# hadolint ignore=DL3008, DL3027
RUN \
    apt update \
    && apt-env.sh apt -y install --no-install-recommends -qq \
        locales \
        wget \
        dumb-init \
        libnss-wrapper \
        xz-utils \
        zstd \
## https://www.postgresql.org/docs/16/app-psql.html#APP-PSQL-META-COMMAND-PSET-PAGER
## https://github.com/postgres/postgres/blob/REL_16_1/src/include/fe_utils/print.h#L25
## (if "less" is available, it gets used as the default pager for psql, and it only adds ~1.5MiB to our image size)
        less \
## Update locales
    && locale-gen ru_RU ru_RU.UTF-8 en_US.UTF-8 \
    && dpkg-reconfigure locales \
    # LANG=ru_RU.UTF-8
    && update-locale \
## Remove cache
    && apt-clean.sh \
## Def version container
    && echo "Minimal Container version ${VERSION}" > /etc/issue

## Set locale language
ENV LANG=ru_RU.UTF-8

## Reduce perl-base: hardlink->symlink
RUN \
    PERL_BASE=/usr/bin \
    && find "${PERL_BASE}/" -wholename "${PERL_BASE}/perl5*" -exec ln -fsv perl {} ';' \
    && ls -li "${PERL_BASE}/perl"*

## Temporary directory for installer
WORKDIR /tmp

## Copy '.c' file
COPY ./configuration/su-exec.c su-exec.c

## Install build components for compile su-exec
# hadolint ignore=DL3008, DL3027
RUN \
    apt update \
    && apt-env.sh apt -y install --no-install-recommends -qq \
        gcc \
        libc-dev \
## Compile su-exec
    && gcc -Os -no-pie -static -std=gnu99 -s -Wall -Werror \
        -o /usr/local/bin/su-exec su-exec.c \
    && chmod 0700 /usr/local/bin/su-exec \
## Remove packages
    && apt-env.sh apt-remove.sh gcc libc-dev \
## Remove cache
    && apt-clean.sh

## Install postgres
RUN \
    groupadd -r postgres --gid=999 \
## https://salsa.debian.org/postgresql/postgresql-common/blob/997d842ee744687d99a2b2d95c1083a2615c79e8/debian/postgresql-common.postinst#L32-35
    && useradd -r -g postgres --uid=999 --home-dir="${PG_DIR}" --shell=/bin/bash postgres \
    && wget --progress=dot:giga \
        "${postgrespro_link}" \
    && apt-env.sh sh pgpro-repo-add.sh \
    && apt-env.sh apt -y install --no-install-recommends -qq \
        postgrespro-"${PG_VERSION_SUFFIX}" \
    && mkdir /docker-entrypoint-initdb.d \
    && mkdir -p /usr/share/postgresql \
    && dpkg-divert --add --rename --divert "/usr/share/postgresql/postgresql.conf.sample.dpkg" "${BINDIR%/*}/share/postgresql.conf.sample" \
    && cp -v /usr/share/postgresql/postgresql.conf.sample.dpkg /usr/share/postgresql/postgresql.conf.sample \
    && ln -sv /usr/share/postgresql/postgresql.conf.sample "${BINDIR%/*}/share/" \
    && sed -ri "s!^#?(listen_addresses)\s*=\s*\S+.*!\1 = '*'!" /usr/share/postgresql/postgresql.conf.sample \
    && grep -F "listen_addresses = '*'" /usr/share/postgresql/postgresql.conf.sample \
## Remove packages
    && apt-env.sh apt-remove.sh wget \
## Remove cache
    && apt-clean.sh

## Deduplicate
# hadolint ignore=DL3027, DL4006
RUN \
    apt update \
    && apt-env.sh apt -y install --no-install-recommends --no-install-suggests \
        jdupes \
    && apt-clean.sh \
    && echo; du -xd1 /usr/ | sort -Vk2; echo \
    && jdupes -1LSpr /usr/ \
    && echo; du -xd1 /usr/ | sort -Vk2; echo \
    && apt-env.sh apt-remove.sh jdupes

## Remove unwanted binaries
RUN \
    rm-binary.sh \
            addgroup \
            addpart \
            adduser \
            apt-ftparchive \
            agetty \
            badblocks \
            blkdiscard \
            blkid \
            blkzone \
            blockdev \
            bsd-write \
            chage \
            chcpu \
            chfn \
            chgpasswd \
            chmem \
            chpasswd \
            chsh \
            cpgr \
            cppw \
            crontab \
            ctrlaltdel \
            debugfs \
            delgroup \
            delpart \
            deluser \
            dmesg \
            dumpe2fs \
            e2freefrag \
            e2fsck \
            e2image \
            e2label \
            e2mmpstatus \
            e2scrub \
            'e2scrub*' \
            e2undo \
            e4crypt \
            e4defrag \
            expiry \
            faillock \
            fdformat \
            fincore \
            findfs \
            fsck \
            'fsck.*' \
            fsfreeze \
            fstrim \
            getty \
            gpasswd \
            groupadd \
            groupdel \
            groupmems \
            groupmod \
            grpck \
            grpconv \
            grpunconv \
            hwclock \
            isosize \
            last \
            lastb \
            ldattach \
            losetup \
            lsblk \
            lsirq \
            lslogins \
            mcookie \
            mesg \
            mke2fs \
            mkfs \
            'mkfs.*' \
            mkhomedir_helper \
            mklost+found \
            mkswap \
            mount \
            newgrp \
            newusers \
            pam-auth-update \
            pam_getenv \
            pam_namespace_helper \
            pam_timestamp_check \
            partx \
            passwd \
            pivot_root \
            pwck \
            pwconv \
            pwhistory_helper \
            pwunconv \
            raw \
            readprofile \
            resize2fs \
            resizepart \
            rtcwake \
            sg \
            shadowconfig \
            su \
            sulogin \
            swaplabel \
            swapoff \
            swapon \
            switch_root \
            tune2fs \
            umount \
            unix_chkpwd \
            unix_update \
            update-passwd \
            useradd \
            userdel \
            usermod \
            utmpdump \
            vigr \
            vipw \
            wall \
            wdctl \
            wipefs \
            write \
            'write.*' \
            zramctl

## Prune unused files
RUN \
    find /usr/local/sbin/ ! -type d -ls -delete \
    find /tmp/ ! -type d -ls -delete \
    && find /run/ -mindepth 1 -ls -delete || : \
    && install -d -m 01777 /run/lock

## Create postgres space dirs
RUN \
    install --verbose --directory --owner postgres --group postgres --mode 3777 /var/run/postgresql \
## Also create the postgres user's home directory with appropriate permissions
## See https://github.com/docker-library/postgres/issues/274
    && install --verbose --directory --owner postgres --group postgres --mode 1777 "${PG_DIR}" \
## This 1777 will be replaced by 0700 at runtime (allows semi-arbitrary "--user" values)
    && install --verbose --directory --owner postgres --group postgres --mode 1777 "${PGDATA}" \
    && install --verbose --directory --owner postgres --group postgres --mode 1777 "/etc/postgresql"

## Set volume
VOLUME "${PGDATA}"

## Copy entrypoint file
COPY configuration/docker-entrypoint.sh /sbin/docker-entrypoint.sh

## Be gentle and expose port
EXPOSE 5432/tcp

## Set base directory
WORKDIR "${PG_DIR}"

ENTRYPOINT [ "dumb-init", "docker-entrypoint.sh" ]

## Calls "Fast Shutdown mode" wherein new connections are disallowed and any
## in-progress transactions are aborted, allowing PostgreSQL to stop cleanly and
## flush tables to disk.
#
## See https://www.postgresql.org/docs/current/server-shutdown.html for more details
## about available PostgreSQL server shutdown signals.
#
## See also https://www.postgresql.org/docs/current/server-start.html for further
## justification of this as the default value, namely that the example (and
## shipped) systemd service files use the "Fast Shutdown mode" for service
## termination.

STOPSIGNAL SIGINT

## An additional setting that is recommended for all users regardless of this
## value is the runtime "--stop-timeout" (or your orchestrator/runtime's
## equivalent) for controlling how long to wait between sending the defined
## STOPSIGNAL and sending SIGKILL.
#
## The default in most runtimes (such as Docker) is 10 seconds, and the
## documentation at https://www.postgresql.org/docs/current/server-start.html notes
## that even 90 seconds may not be long enough in many instances.

CMD [ "postgres" ]
