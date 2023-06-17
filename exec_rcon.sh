#!/bin/bash

CONTAINER_NAME="docker-minecraft-server_mc"
CONTAINER_NAME="mcaws"

docker exec ${CONTAINER_NAME} rcon-cli "$@"

