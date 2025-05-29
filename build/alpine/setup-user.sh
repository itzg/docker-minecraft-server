#!/bin/sh

set -e

addgroup -g 1000 minecraft
addgroup -g 1001 service-group
adduser -Ss /bin/false -u 1000 -G minecraft -h /home/minecraft minecraft
adduser -Ss /bin/false -u 1001 -G service-group -H service-account
