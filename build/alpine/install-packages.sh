#!/bin/sh

set -e
set -o pipefail

# Patched knockd is only available for amd64 on Alpine, so install the package for other architectures
knockPkg=""
if [ "$TARGETARCH" != amd64 ]; then
  knockPkg="knock"
  echo "Installing knock package for $TARGETARCH architecture"
fi

# Install necessary packages
# shellcheck disable=SC2086
apk add --no-cache -U \
    openssl \
    imagemagick \
    file \
    lsof \
    coreutils \
    findutils \
    procps \
    shadow \
    bash \
    curl \
    iputils \
    iproute2 \
    git \
    git-lfs \
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
    numactl \
    jattach \
    gcompat \
    "$knockPkg" \
    ${EXTRA_ALPINE_PACKAGES}

if ! [ "$knockPkg" ]; then
  # Download and install patched knockd
  knockdUrl="https://github.com/${KNOCKD_REPO_ORG}/releases/download/${KNOCKD_VERSION}/knock-${KNOCKD_VERSION}-alpine-amd64.tar.gz"
  echo "Downloading knockd from $knockdUrl"
  curl -fsSL -o /tmp/knock.tar.gz "$knockdUrl"
  tar -xf /tmp/knock.tar.gz -C /usr/local/ && rm /tmp/knock.tar.gz
  ln -s /usr/local/sbin/knockd /usr/sbin/knockd
  setcap cap_net_raw=ep /usr/local/sbin/knockd
fi

# Set Git credentials globally
cat <<EOF >> /etc/gitconfig
[user]
	name = Minecraft Server on Docker
	email = server@example.com
EOF
git lfs install