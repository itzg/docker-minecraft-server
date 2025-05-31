
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

By default, the container will switch to and run the Minecraft server as user ID 1000 and group ID 1000; however, that can be changed by setting the environment variables `UID` and `GID`.

The startup will also skip user switching if the `--user`/`-u` argument is passed to `docker run` or `user` is set on the compose service.

## Extra Arguments

Arguments that would usually be passed to the jar file (those which are written after the filename) can be passed via the `EXTRA_ARGS` environment variable.

See [Custom worlds directory path](../misc/world-data.md#custom-worlds-directory-path) for an example.

## Interactive and Color Console

When RCON is enabled, which is the default, and [TTY](https://docs.docker.com/compose/compose-file/05-services/#tty) is enabled on the container, then some server types will output colorized logs and provide a fully interactive console. To access the interactive console, use [`docker attach`](https://docs.docker.com/engine/reference/commandline/container_attach/) (not `exec`). When finished, make sure to use the sequence Control-P, Control-Q to detach without stopping the container.

If this behavior interferes with the log content, then disable TTY or remove the setting entirely since the default is disabled. In a compose file, set the service's `tty` parameter to `false`. On the `docker run` command-line remove the `-t` argument.

## Server Shutdown Options

To allow time for players to finish what they're doing during a graceful server shutdown, set `STOP_SERVER_ANNOUNCE_DELAY` to a number of seconds to delay after an announcement is posted by the server.

!!! warning "Increase stop grace period"

    The Docker stop grace period must be increased to a value longer than the announce delay. The value to use that is longer than announce delay will vary based upon the amount of time it takes for final world data saving. If the container exits with exit code 137, then that indicates a longer grace period is needed. 
    
    The grace period can be increased using [the -t option on docker-compose down](https://docs.docker.com/compose/reference/down/) or set the [stop_grace_period](https://docs.docker.com/compose/compose-file/05-services/#stop_grace_period) in the compose file.

The `STOP_SERVER_ANNOUNCE_DELAY` can be bypassed by sending a `SIGUSR1` signal to the `mc-server-runner` process.

`docker`:

        docker stop --signal SIGUSR1 mc

`docker compose`:

        docker compose kill --signal SIGUSR1

## Configuration Options for Minecraft Server Health Monitoring

The image tags include specific variables to simplify configuration for monitoring the health of a Minecraft server:

- `-e SERVER_HOST=localhost` : This variable sets the host address of the Minecraft server to be monitored. By default, it is set to `localhost`, but you can replace it with the actual hostname or IP address of your Minecraft server.

- `-e SERVER_PORT=25565` : This variable sets the port number on which the Minecraft server is running. By default, Minecraft servers run on port 25565, but if your server is configured to use a different port, you should replace `25565` with the correct port number. This helps the monitoring system to accurately check the health status of the Minecraft server on the specified port.

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
