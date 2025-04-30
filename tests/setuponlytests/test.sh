#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

: "${IMAGE_TO_TEST:=itzg/minecraft-server}"

# go to script root directory
cd "$(dirname "$0")" || exit 1

outputContainerLog() {
  logs=${1?}

  echo "${folder} test scenario FAILED"
  echo ":::::::::::: LOGS ::::::::::::::::
$logs
::::::::::::::::::::::::::::::::::
"
}

delta() {
  startTime=${1?}

  endTime=$(date +%s)
  echo "$(( endTime - startTime )) seconds"
}

# tests that only run the setup files for things like downloads and configuration.
setupOnlyMinecraftTest(){
  folder=$1
  cd "$folder"
  result=0

  if [ -f require.sh ]; then
    # require.sh scripts can check for environment variables, etc that are required for the test.
    # The script should exit with a non-zero status to indicate the test requirements are missing
    # and the test should be skipped
    if ! bash require.sh; then
      echo "${folder} SKIP"
      cd ..
      return 0
    fi
  fi

  # false positive since it's used in delta calculations below
  # shellcheck disable=SC2034
  start=$(date +%s)
  status=PASSED
  verify=
  if ! logs=$(docker compose run --rm -e SETUP_ONLY=true -e DEBUG="${DEBUG:-false}" mc 2>&1); then
    status=FAILED
    outputContainerLog "$logs"
    result=1
  elif [ -f verify.sh ]; then
    verify=" verify"
    if ! docker run --rm --entrypoint bash -v "${PWD}/data":/data -v "${PWD}/verify.sh":/verify "${IMAGE_TO_TEST}" -e /verify; then
      status=FAILED
      outputContainerLog "$logs"
      result=1
    fi
  fi
  echo "${folder} ${status}${verify} in $(delta start)"

  docker compose down -v --remove-orphans >& /dev/null
  cd ..

  return $result
}

foldersList=("$@")
image=""

# Go through each folder in setuponly and test setups
if (( $# == 0 )); then
  readarray -t folders < <(find . -maxdepth 2 -mindepth 2 -name docker-compose.yml -printf '%h\n')
  foldersList=("${folders[@]}")
  image=" using $IMAGE_TO_TEST"
fi

for folder in "${foldersList[@]}"; do
  echo "Starting Tests in ${folder}${image}"
  setupOnlyMinecraftTest "$folder"
done