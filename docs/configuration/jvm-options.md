# JVM Options

## Memory Limit

By default, the image declares an initial and maximum Java memory-heap limit of 1 GB. There are several ways to adjust the memory settings:

- `MEMORY`: "1G" by default, can be used to adjust both initial (`Xms`) and max (`Xmx`) memory heap settings of the JVM
- `INIT_MEMORY`: independently sets the initial heap size
- `MAX_MEMORY`: independently sets the max heap size

The values of all three are passed directly to the JVM and support format/units as `<size>[g|G|m|M|k|K]`.

To have control over heap size, without relying on absolute memory sizes percentages are also supported using `<size>%`.

!!! info "RAMPercentage parameters"
    Percentage based heap sizing is enabled using `-XX:InitialRAMPercentage` for `INIT_MEMORY` and `-XX:MaxRAMPercentage` for `MAX_MEMORY`.
    For details on the function of these parameters look [here](https://www.baeldung.com/java-jvm-parameters-rampercentage).

!!! example "Using docker run"

    ```
        -e MEMORY=2G
    ```

    or to use init and max memory:

    ```
        -e INIT_MEMORY=1G -e MAX_MEMORY=4G
    ```

!!! example "Using compose file"

    ```
        environment:
          MEMORY: 2G
    ```

    or to use init and max memory:

    ```
        environment:
          INIT_MEMORY: 1G
          MAX_MEMORY: 4G
    ```

To let the JVM calculate the heap size from the container declared memory limit, unset `MEMORY` with an empty value, such as `-e MEMORY=""`. By default, the JVM will use 25% of the container memory limit as the heap limit.

!!! important
    The settings above only set the Java **heap** limits. Memory resource requests and limits on the overall container should also account for non-heap memory usage. An extra 25% is [a general best practice](https://dzone.com/articles/best-practices-java-memory-arguments-for-container).

## Extra JVM Options

General JVM options can be passed to the Minecraft Server invocation by passing a `JVM_OPTS`
environment variable. If needing to set `-XX` options, then pass those with the `JVM_XX_OPTS` variable instead. Both variables accept space-delimited, raw JVM arguments.

```
docker run ... -e JVM_OPTS="-XsomeJVMOption -DpropName=value" ...
```

**NOTE** When declaring `JVM_OPTS` in a compose file's `environment` section with list syntax, **do not** include the quotes:

```yaml
    environment:
      - EULA=true
      - JVM_OPTS=-XsomeJVMOption -DpropName=value
```

Using object syntax is recommended and more intuitive:

```yaml
    environment:
      EULA: "true"
      JVM_OPTS: "-XsomeJVMOption -DpropName=value"
# or without quotes
#     JVM_OPTS: -XsomeJVMOption -DpropName=value
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

## Enable Remote JMX for Profiling

To enable remote JMX, such as for profiling with VisualVM or JMC, set the environment variable `ENABLE_JMX` to "true", set `JMX_HOST` to the IP/host running the Docker container, and add a port forwarding of TCP port 7091, such as:

!!! example

    With `docker run`

    ```
    -e ENABLE_JMX=true -e JMX_HOST=$HOSTNAME -p 7091:7091
    ```

If needing to map to a different port, then also set the environment variable `JMX_PORT` to the desired host port.

!!! example

    With a compose file:

    ```yaml
    environment:
      ENABLE_JMX: true
      JMX_HOST: ${HOSTNAME}
      JMX_PORT: "7092"
    ports:
      - "7092:7092"
    ```

## Enable Aikar's Flags

[Aikar has done some research](https://aikar.co/2018/07/02/tuning-the-jvm-g1gc-garbage-collector-flags-for-minecraft/) into finding the optimal JVM flags for GC tuning, which becomes more important as more users are connected concurrently. [PaperMC also has an explanation](https://docs.papermc.io/paper/aikars-flags) of what the JVM flags are doing.

The set of flags documented there can be added using

    -e USE_AIKAR_FLAGS=true

When `MEMORY` is greater than or equal to 12G, then the Aikar flags will be adjusted according to the article.

## Enable MeowIce's Flags

[MeowIce has created an updated set of JVM flags](https://github.com/MeowIce/meowice-flags?tab=readme-ov-file#why-would-i-have-to-switch-) based on Aikar's flags but with support for optimizations for Java 17 and above

The set of flags documented there can be added by setting the environment variable `USE_MEOWICE_FLAGS` to `true`. There is an optional `USE_MEOWICE_GRAALVM_FLAGS` variable to enable GraalVM specific optimizations, defaults to `FALSE`.
