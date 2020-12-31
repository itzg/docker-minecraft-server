#!/bin/bash

. ${SCRIPTS:-/}start-utils

if isTrue "${DISABLE_HEALTHCHECK}"; then
  echo "Healthcheck disabled"
  exit 0
elif isTrue "${ENABLE_AUTOPAUSE}" && [[ "$( ps -ax -o stat,comm | grep 'java' | awk '{ print $1 }')" =~ ^T.*$ ]]; then
  echo "Java process suspended by Autopause function"
  exit 0
else
  mc-monitor status --host localhost --port $SERVER_PORT
  exit $?
fi
