### Replacing variables inside configs

Sometimes you have mods or plugins that require configuration information that is only available at runtime.
For example if you need to configure a plugin to connect to a database,
you don't want to include this information in your Git repository or Docker image.
Or maybe you have some runtime information like the server name that needs to be set
in your config files after the container starts.

For those cases there is the option to replace defined variables inside your configs
with environment variables defined at container runtime.

When the environment variable `REPLACE_ENV_IN_PLACE` is set to `true` (the default), the startup script will go through all files inside the container's `/data` path and replace variables that match the container's environment variables. Variables can instead (or in addition to) be replaced in files sync'ed from `/plugins`, `/mods`, and `/config` by setting `REPLACE_ENV_DURING_SYNC` to `true` (defaults to `false`). 

Variables that you want to replace need to be declared inside curly brackets and prefixed with a dollar sign, such as  `${CFG_YOUR_VARIABLE}`, which is same as many scripting languages.

You can also change `REPLACE_ENV_VARIABLE_PREFIX`, which defaults to "CFG_", to limit which environment variables are allowed to be used. For example, with "CFG_" as the prefix, the variable `${CFG_DB_HOST}` would be subsituted, but not `${DB_HOST}`.

If you want to use a file's content for value, such as when using secrets mounted as files, declare the placeholder named like normal in the file and declare an environment variable named the same but with the suffix `_FILE`. 

For example, a `my.cnf` file could contain:

```
[client]
password = ${CFG_DB_PASSWORD}
```

...a secret declared in the compose file with:
```yaml
secrets:
  db_password:
    external: true
```

...and finally the environment variable would be named with a `_FILE` suffix and point to the mounted secret:
```yaml
    environment:
      CFG_DB_PASSWORD_FILE: /run/secrets/db_password
```

Variables will be replaced in files with the following extensions:
`.yml`, `.yaml`, `.txt`, `.cfg`, `.conf`, `.properties`.

Specific files can be excluded by listing their name (without path) in the variable `REPLACE_ENV_VARIABLES_EXCLUDES`.

Paths can be excluded by listing them in the variable `REPLACE_ENV_VARIABLES_EXCLUDE_PATHS`. Path
excludes are recursive. Here is an example:
```
REPLACE_ENV_VARIABLES_EXCLUDE_PATHS="/data/plugins/Essentials/userdata /data/plugins/MyPlugin"
```

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
version: "3.8"
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

volumes:
  mc:
  rcon:

secrets:
  db_password:
    file: ./db_password
```

### Patching existing files

JSON path based patches can be applied to one or more existing files by setting the variable `PATCH_DEFINITIONS` to the path of a directory that contains one or more [patch definition json files](https://github.com/itzg/mc-image-helper#patchdefinition) or a [patch set json file](https://github.com/itzg/mc-image-helper#patchset).

Variable placeholders in the patch values can be restricted by setting `REPLACE_ENV_VARIABLE_PREFIX`, which defaults to "CFG_".

The following example shows a patch-set file were various fields in the `paper.yaml` configuration file can be modified and added:

```json
{
  "patches": [
    {
      "file": "/data/paper.yml",
      "ops": [
        {
          "$set": {
            "path": "$.verbose",
            "value": true
          }
        },
        {
          "$set": {
            "path": "$.settings['velocity-support'].enabled",
            "value": "${CFG_VELOCITY_ENABLED}",
            "value-type": "bool"
          }
        },
        {
          "$put": {
            "path": "$.settings",
            "key": "my-test-setting",
            "value": "testing"
          }
        }
      ]
    }
  ]
}
```

> **NOTES:** Only JSON and Yaml files can be patched at this time. TOML support is planned to be added next. Removal of comments and other cosmetic changes will occur when patched files are processed.

### Running with a custom server JAR

If you would like to run a custom server JAR, set `-e TYPE=CUSTOM` and pass the custom server
JAR via `CUSTOM_SERVER`. It can either be a URL or a container path to an existing JAR file.

If it is a URL, it will only be downloaded into the `/data` directory if it wasn't already. As
such, if you need to upgrade or re-download the JAR, then you will need to stop the container,
remove the file from the container's `/data` directory, and start again.

### Force re-download of the server file

For VANILLA, FORGE, BUKKIT, SPIGOT, PAPER, CURSEFORGE, SPONGEVANILLA server types, set
`$FORCE_REDOWNLOAD` to some value (e.g. 'true) to force a re-download of the server file for
the particular server type. by adding a `-e FORCE_REDOWNLOAD=true` to your command-line.

For example, with PaperSpigot, it would look something like this:

```
docker run -d -v /path/on/host:/data \
    -e TYPE=PAPER -e FORCE_REDOWNLOAD=true \
    -p 25565:25565 -e EULA=TRUE --name mc itzg/minecraft-server
