#!/bin/sh

export TARGET

set -e

apt-get update

DEBIAN_FRONTEND=noninteractive \
apt-get install -y \
  imagemagick \
  file \
  gosu \
  sudo \
  net-tools \
  iputils-ping \
  curl \
  git \
  jq \
  dos2unix \
  mysql-client \
  tzdata \
  rsync \
  nano \
  unzip \
  zstd \
  lbzip2 \
  nfs-common \
  libpcap0.8 \
  wget

apt-get clean

# Patched knockd
wget -O /tmp/knock.tar.gz https://github.com/Metalcape/knock/releases/download/0.8.1/knock-0.8.1-$TARGET.tar.gz
tar -xf /tmp/knock.tar.gz -C /usr/local/ && rm /tmp/knock.tar.gz
ln -s /usr/local/sbin/knockd /usr/sbin/knockd
find /usr/lib -name 'libpcap.so.0.8' -execdir cp '{}' libpcap.so.1 \;
