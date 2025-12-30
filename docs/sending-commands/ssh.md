---
title: Over SSH
---

The container can host an SSH console. It is enabled by setting `ENABLE_SSH` to `true`.
The SSH server only supports password based authentication. The password is the same as the RCON password.

!!! question
    See [the RCON password](../configuration/server-properties.md/#rcon-password) section under configuration/server-properties for more information on how to set an RCON password.

The SSH server runs on port `2222` inside the container.

??? tip "Tip: Remember to forward the SSH port to the host"

    ```yaml title="compose.yaml"
    services:
      mc:
        ports:
          - '25565:25565'
          - '2222:2222'
    ```

## Connecting

Connecting should be as simple as running
```bash
ssh anyuser@127.0.0.1 -p 2222
```
and typing in the RCON password.

## Environment variables

| Environment Variable | Usage                     | Default |
| -------------------- | ------------------------- | ------- |
| `ENABLE_WEBSOCKET`   | Enable remote SSH console | `false` |


## Example

```yaml title="compose.yaml"
services:
  mc:
    image: itzg/minecraft-server:latest
    pull_policy: daily
    tty: true
    stdin_open: true
    ports:
      - "25565:25565"
      - "2222:2222"
    environment:
      EULA: "TRUE"
      ENABLE_SSH: true
      RCON_PASSWORD: "my-very-secure-password"
    volumes:
      # attach the relative directory 'data' to the container's /data path
      - ./data:/data
```
