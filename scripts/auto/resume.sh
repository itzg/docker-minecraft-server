#!/bin/bash

. "$(dirname "$0")/../start-utils"
if isTrue "${DEBUG_AUTOPAUSE}"; then
  set -x
fi

if [[ $( ps -ax -o stat,comm | grep 'java' | awk '{ print $1 }') =~ ^T.*$ ]] ; then
  pkill -CONT java

  # remove .paused file from data directory
  rm -f /data/.paused
fi
