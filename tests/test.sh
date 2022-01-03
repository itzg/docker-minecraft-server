#!/bin/bash

# go to script root directory
cd "$(dirname "$0")" || exit 1

# compose down function for reuse
down() {
  docker-compose down -v --remove-orphans
}

fullMinecraftUpTest(){
  folder=$1
  failed=false
  # run the monitor to validate the Minecraft image is healthy
  docker-compose run monitor || failed=true
  echo "${folder} Result: failed=$failed"

  # docker-compose logs outputs messages from the specified container
  if $failed; then
    docker-compose logs mc
    down
    exit 2
  fi
  down
}

setupOnlyMinecraftTest(){
  folder=$1
  failed=false
  # run the monitor to validate the Minecraft image is healthy
  docker-compose --log-level ERROR up --quiet-pull --exit-code-from mc 2>/dev/null || failed=true
  echo "${folder} Result: failed=$failed"

  # docker-compose logs outputs messages from the specified container
  if $failed; then
    docker-compose logs mc
    down
    cd ..
    exit 2
  fi
  down
  cd ..
}

# run tests on base docker compose and validate mc service with monitor
fullMinecraftUpTest 'Full Vanilla Test'

# go through each folder to test builds
FOLDERS=$(ls)
for folder in $FOLDERS; do
    # If folder is a directory
    if [ -d "$folder" ]; then
      cd "$folder"
      setupOnlyMinecraftTest $folder
    fi
done
