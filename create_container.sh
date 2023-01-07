#!/bin/bash

. server_config.sh

docker run -d -v /path/on/host:/data \
    -e TYPE=PAPER \
    -p 25565:25565 -e EULA=TRUE --name $CONTAINER_NAME itzg/minecraft-server

