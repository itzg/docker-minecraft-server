#!/bin/sh

set -e

if id ubuntu > /dev/null 2>&1; then
  deluser ubuntu
fi

addgroup --gid 1000 minecraft
addgroup --gid 1001 knockd
adduser --system --shell /bin/false --uid 1000 --ingroup minecraft --home /data minecraft
adduser --system --shell /bin/false --uid 1001 --ingroup knockd knockd
