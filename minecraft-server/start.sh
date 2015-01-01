#!/bin/sh
set -e
chown -R minecraft:minecraft /data /start-minecraft
exec su -s /bin/bash -c /start-minecraft minecraft
