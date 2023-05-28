To troubleshoot the container initialization, such as when server files are pre-downloaded, set the environment variable `DEBUG` to `true`. The container logs will include **much more** output, and it is highly recommended including that output when reporting any [issues](https://github.com/itzg/docker-minecraft-server/issues).

To troubleshoot just the command-line used to start the Minecraft server, set the environment variable `DEBUG_EXEC` to `true`.

To troubleshoot any issues with memory allocation reported by the JVM, set the environment variable `DEBUG_MEMORY` to `true`.
