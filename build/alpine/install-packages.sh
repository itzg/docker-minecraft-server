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
    libpcap0.8 \
    libpcap-dev \
    autoconf \
    make \
    gcc

# Install knockd from source

git clone https://github.com/Metalcape/knock
cd knock
git checkout cooldown
autoreconf -fi
./configure --prefix=/usr/local
make
make install
