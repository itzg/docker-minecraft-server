#!/bin/sh

set -e

distro=$(cat /etc/os-release | grep -E "^ID=" | cut -d= -f2 | sed -e 's/"//g')

"$(dirname "$0")/${distro}/$1".sh

if [ "$1" = "install-packages" ]; then
# Set Git credentials globally
    cat <<EOF >> /etc/gitconfig
[user]
	name = Minecraft Server on Docker
	email = server@example.com
EOF
fi
