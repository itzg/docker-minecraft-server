#!/bin/bash

# go to script root directory
# cd "$(dirname "$0")" || exit 1

# compose down function for reuse
down() {
  docker-compose down -v
  cd ..
}

# go through each folder to test builds
for folder in *; do
    # If folder is a directory
    if [ -d "$folder" ]; then
      cd "$folder"
      failed=false
      docker-compose run monitor || failed=true
      echo "${folder} Result: failed=$failed"
      if $failed; then
        docker-compose logs mc
        down
        exit 1
      else
        down
        cd ..
      fi
    fi
done





