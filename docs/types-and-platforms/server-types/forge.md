Enable [Forge server](http://www.minecraftforge.net/) mode by adding a `-e TYPE=FORGE` to your command-line.

The overall version is specified by `VERSION`, [as described in the section above](../../versions/minecraft.md) and will run the recommended Forge version by default. You can also choose to run a specific Forge version with `FORGE_VERSION`, such as `-e FORGE_VERSION=14.23.5.2854`.

```
docker run -d -v /path/on/host:/data \
    -e TYPE=FORGE \
    -e VERSION=1.12.2 -e FORGE_VERSION=14.23.5.2854 \
    -p 25565:25565 -e EULA=TRUE --name mc itzg/minecraft-server
```

To use a pre-downloaded Forge installer, place it in the attached `/data` directory and
specify the name of the installer file with `FORGE_INSTALLER`, such as:

```
docker run -d -v /path/on/host:/data ... \
    -e FORGE_INSTALLER=forge-1.11.2-13.20.0.2228-installer.jar ...
```

To download a Forge installer from a custom location, such as your own file repository, specify
the URL with `FORGE_INSTALLER_URL`, such as:

```
docker run -d -v /path/on/host:/data ... \
    -e FORGE_INSTALLER_URL=http://HOST/forge-1.11.2-13.20.0.2228-installer.jar ...
```

In both of the cases above, there is no need for the `VERSION` or `FORGEVERSION` variables.

!!! note

    If an error occurred while installing Forge, it might be possible to resolve by temporarily setting `FORGE_FORCE_REINSTALL` to "true". Be sure to remove that variable after successfully starting the server.
