#!/bin/bash

exec 1>/tmp/terminal-mc

. /autopause/autopause-fcns.sh

sudo /usr/sbin/knockd -c /autopause/knockd-config.cfg -d
if [ $? -ne 0 ] ; then
  while :
  do
    if [[ -n $(ps -o comm | grep java) ]] ; then
      break
    fi
    sleep 0.1
  done
  echo "[Autopause loop] Failed to start knockd daemon."
  echo "[Autopause loop] Possible cause: docker's host network mode."
  echo "[Autopause loop] Recreate without host mode or disable autopause functionality."
  echo "[Autopause loop] Stopping server."
  killall -SIGTERM java
  exit 1
fi

STATE=K
TIME_THRESH=$(($(current_uptime)+$AUTOPAUSE_TIMEOUT_KN))

while :
do
  case X$STATE in
  XK)
    # Knocked
    if java_clients_connected ; then
      echo "[Autopause loop] Client connected - waiting for disconnect"
      STATE=E
    else
      if [[ $(current_uptime) -ge $TIME_THRESH ]] ; then
        echo "[Autopause loop] No client connected since startup - stopping"
        /autopause/pause.sh
        STATE=S
      fi
    fi
    ;;
  XE)
    # Established
    if ! java_clients_connected ; then
      TIME_THRESH=$(($(current_uptime)+$AUTOPAUSE_TIMEOUT_EST))
      echo "[Autopause loop] All clients disconnected - stopping in $AUTOPAUSE_TIMEOUT_EST seconds"
      STATE=I
    fi
    ;;
  XI)
    # Idle
    if java_clients_connected ; then
      echo "[Autopause loop] Client reconnected - waiting for disconnect"
      STATE=E
    else
      if [[ $(current_uptime) -ge $TIME_THRESH ]] ; then
        echo "[Autopause loop] No client reconnected - stopping"
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
        echo "[Autopause loop] Client connected - waiting for disconnect"
        STATE=E
      else
        TIME_THRESH=$(($(current_uptime)+$AUTOPAUSE_TIMEOUT_KN))
        echo "[Autopause loop] Server was knocked - waiting for clients or timeout"
        STATE=K
      fi
    fi
    ;;
  *)
    echo "[Autopause loop] Error: invalid state: $STATE"
    ;;
  esac
  if [[ "$STATE" == "S" ]] ; then
    # before rcon times out
    sleep 2
  else
    sleep $AUTOPAUSE_PERIOD
  fi
done
