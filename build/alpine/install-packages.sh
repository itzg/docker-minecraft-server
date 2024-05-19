#!/bin/sh

set -e
set -o pipefail

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
    curl iputils \
    git \
    jq \
    mysql-client \
    tzdata \
    rsync \
    nano \
    sudo \
    tar \
    zstd \
    nfs-utils \
    libpcap \
    libwebp \
    libcap

# Patched knockd
curl -fsSL -o /tmp/knock.tar.gz https://github.com/Metalcape/knock/releases/download/0.8.1/knock-0.8.1-alpine-amd64.tar.gz
tar -xf /tmp/knock.tar.gz -C /usr/local/ && rm /tmp/knock.tar.gz
ln -s /usr/local/sbin/knockd /usr/sbin/knockd
setcap cap_net_raw=ep /usr/local/sbin/knockd

# Set git credentials
echo -e "[user]\n       name = Minecraft Server on Docker\n     email = server@example.com" >> /etc/gitconfig
