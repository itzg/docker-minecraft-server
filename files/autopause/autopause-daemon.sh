#!/bin/bash

exec 1>/tmp/terminal-mc

sudo /usr/sbin/knockd -c /autopause/knockd-config.cfg -d

STATE=K
TIME_THRESH=current_uptime+$AUTOPAUSE_TIMEOUT_KN

while :
do
  case X$STATE in
  XK)
    # Knocked
    if java_clients_connected; then
      STATE=E
    else
      if [ current_uptime -ge $TIME_THRESH ]; then
        exec /autopause/pause.sh
        STATE=S
      fi
    fi
    ;;
  XE)
    # Established
    if ! java_clients_connected; then
      TIME_THRESH=current_uptime+$AUTOPAUSE_TIMEOUT_EST
      STATE=I
    fi
    ;;
  XI)
    # Idle
    if java_clients_connected; then
      STATE=E
    else
      if [ current_uptime -ge $TIME_THRESH ]; then
        exec /autopause/pause.sh
        STATE=S
      fi
    fi
    ;;
  XS)
    # Stopped
    if java_running; then
      TIME_THRESH=current_uptime+$AUTOPAUSE_TIMEOUT_KN
      STATE=K
    fi
    ;;
  *)
    echo "[Autopause loop]: Error: invalid state: $STATE"
    ;;
  esac
  sleep $AUTOPAUSE_CHECK_INTERVAL
done

current_uptime() {
  return awk '{print $1}' /proc/uptime
}

java_running() {
  if [[ $( ps -a -o stat,comm | grep 'java' | awk '{ print $1 }') =~ ^S.*$ ]] ; then
    return 1
  else
    return 0
  fi
}

java_clients_connected() {
  if netstat -tn | grep $SERVER_PORT | grep ESTABLISHED ; then
    return 1
  else
    return 0
  fi
}
