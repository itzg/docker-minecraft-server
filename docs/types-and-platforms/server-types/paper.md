Enable Paper server mode by adding a `-e TYPE=PAPER` to your command-line.

By default, the container will run the latest build of [Paper server](https://papermc.io/downloads) but you can also choose to run a specific build with `-e PAPERBUILD=205`.

    docker run -d -v /path/on/host:/data \
        -e TYPE=PAPER \
        -p 25565:25565 -e EULA=TRUE --name mc itzg/minecraft-server

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

### Folia

Enable Folia server mode by adding a `-e TYPE=FOLIA` to your command-line.

By default, the container will run the latest build of [Folia server](https://papermc.io/downloads), but you can also choose to run a specific build with `-e FOLIABUILD=26`.

    docker run -d -v /path/on/host:/data \
        -e TYPE=FOLIA \
        -p 25565:25565 -e EULA=TRUE --name mc itzg/minecraft-server

If you are hosting your own copy of Folia you can override the download URL with `FOLIA_DOWNLOAD_URL=<url>`.

If you have attached a host directory to the `/data` volume, then you can install plugins via the `plugins` subdirectory. You can also [attach a `/plugins` volume](../../mods-and-plugins/index.md#optional-plugins-mods-and-config-attach-points). If you add plugins while the container is running, you'll need to restart it to pick those up.

[You can also auto-download plugins using `SPIGET_RESOURCES`.](../../mods-and-plugins/spiget.md)

!!! note
    The Folia type inherits from the Paper type. Paper's variables will override the Folia ones.
