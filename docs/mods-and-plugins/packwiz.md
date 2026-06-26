# Packwiz Modpacks

[packwiz](https://packwiz.infra.link/) is a CLI tool for maintaining and providing modpack definitions, with support for both CurseForge and Modrinth as sources. See the [packwiz tutorial](https://packwiz.infra.link/tutorials/getting-started/) for more information.

To configure server mods using a packwiz modpack, set the `PACKWIZ_URL` environment variable to the location of your `pack.toml` modpack definition:

```
docker run -d --pull=always \
    -v /path/on/host:/data -e TYPE=FABRIC \
    -e "PACKWIZ_URL=https://example.com/modpack/pack.toml" \
    itzg/minecraft-server
```

packwiz modpack definitions are processed before other mod definitions (`MODPACK`, `MODS`, etc.) to allow for additional processing/overrides you may want to perform (in case of mods not available via Modrinth/CurseForge, or you do not maintain the pack).

If the pack ships a `.env` file that you reference with `LOAD_ENV_FROM_FILE`, that file is re-loaded immediately after the packwiz installer runs, so the freshly downloaded values are applied to the remaining startup stages. Note that `TYPE` and `VERSION` are resolved earlier (before the deploy is dispatched), so a pack-provided `.env` cannot change those from within packwiz; use `LOAD_ENV_FROM_GENERIC_PACK` or `LOAD_ENV_FROM_ARCHIVE` for those.

!!! note 

    packwiz is pre-configured to only download server mods. If client-side mods are downloaded and cause issues, check your pack.toml configuration, and make sure any client-only mods are not set to `"both"`, but rather `"client"` for the side configuration item.
