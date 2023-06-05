# Forge API

## ForgeAPI usage to use non-version specific projects

!!! warning "Deprecated"
    This approach will soon be deprecated in favor of a variation of `AUTO_CURSEFORGE`.

!!! warning
    This potentially could lead to unexpected behavior if the Mod receives an update with unexpected behavior.

This is more complicated because you will be pulling/using the latest mod for the release of your game. To get started make sure you have a [CursedForge API Key](https://docs.curseforge.com/#getting-started). Then use the environmental parameters in your docker build.

Please be aware of the following when using these options for your mods:
* Mod Release types: Release, Beta, and Alpha.
* Mod dependencies: Required and Optional
* Mod family: Fabric, Forge, and Bukkit.

Parameters to use the ForgeAPI:

* `MODS_FORGEAPI_KEY` - Required
* `MODS_FORGEAPI_FILE` - Required or use MODS_FORGEAPI_PROJECTIDS (Overrides MODS_FORGEAPI_PROJECTIDS)
* `MODS_FORGEAPI_PROJECTIDS` - Required or use MODS_FORGEAPI_FILE
* `MODS_FORGEAPI_RELEASES` - Default is release, Options: [Release|Beta|Alpha]
* `MODS_FORGEAPI_DOWNLOAD_DEPENDENCIES` - Default is False, attempts to download required mods (releaseType Release) defined in Forge.
* `MODS_FORGEAPI_IGNORE_GAMETYPE` - Default is False, Allows for filtering mods on family type: FORGE, FABRIC, and BUKKIT. (Does not filter for Vanilla or custom)
* `REMOVE_OLD_FORGEAPI_MODS` - Default is False
* `REMOVE_OLD_DATAPACKS_DEPTH` - Default is 1
* `REMOVE_OLD_DATAPACKS_INCLUDE` - Default is *.jar

Example of expected forge api project ids, releases, and key:

```yaml
  MODS_FORGEAPI_PROJECTIDS: 306612,256717
  MODS_FORGEAPI_RELEASES: Release
  MODS_FORGEAPI_KEY: $WRX...
```

Example of expected ForgeAPI file format.

**Field Description**:
* `name` is currently unused, but can be used to document each entry.
* `projectId` id is the id found on the CurseForge website for a particular mod
* `releaseType` Type corresponds to forge's R, B, A icon for each file. Default Release, options are (release|beta|alpha).
* `fileName` is used for version pinning if latest file will not work for you.

```json
[
  {
      "name": "fabric api",
      "projectId": "306612",
      "releaseType": "release"
  },
  {
      "name": "fabric voice mod",
      "projectId": "416089",
      "releaseType": "beta"
  },
  {
      "name": "Biomes o plenty",
      "projectId": "220318",
      "fileName": "BiomesOPlenty-1.18.1-15.0.0.100-universal.jar",
      "releaseType": "release"
  }
]
```
