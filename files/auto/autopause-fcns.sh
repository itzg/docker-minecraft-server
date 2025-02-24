#!/bin/bash

# shellcheck source=../scripts/start-utils
. "${SCRIPTS:-/}start-utils"
current_uptime() {
  awk '{print $1}' /proc/uptime | cut -d . -f 1
}

java_running() {
  [[ $( ps -ax -o stat,comm | grep 'java' | awk '{ print $1 }') =~ ^S.*$ ]]
}

java_process_exists() {
  [[ -n "$(ps -ax -o comm | grep 'java')" ]]
}

rcon_client_exists() {
  [[ -n "$(ps -ax -o comm | grep 'rcon-cli')" ]]
}

use_proxy() {
  if isTrue "$USES_PROXY_PROTOCOL"; then
    echo "--use-proxy"
  fi
}

use_server_list_ping() {
  if versionLessThan 1.7; then
    echo "--use-server-list-ping"
  fi
}

mc_server_listening() {
  mc-monitor status $(use_proxy) --host "${SERVER_HOST:-localhost}" --port "$SERVER_PORT" $(use_server_list_ping) --timeout 10s >&/dev/null
}

java_clients_connections() {
  local connections
  if java_running; then
    if ! connections=$(mc-monitor status $(use_proxy) --host "${SERVER_HOST:-localhost}" --port "$SERVER_PORT" $(use_server_list_ping) --show-player-count); then
      # consider it a non-zero player count if the ping fails
      # otherwise a laggy server with players connected could get paused
      connections=1
    fi
  else
    connections=0
  fi
  echo $connections
}

java_clients_connected() {
  (( $(java_clients_connections) > 0 ))
}
