# Auto-Stop

An option to stop the server after a specified time has been added for niche applications (e.g. billing saving on AWS Fargate). The function is incompatible with the Autopause functionality, as they basically cancel out each other.

!!! note

    the docker container variables have to be set accordingly (restart policy set to "no") and that the container has to be manually restarted.

A `.skip-stop` file can be created in the `/data` directory to make the server skip autostopping, for as long as the file is present. The autostop timer will also be reset.

A starting, example compose file has been provided in [examples/docker-compose-autostop.yml](https://github.com/itzg/docker-minecraft-server/blob/master/examples/docker-compose-autostop.yml).

Enable the Autostop functionality by setting:

```
-e ENABLE_AUTOSTOP=TRUE
```

The following environment variables define the behavior of auto-stopping:
- `AUTOSTOP_TIMEOUT_EST`, default `3600` (seconds)
  describes the time between the last client disconnect and the stopping of the server (read as timeout established)
- `AUTOSTOP_TIMEOUT_INIT`, default `1800` (seconds)
  describes the time between server start and the stopping of the server, when no client connects in-between (read as timeout initialized)
- `AUTOSTOP_PERIOD`, default `10` (seconds)
  describes period of the daemonized state machine, that handles the stopping of the server
- `AUTOPAUSE_STATUS_RETRY_LIMIT`, default 10
- `AUTOPAUSE_STATUS_RETRY_INTERVAL`, default 2s

> To troubleshoot, add `DEBUG_AUTOSTOP=true` to see additional output

## Proxy Support
If you make use of PROXY Protocol, i.e. through something like HAProxy or Fly.io, you will need to enable it in your variety of server's configuration, and then set the `USES_PROXY_PROTOCOL` envar to `true`. This lets Autostop monitor the server, where it otherwise wouldn't
