#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

# go to script root directory
cd "$(dirname "$0")" || exit 1

# go through top level folders and trigger the tests in the subfolders
readarray -t folders < <(find . -maxdepth 2 -mindepth 2 -name test.sh -printf '%h\n')
for folder in "${folders[@]}"; do
  cd "$folder"
  echo "Starting ${folder} Tests"
  bash ./test.sh
  cd ..
done
