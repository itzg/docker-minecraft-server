#!/bin/bash

# ./export_level_dat.sh <volume_tag> <level.dat output directory>
# Example ./export_level_dat.sh data ./utilities/nbt-utils/

docker compose pause

VOLUME_TAG=$1
EXPORT_TARGET=$2

# We assume that the volume of the container is <current folder>_<user_input>
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
VOLUME_NAME="$(sed 's#.*/##' <<< "${SCRIPT_DIR}")_${VOLUME_TAG}"
echo "Exporting level.dat from volume: '${VOLUME_NAME}'"

docker run -it --rm \
	-v ${VOLUME_NAME}:/data \
	-v "$PWD/${EXPORT_TARGET}":/export \
	alpine \
	cp /data/world/level.dat /export/level.exported.dat

docker compose unpause


