#!/bin/bash

current_uptime() {
  echo $(awk '{print $1}' /proc/uptime | cut -d . -f 1)
}

java_running() {
  [[ $( ps -a -o stat,comm | grep 'java' | awk '{ print $1 }') =~ ^S.*$ ]]
}

rcon_client_exists() {
  [[ -n "$(ps -a -o comm | grep 'rcon-cli')" ]]
}

mc_server_listening() {
  [[ -n $(netstat -tln | grep "0.0.0.0:$SERVER_PORT" | grep LISTEN) ]]
}

java_clients_connected() {
  local connections
  connections=$(netstat -tn | grep ":$SERVER_PORT" | grep ESTABLISHED)
  if [[ -z "$connections" ]] ; then
    return 1
  fi
  IFS=$'\n'
  connections=($connections)
  unset IFS
  # check that at least one external address is not localhost
  # remember, that the host network mode does not work with autopause because of the knockd utility
  for (( i=0; i<${#connections[@]}; i++ ))
  do
    if [[ ! $(echo "${connections[$i]}" | awk '{print $5}') =~ ^\s*127\.0\.0\.1:.*$ ]] ; then
      # not localhost
      return 0
    fi
  done
  return 1
}
