# Server Types and Mod Platforms

Server types can be selected by setting the `TYPE` environment variable to one of the types described in these sections.

The default server type is [the official software provided by Mojang](https://www.minecraft.net/en-us/download/server), which can be explicitly selected by setting `TYPE` to "VANILLA".

**From the sections to the left...**

The **mod platforms** take a modpack identifier, file, etc and use that to select and download the appropriate version of a mod loader, such as Forge or Fabric, downloading declared mods/plugins, and apply any additional files. The mod platforms are selected by setting `MOD_PLATFORM`; however, for ease of use and compatibility, the selection can be set in `TYPE`.

The individual **server types** allow for selecting the mod loader / server type and specific versions of those. 

!!! important
    For all the server types, the `VERSION` environment variable is used to declare the Minecraft version itself, such as 1.19.4. Each server type will have specific variables for qualifying their version in addition to the Minecraft version.
