Enable [Forge server](http://www.minecraftforge.net/) mode by adding a `-e TYPE=FORGE` to your command-line.

The overall version is specified by `VERSION`, [as described in the section above](../../versions/minecraft.md). By default, the recommended version of Forge for that Minecraft version will be selected. The latest version can be selected instead by setting the environment variable `FORGE_VERSION` to "latest". You can also choose a specific Forge version by setting `FORGE_VERSION` with that version, such as "14.23.5.2854".

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
