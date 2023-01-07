#!/bin/bash

. server_config.sh

docker exec $CONTAINER_NAME rcon-cli stop

docker stop $CONTAINER_NAME

