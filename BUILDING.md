Ensure buildx/BuildKit support is enabled and run:

```
docker buildx build --platform=linux/arm64 --platform=linux/arm/v7 --platform=linux/amd64 --tag itzg/minecraft-server:multiarch --push .
```
