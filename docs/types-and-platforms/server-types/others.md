
## SpongeVanilla

Enable SpongeVanilla server mode by adding a `-e TYPE=SPONGEVANILLA` to your command-line.

By default the container will run the latest `STABLE` version.
If you want to run a specific version, you can add `-e SPONGEVERSION=1.11.2-6.1.0-BETA-19` to your command-line.

Beware that current [Sponge](https://www.spongepowered.org) `STABLE` versions for Minecraft 1.12 require using [the Java 8 tag](../../versions/java.md):

``` shell
docker run -d -v /path/on/host:/data -e TYPE=SPONGEVANILLA \
    -p 25565:25565 -e EULA=TRUE --name mc itzg/minecraft-server:java8-multiarch
```

You can also choose to use the `EXPERIMENTAL` branch.
Just change it with `SPONGEBRANCH`, such as:

``` shell
$ docker run -d -v /path/on/host:/data ... \
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
