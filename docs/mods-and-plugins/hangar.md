# Auto-download from Hangar

[Hangar](https://hangar.papermc.io/) is PaperMC's plugin repository for [Paper](../types-and-platforms/server-types/paper.md) and its derivatives. At startup, the container will automatically locate and download the newest version of each plugin that supports the `VERSION` in use. Older file versions downloaded previously will automatically be cleaned up.

## Usage

To use this feature, set the environment variable `HANGAR_PROJECTS` to a comma or newline separated list of projects. This is supported when `TYPE` is `PAPER`, `FOLIA`, `PURPUR`, `PUFFERFISH`, or `LEAF`.

Each project entry can be any of the following combinations where a colon (`:`) is used to separate the different parts:

```
Project
Project : Version
@ Listing File
```

Where:

- **Project** is the project slug or ID. The slug is the last part of the project page URL, such as "Maintenance" from <https://hangar.papermc.io/kennytv/Maintenance>
- **Version** is the version name, such as "5.1.1". When omitted, the newest version from the channel given by `HANGAR_CHANNEL` that supports the Minecraft `VERSION` is selected. Selecting a specific version skips the Minecraft version check.
- **Listing file** is a container path to a file containing a list of projects

Append a `?` to a project, such as `Maintenance?`, to mark it as optional. An optional project that is not available is skipped with a warning instead of failing the startup.

By default, the newest version from the "Release" channel will be selected. You can instead choose another channel by setting `HANGAR_CHANNEL`, such as "Snapshot". The channels of a project are listed on its versions page.

!!! note "External downloads"

    Some projects, such as [Floodgate](https://hangar.papermc.io/GeyserMC/Floodgate), link to a file hosted outside of Hangar. That file is downloaded from the external location and is downloaded again when the external file has been modified.

### Example

```yaml
    environment:
      TYPE: PAPER
      HANGAR_PROJECTS: |
        ViaVersion
        Maintenance:5.1.1
```
