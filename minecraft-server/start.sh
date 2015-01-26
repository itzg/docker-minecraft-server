#!/bin/sh

set -e
usermod --uid $UID minecraft
chown -R minecraft /data /start-minecraft
exec su -s /bin/bash -c /start-minecraft minecraft
