---
title: Sending commands
---

[RCON](http://wiki.vg/RCON) is enabled by default, so you can `exec` into the container to
access the Minecraft server console:

```
docker exec -i mc rcon-cli
```

Note: The `-i` is required for interactive use of rcon-cli.

To run a simple, one-shot command, such as stopping a Minecraft server, pass the command as arguments to `rcon-cli`, such as:

```
docker exec mc rcon-cli stop
```

_The `-i` is not needed in this case._

## When RCON is disabled

If rcon is disabled you can send commands by passing them as arguments to the packaged `mc-send-to-console` script after setting the env var `CREATE_CONSOLE_IN_PIPE` to "true". For example, a player can be op'ed in the container `mc` with: 

```shell
docker exec --user 1000 mc mc-send-to-console op player
            |                     |
            +- container name     +- Minecraft commands start here
```

## Enabling interactive console

In order to attach and interact with the Minecraft server make sure to enable TTY and keep stdin open.

!!! example

    With `docker run` use the `-it` arguments:

    ```shell
    docker run -d -it -p 25565:25565 --name mc itzg/minecraft-server
    ```

    or with a compose file:

    ```yaml
    services:
      minecraft:
        stdin_open: true
        tty: true
    ```

With that you can attach and interact at any time using the following, replacing the `{...}` placeholders.

...when container is created with `docker run`
```
docker attach {container name or ID}
```

...or when declared using a compose file
```
docker compose attach {service name}
```

and then Control-p Control-q to **detach**.

!!! info "RCON is required for fully interactive, color console"

    RCON must be enabled, which is the default, in order to use a fully interactive console with auto-completion and colorized log output. 