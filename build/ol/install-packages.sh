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
baseurl=https://yum.oracle.com/repo/OracleLinux/OL${os_major_version}$([ "$os_major_version" -ge 10 ] && echo '/0' || echo '')/developer/EPEL/\$basearch/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle
gpgcheck=1
enabled=1
EOF

# Update system
dnf update -y

# Install necessary packages
# shellcheck disable=SC2086
# shellcheck disable=SC2046
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
  $([ "$os_major_version" -ge 10 ] && echo 'mysql8.4' || echo 'mysql') \
  procps-ng \
  tzdata \
  rsync \
  nano \
  unzip \
  zstd \
  $([ "$os_major_version" -ge 10 ] && echo 'bzip2' || echo 'lbzip2') \
  libpcap \
  libwebp \
  findutils \
  which \
  glibc-langpack-en \
  $([ "$os_major_version" -ge 10 ] && echo 'git-lfs' || echo '') \
  $([ "$os_major_version" -ge 10 ] && echo 'openssl' || echo '') \
  ${EXTRA_DNF_PACKAGES}

# Install Git LFS through third party repository for older OL releases
if [ "$os_major_version" -lt 10 ]; then
  curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.rpm.sh | sudo bash
  dnf update -y
  dnf install -y git-lfs
fi

# Clean up DNF when done
dnf clean all

cat <<EOF > /usr/local/sbin/knockd
#!/bin/sh

echo "Auto-pause (using knockd) is currently unavailable on graalvm image variants"
echo "Consider using a different image variant https://docker-minecraft-server.readthedocs.io/en/latest/versions/java/"
echo "or mc-router's auto scale up/down feature https://github.com/itzg/mc-router#docker-auto-scale-updown"
exit 2
EOF
chmod 755 /usr/local/sbin/knockd
# TODO restore retrieval from https://github.com/Metalcape/knock when tar's "Cannot open: Invalid argument" is solved

# Set git credentials globally
cat <<EOF >> /etc/gitconfig
[user]
	name = Minecraft Server on Docker
	email = server@example.com
EOF
