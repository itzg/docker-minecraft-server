To use a different Minecraft version, pass the `VERSION` environment variable (case sensitive), which can have the value

- `LATEST` for latest release (the default)
- `SNAPSHOT` for latest snapshot
- a specific legacy version, such as `1.7.9`, `25w35a`, `1.15.2-pre2` or `1.21.11-rc1`
- a specific [new version numbering system](https://www.minecraft.net/en-us/article/minecraft-new-version-numbering-system) version like `26.1`, `26.1-snapshot-1`, `26.1-pre-1`, or `26.1-rc-1`
- or an alpha and beta version, such as "b1.7.3" (server download might not exist)

For example, to use the latest snapshot:

```
docker run -d -e VERSION=SNAPSHOT ...
```

or a specific version:

```
docker run -d -e VERSION=1.7.9 ...
```

When using "LATEST" or "SNAPSHOT" an upgrade can be performed by simply restarting the container.
During the next startup, if a newer version is available from the respective release channel, then
the new server jar file is downloaded and used. 

!!! note

    Over time you might see older versions of the server jar remain in the `/data` directory. It is safe to remove those.
