[![Docker Pulls](https://img.shields.io/docker/pulls/itzg/minecraft-server.svg)](https://hub.docker.com/r/itzg/minecraft-server/)
[![Docker Stars](https://img.shields.io/docker/stars/itzg/minecraft-server.svg?maxAge=2592000)](https://hub.docker.com/r/itzg/minecraft-server/)
[![GitHub Issues](https://img.shields.io/github/issues-raw/itzg/docker-minecraft-server.svg)](https://github.com/itzg/docker-minecraft-server/issues)
[![Discord](https://img.shields.io/discord/660567679458869252)](https://discord.gg/DXfKpjB)
[![Build and Publish](https://github.com/itzg/docker-minecraft-server/workflows/Build%20and%20Publish/badge.svg)](https://github.com/itzg/docker-minecraft-server/actions)
[![](https://img.shields.io/badge/Donate-Buy%20me%20a%20coffee-orange.svg)](https://www.buymeacoffee.com/itzg)

This docker image provides a Minecraft Server that will automatically download the latest stable
version at startup. You can also run/upgrade to any specific version or the
latest snapshot. See the _Versions_ section below for more information.

To simply use the latest stable version, run

    docker run -d -p 25565:25565 --name mc itzg/minecraft-server

where the standard server port, 25565, will be exposed on your host machine.

If you want to serve up multiple Minecraft servers or just use an alternate port,
change the host-side port mapping such as

    docker run -p 25566:25565 ...

will serve your Minecraft server on your host's port 25566 since the `-p` syntax is
`host-port`:`container-port`.

Speaking of multiple servers, it's handy to give your containers explicit names using `--name`, such as

    docker run -d -p 25565:25565 --name mc itzg/minecraft-server

With that you can easily view the logs, stop, or re-start the container:

    docker logs -f mc
        ( Ctrl-C to exit logs action )

    docker stop mc

    docker start mc

## Looking for a Bedrock Dedicated Server

For Minecraft clients running on consoles, mobile, or native Windows, you'll need to
use this image instead:

[itzg/minecraft-bedrock-server](https://hub.docker.com/r/itzg/minecraft-bedrock-server)

## Interacting with the server

[RCON](http://wiki.vg/RCON) is enabled by default, so you can `exec` into the container to
access the Minecraft server console:

```
docker exec -i mc rcon-cli
```

Note: The `-i` is required for interactive use of rcon-cli.

To run a simple, one-shot command, such as stopping a Minecraft server, pass the command as
arguments to `rcon-cli`, such as:

```
docker exec mc rcon-cli stop
```

_The `-i` is not needed in this case._

In order to attach and interact with the Minecraft server, add `-it` when starting the container, such as

    docker run -d -it -p 25565:25565 --name mc itzg/minecraft-server

With that you can attach and interact at any time using

    docker attach mc

and then Control-p Control-q to **detach**.

For remote access, configure your Docker daemon to use a `tcp` socket (such as `-H tcp://0.0.0.0:2375`)
and attach from another machine:

    docker -H $HOST:2375 attach mc

Unless you're on a home/private LAN, you should [enable TLS access](https://docs.docker.com/articles/https/).

## EULA Support

Mojang now requires accepting the [Minecraft EULA](https://account.mojang.com/documents/minecraft_eula). To accept add

        -e EULA=TRUE

such as

        docker run -d -it -e EULA=TRUE -p 25565:25565 --name mc itzg/minecraft-server

## Timezone Configuration

You can configure the timezone to match yours by setting the `TZ` environment variable:

        -e TZ=Europe/London

such as:

        docker run -d -it -e TZ=Europe/London -p 25565:25565 --name mc itzg/minecraft-server

Or mounting `/etc/timezone` as readonly (not supported on Windows):

        -v /etc/timezone:/etc/timezone:ro

such as:

        docker run -d -it -v /etc/timezone:/etc/timezone:ro -p 25565:25565 --name mc itzg/minecraft-server

## Attaching data directory to host filesystem

In order to readily access the Minecraft data, use the `-v` argument
to map a directory on your host machine to the container's `/data` directory, such as:

    docker run -d -v /path/on/host:/data ...

When attached in this way you can stop the server, edit the configuration under your attached `/path/on/host`
and start the server again with `docker start CONTAINERID` to pick up the new configuration.

## Versions

To use a different Minecraft version, pass the `VERSION` environment variable, which can have the value

- LATEST (the default)
- SNAPSHOT
- or a specific version, such as "1.7.9"

For example, to use the latest snapshot:

    docker run -d -e VERSION=SNAPSHOT ...

or a specific version:

    docker run -d -e VERSION=1.7.9 ...

When using "LATEST" or "SNAPSHOT" an upgrade can be performed by simply restarting the container.
During the next startup, if a newer version is available from the respective release channel, then
the new server jar file is downloaded and used. _NOTE: over time you might see older versions of
the server jar remain in the `/data` directory. It is safe to remove those._

## Running Minecraft server on different Java version

To use a different version of Java, please use a docker tag to run your Minecraft server.

| Tag name       | Description                                 | Linux        |
| -------------- | ------------------------------------------- | ------------ |
| latest         | **Default**. Uses Java version 8 update 212 | Alpine Linux |
| adopt13        | Uses Java version 13 latest update          | Alpine Linux |
| adopt11        | Uses Java version 11 latest update          | Alpine Linux |
| openj9         | Uses Eclipse OpenJ9 JVM                     | Alpine Linux |
| openj9-nightly | Uses Eclipse OpenJ9 JVM testing builds      | Alpine Linux |
| multiarch      | Uses Java version 8 latest update           | Debian Linux |

For example, to use a Java version 13:

    docker run --name mc itzg/minecraft-server:adopt13

Keep in mind that some versions of Minecraft server can't work on the newest versions of Java. Also, FORGE doesn't support openj9 JVM implementation.

## Healthcheck

This image contains [mc-monitor](https://github.com/itzg/mc-monitor) and uses
its `status` command to continually check on the container's. That can be observed
from the `STATUS` column of `docker ps`

```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                    PORTS                                 NAMES
b418af073764        mc                  "/start"            43 seconds ago      Up 41 seconds (healthy)   0.0.0.0:25565->25565/tcp, 25575/tcp   mc
```

You can also query the container's health in a script friendly way:

```
> docker container inspect -f "{{.State.Health.Status}}" mc
healthy
```

## Autopause (experimental)

### Description

> EXPERIMENTAL: this feature only works with default bridge networking using official Docker distributions. Host networking and container management software, such as Portainer, and NAS solutions do not seem to provide compatible networking.

There are various bug reports on [Mojang](https://bugs.mojang.com) about high CPU usage of servers with newer versions, even with few or no clients connected (e.g. [this one](https://bugs.mojang.com/browse/MC-149018), in fact the functionality is based on [this comment in the thread](https://bugs.mojang.com/browse/MC-149018?focusedCommentId=593606&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel#comment-593606)).

An autopause functionality has been added to this image to monitor whether clients are connected to the server. If for a specified time no client is connected, the Java process is stopped. When knocking on the server port (e.g. by the ingame Multiplayer server overview), the process is resumed. The experience for the client does not change.

Of course, even loaded chunks are not ticked when the process is stopped.

From the server's point of view, the pausing causes a single tick to take as long as the process is stopped, so the server watchdog might intervene after the process is continued, possibly forcing a container restart. To prevent this, ensure that the `max-tick-time` in the `server.properties` file is set correctly.

On startup the `server.properties` file is checked and, if applicable, a warning is printed to the terminal. When the server is created (no data available in the persistent directory), the properties file is created with the Watchdog disabled.

A starting, example compose file has been provided in [examples/docker-compose-autopause.yml](examples/docker-compose-autopause.yml).

### Enabling Autopause

Enable the Autopause functionality by setting:

```
-e ENABLE_AUTOPAUSE=TRUE
```

There are 4 more environment variables that define the behaviour:
* `AUTOPAUSE_TIMEOUT_EST`, default `3600` (seconds)
describes the time between the last client disconnect and the pausing of the process (read as timeout established)
* `AUTOPAUSE_TIMEOUT_INIT`, default `600` (seconds)
describes the time between server start and the pausing of the process, when no client connects inbetween (read as timeout initialized)
* `AUTOPAUSE_TIMEOUT_KN`, default `120` (seconds)
describes the time between knocking of the port (e.g. by the main menu ping) and the pausing of the process, when no client connects inbetween (read as timeout knocked)
* `AUTOPAUSE_PERIOD`, default `10` (seconds)
describes period of the daemonized state machine, that handles the pausing of the process (resuming is done independently)

## Deployment Templates and Examples

### Helm Charts

- [stable/minecraft](https://hub.helm.sh/charts/stable/minecraft) ([chart source](https://github.com/helm/charts/tree/master/stable/minecraft))
- [mcsh/server-deployment](https://github.com/mcserverhosting-net/charts)

### Examples

The [examples directory](https://github.com/itzg/docker-minecraft-server/tree/master/examples) also provides examples of deploying the [itzg/minecraft-server](https://hub.docker.com/r/itzg/minecraft-server/) Docker image.

## Running a Forge Server

Enable Forge server mode by adding a `-e TYPE=FORGE` to your command-line.
By default the container will run the `RECOMMENDED` version of [Forge server](http://www.minecraftforge.net/wiki/)
but you can also choose to run a specific version with `-e FORGEVERSION=10.13.4.1448`.

    $ docker run -d -v /path/on/host:/data \
        -e TYPE=FORGE -e FORGEVERSION=10.13.4.1448 \
        -p 25565:25565 -e EULA=TRUE --name mc itzg/minecraft-server

To use a pre-downloaded Forge installer, place it in the attached `/data` directory and
specify the name of the installer file with `FORGE_INSTALLER`, such as:

    $ docker run -d -v /path/on/host:/data ... \
        -e FORGE_INSTALLER=forge-1.11.2-13.20.0.2228-installer.jar ...

To download a Forge installer from a custom location, such as your own file repository, specify
the URL with `FORGE_INSTALLER_URL`, such as:

    $ docker run -d -v /path/on/host:/data ... \
        -e FORGE_INSTALLER_URL=http://HOST/forge-1.11.2-13.20.0.2228-installer.jar ...

In both of the cases above, there is no need for the `VERSION` or `FORGEVERSION` variables.

In order to add mods, you have two options.

### Using the /data volume

This is the easiest way if you are using a persistent `/data` mount.

To do this, you will need to attach the container's `/data` directory
(see "Attaching data directory to host filesystem”).
Then, you can add mods to the `/path/on/host/mods` folder you chose. From the example above,
the `/path/on/host` folder contents look like:

```
/path/on/host
├── mods
│   └── ... INSTALL MODS HERE ...
├── config
│   └── ... CONFIGURE MODS HERE ...
├── ops.json
├── server.properties
├── whitelist.json
└── ...
```

If you add mods while the container is running, you'll need to restart it to pick those
up:

    docker stop mc
    docker start mc

### Using separate mounts

This is the easiest way if you are using an ephemeral `/data` filesystem,
or downloading a world with the `WORLD` option.

There are two additional volumes that can be mounted; `/mods` and `/config`.
Any files in either of these filesystems will be copied over to the main
`/data` filesystem before starting Minecraft.

This works well if you want to have a common set of modules in a separate
location, but still have multiple worlds with different server requirements
in either persistent volumes or a downloadable archive.

### Replacing variables inside configs

Sometimes you have mods or plugins that require configuration information that is only available at runtime.
For example if you need to configure a plugin to connect to a database,
you don't want to include this information in your Git repository or Docker image.
Or maybe you have some runtime information like the server name that needs to be set
in your config files after the container starts.

For those cases there is the option to replace defined variables inside your configs
with environment variables defined at container runtime.

If you set the enviroment variable `REPLACE_ENV_VARIABLES` to `TRUE` the startup script
will go thru all files inside your `/data` volume and replace variables that match your
defined environment variables. Variables that you want to replace need to be wrapped
inside `${YOUR_VARIABLE}` curly brackets and prefixed with a dollar sign. This is the regular
syntax for enviromment variables inside strings or config files.

Optionally you can also define a prefix to only match predefined environment variables.

`ENV_VARIABLE_PREFIX="CFG_"` <-- this is the default prefix

If you want use file for value (like when use secrets) you can add suffix `_FILE` to your variable name (in  run command).

There are some limitations to what characters you can use.

| Type  | Allowed Characters  |
| ----- | ------------------- |
| Name  | `0-9a-zA-Z_-`       |
| Value | `0-9a-zA-Z_-:/=?.+` |

Variables will be replaced in files with the following extensions:
`.yml`, `.yaml`, `.txt`, `.cfg`, `.conf`, `.properties`.

Specific files can be excluded by listing their name (without path) in the variable `REPLACE_ENV_VARIABLES_EXCLUDES`. 

Here is a full example where we want to replace values inside a `database.yml`.

```yml

---
database:
  host: ${CFG_DB_HOST}
  name: ${CFG_DB_NAME}
  password: ${CFG_DB_PASSWORD}
```

This is how your `docker-compose.yml` file could look like:

```yml
version: "3"
# Other docker-compose examples in /examples

services:
  minecraft:
    image: itzg/minecraft-server
    ports:
      - "25565:25565"
    volumes:
      - "mc:/data"
    environment:
      EULA: "TRUE"
      ENABLE_RCON: "true"
      RCON_PASSWORD: "testing"
      RCON_PORT: 28016
      # enable env variable replacement
      REPLACE_ENV_VARIABLES: "TRUE"
      # define an optional prefix for your env variables you want to replace
      ENV_VARIABLE_PREFIX: "CFG_"
      # and here are the actual variables
      CFG_DB_HOST: "http://localhost:3306"
      CFG_DB_NAME: "minecraft"
      CFG_DB_PASSWORD_FILE: "/run/secrets/db_password"
    restart: always
  rcon:
    image: itzg/rcon
    ports:
      - "4326:4326"
      - "4327:4327"
    volumes:
      - "rcon:/opt/rcon-web-admin/db"

volumes:
  mc:
  rcon:

secrets:
  db_password:
    file: ./db_password
```

The content of `db_password`:

    ug23u3bg39o-ogADSs

## Running a Bukkit/Spigot server

Enable Bukkit/Spigot server mode by adding a `-e TYPE=BUKKIT` or `-e TYPE=SPIGOT` to your command-line.

    docker run -d -v /path/on/host:/data \
        -e TYPE=SPIGOT \
        -p 25565:25565 -e EULA=TRUE --name mc itzg/minecraft-server

If you are hosting your own copy of Bukkit/Spigot you can override the download URLs with:

- -e BUKKIT_DOWNLOAD_URL=<url>
- -e SPIGOT_DOWNLOAD_URL=<url>

You can build spigot from source by adding `-e BUILD_FROM_SOURCE=true`

If you have attached a host directory to the `/data` volume, then you can install plugins within the `plugins` subdirectory. You can also [attach a `/plugins` volume](#deploying-plugins-from-attached-volume). If you add plugins while the container is running, you'll need to restart it to pick those up.

## Running a PaperSpigot server

Enable PaperSpigot server mode by adding a `-e TYPE=PAPER` to your command-line.

By default the container will run the latest build of [Paper server](https://papermc.io/downloads)
but you can also choose to run a specific build with `-e PAPERBUILD=205`.

    docker run -d -v /path/on/host:/data \
        -e TYPE=PAPER \
        -p 25565:25565 -e EULA=TRUE --name mc itzg/minecraft-server

If you are hosting your own copy of PaperSpigot you can override the download URL with:

- -e PAPER_DOWNLOAD_URL=<url>

An example compose file is provided at
[examples/docker-compose-paper.yml](examples/docker-compose-paper.yml).

If you have attached a host directory to the `/data` volume, then you can install plugins via the `plugins` subdirectory. You can also [attach a `/plugins` volume](#deploying-plugins-from-attached-volume). If you add plugins while the container is running, you'll need to restart it to pick those up.

## Running a Tuinity server

A [Tuinity](https://github.com/Spottedleaf/Tuinity) server, which is a fork of Paper aimed at improving server performance at high playercounts.

    -e TYPE=TUINITY

> **NOTE** only `VERSION=LATEST` is supported

## Running a Magma server

A [Magma](https://magmafoundation.org/) server, which is a combination of Forge and PaperMC, can be used with

    -e TYPE=MAGMA

> **NOTE** there are limited base versions supported, so you will also need to  set `VERSION`, such as "1.12.2"


## Running a Mohist server

A [Mohist](https://github.com/Mohist-Community/Mohist) server can be used with

    -e TYPE=MOHIST

> **NOTE** there are limited base versions supported, so you will also need to  set `VERSION`, such as "1.12.2"


## Running a Catserver type server

A [Catserver](http://catserver.moe/) type server can be used with

    -e TYPE=CATSERVER

> **NOTE** Catserver only provides a single release stream, so `VERSION` is ignored

## Running a server with a Feed the Beast modpack

> **NOTE** requires `itzg/minecraft-server:multiarch` image

[Feed the Beast application](https://www.feed-the-beast.com/) modpacks are supported by using `-e TYPE=FTBA` (**note** the "A" at the end of the type). This server type will automatically take care of downloading and installing the modpack and appropriate version of Forge, so the `VERSION` does not need to be specified.

### Environment Variables:
- `FTB_MODPACK_ID`: **required**, the numerical ID of the modpack to install. The ID can be located by finding the modpack at [Neptune FTB](https://ftb.neptunepowered.org/) and using the "Pack ID"
- `FTB_MODPACK_VERSION_ID`: optional, the numerical Id of the version to install. If not specified, the latest version will be installed. The "Version ID" can be obtained by drilling into the Versions tab and clicking a specific version.

### Upgrading

If a specific `FTB_MODPACK_VERSION_ID` was not specified, simply restart the container to pick up the newest modpack version. If using a specific version ID, recreate the container with the new version ID.

### Example

The following example runs the latest version of [FTB Presents Direwolf20 1.12](https://ftb.neptunepowered.org/pack/ftb-presents-direwolf20-1-12/):

```
docker run -d --name mc-ftb -e EULA=TRUE \
  -e TYPE=FTBA -e FTB_MODPACK_ID=31 \
  -p 25565:25565 \
  itzg/minecraft-server:multiarch
```

> Normally you will also add `-v` volume for `/data` since the mods and config are installed there along with world data.

## Running a server with a CurseForge modpack

Enable this server mode by adding `-e TYPE=CURSEFORGE` to your command-line,
but note the following additional steps needed...

You need to specify a modpack to run, using the `CF_SERVER_MOD` environment
variable. A CurseForge server modpack is available together with its respective
client modpack at <https://www.curseforge.com/minecraft/modpacks> .

Now you can add a `-e CF_SERVER_MOD=name_of_modpack.zip` to your command-line.

    docker run -d -v /path/on/host:/data -e TYPE=CURSEFORGE \
        -e CF_SERVER_MOD=SkyFactory_4_Server_4.1.0.zip \
        -p 25565:25565 -e EULA=TRUE --name mc itzg/minecraft-server

If you want to keep the pre-download modpacks separate from your data directory,
then you can attach another volume at a path of your choosing and reference that.
The following example uses `/modpacks` as the container path as the pre-download area:

    docker run -d -v /path/on/host:/data -v /path/to/modpacks:/modpacks \
        -e TYPE=CURSEFORGE \
        -e CF_SERVER_MOD=/modpacks/SkyFactory_4_Server_4.1.0.zip \
        -p 25565:25565 -e EULA=TRUE --name mc itzg/minecraft-server

### Fixing "unable to launch forgemodloader"

If your server's modpack fails to load with an error [like this](https://support.feed-the-beast.com/t/cant-start-crashlanding-server-unable-to-launch-forgemodloader/6028/2):

    unable to launch forgemodloader

then you apply a workaround by adding this to the run invocation:

    -e FTB_LEGACYJAVAFIXER=true

## Running a SpongeVanilla server

Enable SpongeVanilla server mode by adding a `-e TYPE=SPONGEVANILLA` to your command-line.
By default the container will run the latest `STABLE` version.
If you want to run a specific version, you can add `-e SPONGEVERSION=1.11.2-6.1.0-BETA-19` to your command-line.

    docker run -d -v /path/on/host:/data -e TYPE=SPONGEVANILLA \
        -p 25565:25565 -e EULA=TRUE --name mc itzg/minecraft-server

You can also choose to use the `EXPERIMENTAL` branch.
Just change it with `SPONGEBRANCH`, such as:

    $ docker run -d -v /path/on/host:/data ... \
        -e TYPE=SPONGEVANILLA -e SPONGEBRANCH=EXPERIMENTAL ...

## Running a Fabric Server

Enable Fabric server mode by adding a `-e TYPE=FABRIC` to your command-line.
By default the container will run the latest version of [Fabric server](http://fabricmc.net/use/)
but you can also choose to run a specific version with `-e FABRICVERSION=0.5.0.32`.

    $ docker run -d -v /path/on/host:/data \
        -e TYPE=FABRIC -e FABRICVERSION=0.5.0.32 \
        -p 25565:25565 -e EULA=TRUE --name mc itzg/minecraft-server

To use a pre-downloaded Fabric installer, place it in the attached `/data` directory and
specify the name of the installer file with `FABRIC_INSTALLER`, such as:

    $ docker run -d -v /path/on/host:/data ... \
        -e FABRIC_INSTALLER=fabric-installer-0.5.0.32.jar ...

To download a Fabric installer from a custom location, such as your own file repository, specify
the URL with `FABRIC_INSTALLER_URL`, such as:

    $ docker run -d -v /path/on/host:/data ... \
        -e FORGE_INSTALLER_URL=http://HOST/fabric-installer-0.5.0.32.jar ...

In both of the cases above, there is no need for the `VERSION` or `FABRICVERSION` variables.

In order to add mods, you have two options.

### Using the /data volume

This is the easiest way if you are using a persistent `/data` mount.

To do this, you will need to attach the container's `/data` directory
(see "Attaching data directory to host filesystem”).
Then, you can add mods to the `/path/on/host/mods` folder you chose. From the example above,
the `/path/on/host` folder contents look like:

```
/path/on/host
├── mods
│   └── ... INSTALL MODS HERE ...
├── config
│   └── ... CONFIGURE MODS HERE ...
├── ops.json
├── server.properties
├── whitelist.json
└── ...
```

If you add mods while the container is running, you'll need to restart it to pick those
up:

    docker stop mc
    docker start mc

### Using separate mounts

This is the easiest way if you are using an ephemeral `/data` filesystem,
or downloading a world with the `WORLD` option.

There are two additional volumes that can be mounted; `/mods` and `/config`.
Any files in either of these filesystems will be copied over to the main
`/data` filesystem before starting Minecraft.

This works well if you want to have a common set of modules in a separate
location, but still have multiple worlds with different server requirements
in either persistent volumes or a downloadable archive.

## Deploying plugins from attached volume

There is one additional volume that can be mounted; `/plugins`. Any files in this filesystem will be copied over to the main `/data/plugins` filesystem before starting Minecraft. Set `PLUGINS_SYNC_UPDATE=false` if you want files from `/plugins` to take precedence over newer files in `/data/plugins`.

This works well if you want to have a common set of plugins in a separate location, but still have multiple worlds with different server requirements in either persistent volumes or a downloadable archive.

## Running with a custom server JAR

If you would like to run a custom server JAR, set `-e TYPE=CUSTOM` and pass the custom server
JAR via `CUSTOM_SERVER`. It can either be a URL or a container path to an existing JAR file.

If it is a URL, it will only be downloaded into the `/data` directory if it wasn't already. As
such, if you need to upgrade or re-download the JAR, then you will need to stop the container,
remove the file from the container's `/data` directory, and start again.

## Force re-download of the server file

For VANILLA, FORGE, BUKKIT, SPIGOT, PAPER, CURSEFORGE, SPONGEVANILLA server types, set
`$FORCE_REDOWNLOAD` to some value (e.g. 'true) to force a re-download of the server file for
the particular server type. by adding a `-e FORCE_REDOWNLOAD=true` to your command-line.

For example, with PaperSpigot, it would look something like this:

```
docker run -d -v /path/on/host:/data \
    -e TYPE=PAPER -e FORCE_REDOWNLOAD=true \
    -p 25565:25565 -e EULA=TRUE --name mc itzg/minecraft-server
```

## Using Docker Compose

Rather than type the server options below, the port mappings above, etc
every time you want to create new Minecraft server, you can now use
[Docker Compose](https://docs.docker.com/compose/). Start with a
`docker-compose.yml` file like the following:

```
minecraft-server:
  ports:
    - "25565:25565"

  environment:
    EULA: "TRUE"

  image: itzg/minecraft-server

  container_name: mc

  tty: true
  stdin_open: true
  restart: always
```

and in the same directory as that file run

    docker-compose up -d

Now, go play...or adjust the `environment` section to configure
this server instance.

## Server configuration

By default the server configuration will be created and set based on the following
environment variables, but only the first time the server is started. If the
`server.properties` file already exists, the values in them will not be changed.

If you would like to override the server configuration each time the container
starts up, you can set the OVERRIDE_SERVER_PROPERTIES environment variable like:

    docker run -d -e OVERRIDE_SERVER_PROPERTIES=true ...

This will reset any manual configuration of the `server.properties` file, so if
you want to make any persistent configuration changes you will need to make sure
you have properly set the proper environment variables in your docker run command (described below).

### Server name

The server name (e.g. for bungeecord) can be set like:

    docker run -d -e SERVER_NAME=MyServer ...

### Server port

> **WARNING:** only change this value if you know what you're doing. It is only needed when using host networking and it is rare that host networking should be used. Use `-p` port mappings instead.

If you must, the server port can be set like:

    docker run -d -e SERVER_PORT=25566 ...

**however**, be sure to change your port mapping accordingly and be prepared for some features to break.

### Difficulty

The difficulty level (default: `easy`) can be set like:

    docker run -d -e DIFFICULTY=hard ...

Valid values are: `peaceful`, `easy`, `normal`, and `hard`, and an
error message will be output in the logs if it's not one of these
values.

### Whitelist Players

To whitelist players for your Minecraft server, pass the Minecraft usernames separated by commas via the `WHITELIST` environment variable, such as

    docker run -d -e WHITELIST=user1,user2 ...

If the `WHITELIST` environment variable is not used, any user can join your Minecraft server if it's publicly accessible.

### Op/Administrator Players

To add more "op" (aka adminstrator) users to your Minecraft server, pass the Minecraft usernames separated by commas via the `OPS` environment variable, such as

    docker run -d -e OPS=user1,user2 ...

### Server icon

A server icon can be configured using the `ICON` variable. The image will be automatically
downloaded, scaled, and converted from any other image format:

    docker run -d -e ICON=http://..../some/image.png ...

### Rcon

To use rcon use the `ENABLE_RCON` and `RCON_PASSORD` variables.
By default rcon port will be `25575` but can easily be changed with the `RCON_PORT` variable.

    docker run -d -e ENABLE_RCON=true -e RCON_PASSWORD=testing

### Query

Enabling this will enable the gamespy query protocol.
By default the query port will be `25565` (UDP) but can easily be changed with the `QUERY_PORT` variable.

    docker run -d -e ENABLE_QUERY=true

### Max players

By default max players is 20, you can increase this with the `MAX_PLAYERS` variable.

    docker run -d -e MAX_PLAYERS=50

### Max world size

This sets the maximum possible size in blocks, expressed as a radius, that the world border can obtain.

    docker run -d -e MAX_WORLD_SIZE=10000

### Allow Nether

Allows players to travel to the Nether.

    docker run -d -e ALLOW_NETHER=true

### Announce Player Achievements

Allows server to announce when a player gets an achievement.

    docker run -d -e ANNOUNCE_PLAYER_ACHIEVEMENTS=true

### Enable Command Block

Enables command blocks

     docker run -d -e ENABLE_COMMAND_BLOCK=true

### Force Gamemode

Force players to join in the default game mode.

- false - Players will join in the gamemode they left in.
- true - Players will always join in the default gamemode.

  `docker run -d -e FORCE_GAMEMODE=false`

### Generate Structures

Defines whether structures (such as villages) will be generated.

- false - Structures will not be generated in new chunks.
- true - Structures will be generated in new chunks.

  `docker run -d -e GENERATE_STRUCTURES=true`

### Hardcore

If set to true, players will be set to spectator mode if they die.

    docker run -d -e HARDCORE=false

### Snooper

If set to false, the server will not send data to snoop.minecraft.net server.

    docker run -d -e SNOOPER_ENABLED=false

### Max Build Height

The maximum height in which building is allowed.
Terrain may still naturally generate above a low height limit.

    docker run -d -e MAX_BUILD_HEIGHT=256

### Max Tick Time

The maximum number of milliseconds a single tick may take before the server watchdog stops the server with the message, A single server tick took 60.00 seconds (should be max 0.05); Considering it to be crashed, server will forcibly shutdown. Once this criteria is met, it calls System.exit(1).
Setting this to -1 will disable watchdog entirely

    docker run -d -e MAX_TICK_TIME=60000

### Spawn Animals

Determines if animals will be able to spawn.

    docker run -d -e SPAWN_ANIMALS=true

### Spawn Monsters

Determines if monsters will be spawned.

    docker run -d -e SPAWN_MONSTERS=true

### Spawn NPCs

Determines if villagers will be spawned.

    docker run -d -e SPAWN_NPCS=true

### Set spawn protection

Sets the area that non-ops can not edit (0 to disable)

    docker run -d -e SPAWN_PROTECTION=0

### View Distance

Sets the amount of world data the server sends the client, measured in chunks in each direction of the player (radius, not diameter).
It determines the server-side viewing distance.

    docker run -d -e VIEW_DISTANCE=10

### Level Seed

If you want to create the Minecraft level with a specific seed, use `SEED`, such as

    docker run -d -e SEED=1785852800490497919 ...

### Game Mode

By default, Minecraft servers are configured to run in Survival mode. You can
change the mode using `MODE` where you can either provide the [standard
numerical values](http://minecraft.gamepedia.com/Game_mode#Game_modes) or the
shortcut values:

- creative
- survival
- adventure
- spectator (only for Minecraft 1.8 or later)

For example:

    docker run -d -e MODE=creative ...

### Message of the Day

The message of the day, shown below each server entry in the UI, can be changed with the `MOTD` environment variable, such as

    docker run -d -e 'MOTD=My Server' ...

If you leave it off, a default is computed from the server type and version, such as

    A Paper Minecraft Server powered by Docker

when `TYPE` is `PAPER`. That way you can easily differentiate between several servers you may have started.

_The example shows how to specify a server message of the day that contains spaces by putting quotes
around the whole thing._

### PVP Mode

By default, servers are created with player-vs-player (PVP) mode enabled. You can disable this with the `PVP`
environment variable set to `false`, such as

    docker run -d -e PVP=false ...

### Level Type and Generator Settings

By default, a standard world is generated with hills, valleys, water, etc. A different level type can
be configured by setting `LEVEL_TYPE` to an expected type, such as

- DEFAULT
- FLAT
- LARGEBIOMES
- AMPLIFIED
- CUSTOMIZED
- BUFFET

Descriptions are available at the [gamepedia](http://minecraft.gamepedia.com/Server.properties).

When using a level type of `FLAT`, `CUSTOMIZED`, and `BUFFET`, you can further configure the world generator
by passing [custom generator settings](http://minecraft.gamepedia.com/Superflat).
**Since generator settings usually have ;'s in them, surround the -e value with a single quote, like below.**

For example (just the `-e` bits):

    -e LEVEL_TYPE=flat -e 'GENERATOR_SETTINGS=3;minecraft:bedrock,3*minecraft:stone,52*minecraft:sandstone;2;'

### Custom Server Resource Pack

You can set a link to a custom resource pack and set it's checksum using the `RESOURCE_PACK` and `RESOURCE_PACK_SHA1` options respectively, the default is blank:

    docker run -d -e 'RESOURCE_PACK=http\://link.com/to/pack.zip?\=1' -e 'RESOURCE_PACK_SHA1=d5db29cd03a2ed055086cef9c31c252b4587d6d0'

**NOTE:** `:` and `=` must be escaped using `\`. The checksum plain-text hexadecimal.

### World Save Name

You can either switch between world saves or run multiple containers with different saves by using the `LEVEL` option,
where the default is "world":

    docker run -d -e LEVEL=bonus ...

**NOTE:** if running multiple containers be sure to either specify a different `-v` host directory for each
`LEVEL` in use or don't use `-v` and the container's filesystem will keep things encapsulated.

### Downloadable world

Instead of mounting the `/data` volume, you can instead specify the URL of a ZIP file containing an archived world. It will be searched for a file `level.dat` and the containing subdirectory moved to the directory named by `$LEVEL`. This means that most of the archived Minecraft worlds downloadable from the Internet will already be in the correct format.

    docker run -d -e WORLD=http://www.example.com/worlds/MySave.zip ...

**NOTE:** This URL must be accessible from inside the container. Therefore,
you should use an IP address or a globally resolvable FQDN, or else the
name of a linked container.

**NOTE:** If the archive contains more than one `level.dat`, then the one to select can be picked with `WORLD_INDEX`, which defaults to 1.

### Cloning world from a container path

The `WORLD` option can also be used to reference a directory or zip file that will be used as a source to clone or unzip the world directory.

For example, the following would initially clone the world's content
from `/worlds/basic`. Also notice in the example that you can use a
read-only volume attachment to ensure the clone source remains pristine.

```
docker run ... -v $HOME/worlds:/worlds:ro -e WORLD=/worlds/basic
```

### Downloadable mod/plugin pack for Forge, Bukkit, and Spigot Servers

Like the `WORLD` option above, you can specify the URL of a "mod pack"
to download and install into `mods` for Forge or `plugins` for Bukkit/Spigot.
To use this option pass the environment variable `MODPACK`, such as

    docker run -d -e MODPACK=http://www.example.com/mods/modpack.zip ...

**NOTE:** The referenced URL must be a zip file with one or more jar files at the
top level of the zip archive. Make sure the jars are compatible with the
particular `TYPE` of server you are running.

You may also download individual mods using the `MODS` environment variable and supplying the URL
to the jar files. Multiple mods/plugins should be comma separated.

    docker run -d -e MODS=https://www.example.com/mods/mod1.jar,https://www.example.com/mods/mod2.jar ...

### Remove old mods/plugins

When the option above is specified (`MODPACK`) you can also instruct script to
delete old mods/plugins prior to installing new ones. This behaviour is desirable
in case you want to upgrade mods/plugins from downloaded zip file.
To use this option pass the environment variable `REMOVE_OLD_MODS="TRUE"`, such as

    docker run -d -e REMOVE_OLD_MODS="TRUE" -e MODPACK=http://www.example.com/mods/modpack.zip ...

**WARNING:** All content of the `mods` or `plugins` directory will be deleted
before unpacking new content from the MODPACK or MODS.

### Online mode

By default, server checks connecting players against Minecraft's account database. If you want to create an offline server or your server is not connected to the internet, you can disable the server to try connecting to minecraft.net to authenticate players with environment variable `ONLINE_MODE`, like this

    docker run -d -e ONLINE_MODE=FALSE ...

### Allow flight

Allows users to use flight on your server while in Survival mode, if they have a mod that provides flight installed.

    -e ALLOW_FLIGHT=TRUE|FALSE

### Other server property mappings

| Environment Variable              | Server Property                   |
| --------------------------------- | --------------------------------- |
| PLAYER_IDLE_TIMEOUT               | player-idle-timeout               |
| BROADCAST_CONSOLE_TO_OPS          | broadcast-console-to-ops          |
| BROADCAST_RCON_TO_OPS             | broadcast-rcon-to-ops             |
| ENABLE_JMX                        | enable-jmx-monitoring             |
| SYNC_CHUNK_WRITES                 | sync-chunk-writes                 |
| ENABLE_STATUS                     | enable-status                     |
| ENTITY_BROADCAST_RANGE_PERCENTAGE | entity-broadcast-range-percentage |
| FUNCTION_PERMISSION_LEVEL         | function-permission-level         |
| NETWORK_COMPRESSION_THRESHOLD     | network-compression-threshold     |
| OP_PERMISSION_LEVEL               | op-permission-level               |
| PREVENT_PROXY_CONNECTIONS         | prevent-proxy-connections         |
| USE_NATIVE_TRANSPORT              | use-native-transport              |
| ENFORCE_WHITELIST                 | enforce-whitelist                 |

## Miscellaneous Options

### Running as alternate user/group ID

By default, the container will switch to user ID 1000 and group ID 1000;
however, you can override those values by setting `UID` and/or `GID` as environmental entries, during the `docker run` command.

    -e UID=1234
    -e GID=1234

The container will also skip user switching if the `--user`/`-u` argument
is passed to `docker run`.

### Memory Limit

By default, the image declares a Java initial and maximum memory limit of 1 GB. There are several
ways to adjust the memory settings:

- `MEMORY`, "1G" by default, can be used to adjust both initial (`Xms`) and max (`Xmx`)
  memory settings of the JVM
- `INIT_MEMORY`, independently sets the initial heap size
- `MAX_MEMORY`, independently sets the max heap size

The values of all three are passed directly to the JVM and support format/units as
`<size>[g|G|m|M|k|K]`. For example:

    -e MEMORY=2G

### JVM Options

General JVM options can be passed to the Minecraft Server invocation by passing a `JVM_OPTS`
environment variable. Options like `-X` that need to proceed general JVM options can be passed
via a `JVM_XX_OPTS` environment variable.

For some cases, if e.g. after removing mods, it could be necessary to startup minecraft with an additional `-D` parameter like `-Dfml.queryResult=confirm`. To address this you can use the environment variable `JVM_DD_OPTS`, which builds the params from a given list of values separated by space, but without the `-D` prefix. To make things running under systems (e.g. Plesk), which doesn't allow `=` inside values, a `:` (colon) could be used instead. The upper example would look like this:
`JVM_DD_OPTS=fml.queryResult:confirm`, and will be converted to `-Dfml.queryResult=confirm`.

### Enable Remote JMX for Profiling

To enable remote JMX, such as for profiling with VisualVM or JMC, add the environment variable `ENABLE_JMX=true` and add a port forwarding of TCP port 7091, such as:

    -e ENABLE_JMX=true -p 7091:7091

### Enable Aikar's Flags

[Aikar has does some research](https://mcflags.emc.gs/) into finding the optimal JVM flags for GC tuning, which becomes more important as more users are connected concurrently. The set of flags documented there can be added using

    -e USE_AIKAR_FLAGS=true

When `MEMORY` is greater than or equal to 12G, then the Aikar flags will be adjusted according to the article.

Large page support can also be enabled by adding

    -e USE_LARGE_PAGES=true

### HTTP Proxy

You may configure the use of an HTTP/HTTPS proxy by passing the proxy's URL via the `PROXY`
environment variable. In [the example compose file](examples/docker-compose-proxied.yml) it references
a companion squid proxy by setting the equivalent of

    -e PROXY=proxy:3128

### Using "noconsole" option

Some older versions (pre-1.14) of Spigot required `--noconsole` to be passed when detaching stdin, which can be done by setting `-e CONSOLE=FALSE`.

### Explicitly disable GUI

Some older servers get confused and think that the GUI interface is enabled. You can explicitly
disable that by passing `-e GUI=FALSE`.

## Running on RaspberryPi

To run this image on a RaspberryPi 3 B+, 4, or newer, use the image tag

    itzg/minecraft-server:multiarch

> NOTE: you may need to lower the memory allocation, such as `-e MEMORY=750m`
