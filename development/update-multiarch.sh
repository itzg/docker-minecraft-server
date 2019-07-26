#!/bin/bash

manifest="itzg/minecraft-server:multiarch"

for t in latest rpi3 aarch64; do
    docker pull itzg/minecraft-server:$t
done

docker manifest create --amend ${manifest} \
  itzg/minecraft-server:aarch64 \
  itzg/minecraft-server:latest \
  itzg/minecraft-server:rpi3

docker manifest annotate --os linux --arch amd64 ${manifest} itzg/minecraft-server:latest
docker manifest annotate --os linux --arch arm64 ${manifest} itzg/minecraft-server:aarch64
docker manifest annotate --os linux --arch arm --variant v7 ${manifest} itzg/minecraft-server:rpi3

docker manifest push ${manifest}