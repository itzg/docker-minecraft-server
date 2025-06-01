A [PaperMC server](https://papermc.io/) can be automatically downloaded, upgraded, and run by setting the environment variable TYPE to "PAPER".

By default, the container will find and download the latest build for the `VERSION` chosen. If `VERSION` is not specified, then the latest Minecraft version released by PaperMC is selected. Along with a specific `VERSION`, a specific Paper build can be selected by setting the environment variable `PAPER_BUILD`. 

To allow for the selection of experimental builds, set `PAPER_CHANNEL` to "experimental", otherwise only release/default channel builds are selected.

!!! example

    Using `docker run` command line
    
    ```
    docker run ... -e TYPE=PAPER ... 
    
    docker run ... -e TYPE=PAPER -e VERSION=1.20.6 ... 
    
    docker run ... -e TYPE=PAPER -e VERSION=1.20.6 -e PAPER_BUILD=140 ... 
    
    docker run ... -e TYPE=PAPER -e PAPER_CHANNEL=experimental ... 
    ```
    
    Using a compose file:
    
    ```yaml
    environment:
      TYPE: PAPER
    ```
    
    ```yaml
    environment:
      TYPE: PAPER
      VERSION: 1.20.6
      PAPER_BUILD: 140
    ```
    
    ```yaml
    environment:
      TYPE: PAPER
      PAPER_CHANNEL: experimental
    ```

!!! tip

    If you see the following error, it likely means you need to set the env var `PAPER_CHANNEL` to "experimental"
    
    ```
    No build found for version 1.21 with channel 'default'
    ```

If you are hosting your own copy of Paper you can override the download URL with `PAPER_DOWNLOAD_URL=<url>`.

If you have attached a host directory to the `/data` volume, then you can install plugins via the `plugins` subdirectory. You can also [attach a `/plugins` volume](../../mods-and-plugins/index.md#optional-plugins-mods-and-config-attach-points). If you add plugins while the container is running, you'll need to restart it to pick those up.

[You can also auto-download plugins using `SPIGET_RESOURCES`.](../../mods-and-plugins/spiget.md)

## Alternatives

### Pufferfish

A [Pufferfish](https://github.com/pufferfish-gg/Pufferfish) server, which is "a highly optimized Paper fork designed for large servers requiring both maximum performance, stability, and "enterprise" features."

    -e TYPE=PUFFERFISH

!!! note

    The `VERSION` variable is used to select branch latest, 1.18, or 1.17. Use PUFFERFISH_BUILD to really select the SERVER VERSION number.

Extra variables:
- `PUFFERFISH_BUILD=lastSuccessfulBuild` : set a specific Pufferfish build to use. Example: selecting build 47 => 1.18.1, or build 50 => 1.18.2 etc
- `FORCE_REDOWNLOAD=false` : set to true to force the located server jar to be re-downloaded
- `USE_FLARE_FLAGS=false` : set to true to add appropriate flags for the built-in [Flare](https://blog.airplane.gg/flare) profiler

### Purpur

A [Purpur](https://purpurmc.org/) server, which is "a drop-in replacement for Paper servers designed for configurability and new, fun, exciting gameplay features."

    -e TYPE=PURPUR

!!! note

    The `VERSION` variable is used to lookup a build of Purpur to download

Extra variables:
- `PURPUR_BUILD=LATEST` : set a specific Purpur build to use
- `FORCE_REDOWNLOAD=false` : set to true to force the located server jar to be re-downloaded
- `USE_FLARE_FLAGS=false` : set to true to add appropriate flags for the built-in [Flare](https://blog.airplane.gg/flare) profiler
- `PURPUR_DOWNLOAD_URL=<url>` : set URL to download Purpur from custom URL.

### Leaf

A [Leaf server](https://www.leafmc.one/) is a Paper fork focused on performance improvements and low-level optimizations for smoother gameplay.

To use a Leaf server, set the environment variable `TYPE` to `"LEAF"`.

    -e TYPE=LEAF

!!! note

    The `VERSION` variable is used to select the Minecraft version to run.  
    To specify a particular Leaf build, use `LEAF_BUILD`.  

By default the latest build will be used; however, a specific build number can be selected by setting `LEAF_BUILD`, such as

    -e VERSION=1.21.4 -e LEAF_BUILD=441

### Folia

A [Folia server](https://papermc.io/software/folia) can be used by setting the environment variable `TYPE` to "FOLIA".

By default, the container will run the latest experimental build of [Folia server](https://papermc.io/downloads), but you can also choose to run a specific build with `-e FOLIABUILD=26`. The release channel can be changed with the variable `FOLIA_CHANNEL`; however, only experimental builds are available at this time.

!!! example

    Using `docker run`
    
    ```
    docker run -d -v /path/on/host:/data \
        -e TYPE=FOLIA \
        -p 25565:25565 -e EULA=TRUE --name mc itzg/minecraft-server
    ```

If you are hosting your own copy of Folia you can override the download URL with `FOLIA_DOWNLOAD_URL=<url>`.

If you have attached a host directory to the `/data` volume, then you can install plugins via the `plugins` subdirectory. You can also [attach a `/plugins` volume](../../mods-and-plugins/index.md#optional-plugins-mods-and-config-attach-points). If you add plugins while the container is running, you'll need to restart it to pick those up.

[You can also auto-download plugins using `SPIGET_RESOURCES`.](../../mods-and-plugins/spiget.md)

!!! note
    The Folia type inherits from the Paper type. Paper's variables will override the Folia ones.
