#!/bin/sh

set -e

addgroup --gid 1000 minecraft
adduser --system --shell /bin/false --uid 1000 --ingroup minecraft --home /data minecraft