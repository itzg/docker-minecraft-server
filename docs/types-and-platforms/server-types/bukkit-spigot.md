# Bukkit/Spigot

!!! failure "GetBukkit site no longer supports automated downloads"

    The downloads provider <https://getbukkit.org> seems to no longer support automated downloads. As such, it is highly recommended to switch to [Paper](paper.md) instead since it is actively maintained and fully compatible with Bukkit/Spigot plugins.

Run a Bukkit/Spigot server type by setting the environment variable `TYPE` to "BUKKIT" or "SPIGOT".

!!! example

    Command-line
    ```
    docker run ... -e TYPE=SPIGOT ...
    ```

    Compose
    ```yaml
        environment:
          ...
          TYPE: SPIGOT
    ```

If the downloaded server jar is corrupted, set `FORCE_REDOWNLOAD` to "true" to force a re-download during next container startup. After successfully re-downloading, you should remove that or set to "false".

If you are hosting your own copy of Bukkit/Spigot you can override the download URLs with:

- -e BUKKIT_DOWNLOAD_URL=<url>
- -e SPIGOT_DOWNLOAD_URL=<url>

!!! note

    Some of the `VERSION` values are not as intuitive as you would think, so make sure to click into the version entry to find the **exact** version needed for the download. For example, "1.8" is not sufficient since their download naming expects `1.8-R0.1-SNAPSHOT-latest` exactly.

## Build from source

You can build spigot from source by setting the environment variable `BUILD_FROM_SOURCE` to "true".

## Alternatives

### Canyon

[Canyon](https://github.com/canyonmodded/canyon) is a fork of CraftBukkit for Minecraft Beta 1.7.3. It includes multiple enhancements whilst also retaining compatibility with old Bukkit plugins and mods as much as possible.

    -e VERSION=b1.7.3 -e TYPE=CANYON

!!! important
    Only `VERSION=b1.7.3` is supported. Since that version pre-dates the health check mechanism used by this image, that will need to be disabled by setting `DISABLE_HEALTHCHECK=true`.

Canyon is on a temporary hiatus, so by default the final build from GitHub will be used; however, a specific build number can be selected in some instances by setting `CANYON_BUILD`, such as

    -e CANYON_BUILD=6
    -e CANYON_BUILD=26

### Poseidon

[Poseidon](https://github.com/retromcorg/Project-Poseidon) is a fork of CraftBukkit for Minecraft Beta 1.7.3. It includes multiple enhancements whilst also retaining compatibility with old Bukkit plugins.

    -e VERSION=b1.7.3 -e TYPE=CANYON

!!! important
    Only `VERSION=b1.7.3` is supported. Since that version pre-dates the health check mechanism used by this image, that will need to be disabled by setting `DISABLE_HEALTHCHECK=true`.

### Uberbukkit

[Uberbukkit](https://github.com/Moresteck/uberbukkit) is a fork of CraftBukkit for Minecraft Beta with Multi version support, supports b1.0 - b1.7.3
