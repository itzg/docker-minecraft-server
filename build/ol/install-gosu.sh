#!/bin/bash

set -euo pipefail

GOSU_VERSION="1.16"
GOSU_BASE_URL="https://github.com/tianon/gosu/releases/download/$GOSU_VERSION"

case $(uname -m) in
    "aarch64")
        GOSU_ARCH="gosu-arm64"
        ;;
    "x86_64")
        GOSU_ARCH="gosu-amd64"
        ;;
    *)
        echo "Architecture not supported!"
        exit 1
        ;;
esac

curl -sL -o /bin/gosu "${GOSU_BASE_URL}/${GOSU_ARCH}"
chmod +x /bin/gosu
