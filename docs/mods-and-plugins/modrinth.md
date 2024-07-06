# Auto-download from Modrinth

[Modrinth](https://modrinth.com/) is an open source modding platform with a clean, easy to use website for finding [Fabric and Forge mods](https://modrinth.com/mods). At startup, the container will automatically locate and download the newest versions of mod/plugin files that correspond to the `TYPE` and `VERSION` in use. Older file versions downloaded previously will automatically be cleaned up.

- **MODRINTH_PROJECTS** : comma or newline separated list of project slugs (short name) or IDs. The project ID is located in the "Technical information" section. The slug is the part of the page URL that follows `/mod/`:
  ```
    https://modrinth.com/mod/fabric-api
                             ----------
                              |
                              +-- project slug
  ```
  Also, a specific version/type can be declared using colon symbol and version id/type after the project slug. The version id can be found in the 'Metadata' section. Valid version types are `release`, `beta`, `alpha`.

!!! example
        
    | Description                     | Example               |
    |---------------------------------|-----------------------|
    | Select latest version           | `fabric-api`          |
    | Select specific version         | `fabric-api:PbVeub96` |
    | Select latest beta version      | `fabric-api:beta`     |
    | Latest version using project ID | `P7dR8mSH`            |

## Extra options

`MODRINTH_DOWNLOAD_DEPENDENCIES`
: Can be set to `none` (the default), `required`, or `optional` to download required and/or optional dependencies.

`MODRINTH_ALLOWED_VERSION_TYPE`
: The version type is used to determine the newest version to use from each project. The allowed values are `release` (default), `beta`, `alpha`. Setting to `beta` will pick up both release and beta versions. Setting to `alpha` will pick up release, beta, and alpha versions.

