#!/bin/bash

. /start-utils
if isTrue "${DEBUG_AUTOPAUSE}"; then
  set -x
fi

if [[ $( ps -ax -o stat,comm | grep 'java' | awk '{ print $1 }') =~ ^T.*$ ]] ; then
  logAutopauseAction "Knocked, resuming Java process"
  pkill -CONT java
fi
