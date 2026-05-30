#!/bin/env bash

export MOTD="${MOTD//\\n/$'\n'}"
exec /image/scripts/start "$@"

