---
title: Over SSH
---

The container can host an SSH console. It is enabled by setting `ENABLE_SSH` to `true`.
The SSH server only supports password based authentication. The password is the same as the RCON password.

!!! question
    See [the RCON password](../configuration/server-properties.md/#rcon-password) section under configuration/server-properties for more information on how to set an RCON password.

The SSH server runs on port `2222` inside the container.

??? tip "Tip: Exposing the SSH port"

    !!! warning "Security Implications"
        By default, publishing ports in Docker binds them to all network interfaces (`0.0.0.0`), making the SSH console accessible to any device that can reach your host machine.
        
        Since the SSH console grants **full administrative access** to your server, it is critical to use a strong [RCON password](../configuration/server-properties.md/#rcon-password). 
        
        If you wish to restrict access to the local machine only, refer to the [Docker documentation](https://docs.docker.com/engine/network/port-publishing/#publishing-ports) on binding to specific IP addresses (e.g., `127.0.0.1:2222:2222`).
      
        If SSH access is only intended for inter-container connections, consider **NOT** forwarding the port to the host machine, and putting the containers in a shared [Docker network](https://docs.docker.com/engine/network/#user-defined-networks).

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
| `ENABLE_SSH`   | Enable remote SSH console | `false` |


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
      RCON_PASSWORD_FILE: /run/secrets/rcon_pass
    volumes:
      # attach the relative directory 'data' to the container's /data path
      - ./data:/data
    
secrets:
  rcon_pass:
    file: ./rcon_password
```
