#!/bin/sh

set -e

addgroup -g 1000 minecraft
adduser -Ss /bin/false -u 1000 -G minecraft -h /home/minecraft minecraft