```

### Running as alternate user/group ID

By default, the container will switch to user ID 1000 and group ID 1000;
however, you can override those values by setting `UID` and/or `GID` as environmental entries, during the `docker run` command.

    -e UID=1234
    -e GID=1234

The container will also skip user switching if the `--user`/`-u` argument
is passed to `docker run`.

### Memory Limit

By default, the image declares an initial and maximum Java memory-heap limit of 1 GB. There are several ways to adjust the memory settings:

- `MEMORY`: "1G" by default, can be used to adjust both initial (`Xms`) and max (`Xmx`) memory heap settings of the JVM
- `INIT_MEMORY`: independently sets the initial heap size
- `MAX_MEMORY`: independently sets the max heap size

The values of all three are passed directly to the JVM and support format/units as `<size>[g|G|m|M|k|K]`. For example:

    -e MEMORY=2G

To let the JVM calculate the heap size from the container declared memory limit, unset `MEMORY` with an empty value, such as `-e MEMORY=""`. By default, the JVM will use 25% of the container memory limit as the heap limit; however, as an example the following would tell the JVM to use 75% of the container limit of 2GB of memory:

     -e MEMORY="" -e JVM_XX_OPTS="-XX:MaxRAMPercentage=75" -m 2000M

> The settings above only set the Java **heap** limits. Memory resource requests and limits on the overall container should also account for non-heap memory usage. An extra 25% is [a general best practice](https://dzone.com/articles/best-practices-java-memory-arguments-for-container).

### JVM Options

General JVM options can be passed to the Minecraft Server invocation by passing a `JVM_OPTS`
environment variable. The JVM requires `-XX` options to precede `-X` options, so those can be declared in `JVM_XX_OPTS`. Both variables are space-delimited, raw JVM arguments.

```
docker run ... -e JVM_OPTS="-someJVMOption someJVMOptionValue" ...
```

**NOTE** When declaring `JVM_OPTS` in a compose file's `environment` section with list syntax, **do not** include the quotes:

```yaml
    environment:
      - EULA=true
      - JVM_OPTS=-someJVMOption someJVMOptionValue 
```

Using object syntax is recommended and more intuitive:

```yaml
    environment:
      EULA: "true"
      JVM_OPTS: "-someJVMOption someJVMOptionValue"
# or
#     JVM_OPTS: -someJVMOption someJVMOptionValue
```

As a shorthand for passing several system properties as `-D` arguments, you can instead pass a comma separated list of `name=value` or `name:value` pairs with `JVM_DD_OPTS`. (The colon syntax is provided for management platforms like Plesk that don't allow `=` inside a value.)

For example, instead of passing

```yaml
  JVM_OPTS: -Dfml.queryResult=confirm -Dname=value
```

you can use

```yaml
  JVM_DD_OPTS: fml.queryResult=confirm,name=value
```

### Extra Arguments

Arguments that would usually be passed to the jar file (those which are written after the filename) can be passed via the `EXTRA_ARGS` environment variable.

See [Custom worlds directory path](../misc/world-data.md#custom-worlds-directory-path) for an example.

### Interactive and Color Console

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

### Server Shutdown Options

To allow time for players to finish what they're doing during a graceful server shutdown, set `STOP_SERVER_ANNOUNCE_DELAY` to a number of seconds to delay after an announcement is posted by the server.

> **NOTE** be sure to adjust Docker's shutdown timeout accordingly, such as using [the -t option on docker-compose down](https://docs.docker.com/compose/reference/down/).

### OpenJ9 Specific Options

The openj9 image tags include specific variables to simplify configuration:

- `-e TUNE_VIRTUALIZED=TRUE` : enables the option to
  [optimize for virtualized environments](https://www.eclipse.org/openj9/docs/xtunevirtualized/)
- `-e TUNE_NURSERY_SIZES=TRUE` : configures nursery sizes where the initial size is 50%
  of the `MAX_MEMORY` and the max size is 80%.

### Enabling rolling logs

By default the vanilla log file will grow without limit. The logger can be reconfigured to use a rolling log files strategy by using:

```
  -e ENABLE_ROLLING_LOGS=true
