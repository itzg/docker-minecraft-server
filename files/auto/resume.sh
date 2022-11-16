#!/bin/bash

. /start-utils
if isTrue "${DEBUG_AUTOPAUSE}"; then
  set -x
fi

if [[ $( ps -ax -o stat,comm | grep 'java' | awk '{ print $1 }') =~ ^T.*$ ]] ; then
  logAutopauseAction "Knocked from $1, resuming Java process"
  echo "$1" > /var/log/knocked-source
  pkill -CONT java

  # remove .paused file from data directory
  rm -f /data/.paused
fi
