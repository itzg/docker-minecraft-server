A [Fabric server](https://fabricmc.net/) can be automatically downloaded, upgraded, and run by setting the environment variable TYPE to "FABRIC"

!!! example

    Using `docker run` command line

    ```
    docker run -d -e EULA=TRUE -e TYPE=FABRIC -p 25565:25565 itzg/minecraft-server
    ```
    
    In a compose file service:
    
    ```yaml
    environment:
      EULA: TRUE
      TYPE: FABRIC
    ```

By default, the container will install the latest [fabric server launcher](https://fabricmc.net/use/server/), using the latest [fabric-loader](https://fabricmc.net/wiki/documentation:fabric_loader) against the minecraft version you have defined with `VERSION` (defaulting to the latest vanilla release of the game).

A specific loader or launcher version other than the latest can be requested using `FABRIC_LOADER_VERSION` and `FABRIC_LAUNCHER_VERSION` respectively, such as:

!!! example "Using launcher and loader versions"

    With docker run

    ```
    docker run -d ... \
        -e TYPE=FABRIC \
        -e FABRIC_LAUNCHER_VERSION=0.10.2 \
        -e FABRIC_LOADER_VERSION=0.13.1
    ```
    
    In a compose file service:
    
    ```yaml
    environment:
      EULA: TRUE
      TYPE: FABRIC
      FABRIC_LAUNCHER_VERSION: 0.10.2
      FABRIC_LOADER_VERSION: 0.13.1
    ```

!!! note "Fabric API"

    As [mentioned on the Fabric download page](https://fabricmc.net/use/installer/), most mods will require the Fabric API mod to be installed. That can be easily done by utilizing [the Modrinth downloads feature](../../mods-and-plugins/modrinth.md), such as adding this to the `environment` of a compose file service:
    
    ```yaml
          TYPE: FABRIC
          MODRINTH_PROJECTS: |
            fabric-api
    ```

!!! note "Alternate launcher"

    If you wish to use an alternative launcher you can:  

    - Provide the path to a custom launcher jar available to the container with `FABRIC_LAUNCHER`, relative to `/data` (such as `-e FABRIC_LAUNCHER=fabric-server-custom.jar`)
    - Provide the URL to a custom launcher jar with `FABRIC_LAUNCHER_URL` (such as `-e FABRIC_LAUNCHER_URL=http://HOST/fabric-server-custom.jar`)

See the [Working with mods and plugins](../../mods-and-plugins/index.md) section to set up Fabric mods and configuration.
