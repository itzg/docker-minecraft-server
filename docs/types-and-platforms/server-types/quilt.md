Enable [Quilt server](https://quiltmc.org/) mode by adding a `-e TYPE=QUILT` to your command-line.

```
docker run -d -v /path/on/host:/data \
    -e TYPE=QUILT \
    -p 25565:25565 -e EULA=TRUE --name mc itzg/minecraft-server
```

By default, the container will install the latest [quilt server launcher](https://quiltmc.org/install/server/), using the latest [quilt-installer](https://github.com/QuiltMC/quilt-installer) against the minecraft version you have defined with `VERSION` (defaulting to the latest vanilla release of the game).

A specific loader or installer version other than the latest can be requested using `QUILT_LOADER_VERSION` and `QUILT_INSTALLER_VERSION` respectively, such as:

```
docker run -d -v /path/on/host:/data ... \
    -e TYPE=QUILT \
    -e QUILT_LOADER_VERSION=0.16.0 \
    -e QUILT_INSTALLER_VERSION=0.4.1
```

!!! note

    If you wish to use an alternative launcher you can: 

    - Provide the path to a custom launcher jar available to the container with `QUILT_LAUNCHER`, relative to `/data` (such as `-e QUILT_LAUNCHER=quilt-server-custom.jar`)
    - Provide the URL to a custom launcher jar with `QUILT_LAUNCHER_URL` (such as `-e QUILT_LAUNCHER_URL=http://HOST/quilt-server-custom.jar`)

See the [Working with mods and plugins](../../mods-and-plugins/index.md) section to set up Quilt mods and configuration.
