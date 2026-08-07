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

# Tracks consecutive status-ping failures so the warning below can be rate
# limited instead of repeating every AUTOPAUSE_PERIOD. Held in a file rather
# than a variable because java_clients_connections is called through command
# substitution, so it runs in a subshell and any variable it sets is lost.
autopause_ping_failures_file="${AUTOPAUSE_PING_FAILURE_STATE:-/tmp/.autopause-status-ping-failures}"

autopause_ping_failures() {
  local count
  count=$(cat "${autopause_ping_failures_file}" 2>/dev/null)
  [[ ${count} =~ ^[0-9]+$ ]] || count=0
  echo "${count}"
}

java_clients_connections() {
  local connections
  local failures
  if java_running; then
    if ! connections=$(mc-monitor status \
        --host "${SERVER_HOST:-localhost}" \
        --port "$SERVER_PORT" \
        --retry-limit "${AUTOPAUSE_STATUS_RETRY_LIMIT:-10}" --retry-interval "${AUTOPAUSE_STATUS_RETRY_INTERVAL:-2s}" \
        $(use_proxy) $(use_server_list_ping) \
        --show-player-count); then
      # consider it a non-zero player count if the ping fails
      # otherwise a laggy server with players connected could get paused
      connections=1

      # A failing ping is indistinguishable from "a player is connected", so a
      # ping that fails permanently means the server never pauses and nothing
      # ever says why. Warn on the first failure, then every 30th.
      # Logged to stderr because this function returns its value on stdout.
      failures=$(( $(autopause_ping_failures) + 1 ))
      echo "${failures}" > "${autopause_ping_failures_file}"
      if [[ ${failures} -eq 1 ]] || [[ $((failures % 30)) -eq 0 ]]; then
        logAutopause "Status ping to ${SERVER_HOST:-localhost}:${SERVER_PORT} failed (${failures} consecutive). Assuming players are connected, so the server will not pause. If this persists while nobody is online, something is blocking the status ping." >&2
      fi
    else
      failures=$(autopause_ping_failures)
      if [[ ${failures} -gt 0 ]]; then
        logAutopause "Status ping recovered after ${failures} consecutive failures." >&2
        rm -f "${autopause_ping_failures_file}"
      fi
    fi
  else
    connections=0
  fi
  echo $connections
}

java_clients_connected() {
  (( $(java_clients_connections) > 0 ))
}
