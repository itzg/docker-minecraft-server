A [Forge server](http://www.minecraftforge.net/) can be automatically downloaded, upgraded, and run by setting the environment variable `TYPE` to "FORGE".

!!! note "A note from the installer"

    > Please do not automate the download and installation of Forge.
    Our efforts are supported by ads from the download page.
    If you MUST automate this, please consider supporting the project through <https://www.patreon.com/LexManos/>

    Since my project also relies on donations, please pass it along and consider contributing to the Patreon above.

!!! example

    ```
    docker run -e TYPE=FORGE ...
    ```
    
    or in a compose file
    ```yaml
        environment:
          TYPE: FORGE
    ```

The overall version is specified by `VERSION`, [as described in the section above](../../versions/minecraft.md) and provides the same benefits of upgrading as new versions are released. By default, the recommended version of Forge for that Minecraft version will be selected. The latest version can be selected instead by setting the environment variable `FORGE_VERSION` to "latest". You can also choose a specific Forge version by setting `FORGE_VERSION` with that version, such as "14.23.5.2854".


!!! example

    ```
    docker run -e TYPE=FORGE -e VERSION=1.12.2 -e FORGE_VERSION=14.23.5.2854 ...
    ```
    
    or in a compose file
    ```yaml
        environment:
          TYPE: FORGE
          VERSION: "1.12.2"
          FORGE_VERSION: "14.23.5.2854"
    ```

To use a pre-downloaded Forge installer, place it in a location mounted into the container and specify the container path with `FORGE_INSTALLER`. To download a Forge installer from a custom location, such as your own file repository, specify the URL with `FORGE_INSTALLER_URL`.

In both of the cases above, there is no need for the `VERSION` or `FORGE_VERSION` variables.

!!! note

    If an error occurred while installing Forge, it might be possible to resolve by temporarily setting `FORGE_FORCE_REINSTALL` to "true". Be sure to remove that variable after successfully starting the server.

## Alternatives

### NeoForge

Support for [NeoForge](https://neoforged.net/) is also provided. A NeoForge server can be automatically managed by setting `TYPE` to "NEOFORGE". `VERSION` specifies the Minecraft version and `NEOFORGE_VERSION` can be set to select a specific version, "latest", or "beta". By default, the latest, non-beta NeoForge version available for the requested Minecraft version will be used.

!!! example

    ```
    docker run -e TYPE=NEOFORGE -e VERSION=1.20.1 -e NEOFORGE_VERSION=47.1.79 ...
    ```
    
    or in a compose file
    ```yaml
        environment:
          TYPE: NEOFORGE
          VERSION: "1.20.4"
          NEOFORGE_VERSION: "beta"
    ```

### Cleanroom

[Cleanroom](https://github.com/CleanroomMC/Cleanroom) isn't fully automated, but can be utilized by...

1. choose the desired release at https://github.com/CleanroomMC/Cleanroom/releases
2. grab the link to the `*-installer.jar` file in that release
3. with `TYPE` set to "FORGE", set `FORGE_INSTALLER_URL` to the installer jar's link

!!! example

    In docker compose `environment`
    
    ```yaml
      TYPE: FORGE
      FORGE_INSTALLER_URL: https://github.com/CleanroomMC/Cleanroom/releases/download/0.2.4-alpha/cleanroom-0.2.4-alpha-installer.jar
    ```
    
    [Full example](https://github.com/itzg/docker-minecraft-server/tree/master/examples/cleanroom)