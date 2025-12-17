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

For example, with Paper, it would look something like this:

```
docker run -d --pull=always \
    -v /path/on/host:/data \
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
    
    The grace period can be increased using [the -t option on `docker compose down`](https://docs.docker.com/compose/reference/down/) or set the [stop_grace_period](https://docs.docker.com/compose/compose-file/05-services/#stop_grace_period) in the compose file.

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

## Customizing log4j2 configuration

The image now uses a templated log4j2 configuration based on PaperMC's logging setup, which is automatically applied for versions that don't require Log4j security patches. This configuration provides rolling logs and advanced logging features by default.

### Customization via environment variables

You can customize various aspects of the logging behavior using environment variables:

- `LOG_LEVEL` : Root logger level (default: `info`)
  ```
  -e LOG_LEVEL=debug
  ```

- `ROLLING_LOG_FILE_PATTERN` : Pattern for rolled log file names (default: `logs/%d{yyyy-MM-dd}-%i.log.gz`)
  ```
  -e ROLLING_LOG_FILE_PATTERN="logs/archive/%d{yyyy-MM-dd}-%i.log.gz"
  ```

- `ROLLING_LOG_MAX_FILES` : Maximum number of archived log files to keep (default: `1000`)
  ```
  -e ROLLING_LOG_MAX_FILES=30
  ```

### Customizing log message formats

For full control over how log messages are formatted, you can customize the Log4j2 pattern layouts using these variables. These use [Log4j2 Pattern Layout syntax](https://logging.apache.org/log4j/2.x/manual/layouts.html#PatternLayout):

- `LOG_CONSOLE_FORMAT` : Format for console output (what you see in `docker logs`)
  Default: `[%d{HH:mm:ss}] [%t/%level]: %msg%n`

- `LOG_FILE_FORMAT` : Format for file logs (written to `logs/latest.log`)
  Default: `[%d{HH:mm:ss}] [%t/%level]: %msg%n`

- `LOG_TERMINAL_FORMAT` : Format for interactive terminal console (used with `docker attach`)
  Default: `[%d{HH:mm:ss} %level]: %msg%n`

### Example configurations

Simple timestamp customization (most common use case):
```yaml
environment:
  # What you see in docker logs
  LOG_CONSOLE_FORMAT: "[%d{yyyy-MM-dd HH:mm:ss.SSS}] [%t/%level]: %msg%n"
  # What gets written to logs/latest.log
  LOG_FILE_FORMAT: "[%d{yyyy-MM-dd HH:mm:ss.SSS}] [%t/%level]: %msg%n"
```

Advanced customization:
```yaml
environment:
  LOG_LEVEL: debug
  # Custom ISO8601 format with logger names
  LOG_CONSOLE_FORMAT: "%d{ISO8601} %-5level [%t] %logger{36} - %msg%n"
  LOG_FILE_FORMAT: "%d{ISO8601} %-5level [%t] %logger{36} - %msg%n"
  ROLLING_LOG_MAX_FILES: 50
```

### Legacy ENABLE_ROLLING_LOGS option

The `ENABLE_ROLLING_LOGS` environment variable is no longer needed for most use cases, as rolling logs are now enabled by default through the templated configuration. This option is maintained for backward compatibility but is only checked for error reporting when rolling logs cannot be used due to Log4j security patches.

> **NOTE** The templated log4j2 configuration may interfere with interactive/color consoles [as described in the section above](#interactive-and-color-console)

## Timezone Configuration

You can configure the timezone to match yours by setting the `TZ` environment variable:

        -e TZ=Europe/London

such as:

        docker run -d -it --pull=always -e TZ=Europe/London -p 25565:25565 --name mc itzg/minecraft-server

Or mounting `/etc/timezone` as readonly (not supported on Windows):

        -v /etc/timezone:/etc/timezone:ro

such as:

        docker run -d -it --pull=always -v /etc/timezone:/etc/timezone:ro -p 25565:25565 --name mc itzg/minecraft-server

## HTTP Proxy

You may configure the use of an HTTP/HTTPS proxy by passing the proxy's "host:port" via the environment variable `PROXY`. In [the example compose file](https://github.com/itzg/docker-minecraft-server/blob/master/examples/docker-compose-proxied.yml) it references a Squid proxy. The host and port can be separately passed via the environment variables `PROXY_HOST` and `PROXY_PORT`. A `|` delimited list of hosts to exclude from proxying can be passed via `PROXY_NON_PROXY_HOSTS`.

## Using "noconsole" option

Some older versions (pre-1.14) of Spigot required `--noconsole` to be passed when detaching stdin, which can be done by setting `-e CONSOLE=FALSE`.

## Explicitly disable GUI

Some older servers get confused and think that the GUI interface is enabled. You can explicitly
disable that by passing `-e GUI=FALSE`.

## Stop Duration

When the container is signaled to stop, the Minecraft process wrapper will attempt to send a "stop" command via RCON or console and waits for the process to gracefully finish. By default, it waits 60 seconds, but that duration can be configured by setting the environment variable `STOP_DURATION` to the number of seconds.

Be sure to also increase the shutdown timeout described [here for docker compose down](https://docs.docker.com/reference/cli/docker/compose/down/#options) and [here for docker stop](https://docs.docker.com/reference/cli/docker/container/stop/#options).

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

For example, to download configuration files for plugins:

```yaml
environment:
  DOWNLOAD_EXTRA_CONFIGS: |
    plugins/WorldEdit<https://raw.githubusercontent.com/EngineHub/WorldEdit/refs/heads/version/7.3.x/worldedit-bukkit/src/main/resources/defaults/config.yml
    plugins/EssentialsX<https://raw.githubusercontent.com/EssentialsX/Essentials/refs/heads/2.x/Essentials/src/main/resources/config.yml
```

Or as a single line:

```yaml
environment:
  DOWNLOAD_EXTRA_CONFIGS: "plugins/WorldEdit<https://example.com/worldedit.yml,config<https://example.com/another.yml"
```

The files will be downloaded to `/data/` relative paths, so `plugins/WorldEdit` will be saved as `/data/plugins/WorldEdit/config.yml`.

!!! note 
    The downloaded files can be further processed using [environment variable replacement](interpolating.md) or [patch definitions](interpolating.md#patching-existing-files)

## Enable timestamps in init logs

Before the container starts the Minecraft Server its output is prefixed with `[init]`, such as

```
[init] Starting the Minecraft server...
```

To also include the timestamp with each log, set `LOG_TIMESTAMP` to "true". The log output will then look like:

```
[init] 2022-02-05 16:58:33+00:00 Starting the Minecraft server...
```
