# Auto-download using Spiget

The `SPIGET_RESOURCES` variable can be set with a comma-separated list of SpigotMC resource IDs to automatically download [Spigot/Bukkit/Paper plugins](https://www.spigotmc.org/resources/) using [the spiget API](https://spiget.org/). Resources that are zip files will be expanded into the plugins directory and resources that are simply jar files will be moved there.

!!! important "SPIGET not SPIGOT"
    The variable is purposely spelled SPIG**E**T with an "E"

The **resource ID** can be located from the numerical part of the URL after the shortname/slug and a dot. For example, the ID is **28140** from

    https://www.spigotmc.org/resources/luckperms.28140/
                                                 =====

For example, the following will auto-download the [LuckPerms](https://www.spigotmc.org/resources/luckperms.28140/) and [Vault](https://www.spigotmc.org/resources/vault.34315/) plugins:

    -e SPIGET_RESOURCES=28140,34315

!!! note
    Some plugins, such as EssentialsX (resource ID 9089), do not permit automated downloads via Spiget. Instead, you will need to pre-download the desired file and supply it to the container, such as using the `/plugins` mount point, described [in the main section](index.md).

