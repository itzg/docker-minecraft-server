# Intro

[![Docker Pulls](https://img.shields.io/docker/pulls/itzg/minecraft-server.svg)](https://hub.docker.com/r/itzg/minecraft-server/)
[![Docker Stars](https://img.shields.io/docker/stars/itzg/minecraft-server.svg?maxAge=2592000)](https://hub.docker.com/r/itzg/minecraft-server/)
[![GitHub Issues](https://img.shields.io/github/issues-raw/itzg/docker-minecraft-server.svg)](https://github.com/itzg/docker-minecraft-server/issues)
[![Discord](https://img.shields.io/discord/660567679458869252?label=Discord&logo=discord)](https://discord.gg/DXfKpjB)
[![Build and Publish](https://github.com/itzg/docker-minecraft-server/workflows/Build%20and%20Publish/badge.svg)](https://github.com/itzg/docker-minecraft-server/actions)
[![](https://img.shields.io/badge/Donate-Buy%20me%20a%20coffee-orange.svg)](https://www.buymeacoffee.com/itzg)

This docker image provides a Minecraft Server that will automatically download the latest stable
version at startup. You can also run/upgrade to any specific version or the
latest snapshot. See the _Versions_ section below for more information.

To simply use the latest stable version, run

    docker run -d -it -p 25565:25565 -e EULA=TRUE itzg/minecraft-server

where, in this case, the standard server port 25565, will be exposed on your host machine.

!!! note

    If you plan on running a server for a longer amount of time it is highly recommended using a management layer such as [Docker Compose](#using-docker-compose) or [Kubernetes](misc/deployment/index.md#on-kubernetes) to allow for incremental reconfiguration and image upgrades.

!!! info 

    Be sure to always include `-e EULA=TRUE` in your commands and container definitions, as Mojang/Microsoft requires EULA acceptance.

!!! warning 

    **DO NOT** port forward RCON on 25575 without first setting `RCON_PASSWORD` to a secure value. It is highly recommended to only use RCON within the container, such as with `rcon-cli`. 

By default, the container will download the latest version of the "vanilla" [Minecraft: Java Edition server](https://www.minecraft.net/en-us/download/server) provided by Mojang. The [`VERSION`](versions/java.md) and the [`TYPE`](types-and-platforms/index.md) can be configured to create many variations of desired Minecraft server. 

## Using [Docker Compose](https://docs.docker.com/compose/)

1. Create a new directory
2. Put the contents of the file below in a file called `docker-compose.yml`
3. Run `docker compose up -d` in that directory
4. Done! Point your client at your host's name/IP address and port 25565.

```yaml

services:
  mc:
    image: itzg/minecraft-server
    tty: true
    stdin_open: true
    ports:
      - "25565:25565"
    environment:
      EULA: "TRUE"
    volumes:
      # attach the relative directory 'data' to the container's /data path
      - ./data:/data
```

To apply changes made to the compose file, just run `docker compose up -d` again.

Follow the logs of the container using `docker compose logs -f`, check on the status with `docker compose ps`, and stop the container using `docker compose stop`.

!!! note "Configurator Tool"
    If you prefer to use an interactive tool to create or edit a Docker Compose file for this image, you can check out [setupmc.com's configurator](https://setupmc.com/java-server/). It provides a form that supports most of the image variables and generates the `compose.yml` file in real time.

!!! note "More Compose Examples"
    There are more [examples located in the Github repo](https://github.com/itzg/docker-minecraft-server/tree/master/examples).

!!! note "Deployment Examples"
    The [deployments page](misc/deployment/index.md) provides more examples of deployment with and beyond Docker Compose.
