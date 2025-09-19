#!/bin/bash

. "$(dirname "$0")/../start-utils"
if isTrue "${DEBUG_AUTOSTOP}"; then
  set -x
fi

logAutostopAction "Stopping Java process"
pkill -f --signal SIGTERM mc-server-runner

