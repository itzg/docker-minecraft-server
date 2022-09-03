#!/bin/bash

: "${RCON_CMDS_STARTUP:=}"
: "${RCON_CMDS_ON_CONNECT:=}"
: "${RCON_CMDS_ON_DISCONNECT:=}"
: "${RCON_CMDS_FIRST_CONNECT:=}"
: "${RCON_CMDS_LAST_DISCONNECT:=}"
: "${RCON_CMDS_PERIOD:=10}"

# needed for the clients connected function residing in autopause
# shellcheck source=../auto/autopause-fcns.sh
. /auto/autopause-fcns.sh

# shellcheck source=start-utils
. ${SCRIPTS:-/}start-utils

run_command(){
  rcon_cmd="$1"
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
      if 
        [[ -z "$RCON_CMDS_ON_CONNECT" ]] && 
        [[ -z "$RCON_CMDS_ON_DISCONNECT" ]] && 
        [[ -z "$RCON_CMDS_FIRST_CONNECT" ]] && 
        [[ -z "$RCON_CMDS_LAST_DISCONNECT" ]]
      then
        logRcon "No addition rcon commands are given, stopping rcon cmd service"
        exit 0
      fi
      STATE=II
    fi
    ;;
  XII)
    CURR_CLIENTCONNECTIONS=$(java_clients_connections)
    # First client connection
    # Setting priority run order: on first client connection is usually to STOP maintence, aka DO THIS FIRST
    if (( CURR_CLIENTCONNECTIONS > 0 )) && (( CLIENTCONNECTIONS == 0 )) && [[ "$RCON_CMDS_FIRST_CONNECT" ]]; then
        logRcon "First Clients has Connected, running first connect cmds"
        while read -r cmd; do
          run_command "$cmd"
        done <<< "$RCON_CMDS_FIRST_CONNECT"
    fi

    # When a client joins
    if (( CURR_CLIENTCONNECTIONS > CLIENTCONNECTIONS )) && [[ "$RCON_CMDS_ON_CONNECT" ]]; then
        logRcon "Clients have Connected, running connect cmds"
        while read -r cmd; do
          run_command "$cmd"
        done <<< "$RCON_CMDS_ON_CONNECT"
    # When a client leaves
    elif (( CURR_CLIENTCONNECTIONS < CLIENTCONNECTIONS )) && [[ "$RCON_CMDS_ON_DISCONNECT" ]]; then
        logRcon "Clients have Disconnected, running disconnect cmds"
        while read -r cmd; do
          run_command "$cmd"
        done <<< "$RCON_CMDS_ON_DISCONNECT"
    fi

    # Last client connection
    # Setting priority run order: on last client connection is usually to START maintence, aka DO THIS LAST
    if (( CURR_CLIENTCONNECTIONS == 0 )) && (( CLIENTCONNECTIONS > 0 )) && [[ "$RCON_CMDS_LAST_DISCONNECT" ]]; then
        logRcon "ALL Clients have Disconnected, running last disconnect cmds"
        while read -r cmd; do
          run_command "$cmd"
        done <<< "$RCON_CMDS_LAST_DISCONNECT"
    fi
    CLIENTCONNECTIONS=$CURR_CLIENTCONNECTIONS
    ;;
  *)
    logRcon "Error: invalid state: $STATE"
    ;;
  esac
  sleep "$RCON_CMDS_PERIOD"
done
