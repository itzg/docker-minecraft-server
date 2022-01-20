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

# tests that only run the setup files for things like downloads and configuration. 
setupOnlyMinecraftTest(){
  folder=$1
  cd "$folder"
  failed=false
  # run the monitor to validate the Minecraft image is healthy
  docker-compose --log-level ERROR up --quiet-pull --exit-code-from mc 2>/dev/null || failed=true
  echo "${folder} Result: failed=$failed"
  checkandExitOnFailure $failed
  down
  cd ..
}

# go through each folder in setuponly and test setups
FOLDERS=$(ls)
for folder in $FOLDERS; do
    # If folder is a directory
    if [ -d "$folder" ]; then
      echo "Starting Tests on ${folder}"
      setupOnlyMinecraftTest $folder
    fi
done
