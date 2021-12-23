#!/bin/bash

# needed for the clients connected function residing in autopause
. /autopause/autopause-fcns.sh

. ${SCRIPTS:-/}start-utils

# wait for java process to be started
while :
do
  if java_process_exists ; then
    break
  fi
  sleep 0.1
done

STATE=INIT

while :
do
  case X$STATE in
  XINIT)
    # Server startup
    if mc_server_listening ; then
      TIME_THRESH=$(($(current_uptime)+$AUTOSTOP_TIMEOUT_INIT))
      logAutostop "MC Server listening for connections - stopping in $AUTOSTOP_TIMEOUT_INIT seconds"
      STATE=II
    fi
    ;;
  XII)
    # Initial idle
    if java_clients_connected ; then
      logAutostop "Client connected - waiting for disconnect"
      STATE=E
    else
      if [[ $(current_uptime) -ge $TIME_THRESH ]] ; then
        logAutostop "No client connected since startup - stopping server"
        /autostop/stop.sh
        exit 0
      fi
    fi
    ;;
  XE)
    # Established
    if ! java_clients_connected ; then
      TIME_THRESH=$(($(current_uptime)+$AUTOSTOP_TIMEOUT_EST))
      logAutostop "All clients disconnected - stopping in $AUTOSTOP_TIMEOUT_EST seconds"
      STATE=I
    fi
    ;;
  XI)
    # Idle
    if java_clients_connected ; then
      logAutostop "Client reconnected - waiting for disconnect"
      STATE=E
    else
      if [[ $(current_uptime) -ge $TIME_THRESH ]] ; then
        logAutostop "No client reconnected - stopping"
        /autostop/stop.sh
        exit 0
      fi
    fi
    ;;
  *)
    logAutostop "Error: invalid state: $STATE"
    ;;
  esac
  sleep $AUTOSTOP_PERIOD
done
