# Podman Quadlet Example

This example demonstrates how to deploy multiple autoscaling minecraft servers behind mc-router with podman quadlets.

## mc-router.host label

In `mc@.container`, replace `example.com` with your domain.

## Server instance configuration

Each server instance requries an environment file with a matching name in the mc folder; e.g. instance `example` uses `mc/example.env`.

## Container auto-removal fix

Once the quadlets files are installed and daemon-reloaded, the generated service file needs to be edited due to generated quadlets always adding `--rm`.[^1]
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
systemctl --user enable --now mc@example.service mc-router.service
```

## Rootless notes

If running rootless, be sure to enable lingering with `sudo loginctl enable-linger $USER`.

Also note that source IPs are currently lost due to how rootless podman handles custom networks.
This should be fixed in a future podman release.[^2]

[^1]: <https://github.com/podman-container-tools/podman/discussions/28837>
[^2]: <https://github.com/podman-container-tools/podman/pull/28478>
