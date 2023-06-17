
## Building image locally with alternate Java base

The following shows how to change the base Java image used by the build:

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
