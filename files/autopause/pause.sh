#!/bin/bash

if [[ $( ps -a -o stat,comm | grep 'java' | awk '{ print $1 }') =~ ^T.*$ ]] ; then
  echo "[Autopause] Already stopped!" >/tmp/terminal-mc
  STATUS=PA
  export STATUS
  exit 0
fi
echo "[Autopause] Pausing Java process" >/tmp/terminal-mc
STATUS=PS
export STATUS
killall -q -STOP java
