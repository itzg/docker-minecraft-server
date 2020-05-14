#!/bin/bash

if [[ ! $( ps -a -o stat,comm | grep 'java' | awk '{ print $1 }') =~ ^T.*$ ]] ; then
  echo "[Autopause] Already running!" >/tmp/terminal-mc
  STATUS=RA
  export STATUS
  exit 0
fi
echo "[Autopause] Resuming Java process" >/tmp/terminal-mc
STATUS=RC
export STATUS
killall -q -CONT java
