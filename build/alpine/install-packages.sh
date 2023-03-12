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
