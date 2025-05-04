To troubleshoot the container initialization, such as when server files are pre-downloaded, set the environment variable `DEBUG` to `true`. The container logs will include **much more** output, and it is highly recommended including that output when reporting any [issues](https://github.com/itzg/docker-minecraft-server/issues).

To troubleshoot just the command-line used to start the Minecraft server, set the environment variable `DEBUG_EXEC` to `true`.

To troubleshoot any issues with memory allocation reported by the JVM, set the environment variable `DEBUG_MEMORY` to `true`.

If you are experiencing any issues with the "Changing ownership of /data" step, that can be disabled by setting `SKIP_CHOWN_DATA` to `true`.

To confirm the image version that has been pulled, use the following command, replacing `itzg/minecraft-server` as needed for specific image tags:

## Image labels

```shell
docker image inspect itzg/minecraft-server -f "{{json .Config.Labels}}"
```

such as

```json
{
  "org.opencontainers.image.authors": "... <...@gmail.com>",
  "org.opencontainers.image.created": "2025-04-03T02:15:51.405Z",
  "org.opencontainers.image.description": "Docker image that provides a Minecraft Server for Java Edition that automatically downloads selected version at startup",
  "org.opencontainers.image.licenses": "Apache-2.0",
  "org.opencontainers.image.ref.name": "ubuntu",
  "org.opencontainers.image.revision": "d6897a649ecbc16b5fb2e1500e24b64ef80270a0",
  "org.opencontainers.image.source": "https://github.com/itzg/docker-minecraft-server",
  "org.opencontainers.image.title": "docker-minecraft-server",
  "org.opencontainers.image.url": "https://github.com/itzg/docker-minecraft-server",
  "org.opencontainers.image.version": "java21"
}
```

The labels that are most interesting are:

- `org.opencontainers.image.created` : the date/time the image was built
- `org.opencontainers.image.revision` : which maps to <https://github.com/itzg/docker-minecraft-server/commit/REVISION>
- `org.opencontainers.image.version` : image tag and variant [as described in this page](../versions/java.md)