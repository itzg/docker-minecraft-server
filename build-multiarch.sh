#!/bin/bash

# manually purge any pre-existing manifest list
# since docker manifest command lacks a "remove" operation
rm -rf ~/.docker/manifests/docker.io_itzg_minecraft-server-multiarch

export DOCKER_BUILDKIT=1

docker build --platform linux/arm64 -t itzg/minecraft-server:arm64 .
docker push itzg/minecraft-server:arm64

armv7tag=armv7-buildkit
armv7workDir=/tmp/armv7-$$
git worktree add $armv7workDir armv7
# sub-shell for build of armv7
(
  cd $armv7workDir
  docker build --platform linux/arm/v7 -t itzg/minecraft-server:$armv7tag .
  docker push itzg/minecraft-server:$armv7tag
)
git worktree remove $armv7workDir

docker pull itzg/minecraft-server
# use the rpi build one for now since armv7-buildkit is giving ABI mismatch on curl
docker pull itzg/minecraft-server:armv7

docker manifest create itzg/minecraft-server:multiarch \
  itzg/minecraft-server \
  itzg/minecraft-server:armv7 \
  itzg/minecraft-server:arm64

docker manifest inspect itzg/minecraft-server:multiarch

docker manifest push -p itzg/minecraft-server:multiarch
