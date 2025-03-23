# Working with mods and plugins

## Modpack platforms

By far the easiest way to work with mod and plugins, especially large numbers of them, is to utilize modpacks with [one of the supported modpack platforms](../types-and-platforms/index.md).

The following are some supported modpack platforms:

- [Modrinth](../types-and-platforms/mod-platforms/modrinth-modpacks.md) 
- [CurseForge](../types-and-platforms/mod-platforms/auto-curseforge.md)
- [Feed the Beast](../types-and-platforms/mod-platforms/ftb.md)

## Download automation

On the left, there are sections describing some download automation options.

## Mods vs Plugins

The terms "mods" and "plugins" can be quite confusing. Generally, the rule of thumb is that "mods" are used by the types that run client side to modify rendering, add new blocks, and add behaviors server, such as [Forge](../types-and-platforms/server-types/forge.md) and [Fabric](../types-and-platforms/server-types/fabric.md). "Plugins" are used by the types that **only run on servers** to add behaviors, commands, etc such as [Paper](../types-and-platforms/server-types/paper.md) (which derives from [Bukkit/Spigot](../types-and-platforms/server-types/bukkit-spigot.md)). There are also some types that are [hybrids](../types-and-platforms/server-types/hybrids.md), such as Magma, that use both "mods" and "plugins".

Typically, mods needs to be installed in both the client and server; however, there are some cases when only the server needs a mod. Plugins only need to be installed in the server and are never needed in the client.

## Optional plugins, mods, and config attach points

There are optional volume paths that can be attached to supply content to be copied into the data area:

