#!/bin/bash

# docker-compose down

COMMAND="$1"

# We assume that the container of the directory is the current project's immediate folder
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CONTAINER_NAME=$(sed 's#.*/##' <<< "${SCRIPT_DIR}")
echo "Executing command on container: '${CONTAINER_NAME}'"

# Docker volume is assumed to be <container_name>_data
DOCKER_VOLUME="${CONTAINER_NAME}_data"
# Docker volume (should have bash, python3, and wine) 
DOCKER_IMAGE="alpine"

docker run -it --rm \
	--mount source=${DOCKER_VOLUME},target="/data" \
	--mount type=bind,source="$(pwd)/plugins",target="/data/plugins" \
	--mount type=bind,source="$(pwd)/utilities",target="/data/utilities" \
	${DOCKER_IMAGE} \
	sh -c "$COMMAND"



