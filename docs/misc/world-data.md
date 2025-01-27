
## Downloadable world

Instead of mounting the `/data` volume, you can instead specify the URL of a ZIP or compressed TAR file containing an archived world. It will be searched for a file `level.dat` and the containing subdirectory moved to the directory named by `$LEVEL`. This means that most of the archived Minecraft worlds downloadable from the Internet will already be in the correct format.

    docker run -d -e WORLD=http://www.example.com/worlds/MySave.zip ...

!!! note

    This URL must be accessible from inside the container. Therefore, you should use an IP address or a globally resolvable FQDN, or else the name of a linked container.

!!! note

    If the archive contains more than one `level.dat`, then the one to select can be picked with `WORLD_INDEX`, which defaults to 1.

## Cloning world from a container path

The `WORLD` option can also be used to reference a directory, zip file, or compressed tar file that will be used as a source to clone or extract the world directory.

For example, the following would initially clone the world's content from `/worlds/basic`. Also notice in the example that you should use a read-only volume attachment to ensure the clone source remains pristine.

```
docker run ... -v $HOME/worlds:/worlds:ro -e WORLD=/worlds/basic
```

The following diagram shows how this option can be used in a compose deployment with a relative directory:

![](../img/world-copy-compose-project.drawio.png)

## Overwrite world on start
The world will only be downloaded or copied if it doesn't exist already. Set `FORCE_WORLD_COPY=TRUE` to force overwrite the world on every server start.

## Custom worlds directory path
To set a custom worlds directory for the Multiverse plugin on a baremetal server, you'd pass the `--world-dir` argument after the jar file.
In order to accomplish the same in a containerized server, set the `EXTRA_ARGS` environment variable in your command line or docker compose yaml to the same argument string. For example:

```
docker run -d -e EXTRA_ARGS='--world-dir ./worlds/'
```
`--world-container`, `-W`, and `--universe` are aliases to `--world-dir` and can also be used.

## Datapacks

Datapacks can be installed in a similar manner to mods/plugins. There are many environment variables which function in the same way they do for [mods](../mods-and-plugins/index.md):

* `DATAPACKS`: comma-separated list of zip file URL, zip file in container, or directory in container
* `DATAPACKS_FILE`: a text file within the container where each line is a zip file URL, zip file in container, or directory in container
* `REMOVE_OLD_DATAPACKS`: if "true" the datapacks directory is removed of everything matching `REMOVE_OLD_DATAPACKS_INCLUDE`, but excluding `REMOVE_OLD_DATAPACKS_EXCLUDE` no deeper than `REMOVE_OLD_DATAPACKS_DEPTH`
* `REMOVE_OLD_DATAPACKS_DEPTH`: default is 16
* `REMOVE_OLD_DATAPACKS_INCLUDE`: default is `*.zip`
* `REMOVE_OLD_DATAPACKS_EXCLUDE`: default is empty

Datapacks will be placed in `/data/$LEVEL/datapacks`

## VanillaTweaks

[VanillaTweaks](https://vanillatweaks.net/) datapacks, crafting tweaks, and resource packs can be installed with a share code from the website **OR** a json file to specify packs to download and install. Datapacks and crafting tweaks will be installed into the current world directory specified by `$LEVEL`. As new versions of the packs are retrieved the previous versions will automatically be cleaned up.

The share code is the part following the hash sign, as shown here:

```
https://vanillatweaks.net/share/#MGr52E
                                 ------
                                  |
                                  +- share code MGr52E
```

Accepted Parameters:

- `VANILLATWEAKS_FILE`: comma separated list of JSON VanillaTweak pack files accessible within the container
- `VANILLATWEAKS_SHARECODE`: comma separated list of share codes

Example of expected VanillaTweaks share codes:

!!! note

    ResourcePacks, DataPacks, and CraftingTweaks all have separate sharecodes

``` yaml
VANILLATWEAKS_SHARECODE: MGr52E,tF1zL2,LnEDwT
```

!!! note

    Datapack names are all lower case. [See their spec](https://vanillatweaks.net/assets/resources/json/1.21/dpcategories.json) for a full list of 1.21 datapacks, and [their spec](https://vanillatweaks.net/assets/resources/json/1.21/ctcategories.json) for a full list of 1.21 crafting tweaks.

Example of expected VanillaTweaks files:

``` yaml
VANILLATWEAKS_FILE: /config/vt-datapacks.json,/config/vt-craftingtweaks.json,/config/vt-resourcepacks.json
```

``` json title="DataPacks json"
{
  "type": "datapacks",
  "version": "1.21",
  "packs": {
    "gameplay changes": [
      "graves",
      "multiplayer sleep",
      "armored elytra"
    ],
    "teleport commands": ["tpa"]
  }
}
```

``` json title="ResourcePacks json"
{
    "type": "resourcepacks",
    "version": "1.21",
    "packs": {
        "aesthetic": ["CherryPicking", "BlackNetherBricks", "AlternateBlockDestruction"]
    }
}
```


``` json title="CraftingTweaks Json"
{
    "type": "craftingtweaks",
    "version": "1.21",
    "packs": {
        "quality of life": [
            "dropper to dispenser",
            "double slabs",
            "back to blocks"
        ]
    }
}
```
