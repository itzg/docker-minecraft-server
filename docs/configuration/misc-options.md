
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

## Running as alternate user/group ID

By default, the container will switch to user ID 1000 and group ID 1000;
however, you can override those values by setting `UID` and/or `GID` as environmental entries, during the `docker run` command.

    -e UID=1234
    -e GID=1234

The container will also skip user switching if the `--user`/`-u` argument
is passed to `docker run`.

## Extra Arguments

Arguments that would usually be passed to the jar file (those which are written after the filename) can be passed via the `EXTRA_ARGS` environment variable.

See [Custom worlds directory path](../misc/world-data.md#custom-worlds-directory-path) for an example.

## Interactive and Color Console

If you would like to `docker attach` to the Minecraft server console with color and interactive capabilities, then add

```
  -e EXEC_DIRECTLY=true
```

> **NOTES**
>
> This feature doesn't work via rcon, so you will need to `docker attach` to the container. Use the sequence Ctrl-P, Ctrl-Q to detach. 
> 
> This will bypass graceful server shutdown handling when using `docker stop`, so be sure the server console's `stop` command.
> 
> Make to enable stdin and tty with `-it` when using `docker run` or `stdin_open: true` and `tty: true` when using docker compose.
>
> This feature is incompatible with Autopause and cannot be set when `ENABLE_AUTOPAUSE=true`.

## Server Shutdown Options

To allow time for players to finish what they're doing during a graceful server shutdown, set `STOP_SERVER_ANNOUNCE_DELAY` to a number of seconds to delay after an announcement is posted by the server.

> **NOTE** be sure to adjust Docker's shutdown timeout accordingly, such as using [the -t option on docker-compose down](https://docs.docker.com/compose/reference/down/).

## OpenJ9 Specific Options

The openj9 image tags include specific variables to simplify configuration:

- `-e TUNE_VIRTUALIZED=TRUE` : enables the option to
  [optimize for virtualized environments](https://www.eclipse.org/openj9/docs/xtunevirtualized/)
- `-e TUNE_NURSERY_SIZES=TRUE` : configures nursery sizes where the initial size is 50%
  of the `MAX_MEMORY` and the max size is 80%.

## Enabling rolling logs

By default the vanilla log file will grow without limit. The logger can be reconfigured to use a rolling log files strategy by using:

```
  -e ENABLE_ROLLING_LOGS=true
```

> **NOTE** this will interfere with interactive/color consoles [as described in the section above](#interactive-and-color-console)

## Timezone Configuration

You can configure the timezone to match yours by setting the `TZ` environment variable:

        -e TZ=Europe/London

such as:

        docker run -d -it -e TZ=Europe/London -p 25565:25565 --name mc itzg/minecraft-server

Or mounting `/etc/timezone` as readonly (not supported on Windows):

        -v /etc/timezone:/etc/timezone:ro

such as:

        docker run -d -it -v /etc/timezone:/etc/timezone:ro -p 25565:25565 --name mc itzg/minecraft-server

## HTTP Proxy

You may configure the use of an HTTP/HTTPS proxy by passing the proxy's URL via the `PROXY`
environment variable. In [the example compose file](https://github.com/itzg/docker-minecraft-server/blob/master/examples/docker-compose-proxied.yml) it references
a companion squid proxy by setting the equivalent of

    -e PROXY=proxy:3128

## Using "noconsole" option

Some older versions (pre-1.14) of Spigot required `--noconsole` to be passed when detaching stdin, which can be done by setting `-e CONSOLE=FALSE`.

## Explicitly disable GUI

Some older servers get confused and think that the GUI interface is enabled. You can explicitly
disable that by passing `-e GUI=FALSE`.

## Stop Duration

When the container is signalled to stop, the Minecraft process wrapper will attempt to send a "stop" command via RCON or console and waits for the process to gracefully finish. By default it waits 60 seconds, but that duration can be configured by setting the environment variable `STOP_DURATION` to the number of seconds.

## Setup only

If you are using a host-attached data directory, then you can have the image setup the Minecraft server files and stop prior to launching the server process by setting `SETUP_ONLY` to `true`. 
    
## Enable Flare Flags
    
To enable the JVM flags required to fully support the [Flare profiling suite](https://blog.airplane.gg/flare), set the following variable:
    
    -e USE_FLARE_FLAGS=true
    
Flare is built-in to Pufferfish/Purpur, and is available in [plugin form](https://github.com/TECHNOVE/FlarePlugin) for other server types.

## Enable support for optimized SIMD operations

To enable support for optimized SIMD operations, the JVM flag can be set with the following variable:

    -e USE_SIMD_FLAGS=true

SIMD optimized operations are supported by Pufferfish and Purpur.

## Enable timestamps in init logs

Before the container starts the Minecraft Server its output is prefixed with `[init]`, such as

```
[init] Starting the Minecraft server...
```

To also include the timestamp with each log, set `LOG_TIMESTAMP` to "true". The log output will then look like:

```
[init] 2022-02-05 16:58:33+00:00 Starting the Minecraft server...
```
