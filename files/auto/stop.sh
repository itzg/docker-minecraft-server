#!/bin/bash

. /start-utils
if isTrue "${DEBUG_AUTOSTOP}"; then
  set -x
fi

logAutostopAction "Stopping Java process"
commandToExecute="pkill -f --signal SIGTERM mc-server-runner"
if isTrue "${AUTOSTOP_PKILL_USE_SUDO:-false}"; then
  commandToExecute="sudo $commandToExecute"
fi

$commandToExecute