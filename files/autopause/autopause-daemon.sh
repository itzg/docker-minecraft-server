#!/bin/bash

. /autopause/autopause-fcns.sh

. ${SCRIPTS:-/}start-utils


autopause_error_loop() {
  logAutopause "Available interfaces within the docker container:"
  INTERFACES=$(echo /sys/class/net/*)
  INTERFACES=${INTERFACES//\/sys\/class\/net\//}
  logAutopause "  $INTERFACES"
  logAutopause "Please set the environment variable AUTOPAUSE_KNOCK_INTERFACE to the interface that handles incoming connections."
  logAutopause "If unsure which interface to choose, run the ifconfig command in the container."
  logAutopause "Autopause failed to initialize. This log entry will be printed every 30 minutes."
  while :
  do
    if [[ -n $(ps -ax -o comm | grep java) ]] ; then
      break
    fi
    sleep 0.1
  done
  logAutopause "Failed to start knockd daemon."
  logAutopause "Possible cause: docker's host network mode."
  logAutopause "Recreate without host mode or disable autopause functionality."
  logAutopause "Stopping server."
  pkill -SIGTERM java
  exit 1
fi

STATE=INIT

while :
do
  case X$STATE in
  XINIT)
    # Server startup
    if mc_server_listening ; then
      TIME_THRESH=$(($(current_uptime)+$AUTOPAUSE_TIMEOUT_INIT))
      logAutopause "MC Server listening for connections - stopping in $AUTOPAUSE_TIMEOUT_INIT seconds"
      STATE=K
    fi
    ;;
  XK)
    # Knocked
    if java_clients_connected ; then
      logAutopause "Client connected - waiting for disconnect"
      STATE=E
    else
      if [[ $(current_uptime) -ge $TIME_THRESH ]] ; then
        logAutopause "No client connected since startup / knocked - stopping"
        /autopause/pause.sh
        STATE=S
      fi
    fi
    ;;
  XE)
    # Established
    if ! java_clients_connected ; then
      TIME_THRESH=$(($(current_uptime)+$AUTOPAUSE_TIMEOUT_EST))
      logAutopause "All clients disconnected - stopping in $AUTOPAUSE_TIMEOUT_EST seconds"
      STATE=I
    fi
    ;;
  XI)
    # Idle
    if java_clients_connected ; then
      logAutopause "Client reconnected - waiting for disconnect"
      STATE=E
    else
      if [[ $(current_uptime) -ge $TIME_THRESH ]] ; then
        logAutopause "No client reconnected - stopping"
        /autopause/pause.sh
        STATE=S
      fi
    fi
    ;;
  XS)
    # Stopped
    if rcon_client_exists ; then
      /autopause/resume.sh
    fi
    if java_running ; then
      if java_clients_connected ; then
        logAutopause "Client connected - waiting for disconnect"
        STATE=E
      else
        TIME_THRESH=$(($(current_uptime)+$AUTOPAUSE_TIMEOUT_KN))
        logAutopause "Server was knocked - waiting for clients or timeout"
        STATE=K
      fi
    fi
    ;;
  *)
    logAutopause "Error: invalid state: $STATE"
    ;;
  esac
  if [[ "$STATE" == "S" ]] ; then
    # before rcon times out
    sleep 2
  else
    sleep $AUTOPAUSE_PERIOD
  fi
done
