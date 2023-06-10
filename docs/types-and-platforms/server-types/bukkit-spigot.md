# Bukkit/Spigot

Enable Bukkit/Spigot server mode by adding a `-e TYPE=BUKKIT` or `-e TYPE=SPIGOT` to your command-line.

```
docker run -d -v /path/on/host:/data \
    -e TYPE=SPIGOT \
    -p 25565:25565 -e EULA=TRUE --name mc itzg/minecraft-server
```

If the downloaded server jar is corrupted, set `FORCE_REDOWNLOAD` to "true" to force a re-download during next container startup. After successfully re-downloading, you should remove that or set to "false".

If you are hosting your own copy of Bukkit/Spigot you can override the download URLs with:

- -e BUKKIT_DOWNLOAD_URL=<url>
- -e SPIGOT_DOWNLOAD_URL=<url>

You can build spigot from source by adding `-e BUILD_FROM_SOURCE=true`

Plugins can either be managed within the `plugins` subdirectory of the [data directory](../../data-directory.md) or you can also [attach a `/plugins` volume](../../mods-and-plugins/index.md#optional-plugins-mods-and-config-attach-points). If you add plugins while the container is running, you'll need to restart it to pick those up.

[You can also auto-download plugins using `SPIGET_RESOURCES`.](../../mods-and-plugins/spiget.md)

!!! note

    Some of the `VERSION` values are not as intuitive as you would think, so make sure to click into the version entry to find the **exact** version needed for the download. For example, "1.8" is not sufficient since their download naming expects `1.8-R0.1-SNAPSHOT-latest` exactly.

## Alternatives

### Canyon

[Canyon](https://github.com/canyonmodded/canyon) is a fork of CraftBukkit for Minecraft Beta 1.7.3. It includes multiple enhancements whilst also retaining compatibility with old Bukkit plugins and mods as much as possible.

    -e VERSION=b1.7.3 -e TYPE=CANYON

!!! important
    Only `VERSION=b1.7.3` is supported. Since that version pre-dates the health check mechanism used by this image, that will need to be disabled by setting `DISABLE_HEALTHCHECK=true`.

Canyon is on a temporary hiatus, so by default the final build from GitHub will be used; however, a specific build number can be selected in some instances by setting `CANYON_BUILD`, such as

    -e CANYON_BUILD=6
    -e CANYON_BUILD=26
