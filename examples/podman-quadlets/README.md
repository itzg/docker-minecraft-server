# Podman Quadlet Example

This example demonstrates how to deploy multiple autoscaling minecraft servers behind mc-router with [podman quadlets](https://docs.podman.io/en/stable/markdown/podman-systemd.unit.5.html).

## mc-router.host label

In `mc@.container`, replace `example.com` with your domain.

## Server instance configuration

Each server instance requries an environment file with a matching name in the mc folder; e.g. instance `example` uses `mc/example.env`.[^1]

## Container auto-removal fix

Once the quadlets files are installed and daemon-reloaded, the generated service file needs to be edited due to generated quadlets always adding `--rm`.[^2]
To fix this, run `systemctl --user edit mc@.service` and replace the `ExecStart` entry with a copy that substitues `--restart=unless-stopped` where `--rm` is.
The  drop-in should look something like this:

```ini
[Service]
ExecStart=
ExecStart=/usr/bin/podman run --name %p-%i --replace --restart=unless-stopped ...
```

## Start containers/services

```sh
systemctl --user enable --now podman.socket
systemctl --user start mc@example.service mc-router.service
# instances are enabled by symlinking from the template
ln -s ${XDG_CONFIG_HOME}/containers/systemd/mc@.service ${XDG_CONFIG_HOME}/containers/systemd/mc@example.service
```

## Rootless notes

If running rootless, be sure to enable lingering with `sudo loginctl enable-linger $USER`.

Also note that source IPs are currently lost due to how rootless podman handles custom networks.
This should be fixed in a future podman release.[^3]

[^1]: The base config is a [template file](https://docs.podman.io/en/stable/markdown/podman-systemd.unit.5.html#template-files) with instance names after the @ sign .
[^2]: <https://github.com/podman-container-tools/podman/discussions/28837>
[^3]: <https://github.com/podman-container-tools/podman/pull/28478>
