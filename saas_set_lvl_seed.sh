#!/bin/bash

VOLUME_TAG=$1
SEED_VALUE=$2

NBT_UTILS_DIR="./utilities/nbt_utils/"

TIMESTAMP=$(date +"%Y%m%d_%s")

TMP_FILE="./level_${TIMESTAMP}.dat"

# Making sure that the docker container is down is mandatory (Pausing/Stopping doesn't work?)
docker compose stop

# Export the level.dat from the volume to the utilities folder
./export_level_dat.sh ${VOLUME_TAG} ${NBT_UTILS_DIR}

# Have the script create a modified nbt data file that we will use to add back into the volume
${NBT_UTILS_DIR}/routine_set_seed.sh "${NBT_UTILS_DIR}/level.exported.dat" "${NBT_UTILS_DIR}/${TMP_FILE}" ${SEED_VALUE}

# Import the new level.dat file from the utilities folder and back into the volume
./import_level_dat.sh ${VOLUME_TAG} "${NBT_UTILS_DIR}/${TMP_FILE}"

# Remove the temporary file
rm "${NBT_UTILS_DIR}/${TMP_FILE}"

# Start up the docker container again
docker compose start

