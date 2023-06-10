# Feed the Beast

!!! note
    Requires one of the Ubuntu with Hotspot images listed in [the Java versions section](../../versions/java.md).

[Feed the Beast application](https://www.feed-the-beast.com/) modpacks are supported by setting `MOD_PLATFORM` or `TYPE` to "FTBA"

!!! note
    The "A" at the end of "FTBA" is important. The value "FTB" used to be an alias for "CURSEFORGE".

This mod platform type will automatically take care of downloading and installing the modpack and appropriate version of Forge, so the `VERSION` does not need to be specified.

### Environment Variables:
- `FTB_MODPACK_ID`: **required**, the numerical ID of the modpack to install. The ID can be located by [finding the modpack](https://www.feed-the-beast.com/modpack) and locating the ID in this part of the URL:

  ```
  https://www.feed-the-beast.com/modpacks/23-ftb-infinity-evolved-17
                                          ^^
  ```
- `FTB_MODPACK_VERSION_ID`: optional, the numerical ID of the version to install. If not specified, the latest version will be installed. The "Version ID" can be obtained by hovering over a server file entry and grabbing [this ID in the URL](../../img/ftba-version-id-popup.png).

### Upgrading

If a specific `FTB_MODPACK_VERSION_ID` was not specified, simply restart the container to pick up the newest modpack version. If using a specific version ID, recreate the container with the new version ID.

### Example

The following example runs the latest version of [FTB Presents Direwolf20 1.12](https://ftb.neptunepowered.org/pack/ftb-presents-direwolf20-1-12/):

``` shell
docker run -d --name mc-ftb -e EULA=TRUE \
  -e TYPE=FTBA -e FTB_MODPACK_ID=31 \
  -p 25565:25565 \
  itzg/minecraft-server:java8-multiarch
```

!!! note

    Normally you will also add `-v` volume for `/data` since the mods and config are installed there along with world data.
