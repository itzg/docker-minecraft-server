# Examples

Various examples are [maintained in the repository](https://github.com/itzg/docker-minecraft-server/tree/master/examples). The sections below highlight a few particular ones.

## Bedrock compatible server

Using the [GeyserMC plugin](https://geysermc.org/) with a Paper server (or similar) "enables clients from Minecraft Bedrock Edition to join your Minecraft Java server". The example also includes [Floodgate](https://wiki.geysermc.org/floodgate/) which "allows Xbox Live authenticated Bedrock users to join without a Java Edition account". 

```yaml

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

## Lazymc - Put your Minecraft server to rest when idle

With [lazymc-docker-proxy](https://github.com/joesturge/lazymc-docker-proxy) you are able to use [lazymc](https://github.com/timvisee/lazymc) with the minecraft container.

```yaml
# Lazymc requires that the minecraft server have a static IP.
#
# To ensure that our servers have a static IP we need to create
# a network for our services to use.
#
# By default, Docker uses 172.17.0.0/16 subnet range.
# So we need to create a new network in a different subnet
# See the readme for more information.
#
# Please ensure that the subnet falls within the private CIDRs:
# https://datatracker.ietf.org/doc/html/rfc1918#section-3
#
# And that it is not in use by anything else.
networks:
  minecraft-network:
    driver: bridge    
    ipam:
      config:
        - subnet: 172.18.0.0/16

services:
  lazymc:
    image: ghcr.io/joesturge/lazymc-docker-proxy:latest
    # the IPs should start at .2 as .1 is reserved for the gateway
    networks:
      minecraft-network:
        ipv4_address: 172.18.0.2
    restart: unless-stopped
    volumes:
      # you should mount the minecraft server dir under /server, using read only.
      - data:/server:ro
      # you need to supply the docker socket, so that the container can run docker command
      - /var/run/docker.sock:/var/run/docker.sock:ro
    ports:
      # lazymc-docker-proxy acts as a proxy, so there is
      # no need to expose the server port on the Minecraft container
      - "25565:25565"

  # Standard Docker Minecraft server, also works with other server types
  mc:
    image: itzg/minecraft-server:java21
    # Assign a static IP to the server container
    networks:
      minecraft-network:
        ipv4_address: 172.18.0.3
    # We need to add a label here so that lazymc-docker-proxy knows which
    # container to manage
    labels:
      # Set lazymc.enabled to true to enable lazymc on this container
      - lazymc.enabled=true
      # Required to find the container to manage it
      - lazymc.group=mc
      # Point to the service name of the Minecraft server
      - lazymc.server.address=mc:25565
    tty: true
    stdin_open: true
    # This container should be managed solely by the lazymc container
    # so set restart to no, or else the container will start again...
    restart: no
    environment:
      EULA: "TRUE"
    volumes:
      - data:/data

volumes:
  data:
```
[Source](https://github.com/joesturge/lazymc-docker-proxy/blob/master/docker-compose.yaml)

## Lazytainer - Stop Minecraft container based on traffic
Monitors network traffic to the Minecraft containers. If there is traffic, the container runs, otherwise the container is stopped/paused.

By using [Lazytainer](https://github.com/vmorganp/Lazytainer) with the [docker-minecraft-server](https://github.com/itzg/docker-minecraft-server) a somehow similar behaviour to [Lazymc](https://github.com/timvisee/lazymc) can be archived.

```yaml
services:
  lazytainer:
    image: ghcr.io/vmorganp/lazytainer:master
    environment:
      VERBOSE: false
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
      EULA: TRUE
      TYPE: PAPER
      MEMORY: 4G
    volumes:
      - ./data:/data
    labels:
      - lazytainer.group=minecraft
    depends_on:
      - lazytainer
    network_mode: service:lazytainer
    tty: true
    stdin_open: true
    restart: unless-stopped
```
[Source](https://github.com/itzg/docker-minecraft-server/blob/master/examples/lazytainer/docker-compose.yml)
