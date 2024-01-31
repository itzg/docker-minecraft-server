## Running Minecraft server on different Java version

!!! note

    For Forge versions less than 1.18, you _must_ use the `java8-multiarch` (or other java8) image tag.

    In general, if you see the following line in a server startup failure, then it means you need to be using Java 8 instead of the latest image Java version:

    ```
    Caused by: java.lang.ClassCastException: class jdk.internal.loader.ClassLoaders$AppClassLoader 
       cannot be cast to class java.net.URLClassLoader
    ```

When using the image `itzg/minecraft-server` without a tag, the `latest` image tag is implied from the table below. To use a different version of Java, please use an alternate tag to run your Minecraft server container. The `stable` tag is similar to `latest`; however, it tracks [the most recent repository release/tag](https://github.com/itzg/docker-minecraft-server/releases/latest).

| Tag name         | Java version | Linux  | JVM Type           | Architecture      |
|------------------|--------------|--------|--------------------|-------------------|
| latest           | 17           | Ubuntu | Hotspot            | amd64,arm64,armv7 |
| stable           | 17           | Ubuntu | Hotspot            | amd64,arm64,armv7 |
| java8            | 8            | Alpine | Hotspot            | amd64             |
| java8-jdk        | 8            | Ubuntu | Hotspot+JDK        | amd64             |
| java8-multiarch  | 8            | Ubuntu | Hotspot            | amd64,arm64,armv7 |
| java8-openj9     | 8            | Debian | OpenJ9             | amd64             |
| java8-graalvm-ce | 8            | Oracle | GraalVM CE         | amd64             |
| java11           | 11           | Ubuntu | Hotspot            | amd64,arm64,armv7 |
| java11-jdk       | 11           | Ubuntu | Hotspot+JDK        | amd64,arm64,armv7 |
| java11-openj9    | 11           | Debian | OpenJ9             | amd64             |
| java17           | 17           | Ubuntu | Hotspot            | amd64,arm64,armv7 |
| java17-jdk       | 17           | Ubuntu | Hotspot+JDK        | amd64,arm64,armv7 |
| java17-openj9    | 17           | Debian | OpenJ9             | amd64             |
| java17-graalvm   | 17           | Oracle | Oracle GraalVM[^1] | amd64,arm64       |   
| java17-alpine    | 17           | Alpine | Hotspot            | amd64             |
| java21-alpine    | 21           | Alpine | Hotspot            | amd64             |
| java21           | 21           | Ubuntu | Hotspot            | amd64,arm64       |
| java21-graalvm   | 21           | Oracle | Oracle GraalVM[^1] | amd64,arm64       |   

For example, to use Java version 8 on any supported architecture:

    docker run --name mc itzg/minecraft-server:java8-multiarch

!!! note

    Keep in mind that some versions of Minecraft server, such as Forge before 1.17, can't work on the newest versions of Java. Instead, one of the Java 8 images should be used. Also, FORGE doesn't support openj9 JVM implementation.
    
    Some versions of vanilla Minecraft, such as 1.10, also do not run correctly with Java 17. If in doubt, use `java8-multiarch` for any version less than 1.17.

### Deprecated Image Tags

The following image tags have been deprecated and are no longer receiving updates:
- java19
- adopt13
- adopt14
- adopt15
- openj9-nightly
- multiarch-latest
- java16/java16-openj9
- java17-graalvm-ce
- java20-graalvm, java20, java20-alpine

[^1]: Based on the [Oracle GraalMV images](https://blogs.oracle.com/java/post/new-oracle-graalvm-container-images), which as of JDK 17, are now under the [GraalVM Free License](https://blogs.oracle.com/java/post/graalvm-free-license) incorporating what used to be known as the GraalVM Enterprise. 