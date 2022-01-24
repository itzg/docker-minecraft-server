#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# go to script root directory
cd "$(dirname "$0")" || exit 1

# go through top level folders and trigger the tests in the subfolders
readarray -t folders < <(find . -maxdepth 2 -mindepth 2 -name docker-compose.yml -printf '%h\n')
for folder in "${folders[@]}"; do
  cd "$folder"
  if [ -f "./test.sh" ]; then
    echo "Starting ${folder} Tests"
    sh ./test.sh
  fi
  cd ..
done
