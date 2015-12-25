#!/bin/sh

set -e
usermod --uid $UID minecraft
chown -R minecraft /data /start-minecraft

while lsof -- /start-minecraft; do
  echo -n "."
  sleep 1
done
echo "...switching to user 'minecraft'"
exec sudo -E -u minecraft /start-minecraft
