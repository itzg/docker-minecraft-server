#!/bin/bash

# go to script root directory
cd "$(dirname "$0")" || exit 1

# compose down function for reuse
down() {
  docker-compose down -v
}

# go through each folder to test builds
FOLDERS=$(ls)
for folder in $FOLDERS; do
    # If folder is a directory
    if [ -d "$folder" ]; then
      cd "$folder"
      failed=false

      # run the monitor to validate the Minecraft image is healthy
      docker-compose run monitor || failed=true
      echo "${folder} Result: failed=$failed"

      # TODO: findout more about logs mc
      if $failed; then
        docker-compose logs mc
        down
        cd ..
        exit 2
      else
        down
        cd ..
      fi
    fi
done





