

### Magma

A [Magma](https://magmafoundation.org/) server, which is a combination of Forge and PaperMC, can be used with

    -e TYPE=MAGMA

!!! note

    The Magma project has been terminated ([original link died](https://git.magmafoundation.org/magmafoundation/magma-1-20-x/-/commit/4e7abe37403c47d09b74b77bcfc26a19b18f5891), [alternate statement on their discord](https://discord.com/channels/612695539729039411/647287352833605662/1174412642962649198) ). Please use Magma Maintained for 1.12.2, 1.18.2 and 1.19.3, or Ketting for 1.20.1+.

    There are limited base versions supported, so you will also need to  set `VERSION`, such as "1.12.2", "1.16.5", etc.

### Magma Maintained
A [Magma Maintained](https://github.com/magmamaintained/) server, which is a alternative project of Magma, can be used with

    -e TYPE=MAGMA_MAINTAINED

!!! note

    There are limited base versions supported, so you will also need to set `VERSION`, such as "1.12.2", "1.18.2", "1.19.3", or "1.20.1".

    In addition, `FORGE_VERSION` and `MAGMA_MAINTAINED_TAG` must be specified. You can find the supported `FORGE_VERSION` and `MAGMA_MAINTAINED_TAG` in a releases page for each repositories.

### Ketting

A [Ketting](https://github.com/kettingpowered/Ketting-1-20-x) server, which is an alternative project of Magma 1.20.1+, can be used with

    -e TYPE=KETTING

There are limited base versions supported, so you will also need to  set `VERSION`, such as "1.20.1" or later.

`FORGE_VERSION` and `KETTING_VERSION` may be specified; however, they will be defaulted by the [Ketting launcher](https://github.com/kettingpowered/kettinglauncher) otherwise.
Available Ketting Versions may be found at [https://reposilite.c0d3m4513r.com/#/Ketting-Server-Releases/org/kettingpowered/server/forge](https://reposilite.c0d3m4513r.com/#/Ketting-Server-Releases/org/kettingpowered/server/forge).
The Version structure is `MinecraftVersion-ForgeVersion-KettingVersion` (e.g. `1.20.1-47.2.20-0.1.4` is for Minecraft `1.20.1`, Forge `47.2.20` and Ketting `0.1.4`).

### Mohist

A [Mohist](https://github.com/MohistMC/Mohist) server can be used with

    -e TYPE=MOHIST

!!! note

    There are limited base versions supported, so you will also need to  set `VERSION`, such as "1.12.2"

By default the latest build will be used; however, a specific build number can be selected by setting `MOHIST_BUILD`, such as

    -e VERSION=1.16.5 -e MOHIST_BUILD=374

### Youer

A [Youer](https://github.com/MohistMC/Youer) server can be used with

    -e TYPE=YOUER

!!! note

    There are limited base versions supported, so you will also need to  set `VERSION`, such as "1.12.2"

By default the latest build will be used; however, a specific build number can be selected by setting `MOHIST_BUILD`, such as

    -e VERSION=1.16.5 -e MOHIST_BUILD=374

### Banner

A [Banner](https://github.com/MohistMC/Banner) server can be used with

    -e TYPE=BANNER

!!! note

    There are limited base versions supported, so you will also need to  set `VERSION`, such as "1.12.2"

By default the latest build will be used; however, a specific build number can be selected by setting `MOHIST_BUILD`, such as

    -e VERSION=1.16.5 -e MOHIST_BUILD=374

### Catserver

A [Catserver](http://catserver.moe/) type server can be used with

    -e TYPE=CATSERVER

> **NOTE** Catserver only provides a single release stream, so `VERSION` is ignored

### Arclight

A [Arclight](https://arclight.izzel.io/) type server can be used with

    -e TYPE=ARCLIGHT
    -e ARCLIGHT_TYPE=NEOFORGE,FORGE,FABRIC
