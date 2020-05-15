#!/bin/bash

current_uptime() {
  echo $(awk '{print $1}' /proc/uptime | cut -d . -f 1)
}

java_running() {
  [[ $( ps -a -o stat,comm | grep 'java' | awk '{ print $1 }') =~ ^S.*$ ]]
}

java_clients_connected() {
  [[ -n "$(netstat -tn | grep $SERVER_PORT | grep ESTABLISHED)" ]]
}
