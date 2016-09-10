#!/bin/sh

set -e
usermod --uid $UID minecraft
groupmod --gid $GID minecraft

if [ "$SKIP_OWNERSHIP_FIX" != "TRUE" ]; then
  fix_ownership() {
    dir=$1
    if ! sudo -u minecraft test -w $dir; then
      echo "Correcting writability of $dir ..."
      chown -R minecraft:minecraft $dir
      chmod -R u+w $dir
    fi
  }

  fix_ownership /data
  fix_ownership /home/minecraft
fi

echo "Switching to user 'minecraft'"
exec sudo -E -u minecraft /start-minecraft "$@"
