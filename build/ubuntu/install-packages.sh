#!/bin/bash

export TARGET

set -euo pipefail

# Update and install packages
apt-get update
# shellcheck disable=SC2086
DEBIAN_FRONTEND=noninteractive \
apt-get install -y \
  imagemagick \
  file \
  sudo \
  net-tools \
  iputils-ping \
  curl \
  git \
  git-lfs \
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
  libnuma1 \
  libcap2-bin \
  ${EXTRA_DEB_PACKAGES}

# Clean up APT when done
apt-get clean

# Download and install patched knockd
curl -fsSL -o /tmp/knock.tar.gz https://github.com/Metalcape/knock/releases/download/0.8.1/knock-0.8.1-$TARGET.tar.gz
tar -xf /tmp/knock.tar.gz -C /usr/local/ && rm /tmp/knock.tar.gz
ln -s /usr/local/sbin/knockd /usr/sbin/knockd
setcap cap_net_raw=ep /usr/local/sbin/knockd
find /usr/lib -name 'libpcap.so.0.8' -execdir cp '{}' libpcap.so.1 \;

# Set git credentials globally
cat <<EOF >> /etc/gitconfig
[user]
	name = Minecraft Server on Docker
	email = server@example.com
EOF
git lfs install
