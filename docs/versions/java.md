## Image tags

Image references can either omit the tag, which implies the tag `latest`, such as

    itzg/minecraft-server

or explicitly include the tag, such as

    itzg/minecraft-server:<tag>

where `<tag>` refers to the first column of this table:

| Tag            | Java version | Linux  | JVM Type           | Architecture        | Note |
|----------------|--------------|--------|--------------------|---------------------|------|
| latest         | 21           | Ubuntu | Hotspot            | amd64, arm64        |      |
| stable         | 21           | Ubuntu | Hotspot            | amd64, arm64        |      |
| java24         | 24           | Ubuntu | Hotspot            | amd64, arm64        | (2)  |
| java24-graalvm | 24           | Oracle | Oracle GraalVM (3) | amd64, arm64        | (2)  |   
| java21         | 21           | Ubuntu | Hotspot            | amd64, arm64        |      |
| java21-jdk     | 21           | Ubuntu | Hotspot+JDK        | amd64, arm64        |      |
| java21-alpine  | 21           | Alpine | Hotspot            | amd64, arm64        |      |
| java21-graalvm | 21           | Oracle | Oracle GraalVM (3) | amd64, arm64        |      |   
| java17         | 17           | Ubuntu | Hotspot            | amd64, arm64, armv7 |      |
| java17-graalvm | 17           | Oracle | Oracle GraalVM (3) | amd64, arm64        |      |   
| java17-alpine  | 17           | Alpine | Hotspot            | amd64  (1)          |      |
| java16         | 16           | Ubuntu | Hotspot            | amd64, arm64, armv7 | (4)  |
| java11         | 11           | Ubuntu | Hotspot            | amd64, arm64, armv7 |      |
| java8          | 8            | Ubuntu | Hotspot            | amd64, arm64, armv7 |      |

Notes

1. Why no arm64 for Java 17 Alpine? That is because the base images, such as [elipse-temurin](https://hub.docker.com/_/eclipse-temurin/tags?page=&page_size=&ordering=&name=17-jre-alpine) do not provide support for that. Use the Ubuntu based images instead.
2. Short-term variant, subject to deprecation upon next version introduction
3. Based on the [Oracle GraalMV images](https://blogs.oracle.com/java/post/new-oracle-graalvm-container-images), which as of JDK 17, are now under the [GraalVM Free License](https://blogs.oracle.com/java/post/graalvm-free-license) incorporating what used to be known as the GraalVM Enterprise.
4. This version of Java is [recommended for PaperMC 1.16.5](https://docs.papermc.io/paper/getting-started/#requirements)

!!! example "Example using java8"

    With docker run command-line
    
    ```
    docker run -it -e EULA=true itzg/minecraft-server:java8
    ```
    
    or in a compose file
    
    ```yaml
    services:
      mc:
        image: itzg/minecraft-server:java8
    ```

!!! note "Latest"

    The "latest" tag shifts to include not only the latest features and bug fixes, but also the latest Java version that Mojang requires for the latest Minecraft version.

!!! tip "Class File Version"

    If the Minecraft startup is logging an error about a "class file version", then refer [to this table](https://javaalmanac.io/bytecode/versions/) to identify the JDK/Java version corresponding to each class file version.

### Release versions

Since the tags referenced above will shift as the newest image build brings in new features and bug fixes, released variants of those can also be used to pin a specific build of the image.

The syntax of released image tags is:

    itzg/minecraft-server:<release>-<java tag>

where `java tag` still refers to the first column of the table above and `release` refers to [one of the image releases](https://github.com/itzg/docker-minecraft-server/releases).

!!! example

    For example, the 2024.4.0 release of the Java 17 image would be
    
    ```
    itzg/minecraft-server:2024.4.0-java17
    ```

### Stable image tag

The `stable` image tag combines the benefits of `latest` and [release versions](#release-versions) since it shifts to refer to the most recently released version. There is also a per-variant stable tag, formatted as `stable-{variant}`.

## Version compatibilities

[This section in the Minecraft wiki](https://minecraft.wiki/w/Tutorials/Update_Java#Why_update?) lists out versions of **vanilla** Minecraft versions and the corresponding Java version that is required.

### Class file version 65.0

If encountering a startup failure similar to the following examples, then ensure that the latest image has been re-pulled to use a Java 21. Alternatively, set the image tag specifically to `itzg/minecraft-server:java21`.

> Exception in thread "ServerMain" java.lang.UnsupportedClassVersionError: org/bukkit/craftbukkit/Main has been compiled by a more recent version of the Java Runtime (class file version 65.0), this version of the Java Runtime only recognizes class file versions up to 61.0

or

> Error: LinkageError occurred while loading main class net.minecraft.bundler.Main
java.lang.UnsupportedClassVersionError: net/minecraft/bundler/Main has been compiled by a more recent version of the Java Runtime (class file version 65.0), this version of the Java Runtime only recognizes class file versions up to 61.0


### Forge versions

Forge and its mods sometimes utilize non-public APIs of the JVM and as such are suspceptible to becoming broken with newer Java versions.

#### Java 21

Some mods even up to Minecraft 1.21 require Java 17 and will not run on the latest Java version. If you see an error like the following then be sure to explicitly use a Java 17 tagged image:

```
Caused by: org.spongepowered.asm.mixin.throwables.ClassMetadataNotFoundException: java.util.List
	at MC-BOOTSTRAP/org.spongepowered.mixin/org.spongepowered.asm.mixin.transformer.MixinPreProcessorStandard.transformMethod(MixinPreProcessorStandard.java:754)
```

#### Java 8

For Forge versions less than 1.18, you _must_ use the `java8-multiarch` (or other java8) image tag.

In general, if you see the following line in a server startup failure, then it means you need to be using Java 8 instead of the latest image Java version:

```
Caused by: java.lang.ClassCastException: class jdk.internal.loader.ClassLoaders$AppClassLoader 
   cannot be cast to class java.net.URLClassLoader
```

Forge also doesn't support openj9 JVM implementation.

## Deprecated Image Tags

The following image tags have been deprecated and are no longer receiving updates:

- adopt13
- adopt14
- adopt15
- openj9-nightly
- multiarch-latest
- java16-openj9
- java17-graalvm-ce
- java17-openj9
- java19
- java20-graalvm, java20, java20-alpine
- java23-*
- java8-multiarch is still built and pushed, but please move to java8 instead
- java8-alpine, java8-jdk, java8-openj9, java8-graalvm-ce
