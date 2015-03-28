#!/bin/sh

set -e
usermod --uid $UID minecraft
chown -R minecraft /data /start-minecraft

exec sudo -E -u minecraft /start-minecraft

