# Auto-setup GTNH server

[GT New Horizons (GTNH)](https://www.gtnewhorizons.com/) is a Minecraft 1.7.10 modpack maintained and supported by dedicated community members! With over 10 years in development, GTNH offers a carefully balanced and immersive experience to challenge players as they climb through the 15 tiers of technology. The ultimate goal of GTNH is to build the Stargate, an interdimensional teleporter and the symbol for absolute prestige, aptitude, and determination. 

As GTNH is a complex modpack with some specifics it has its own `TYPE` to simplify the deployment and update process. To use it set the environment variable `TYPE` to "GTNH". 

Configuration options with defaults:

- `GTNH_PACK_VERSION`=latest
- `GTNH_DELETE_BACKUPS`=false
- `SKIP_GTNH_UPDATE_CHECK`=false

## Set Modpack version

As GTNH is a Minecraft 1.7.10 modpack, when using it your minecraft version is set to 1.7.10 by default. The [modpack version](https://www.gtnewhorizons.com/downloads/) can be selected by setting `GTNH_PACK_VERSION` to `latest`, `latest-dev` or any specific version number. `latest` will automatically select the latest full release version available and deploy the server with it (Note: this will also automatically update the server on startup). `latest-dev` does the same but selects the latest version marked as beta or RC (it wont select a full release version even if a newer exist). The third (and recommended) option is setting the server to a specific version like `2.8.1` to manage updates manually.

> To actively prevent an update from happening you can set the environment variable `SKIP_GTNH_UPDATE_CHECK` to true this will prevent any update check from running, but will also prevent the server install from running, so just set it after the initial setup.

## Ressource requirements

**Recommended Minimum:**

  - 2-4 cpu cores
  - 6GB of RAM +0.5GB per extra player (early game)
  - 6GB of RAM +1GB per extra player (~UV tier+)
  - 20GB+ storage. HDD is feasible, SSD is preferred

For more details regarding the server setup consult the [modpack wiki](https://wiki.gtnewhorizons.com/wiki/Server_Setup).

## Java Version

GTNH supports java 8 and 17+ (java 17+ is always recommended for maximum performance). The server will only start when a supported version of itzg/docker-minecraft-server is used.

For optimal performance choose java25 with GTNH 2.8.0 and later.

## Config backups

During version upgrade, the server will replace all config files to make sure all new features are setup as intended. The old config files are stored in a backup folder in the data directory, for you to use as reference for manual reapplication of your changed settings. Set the environment variable `GTNH_DELETE_BACKUPS` to true to delete all backup folders at startup. 

## server.properties defaults

To deliver the intended GTNH by default, when running a GTNH server, the following options are set in `server.properties`. It is recommended to leave them as is, but if you know what you are doing feel free to play around with them.

- `LEVEL_TYPE=rwg`
- `DIFFICULTY=hard`
- `ALLOW_FLIGHT=true`
- `ENABLE_COMMAND_BLOCK=true`
- `MOTD=Greg Tech New Horizon <current-pack-version>`

## Java args

With java 17+ the server starts with `-Dfml.readTimeout=180 @java9args.txt -jar lwjgl3ify-forgePatches.jar`. 

With java 8 the server stars with `-XX:+UseStringDeduplication -XX:+UseCompressedOops -XX:+UseCodeCacheFlushing -Dfml.readTimeout=180 -jar forge-1.7.10-10.13.4.1614-1.7.10-universal.jar`
