
## Simple image additions

You can easily build upon the base image using an inline Dockerfile.

```yaml title="compose.yaml"
services:
  mc:
    build:
      context: .
      dockerfile_inline: |
        FROM itzg/minecraft-server:latest

        RUN apt-get update && apt-get install -y \
            webp \
            && rm -rf /var/lib/apt/lists/*
      pull: true # Always pull new base image
    pull_policy: build
    restart: unless-stopped
    environment:
      EULA: true
    ports:
      - "25565:25565/tcp"
    volumes:
      - ./data:/data
```

Here is an example to add Nvidia GPU support for C2ME:

??? Example "C2ME GPU example"
    ```yaml title="compose.yaml"
    
    services:
      mc:
        build:
          context: .
          dockerfile_inline: |
            FROM itzg/minecraft-server:java25
    
            # Install OpenCL loader and NVIDIA driver capabilities
            RUN apt-get update && apt-get install -y \
                ocl-icd-libopencl1 \
                opencl-headers \
                clinfo \
                && rm -rf /var/lib/apt/lists/*
    
            # 1. Create the vendor directory
            # 2. Tell OpenCL to use the NVIDIA library
            RUN mkdir -p /etc/OpenCL/vendors && \
                echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd
    
            # Tell the NVIDIA container runtime to expose all GPU capabilities (including compute/utility)
            ENV NVIDIA_VISIBLE_DEVICES all
            ENV NVIDIA_DRIVER_CAPABILITIES compute,utility,graphics,video
    
            COPY ./mods /mods
          pull: true # Always pull new base image
        pull_policy: build
        restart: unless-stopped
        deploy:
          resources:
            reservations:
              devices:
                - driver: nvidia
                  count: 1
                  capabilities: [gpu]
        environment:
          EULA: true
          TYPE: "FABRIC"
          VERSION: 1.21.10
          MEMORY: 8G
          MODRINTH_PROJECTS: |-
            fabric-api
            c2me
        ports:
          - "25565:25565/tcp"
        volumes:
          - ./data:/data
    ```


!!! tip "For advanced use only"

    This page describes a capability that is not applicable to most users. It is only intended for rare cases when a very specific Java base image is needed or additional packages need to be installed that are not generally applicable or would bloat the image size.

    Be sure to confirm that the desired [version and variant of Java isn't already provided](../versions/java.md).

## Building image locally with alternate Java base

An alternate Java base image can be specified by setting the [docker build argument](https://docs.docker.com/reference/cli/docker/buildx/build/#build-arg) `BASE_IMAGE` to the desired base image. The following shows an example of using the base image `ghcr.io/graalvm/graalvm-ce:ol8-java11`:

```shell
docker build --build-arg BASE_IMAGE=ghcr.io/graalvm/graalvm-ce:ol8-java11 -t IMG_PREFIX/minecraft-server:java11-graalvm .
```

## Building a multi-architecture image

Ensure buildx/BuildKit support is enabled and run the following to build multi-architecture and push to the repository as named by the image:

```shell
docker buildx build --platform=linux/arm64 --platform=linux/arm/v7 --platform=linux/amd64 --tag IMG_PREFIX/minecraft-server --push .
```

To build for local images, multi-architecture is not supported, use the following with buildx to load the image into the local daemon:

```shell
docker buildx build --tag IMG_PREFIX/minecraft-server --load .
```

or just a plain build

```shell
docker build -t IMG_PREFIX/minecraft-server .
```

## Installing extra packages

The following build args can be set to install additional packages for the respective base image distro:

- `EXTRA_DEB_PACKAGES`
- `EXTRA_DNF_PACKAGES`
- `EXTRA_ALPINE_PACKAGES`
