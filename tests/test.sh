#!/bin/bash

# go to script root directory
cd "$(dirname "$0")" || exit 1

# go through top level folders and trigger the tests in the subfolders
FOLDERS=$(ls)
for folder in $FOLDERS; do
    # If folder is a directory
    if [ -d "$folder" ]; then
      cd "$folder"
      if [ -f "./test.sh" ]; then
        echo "Starting ${folder} Tests"
        sh ./test.sh
      fi
      cd ..
    fi
done
