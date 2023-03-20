#!/bin/sh

set -e

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
    libpcap

# Patched knockd
cd /tmp && wget https://github.com/Metalcape/knock/releases/download/0.8.1/knock-0.8.1-alpine-amd64.tar.gz
tar -xf /tmp/knock-0.8.1-alpine-amd64.tar.gz -C /usr/local/
ln -s /usr/local/sbin/knockd /usr/sbin/knockd
