# Examples

Various examples are [maintained in the repository](https://github.com/itzg/docker-minecraft-server/tree/master/examples). The sections below highlight a few particular ones.

## Bedrock compatible server

Using the [GeyserMC plugin](https://geysermc.org/) with a Paper server (or similar) "enables clients from Minecraft Bedrock Edition to join your Minecraft Java server". The example also includes [Floodgate](https://wiki.geysermc.org/floodgate/) which "allows Xbox Live authenticated Bedrock users to join without a Java Edition account". 

```yaml
version: "3.8"

services:
  mc:
    image: itzg/minecraft-server
    environment:
      EULA: "true"
      TYPE: "PAPER"
      PLUGINS: |
        https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot
        https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot
    ports:
      - "25565:25565"
      - "19132:19132/udp"
    volumes:
      - ./data:/data
```

[Source](https://github.com/itzg/docker-minecraft-server/blob/master/examples/geyser/docker-compose.yml)

## Lazytainer - Stop Minecraft container based on traffic
Monitors network traffic to the Minecraft containers. If there is traffic, the container runs, otherwise the container is stopped/paused.

By using [Lazytainer](https://github.com/vmorganp/Lazytainer) with the [docker-minecraft-server](https://github.com/itzg/docker-minecraft-server) a somehow similar behaviour to [Lazymc](https://github.com/timvisee/lazymc) can be archived.

```yaml
version: "3"
services:
  lazytainer:
    container_name: lazytainer
    image: ghcr.io/vmorganp/lazytainer:master
    environment:
      - VERBOSE=false
    ports:
      - 25565:25565
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock:ro
    labels:
      - lazytainer.group.minecraft.sleepMethod=stop
      - lazytainer.group.minecraft.ports=25565
      - lazytainer.group.minecraft.minPacketThreshold=2 # Start after two incomming packets
      - lazytainer.group.minecraft.inactiveTimeout=600 # 10 minutes, to allow the server to bootstrap. You can probably make this lower later if you want.
    restart: unless-stopped
    network_mode: bridge
  mc:
    image: itzg/minecraft-server
    environment:
      - EULA=TRUE
      - TYPE=PURPUR
      - MEMORY=4G
      - TZ=Europe/Berlin
      - OVERRIDE_SERVER_PROPERTIES=TRUE
    volumes:
      - /opt/container_volumes/minecraft/data:/data
    labels:
      - lazytainer.group=minecraft
    depends_on:
      - lazytainer
    network_mode: service:lazytainer
    tty: true
    stdin_open: true
    restart: unless-stopped
networks: {}
```
[Source](https://github.com/itzg/docker-minecraft-server/blob/master/examples/lazytainer/docker-compose.yml)