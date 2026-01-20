
# Autoscaling (sleep when idle)

Autoscaling (sometimes called *sleeping*, *scale to zero* or *wake on join*) is the pattern of stopping a Minecraft server when nobody is playing and starting it again when someone tries to connect with the intention of saving resources when the server is not in use (e.g., on a VPS with limited CPU/RAM or a home server).

## mc-router

[mc-router](https://github.com/itzg/mc-router) is a Minecraft-aware router/multiplexer.

- Routes players by the hostname they connect with (useful for multiple servers behind one port)
- Can auto-start a backend container on join and stop it again after an idle timeout

Examples:

- See the mc-router section in [Examples](../examples.md#mc-router-with-auto-scale)

## Lazymc

[Lazymc](https://github.com/timvisee/lazymc) can keep a server “asleep” until a player connects. With Docker it’s commonly used via [lazymc-docker-proxy](https://github.com/joesturge/lazymc-docker-proxy).

- Players connect to the proxy; the proxy starts/stops the server container
- Usually requires a static IP for the Minecraft container on a user-defined network

Example:

- See the Lazymc section in [Examples](../examples.md#lazymc-put-your-minecraft-server-to-rest-when-idle)

## Lazytainer

[Lazytainer](https://github.com/vmorganp/Lazytainer) starts/stops containers based on network traffic.

- Uses packet thresholds + inactivity timeouts (not Minecraft hostname aware)
- Can be triggered by port scans/pings in noisy environments

Example:

- See the Lazytainer section in [Examples](../examples.md#lazytainer-stop-minecraft-container-based-on-traffic)


