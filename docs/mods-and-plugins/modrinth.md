# Auto-download from Modrinth

[Modrinth](https://modrinth.com/) is an open source modding platform with a clean, easy to use website for finding [Fabric, Forge, etc mods](https://modrinth.com/mods) and [Paper, etc plugins](https://modrinth.com/plugins), and [datapacks](https://modrinth.com/datapacks). At startup, the container will automatically locate and download the newest versions of mod/plugin files that correspond to the `TYPE` and `VERSION` in use. Older file versions downloaded previously will automatically be cleaned up.

## Usage

To use this feature, set the environment variable `MODRINTH_PROJECTS` to a comma or newline separated list of project slugs (short name) or IDs.  

!!! tip "Project ID"

    The project ID can be copied to the clipboard from the project page menu:

    ![Modrinth copy project ID](../img/modrinth-copy-project-id.png)

!!! tip "Project Slug"

    The project slug is the part of the URL that follows `/mod/`, `/plugin/`, or `/datapack/`. For example:
    
    ```
    https://modrinth.com/mod/fabric-api
                             ----------
                              |
                              +-- project slug
    ```

Also, a specific version (or release type) can be declared by adding a colon and then the version id, version number/name, or release type after the project slug. The version ID or number can be found in the 'Metadata' section. Valid release types are `release`, `beta`, `alpha`.

To select a datapack from a Modrinth project, prefix the entry with "datapack:". When running a vanilla server, this is optional since only datapacks will be available for vanilla servers to select.

You can also reference a file containing project entries by prefixing the **container path** path with `@`.

### Examples
            
| Description                     | Example projects entry                                |
|---------------------------------|-------------------------------------------------------|
| Select latest version           | `fabric-api`                                          |
| Select specific version         | `fabric-api:bQZpGIz0`<br/>`fabric-api:0.119.2+1.21.4` |
| Select latest beta version      | `fabric-api:beta`                                     |
| Latest version using project ID | `P7dR8mSH`                                            |
| Latest version of datapack      | `datapack:terralith`                                  |
| Specific version of datapack    | `datapack:terralith:2.5.5`                            |
| Projects Listing File           | `@/path/to/modrinth-mods.txt`                         |

### Notes

!!! info "More about listing files"

    Each line in the listing file is processed as one of the references above; however, blank lines and comments that start with `#` are ignored.
    
    Make sure to place the listing file in a mounted directory/volume or declare an appropriate mount for it.
    
    For example, `MODRINTH_PROJECTS` can be set to "@/extras/modrinth-mods.txt", assuming "/extras" has been added to `volumes` section, where the container file `/extras/modrinth-mods.txt` contains
    
    ```text
    # This comment is ignored
    fabric-api
    
    # This and previous blank line are ignore
    cloth-config
    datapack:terralith
    ```

!!! note "Auto-removal"

    Entries that are removed from the `MODRINTH_PROJECTS` list will be automatically removed from the `mods` or `plugins` directory. This is useful for removing mods/plugins that are no longer needed. An empty `MODRINTH_PROJECTS` list will remove all mods/plugins.

!!! note "Disable processing"

    To temporarily disable processing of the `MODRINTH_PROJECTS` list, then comment out the `MODRINTH_PROJECTS` environment variable.

## Version from Projects

When the environment variable `VERSION_FROM_MODRINTH_PROJECTS` is set to "true" the Minecraft [`VERSION`](../versions/minecraft.md) will be automatically determined by looking at the most recent version of Minecraft that is supported by all the projects provided in `MODRINTH_PROJECTS`.

!!! example

    Given the environment variables
    
    ```yaml
        MODRINTH_PROJECTS: |
          viaversion
          viabackwards
          griefprevention
          discordsrv
        VERSION_FROM_MODRINTH_PROJECTS: true
    ```
    
    Let's say all are supported on Minecraft up to 1.21.8 except griefprevention, which is only supported up to 1.21.7. In that case, `VERSION` will be automatically set to 1.21.7.

## Extra options

`MODRINTH_DOWNLOAD_DEPENDENCIES`
: Can be set to `none` (the default), `required`, or `optional` to download required and/or optional dependencies.

`MODRINTH_PROJECTS_DEFAULT_VERSION_TYPE`
: The version type is used to determine the newest version to use from each project. The allowed values are `release` (default), `beta`, `alpha`. Setting to `beta` will pick up both release and beta versions. Setting to `alpha` will pick up release, beta, and alpha versions.

`MODRINTH_LOADER`
: When using a custom server, set this to specify which loader type will be requested during lookups

