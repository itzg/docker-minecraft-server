#!/bin/bash

if [[ $( ps -a -o stat,comm | grep 'java' | awk '{ print $1 }') =~ ^S.*$ ]] ; then
  rcon-cli save-all >/dev/null
  echo "[$(date -Iseconds)] [Autopause] Pausing Java process" >/tmp/terminal-mc
  killall -q -STOP java
fi
