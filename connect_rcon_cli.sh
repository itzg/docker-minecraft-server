#!/bin/bash

CONTAINER_NAME="docker-minecraft-server_mc_1"
CONTAINER_NAME="mcaws"

docker exec -i ${CONTAINER_NAME} rcon-cli

