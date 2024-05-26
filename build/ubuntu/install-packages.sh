#!/bin/bash

export TARGET

set -euo pipefail

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
  webp

curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
apt-get update
apt-get install -y \
  git-lfs

apt-get clean

# Patched knockd
curl -fsSL -o /tmp/knock.tar.gz https://github.com/Metalcape/knock/releases/download/0.8.1/knock-0.8.1-$TARGET.tar.gz
tar -xf /tmp/knock.tar.gz -C /usr/local/ && rm /tmp/knock.tar.gz
ln -s /usr/local/sbin/knockd /usr/sbin/knockd
setcap cap_net_raw=ep /usr/local/sbin/knockd
find /usr/lib -name 'libpcap.so.0.8' -execdir cp '{}' libpcap.so.1 \;

# Set git credentials
echo -e "[user]\n	name = Minecraft Server on Docker\n	email = server@example.com" >> /etc/gitconfig
