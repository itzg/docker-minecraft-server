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