`/plugins`
: content in this directory is synchronized into `/data/plugins` for server types that use plugins, [as described above](#mods-vs-plugins). For special cases, the source can be changed by setting `COPY_PLUGINS_SRC` and destination by setting `COPY_PLUGINS_DEST`. If using a mod-based loader, such as Forge or Fabric, but a hybrid mod like [Cardboard](https://modrinth.com/mod/cardboard), then set `USES_PLUGINS` to have the automation utilize `/plugins` mount.

`/mods`
: content in this directory is synchronized into `/data/mods` for server types that use mods, [as described above](#mods-vs-plugins). For special cases, the source can be changed by setting `COPY_MODS_SRC` and destination by setting `COPY_MODS_DEST`.

`/config`
: contents are synchronized into `/data/config` by default, but can be changed with `COPY_CONFIG_DEST`. For example, `-v ./config:/config -e COPY_CONFIG_DEST=/data` will allow you to copy over files like `bukkit.yml` and so on directly into the server directory. The source can be changed by setting `COPY_CONFIG_SRC`. Set `SYNC_SKIP_NEWER_IN_DESTINATION=false` if you want files from `/config` to take precedence over newer files in `/data/config`.

By default, the [environment variable processing](../configuration/interpolating.md) is performed on synchronized files that match the expected suffixes in `REPLACE_ENV_SUFFIXES` (by default "yml,yaml,txt,cfg,conf,properties,hjson,json,tml,toml") and are not excluded by `REPLACE_ENV_VARIABLES_EXCLUDES` and `REPLACE_ENV_VARIABLES_EXCLUDE_PATHS`. This processing can be disabled by setting `REPLACE_ENV_DURING_SYNC` to `false`.

If you want old mods/plugins to be removed before the content is brought over from those attach points, then add `-e REMOVE_OLD_MODS=TRUE`. You can fine tune the removal process by specifying the `REMOVE_OLD_MODS_INCLUDE` and `REMOVE_OLD_MODS_EXCLUDE` variables, which are comma separated lists of file glob patterns. If a directory is excluded, then it and all of its contents are excluded. By default, only jars are removed. 

You can also specify the `REMOVE_OLD_MODS_DEPTH` (default is 16) variable to only delete files up to a certain level.

For example: `-e REMOVE_OLD_MODS=TRUE -e REMOVE_OLD_MODS_INCLUDE="*.jar" -e REMOVE_OLD_MODS_DEPTH=1` will remove all old jar files that are directly inside the `plugins/` or `mods/` directory.

These paths work well if you want to have a common set of modules in a separate location, but still have multiple worlds with different server requirements in either persistent volumes or a downloadable archive.

!!! information "Multiple source directories"

    `COPY_PLUGINS_SRC`, `COPY_MODS_SRC`, `COPY_CONFIG_SRC` can each be set to a comma or newline delimited list of container directories to reference.

    For example, in a compose file:
    
    ```yaml
        environment:
          # ...EULA, etc
          TYPE: PAPER
          # matches up to volumes declared below
          COPY_PLUGINS_SRC: /plugins-common,/plugins-local
        volumes:
          - mc-data:/data
          # For example, reference a shared directory used by several projects
          - ../plugins-common:/plugins-common:ro
          # and add plugins unique to this project
          - ./plugins:/plugins-local:ro
    ```

    Alternatively, you can declare other directories along with files and URLs to use in [the `MODS` / `PLUGINS` variables](#modsplugins-list).



## Zip file modpack

Like the `WORLD` option above, you can specify the URL or container path of a "mod pack" to download and install into `mods` for Forge/Fabric or `plugins` for Bukkit/Spigot. To use this option pass the environment variable `MODPACK`, such as

```shell
docker run -d -e MODPACK=http://www.example.com/mods/modpack.zip ...
```

!!! note
    The referenced URL/file must be a zip file with one or more jar files at the
    top level of the zip archive. Make sure the jars are compatible with the
    particular `TYPE` of server you are running.

## Generic pack files

To install all the server content (jars, mods, plugins, configs, etc.) from a zip or tgz file, then set `GENERIC_PACK` to the container path or URL of the archive file. This can also be used to apply a CurseForge modpack that is missing a server start script and/or Forge installer.

If multiple generic packs need to be applied together, set `GENERIC_PACKS` instead, with a comma separated list of archive file paths and/or URLs to files.

To avoid repetition, each entry will be prefixed by the value of `GENERIC_PACKS_PREFIX` and suffixed by the value of `GENERIC_PACKS_SUFFIX`, both of which are optional. For example, the following variables

```
GENERIC_PACKS=configs-v9.0.1,mods-v4.3.6
GENERIC_PACKS_PREFIX=https://cdn.example.org/
GENERIC_PACKS_SUFFIX=.zip
```

would expand to `https://cdn.example.org/configs-v9.0.1.zip,https://cdn.example.org/mods-v4.3.6.zip`.

If applying large generic packs, the update can be time-consuming. To skip the update set `SKIP_GENERIC_PACK_UPDATE_CHECK` to "true". Conversely, the generic pack(s) can be forced to be applied by setting `FORCE_GENERIC_PACK_UPDATE` to "true".

The most time-consuming portion of the generic pack update is generating and comparing the SHA1 checksum. To skip the checksum generation, set `SKIP_GENERIC_PACK_CHECKSUM` to "true".

To disable specific mods, which can be useful for conflicts between multiple generic packs, you can use the `GENERIC_PACKS_DISABLE_MODS` variable to specify mods to disable.

Disabling mods with docker run:
```shell
docker run -d -e GENERIC_PACKS_DISABLE_MODS="mod1.jar mod2.jar" ...
```

Disabling mods within docker compose files:
```yaml
      GENERIC_PACKS_DISABLE_MODS: |
        mod1.jar
        mod2.jar
```

## Mods/plugins list

You may also download or copy over individual mods/plugins using the `MODS` or `PLUGINS` environment variables. Both are a comma or newline delimited list of

- URL of a jar file
- container path to a jar file
- container path to a directory containing jar files

```shell
docker run -d -e MODS=https://www.example.com/mods/mod1.jar,/plugins/common,/plugins/special/mod2.jar ...
```

The newline delimiting allows for compose file usage like:
```yaml
      PLUGINS: |
        https://download.geysermc.org/v2/projects/geyser/versions/latest/builds/latest/downloads/spigot
        https://download.geysermc.org/v2/projects/floodgate/versions/latest/builds/latest/downloads/spigot
```

## Mod/Plugin URL Listing File 

As an alternative to `MODS`/`PLUGINS`, the variable `MODS_FILE` or `PLUGINS_FILE` can be set with the container path or URL of a text file listing a mod/plugin URLs on each line. For example, the following

     -e MODS_FILE=/extras/mods.txt

would load from a file mounted into the container at `/extras/mods.txt`. That file might look like:

```text
https://edge.forgecdn.net/files/2965/233/Bookshelf-1.15.2-5.6.40.jar
https://edge.forgecdn.net/files/2926/27/ProgressiveBosses-2.1.5-mc1.15.2.jar
# This and next line are ignored
#https://edge.forgecdn.net/files/3248/905/goblintraders-1.3.1-1.15.2.jar
https://edge.forgecdn.net/files/3272/32/jei-1.15.2-6.0.3.16.jar
https://edge.forgecdn.net/files/2871/647/ToastControl-1.15.2-3.0.1.jar
```

!!! note

    Blank lines and lines that start with a `#` will be ignored

    [This compose file](https://github.com/itzg/docker-minecraft-server/blob/master/examples/mods-file/docker-compose.yml) shows another example of using this feature.

## Remove old mods/plugins

When the `MODPACK` option above is specified you can also instruct script to delete old mods/plugins prior to installing new ones. This behaviour is desirable in case you want to upgrade mods/plugins from downloaded zip file.

To use this option pass the environment variable `REMOVE_OLD_MODS=TRUE`, such as

```shell
docker run -d -e REMOVE_OLD_MODS=TRUE -e MODPACK=http://www.example.com/mods/modpack.zip ...
```

!!! danger 

    All content of the `mods` or `plugins` directory will be deleted before unpacking new content from the MODPACK or MODS.
