#!/bin/bash

# go to script root directory
cd "$(dirname "$0")" || exit 1

# compose down function for reuse
down() {
  docker-compose down -v --remove-orphans
}

checkandExitOnFailure(){
  failed=$1
  # docker-compose logs outputs messages from the specified container
  if $failed; then
    docker-compose logs mc
    down
    cd ..
    exit 2
  fi
}

# tests to completely spin up Minecraft and use the monitor to validate the service is running.
fullMinecraftUpTest(){
  folder=$1
  cd "$folder"
  failed=false
  # run the monitor to validate the Minecraft image is healthy
  docker-compose run monitor || failed=true
  echo "${folder} Result: failed=$failed"
  checkandExitOnFailure $failed
  down
  cd ..
}

# go through each folder in fulltests and run fullbuilds
FOLDERS=$(ls)
for folder in $FOLDERS; do
    # If folder is a directory
    if [ -d "$folder" ]; then
      echo "Starting Tests on ${folder}"
      fullMinecraftUpTest $folder
    fi
done
