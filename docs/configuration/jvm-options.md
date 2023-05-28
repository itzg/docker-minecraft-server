# JVM Options

## Memory Limit

By default, the image declares an initial and maximum Java memory-heap limit of 1 GB. There are several ways to adjust the memory settings:

- `MEMORY`: "1G" by default, can be used to adjust both initial (`Xms`) and max (`Xmx`) memory heap settings of the JVM
- `INIT_MEMORY`: independently sets the initial heap size
- `MAX_MEMORY`: independently sets the max heap size

The values of all three are passed directly to the JVM and support format/units as `<size>[g|G|m|M|k|K]`. For example:

    -e MEMORY=2G

To let the JVM calculate the heap size from the container declared memory limit, unset `MEMORY` with an empty value, such as `-e MEMORY=""`. By default, the JVM will use 25% of the container memory limit as the heap limit; however, as an example the following would tell the JVM to use 75% of the container limit of 2GB of memory:

     -e MEMORY="" -e JVM_XX_OPTS="-XX:MaxRAMPercentage=75" -m 2000M

!!! important
    The settings above only set the Java **heap** limits. Memory resource requests and limits on the overall container should also account for non-heap memory usage. An extra 25% is [a general best practice](https://dzone.com/articles/best-practices-java-memory-arguments-for-container).

## Extra JVM Options

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

## Enable Remote JMX for Profiling

To enable remote JMX, such as for profiling with VisualVM or JMC, add the environment variable `ENABLE_JMX=true`, set `JMX_HOST` to the IP/host running the Docker container, and add a port forwarding of TCP port 7091, such as:

```
-e ENABLE_JMX=true -e JMX_HOST=$HOSTNAME -p 7091:7091
```

## Enable Aikar's Flags

[Aikar has done some research](https://aikar.co/2018/07/02/tuning-the-jvm-g1gc-garbage-collector-flags-for-minecraft/) into finding the optimal JVM flags for GC tuning, which becomes more important as more users are connected concurrently. The set of flags documented there can be added using

    -e USE_AIKAR_FLAGS=true

When `MEMORY` is greater than or equal to 12G, then the Aikar flags will be adjusted according to the article.
