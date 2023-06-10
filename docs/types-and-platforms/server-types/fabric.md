Enable [Fabric server](https://fabricmc.net/) mode by adding a `-e TYPE=FABRIC` to your command-line.

```
docker run -d -v /path/on/host:/data \
    -e TYPE=FABRIC \
    -p 25565:25565 -e EULA=TRUE --name mc itzg/minecraft-server
```

By default, the container will install the latest [fabric server launcher](https://fabricmc.net/use/server/), using the latest [fabric-loader](https://fabricmc.net/wiki/documentation:fabric_loader) against the minecraft version you have defined with `VERSION` (defaulting to the latest vanilla release of the game).

A specific loader or launcher version other than the latest can be requested using `FABRIC_LOADER_VERSION` and `FABRIC_LAUNCHER_VERSION` respectively, such as:

```
docker run -d -v /path/on/host:/data ... \
    -e TYPE=FABRIC \
    -e FABRIC_LAUNCHER_VERSION=0.10.2 \
    -e FABRIC_LOADER_VERSION=0.13.1
```

!!! note

    If you wish to use an alternative launcher you can:  

    - Provide the path to a custom launcher jar available to the container with `FABRIC_LAUNCHER`, relative to `/data` (such as `-e FABRIC_LAUNCHER=fabric-server-custom.jar`)
    - Provide the URL to a custom launcher jar with `FABRIC_LAUNCHER_URL` (such as `-e FABRIC_LAUNCHER_URL=http://HOST/fabric-server-custom.jar`)

See the [Working with mods and plugins](../../mods-and-plugins/index.md) section to set up Fabric mods and configuration.
