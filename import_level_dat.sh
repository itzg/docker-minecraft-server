#!/bin/bash

# ./import_level_dat.sh <volume_tag> <level.dat filepath>
# Example ./export_level_dat.sh data ./utilities/nbt-utils/level.dat

docker compose pause

VOLUME_TAG=$1
IMPORT_TARGET=$2

IMPORT_FILENAME=$(basename $IMPORT_TARGET)
IMPORT_DIRECTORY=$(dirname $IMPORT_TARGET)

# We assume that the volume of the container is <current folder>_<user_input>
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
VOLUME_NAME="$(sed 's#.*/##' <<< "${SCRIPT_DIR}")_${VOLUME_TAG}"
echo "Exporting level.dat from volume: '${VOLUME_NAME}'"

docker run -it --rm \
	-v ${VOLUME_NAME}:/data \
	-v "$PWD/${IMPORT_DIRECTORY}":/import \
	alpine \
	cp /import/${IMPORT_FILENAME} /data/world/level.dat
	# cp /data/world/level.dat /export/level.exported.dat

docker compose unpause


