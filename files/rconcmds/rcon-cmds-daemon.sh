#!/bin/bash

: "${RCON_CMDS_STARTUP:=$RCON_CMDS}"
: "${RCON_CMDS_ON_CONNECT:=}"
: "${RCON_CMDS_ON_DISCONNECT:=}"

# needed for the clients connected function residing in autopause
# shellcheck source=/autopause/autopause-fcns.sh
. /autopause/autopause-fcns.sh

# shellcheck source=start-utils
. ${SCRIPTS:-/}start-utils

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
      logAutopause "RCON: MCServer is listening, running startup"
      if [[ "$RCON_CMDS_STARTUP" ]]; then
        /rconcmds/run_commands.sh "$RCON_CMDS_STARTUP"
      fi
      STATE=II
    fi
    ;;
  XII)
    # Main Loop looking for new connections 
    CURR_CLIENTCONNECTIONS=java_clients_connections
    if [[ "$CURR_CLIENTCONNECTIONS" -eq "$CLIENTCONNECTIONS" ]]; then
      logAutopause "RCON: No Clients have Connected"
    elif [[ "$CURR_CLIENTCONNECTIONS" -gt "$CLIENTCONNECTIONS" ]] && [[ "$RCON_CMDS_ON_CONNECT" ]]; then
        logAutopause "RCON: Clients have Connected, running connect cmds"
        /rconcmds/run_commands.sh "$RCON_CMDS_ON_CONNECT"
    elif [[ "$CURR_CLIENTCONNECTIONS" -lt "$CLIENTCONNECTIONS" ]] && [[ "$RCON_CMDS_ON_DISCONNECT" ]]; then
        logAutopause "RCON: Clients have Disconnected, running disconnect cmds"
        /rconcmds/run_commands.sh "$RCON_CMDS_ON_DISCONNECT"
    fi
    CLIENTCONNECTIONS=$CURR_CLIENTCONNECTIONS
    ;;
  *)
    logAutopause "Error: invalid state: $STATE"
    ;;
  esac
  sleep "$RCON_CMDS_PERIOD"
done