```

> **NOTE** this will interfere with interactive/color consoles [as described in the section above](#interactive-and-color-console)

### Timezone Configuration

You can configure the timezone to match yours by setting the `TZ` environment variable:

        -e TZ=Europe/London

such as:

        docker run -d -it -e TZ=Europe/London -p 25565:25565 --name mc itzg/minecraft-server

Or mounting `/etc/timezone` as readonly (not supported on Windows):

        -v /etc/timezone:/etc/timezone:ro

such as:

        docker run -d -it -v /etc/timezone:/etc/timezone:ro -p 25565:25565 --name mc itzg/minecraft-server

### Enable Remote JMX for Profiling

To enable remote JMX, such as for profiling with VisualVM or JMC, add the environment variable `ENABLE_JMX=true`, set `JMX_HOST` to the IP/host running the Docker container, and add a port forwarding of TCP port 7091, such as:

```
-e ENABLE_JMX=true -e JMX_HOST=$HOSTNAME -p 7091:7091
```

### Enable Aikar's Flags

[Aikar has done some research](https://aikar.co/2018/07/02/tuning-the-jvm-g1gc-garbage-collector-flags-for-minecraft/) into finding the optimal JVM flags for GC tuning, which becomes more important as more users are connected concurrently. The set of flags documented there can be added using

    -e USE_AIKAR_FLAGS=true

When `MEMORY` is greater than or equal to 12G, then the Aikar flags will be adjusted according to the article.

### HTTP Proxy

You may configure the use of an HTTP/HTTPS proxy by passing the proxy's URL via the `PROXY`
environment variable. In [the example compose file](https://github.com/itzg/docker-minecraft-server/blob/master/examples/docker-compose-proxied.yml) it references
a companion squid proxy by setting the equivalent of

    -e PROXY=proxy:3128

### Using "noconsole" option

Some older versions (pre-1.14) of Spigot required `--noconsole` to be passed when detaching stdin, which can be done by setting `-e CONSOLE=FALSE`.

### Explicitly disable GUI

Some older servers get confused and think that the GUI interface is enabled. You can explicitly
disable that by passing `-e GUI=FALSE`.

### Stop Duration

When the container is signalled to stop, the Minecraft process wrapper will attempt to send a "stop" command via RCON or console and waits for the process to gracefully finish. By default it waits 60 seconds, but that duration can be configured by setting the environment variable `STOP_DURATION` to the number of seconds.

### Setup only

If you are using a host-attached data directory, then you can have the image setup the Minecraft server files and stop prior to launching the server process by setting `SETUP_ONLY` to `true`. 
    
### Enable Flare Flags
    
To enable the JVM flags required to fully support the [Flare profiling suite](https://blog.airplane.gg/flare), set the following variable:
    
    -e USE_FLARE_FLAGS=true
    
Flare is built-in to Pufferfish/Purpur, and is available in [plugin form](https://github.com/TECHNOVE/FlarePlugin) for other server types.

### Enable support for optimized SIMD operations

To enable support for optimized SIMD operations, the JVM flag can be set with the following variable:

    -e USE_SIMD_FLAGS=true

SIMD optimized operations are supported by Pufferfish and Purpur.

### Enable timestamps in init logs

Before the container starts the Minecraft Server its output is prefixed with `[init]`, such as

```
[init] Starting the Minecraft server...
```

To also include the timestamp with each log, set `LOG_TIMESTAMP` to "true". The log output will then look like:

```
[init] 2022-02-05 16:58:33+00:00 Starting the Minecraft server...
```

### Auto-execute RCON commands

RCON commands can be configured to execute when the server starts, a client connects, or a client disconnects.

!!! note

    When declaring several commands within a compose file environment variable, it's easiest to use YAML's `|-` [block style indicator](https://yaml-multiline.info/).

**On Server Start:**

``` yaml
      RCON_CMDS_STARTUP:  |-
        gamerule doFireTick false
        pregen start 200
```

**On Client Connection:**

``` yaml
      RCON_CMDS_ON_CONNECT:  |-
        team join New @a[team=]
```

**Note:**
* On client connect we only know there was a connection, and not who connected. RCON commands will need to be used for that.

**On Client Disconnect:**

``` yaml
      RCON_CMDS_ON_DISCONNECT:  |-
        gamerule doFireTick true
```

**On First Client Connect**

``` yaml
      RCON_CMDS_FIRST_CONNECT: |-
        pregen stop
```

**On Last Client Disconnect**

``` yaml
      RCON_CMDS_LAST_DISCONNECT: |-
        kill @e[type=minecraft:boat]
        pregen start 200

```

**Example of rules for new players**

Uses team NEW and team OLD to track players on the server. So move player with no team to NEW, run a command, move them to team OLD.
[Reference Article](https://www.minecraftforum.net/forums/minecraft-java-edition/redstone-discussion-and/2213523-detect-players-first-join)

``` yaml
      RCON_CMDS_STARTUP:  |-
        /pregen start 200
        /gamerule doFireTick false
        /team add New
        /team add Old
      RCON_CMDS_ON_CONNECT: |-
        /team join New @a[team=]
        /give @a[team=New] birch_boat
        /team join Old @a[team=New]
      RCON_CMDS_FIRST_CONNECT: |-
        /pregen stop
      RCON_CMDS_LAST_DISCONNECT: |-
        /kill @e[type=minecraft:boat]
        /pregen start 200
```
