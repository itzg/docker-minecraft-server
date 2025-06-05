#!/bin/bash

export TARGET

set -euo pipefail

os_major_version=$(awk -F'[= ."]+' '/^VERSION_ID=/{ print $2 }' /etc/os-release)

# Install and configure dnf
microdnf install dnf -y
dnf install 'dnf-command(config-manager)' -y
dnf config-manager --set-enabled ol${os_major_version}_codeready_builder

# Add EPEL repository
tee /etc/yum.repos.d/ol${os_major_version}-epel.repo <<EOF
[ol${os_major_version}_developer_EPEL]
name=Oracle Linux \$releasever EPEL (\$basearch)
baseurl=https://yum.oracle.com/repo/OracleLinux/OL${os_major_version}/developer/EPEL/\$basearch/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle
gpgcheck=1
enabled=1
EOF

# Update system
dnf update -y

# Install necessary packages
# shellcheck disable=SC2086
dnf install -y \
  ImageMagick \
  file \
  sudo \
  net-tools \
  iputils \
  curl \
  git \
  jq \
  dos2unix \
  mysql \
  procps-ng \
  tzdata \
  rsync \
  nano \
  unzip \
  zstd \
  lbzip2 \
  libpcap \
  libwebp \
  findutils \
  which \
  glibc-langpack-en \
  ${EXTRA_DNF_PACKAGES}

# Install Git LFS
curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.rpm.sh | sudo bash
dnf update -y
dnf install -y git-lfs

# Clean up DNF when done
dnf clean all

# Install gosu (assuming the script /build/ol/install-gosu.sh exists and is executable)
bash /build/ol/install-gosu.sh

# Download and install patched knockd
curl -fsSL -o /tmp/knock.tar.gz https://github.com/Metalcape/knock/releases/download/0.8.1/knock-0.8.1-$TARGET.tar.gz
tar -xf /tmp/knock.tar.gz -C /usr/local/ && rm /tmp/knock.tar.gz
ln -s /usr/local/sbin/knockd /usr/sbin/knockd
setcap cap_net_raw=ep /usr/local/sbin/knockd

# Set git credentials globally
cat <<EOF >> /etc/gitconfig
[user]
	name = Minecraft Server on Docker
	email = server@example.com
EOF
