#!/bin/bash

CONTAINER_NAME="docker-minecraft-server_mc_1"

docker exec ${CONTAINER_NAME} rcon-cli "$@"

