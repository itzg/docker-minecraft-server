#!/bin/bash

# go to script root directory
cd "$(dirname "$0")" || exit 1

down() {
    docker compose -f "$1" down -v --remove-orphans
}

# tests to completely spin up Minecraft and use the monitor to validate the service is running.
fullMinecraftUpTest(){
  file="$1"
  failed=false
  # run the monitor to validate the Minecraft image is healthy
  docker compose -f "$file" run monitor || failed=true
  echo "$(dirname "$file") Result: failed=$failed"
  if $failed; then
    docker compose logs mc
    down "$file"
    return 1
  else
    down "$file"
  fi
}

# go through each folder in fulltests and run fullbuilds
files=$(ls */docker-compose.yml)
for file in $files; do

    echo "Starting Tests on $(dirname "$file")"
    if ! fullMinecraftUpTest "$file"; then
      exit 2
    fi

done
