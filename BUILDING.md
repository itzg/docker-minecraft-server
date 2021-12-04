Ensure buildx/BuildKit support is enabled and run:

```shell script
docker buildx build --platform=linux/arm64 --platform=linux/arm/v7 --platform=linux/amd64 --tag itzg/minecraft-server:multiarch --push .
```

To build for local testing, use:

```shell script
docker buildx build --platform=linux/amd64 --tag mc-multiarch --load .
```
