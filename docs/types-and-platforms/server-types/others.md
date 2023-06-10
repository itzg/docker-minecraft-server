
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

    Instead of using format codes in the MOTD, Limbo requires [JSON chat content](https://minecraft.fandom.com/wiki/Raw_JSON_text_format#Java_Edition). If a plain string is provided, which is the default, then it gets converted into the required JSON structure. 

## Crucible

A [Crucible](https://github.com/CrucibleMC/Crucible) server can be run by setting `TYPE` to `CRUCIBLE`.

Configuration options with defaults:

- `CRUCIBLE_RELEASE`=latest

Crucible is only available for 1.7.10, so be sure to set `VERSION=1.7.10`.
