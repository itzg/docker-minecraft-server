#!/bin/sh

set -e
set -o pipefail

# Install necessary packages
# shellcheck disable=SC2086
apk add --no-cache -U \
    openssl \
    imagemagick \
    file \
    lsof \
    su-exec \
    coreutils \
    findutils \
    procps \
    shadow \
    bash \
    curl \
    iputils \
    git \
    jq \
    mysql-client \
    tzdata \
    rsync \
    nano \
    ncurses \
    sudo \
    tar \
    zstd \
    nfs-utils \
    libpcap \
    libwebp \
    libcap \
    ${EXTRA_ALPINE_PACKAGES}

# Download and install patched knockd
curl -fsSL -o /tmp/knock.tar.gz https://github.com/Metalcape/knock/releases/download/0.8.1/knock-0.8.1-alpine-amd64.tar.gz
tar -xf /tmp/knock.tar.gz -C /usr/local/ && rm /tmp/knock.tar.gz
ln -s /usr/local/sbin/knockd /usr/sbin/knockd
setcap cap_net_raw=ep /usr/local/sbin/knockd

# Set Git credentials globally
cat <<EOF >> /etc/gitconfig
[user]
	name = Minecraft Server on Docker
	email = server@example.com
EOF