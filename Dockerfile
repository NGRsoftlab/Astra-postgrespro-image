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

## Set volume
VOLUME "/var/lib/pgpro/${postgrespro_package_suffix}/data"

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
    PG_VERSION_SUFFIX="${postgrespro_package_suffix}"

## https://github.com/hadolint/hadolint/wiki/DL3044
ENV PG_DATA="${PG_DIR}/data"

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

## Install postgres
RUN \
    wget --progress=dot:giga \
        "${postgrespro_link}" \
    && apt-env.sh sh pgpro-repo-add.sh \
    && apt-env.sh apt -y install --no-install-recommends -qq \
        postgrespro-"${PG_VERSION_SUFFIX}" \
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
    && find /run/ -mindepth 1 -ls -delete || : \
    && install -d -m 01777 /run/lock

## Copy entrypoint file
COPY configuration/docker-entrypoint.sh /sbin/docker-entrypoint.sh

## Be gentle and expose port
EXPOSE 5432/tcp

## Set base directory
WORKDIR "/var/lib/pgpro/${PG_VERSION_SUFFIX}"

ENTRYPOINT [ "dumb-init", "--" ]
CMD [ "docker-entrypoint.sh", "postgres" ]
