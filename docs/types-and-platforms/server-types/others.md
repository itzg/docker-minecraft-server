
## SpongeVanilla

Enable SpongeVanilla server mode by adding a `-e TYPE=SPONGEVANILLA` to your command-line.

By default the container will run the latest `STABLE` version.
If you want to run a specific version, you can add `-e SPONGEVERSION=1.11.2-6.1.0-BETA-19` to your command-line.

Beware that current [Sponge](https://www.spongepowered.org) `STABLE` versions for Minecraft 1.12 require using [the Java 8 tag](../../versions/java.md):

``` shell
docker run -d --pull=always -v /path/on/host:/data -e TYPE=SPONGEVANILLA \
    -p 25565:25565 -e EULA=TRUE --name mc itzg/minecraft-server:java8-multiarch
```

You can also choose to use the `EXPERIMENTAL` branch.
Just change it with `SPONGEBRANCH`, such as:

``` shell
$ docker run -d --pull=always -v /path/on/host:/data ... \
    -e TYPE=SPONGEVANILLA -e SPONGEBRANCH=EXPERIMENTAL ...
```

## Limbo

A [Limbo](https://github.com/LOOHP/Limbo) server can be run by setting `TYPE` to `LIMBO`.

Configuration options with defaults:

- `LIMBO_BUILD`=LATEST

  The `VERSION` will be ignored so locate the appropriate value from [here](https://ci.loohpjames.com/job/Limbo/) to match the version expected by clients.

- `FORCE_REDOWNLOAD`=false
- `LIMBO_SCHEMA_FILENAME`=default.schem
- `LEVEL`="Default;${LIMBO_SCHEMA_NAME}"

!!! note

    Instead of using format codes in the MOTD, Limbo requires [JSON chat content](https://minecraft.wiki/w/Raw_JSON_text_format#Java_Edition). If a plain string is provided, which is the default, then it gets converted into the required JSON structure. 

## NanoLimbo

A [NanoLimbo](https://github.com/BoomEaro/NanoLimbo) server can be run by setting `TYPE` to `NANOLIMBO`.

Note: it is a fork of the original [NanoLimbo](https://github.com/Nan1t/NanoLimbo) made by Nan1t

An alternate Limbo server

## Crucible

A [Crucible](https://github.com/CrucibleMC/Crucible) server can be run by setting `TYPE` to `CRUCIBLE`.

Configuration options with defaults:

- `CRUCIBLE_RELEASE`=latest

Crucible is only available for 1.7.10, so be sure to set `VERSION=1.7.10`.

## Custom

To use a custom server jar or class files, set `TYPE` to "CUSTOM" and continue with one of the following options:

The custom jar to be used can be set with `CUSTOM_SERVER` as either a URL to download or the path to a file within the container.

Alternatively, the final `-jar` invocation can be replaced by setting `CUSTOM_JAR_EXEC` to "`-cp <classpath> <classname>`" or "`-jar <jar file>`" form, such as

```
-cp worldedit.jar:Carpet-Server.jar net.minecraft.server.MinecraftServer
```

!!! note

    When using `docker run` make sure to quote the entire value since it has spaces in it, such as

        -e CUSTOM_JAR_EXEC="-cp worldedit.jar:Carpet-Server.jar net.minecraft.server.MinecraftServer"

## Pumpkin

A [Pumpkin](https://pumpkinmc.org/) server can be run by setting `TYPE` to `PUMPKIN`.

Pumpkin is a Minecraft server written in Rust and is shipped as a single native executable instead of a Java jar. The image downloads the asset matching its architecture from the [latest release](https://github.com/Pumpkin-MC/Pumpkin/releases), so `VERSION` and the JVM memory and tuning variables do not apply.

```shell
docker run -d --pull=always -v /path/on/host:/data \
    -p 25565:25565 -p 19132:19132/udp -e EULA=TRUE -e TYPE=PUMPKIN \
    --name mc itzg/minecraft-server
```

Configuration options with defaults:

- `FORCE_REDOWNLOAD`=false

  Set to true to re-download the executable.

Pumpkin is configured through `/data/pumpkin.toml`. The image creates that file on the first run and updates the settings below at each startup, leaving the remaining options in your file alone. Anything without a matching environment variable can be set by editing `pumpkin.toml` directly.

| Variable                                            | Pumpkin setting                                                                    |
| :-------------------------------------------------- | :--------------------------------------------------------------------------------- |
| `MOTD`                                              | `networking.java.motd` and `networking.bedrock.motd`                               |
| `MAX_PLAYERS`                                       | `networking.java.max_players` and `networking.bedrock.max_players`                 |
| `ONLINE_MODE`                                       | `networking.java.online_mode` and `networking.bedrock.online_mode`                 |
| `SERVER_PORT`                                       | `networking.java.address`                                                          |
| `VIEW_DISTANCE`                                     | `networking.java.view_distance` and `networking.bedrock.view_distance`             |
| `SIMULATION_DISTANCE`                               | `networking.java.simulation_distance` and `networking.bedrock.simulation_distance` |
| `LEVEL`                                             | `default_level_name`                                                               |
| `SEED`                                              | `seed`                                                                             |
| `MODE`                                              | `default_gamemode`                                                                 |
| `DIFFICULTY`                                        | `default_difficulty`                                                               |
| `HARDCORE`                                          | `hardcore`                                                                         |
| `ALLOW_NETHER`                                      | `allow_nether`                                                                     |
| `FORCE_GAMEMODE`                                    | `force_gamemode`                                                                   |
| `PVP`                                               | `pvp.enabled`                                                                      |
| `OP_PERMISSION_LEVEL`                               | `op_permission_level`                                                              |
| `SPAWN_PROTECTION`                                  | `spawn_protection`                                                                 |
| `ACCEPTS_TRANSFERS`                                 | `accepts_transfers`                                                                |
| `WHITELIST`, `WHITELIST_FILE` or `ENABLE_WHITELIST` | `white_list`                                                                       |
| `ENFORCE_WHITELIST`                                 | `enforce_whitelist`                                                                |
| `ENABLE_RCON`                                       | `networking.rcon.enabled`                                                          |
| `RCON_PORT`                                         | `networking.rcon.address`                                                          |
| `RCON_PASSWORD`                                     | `networking.rcon.password`                                                         |
| `ENABLE_QUERY`                                      | `networking.query.enabled`                                                         |
| `QUERY_PORT`                                        | `networking.query.address`                                                         |
| `PREVENT_PROXY_CONNECTIONS`                         | `networking.java.authentication.prevent_proxy_connections`                         |
| `RESOURCE_PACK`                                     | `resource_pack.java.url` and `resource_pack.java.enabled`                          |
| `RESOURCE_PACK_SHA1`                                | `resource_pack.java.sha1`                                                          |
| `RESOURCE_PACK_PROMPT`                              | `resource_pack.java.prompt_message`                                                |
| `RESOURCE_PACK_ENFORCE`                             | `resource_pack.java.force`                                                         |
| `LOG_LEVEL`                                         | `logging.level`                                                                    |

!!! note

    The first run adds every option Pumpkin knows about to `pumpkin.toml`, since Pumpkin fills in its own defaults for the settings the image does not manage.

!!! note

    Bedrock Edition players join on UDP port `19132`, which Pumpkin serves itself from the same world. That port has to be published, such as with `-p 19132:19132/udp`, since the image only declares `25565` with `EXPOSE`. See [examples/pumpkin](https://github.com/itzg/docker-minecraft-server/tree/master/examples/pumpkin) for a complete compose file.

!!! note

    Pumpkin is under heavy development, as the project itself states, so configuration and world formats can change between releases. Run it on a test server and keep backups.
