#!/bin/bash

. /start-utils
if isTrue "${DEBUG_AUTOSTOP}"; then
  set -x
fi

logAutostopAction "Stopping Java process"
kill -SIGTERM 1
