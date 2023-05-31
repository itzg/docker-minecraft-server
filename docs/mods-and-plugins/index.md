## Optional plugins, mods, and config attach points

There are optional volume paths that can be attached to supply content to be copied into the data area:

`/plugins`
: contents are synchronized into `/data/plugins` for Bukkit related server types. The source can be changed by setting `COPY_PLUGINS_SRC`. The destination can be changed by setting `COPY_PLUGINS_DEST`. Set `SYNC_SKIP_NEWER_IN_DESTINATION=false` if you want files from `/plugins` to take precedence over newer files in `/data/plugins`.

`/mods`
: contents are synchronized into `/data/mods` for Fabric and Forge related server types. The source can be changed by setting `COPY_MODS_SRC`. The destination can be changed by setting `COPY_MODS_DEST`.

`/config`
: contents are synchronized into `/data/config` by default, but can be changed with `COPY_CONFIG_DEST`. The source can be changed by setting `COPY_CONFIG_SRC`. For example, `-v ./config:/config -e COPY_CONFIG_DEST=/data` will allow you to copy over files like `bukkit.yml` and so on directly into the server directory. Set `SYNC_SKIP_NEWER_IN_DESTINATION=false` if you want files from `/config` to take precedence over newer files in `/data/config`.

By default, the [environment variable processing](../configuration/interpolating.md) is performed on synchronized files that match the expected suffixes in `REPLACE_ENV_SUFFIXES` (by default "yml,yaml,txt,cfg,conf,properties,hjson,json,tml,toml") and are not excluded by `REPLACE_ENV_VARIABLES_EXCLUDES` and `REPLACE_ENV_VARIABLES_EXCLUDE_PATHS`. This processing can be disabled by setting `REPLACE_ENV_DURING_SYNC` to `false`.

If you want old mods/plugins to be removed before the content is brought over from those attach points, then add `-e REMOVE_OLD_MODS=TRUE`. You can fine tune the removal process by specifying the `REMOVE_OLD_MODS_INCLUDE` and `REMOVE_OLD_MODS_EXCLUDE` variables, which are comma separated lists of file glob patterns. If a directory is excluded, then it and all of its contents are excluded. By default, only jars are removed. 

You can also specify the `REMOVE_OLD_MODS_DEPTH` (default is 16) variable to only delete files up to a certain level.

For example: `-e REMOVE_OLD_MODS=TRUE -e REMOVE_OLD_MODS_INCLUDE="*.jar" -e REMOVE_OLD_MODS_DEPTH=1` will remove all old jar files that are directly inside the `plugins/` or `mods/` directory.

These paths work well if you want to have a common set of modules in a separate location, but still have multiple worlds with different server requirements in either persistent volumes or a downloadable archive.

> For more flexibility with mods/plugins preparation, you can declare directories to use in [the `MODS` variable](#zip-file-modpack)

## Auto-downloading SpigotMC/Bukkit/PaperMC plugins with Spiget

The `SPIGET_RESOURCES` variable can be set with a comma-separated list of SpigotMC resource IDs to automatically download [SpigotMC resources/plugins](https://www.spigotmc.org/resources/) using [the spiget API](https://spiget.org/). Resources that are zip files will be expanded into the plugins directory and resources that are simply jar files will be moved there.

> NOTE: the variable is purposely spelled SPIG**E**T with an "E"

The **resource ID** can be located from the numerical part of the URL after the shortname/slug and a dot. For example, the ID is **28140** from

    https://www.spigotmc.org/resources/luckperms.28140/
                                                 =====

For example, the following will auto-download the [LuckPerms](https://www.spigotmc.org/resources/luckperms.28140/) and [Vault](https://www.spigotmc.org/resources/vault.34315/) plugins:

    -e SPIGET_RESOURCES=28140,34315

!!! note
    Some plugins, such as EssentialsX (resource ID 9089), do not permit automated downloads via Spiget. Instead you will need to pre-download the desired file and supply it to the container, such as using the `/plugins` mount point, described above.

## Auto-download mods and plugins from Modrinth

[Modrinth](https://modrinth.com/) is an open source modding platform with a clean, easy to use website for finding [Fabric and Forge mods](https://modrinth.com/mods). At startup, the container will automatically locate and download the newest versions of mod/plugin files that correspond to the `TYPE` and `VERSION` in use. Older file versions downloaded previously will automatically be cleaned up.

- **MODRINTH_PROJECTS** : comma separated list of project slugs (short name) or IDs. The project ID can be located in the "Technical information" section. The slug is the part of the page URL that follows `/mod/`:
  ```
    https://modrinth.com/mod/fabric-api
                             ----------
                              |
                              +-- project slug
  ```
  Also, specific version/type can be declared using colon symbol and version id/type after the project slug. The version id can be found at 'Metadata' section. Valid version types are `release`, `beta`, `alpha`. For instance:
  ```
    -e MODRINTH_PROJECTS=fabric-api,fabric-api:PbVeub96,fabric-api:beta
  ```
- **MODRINTH_DOWNLOAD_OPTIONAL_DEPENDENCIES**=true : required dependencies of the project will _always_ be downloaded and optional dependencies can also be downloaded by setting this to `true`
- **MODRINTH_ALLOWED_VERSION_TYPE**=release : the version type is used to determine the newest version to use from each project. The allowed values are `release`, `beta`, `alpha`.

## Zip file modpack

Like the `WORLD` option above, you can specify the URL or path of a "mod pack"
to download and install into `mods` for Forge/Fabric or `plugins` for Bukkit/Spigot.
To use this option pass the environment variable `MODPACK`, such as

```shell
docker run -d -e MODPACK=http://www.example.com/mods/modpack.zip ...
```

!!! note
    The referenced URL must be a zip file with one or more jar files at the
    top level of the zip archive. Make sure the jars are compatible with the
    particular `TYPE` of server you are running.

You may also download or copy over individual mods using the `MODS` environment variable. `MODS` contains a comma-separated list of
- URL of a jar file
- container path to a jar file
- container path to a directory containing jar files

```shell
docker run -d -e MODS=https://www.example.com/mods/mod1.jar,/plugins/common,/plugins/special/mod2.jar ...
```

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

The most time-consuming portion of the generic pack update is generating and comparing the SHA1 checksum. To skip the checksum generation, set `SKIP_GENERIC_PACK_CHECKSUM` to "true.

## Mod/Plugin URL Listing File 

As an alternative to `MODS`, the variable `MODS_FILE` can be set with the path to a text file listing a mod/plugin URL on each line. For example, the following

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

    [This compose file](https://github.com/itzg/docker-minecraft-server/blob/master/examples/docker-compose-mods-file.yml) shows another example of using this feature.

    It is recommended to combine this option with `REMOVE_OLD_MODS=TRUE` to ensure the mods/plugins remain consistent with the file's listing.

## Remove old mods/plugins

When the `MODPACK` option above is specified you can also instruct script to delete old mods/plugins prior to installing new ones. This behaviour is desirable in case you want to upgrade mods/plugins from downloaded zip file.

To use this option pass the environment variable `REMOVE_OLD_MODS=TRUE`, such as

```shell
docker run -d -e REMOVE_OLD_MODS=TRUE -e MODPACK=http://www.example.com/mods/modpack.zip ...
```

!!! danger 

    All content of the `mods` or `plugins` directory will be deleted before unpacking new content from the MODPACK or MODS.
