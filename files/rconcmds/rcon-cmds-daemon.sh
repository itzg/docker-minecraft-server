#!/bin/bash

: "${RCON_CMDS_STARTUP:=}"
: "${RCON_CMDS_ON_CONNECT:=}"
: "${RCON_CMDS_ON_DISCONNECT:=}"
: "${RCON_CMDS_PERIOD:=10}"

# needed for the clients connected function residing in autopause
# shellcheck source=/autopause/autopause-fcns.sh
. /autopause/autopause-fcns.sh

# shellcheck source=start-utils
. ${SCRIPTS:-/}start-utils

run_command(){
  rcon_cmd=$1
  logRcon "running - $rcon_cmd"
  output=$(rcon-cli "$rcon_cmd")
  logRcon "$output"
}


# wait for java process to be started
while :
do
  if java_process_exists ; then
    break
  fi
  sleep 0.1
done

CLIENTCONNECTIONS=0
STATE=INIT

while :
do
  case X$STATE in
  XINIT)
    # Server startup
    if mc_server_listening ; then
      logRcon "MCServer is listening, running startup"
      if [[ "$RCON_CMDS_STARTUP" ]]; then
        while read -r cmd; do
          run_command "$cmd"
        done <<< "$RCON_CMDS_STARTUP"
      fi
      if [[ -z "$RCON_CMDS_ON_CONNECT" ]] && [[ -z "$RCON_CMDS_ON_DISCONNECT" ]]; then
        logRcon "No addition rcon commands are given, stopping rcon cmd service"
        exit 0
      fi
      STATE=II
    fi
    ;;
  XII)
    # Main Loop looking for connections 
    CURR_CLIENTCONNECTIONS=$(java_clients_connections)
    if (( CURR_CLIENTCONNECTIONS > CLIENTCONNECTIONS )) && [[ "$RCON_CMDS_ON_CONNECT" ]]; then
        logRcon "Clients have Connected, running connect cmds"
        while read -r cmd; do
          run_command "$cmd"
        done <<< "$RCON_CMDS_ON_CONNECT"
    elif (( CURR_CLIENTCONNECTIONS < CLIENTCONNECTIONS )) && [[ "$RCON_CMDS_ON_DISCONNECT" ]]; then
        logRcon "Clients have Disconnected, running disconnect cmds"
        while read -r cmd; do
          run_command "$cmd"
        done <<< "$RCON_CMDS_ON_DISCONNECT"
    fi
    CLIENTCONNECTIONS=$CURR_CLIENTCONNECTIONS
    ;;
  *)
    logRcon "Error: invalid state: $STATE"
    ;;
  esac
  sleep "$RCON_CMDS_PERIOD"
done
