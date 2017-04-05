#!/bin/sh

set -e
sed -i "/^minecraft/s/:1000:1000:/:${UID}:${GID}:/g" /etc/passwd
sed -i "/^minecraft/s/:1000:/:${GID}:/g" /etc/group

if [ "$SKIP_OWNERSHIP_FIX" != "TRUE" ]; then
  fix_ownership() {
    dir=$1
    if ! su-exec minecraft test -w $dir; then
      echo "Correcting writability of $dir ..."
      chown -R minecraft:minecraft $dir
      chmod -R u+w $dir
    fi
  }

  fix_ownership /data
  fix_ownership /home/minecraft
fi

echo "Switching to user 'minecraft'"
su-exec minecraft /start-minecraft $@
