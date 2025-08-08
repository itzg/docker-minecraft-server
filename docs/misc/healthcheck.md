## Healthcheck

This image contains [mc-monitor](https://github.com/itzg/mc-monitor) and uses its `status` command to continually check on the container's. That can be observed from the `STATUS` column of `docker ps`

```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                    PORTS                                 NAMES
b418af073764        mc                  "/start"            43 seconds ago      Up 41 seconds (healthy)   0.0.0.0:25565->25565/tcp, 25575/tcp   mc
```

You can also query the container's health in a script-friendly way:

``` shell
> docker container inspect -f "{{.State.Health.Status}}" mc
healthy
```

There's actually a wrapper script called `mc-health` that takes care of calling `mc-monitor status` with the correct arguments. If needing to customize the health checks parameters, such as in a Compose file, then use something like the following in the service declaration:

``` yaml
healthcheck:
  test: mc-health
  start_period: 1m
  interval: 5s
  retries: 20
```

Some orchestration systems, such as Portainer, don't allow for disabling the default `HEALTHCHECK` declared by this image. In those cases you can approximate the disabling of health checks by setting the environment variable `DISABLE_HEALTHCHECK` to `true`.

The [health check in a Compose service declaration](https://docs.docker.com/reference/compose-file/services/#healthcheck) can also be disabled using:

```yaml
    healthcheck:
      disable: true
      test: ["NONE"]
```

### Health checks for older versions

This container disables health checks for Minecraft versions before b1.8 as those versions do not support any kind of server pinging. For more information see [Server List Ping](https://minecraft.wiki/w/Java_Edition_protocol/Server_List_Ping#Beta_1.8_to_1.3).
