#!/bin/sh
set -e
chown -R minecraft:minecraft /data
exec su -s /bin/bash -c /start-minecraft minecraft
