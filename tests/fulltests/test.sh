#!/bin/bash

# go to script root directory
cd "$(dirname "$0")" || exit 1

# tests to completely spin up Minecraft and use the monitor to validate the service is running.
fullMinecraftUpTest(){
  file="$1"
  result=0

  echo "Testing with images:"
  docker compose -f "$file" config --images

  # run the monitor to validate the Minecraft image is healthy
  upArgs=(
    --attach-dependencies
    --always-recreate-deps
    --abort-on-container-failure
  )
  if ! docker compose -f "$file" up "${upArgs[@]}" monitor; then
    echo "$(dirname "$file") Result: failed"
    result=1
  else
    echo "$(dirname "$file") Result: success"
  fi
  docker compose -f "$file" down -v --remove-orphans
  return $result
}

# go through each folder in fulltests and run fullbuilds
files=$(ls */docker-compose.yml)
for file in $files; do

    echo "Starting Tests on $(dirname "$file")"
    if ! fullMinecraftUpTest "$file"; then
      exit 2
    fi

done
