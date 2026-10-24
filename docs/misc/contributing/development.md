## Adding a server type

Adding a new server `TYPE` can vary due to the complexity of obtaining and configuring each type; however, the addition of any server type includes at least the following steps:

1. Copy an existing "start-deploy*" script, such as [start-deployFabric](https://github.com/itzg/docker-minecraft-server/blob/master/scripts/start-deployFabric) and rename it accordingly making sure to retain the "start-deploy" prefix
2. Modify the type-specific behavior between the "start-utils" preamble and the hand-off to `start-setupWorld` at the end of the script 
3. Develop and test the changes using the [iterative process described below](#iterative-script-development)
4. Add a case-entry to the `case "${TYPE^^}"` in [start-configuration](https://github.com/itzg/docker-minecraft-server/blob/master/scripts/start-configuration)
5. Add a section to the [docs](https://github.com/itzg/docker-minecraft-server/tree/master/docs). It is recommended to copy-modify an existing section to retain a similar wording and level of detail
6. [Submit a pull request](https://github.com/itzg/docker-minecraft-server/pulls)

## Iterative script development

The included `compose-dev.yml` will mount the local `scripts` code into the container and allow for iterative development. Replace `[-e key=value]` with any environment variables you wish to set for testing the modified scripts.

```shell
docker compose -f compose-dev.yml run --rm -it [-e key=value]  mc-dev
```

!!! tip

    To speed up the development cycle, it is recommended to set `SETUP_ONLY` to `true` as part of the run command above.

## Testing changes

Most changes should be covered by a test under `tests/setuponlytests`. Each test scenario needs its own `compose.yml` or `docker-compose.yml`, which defines the container configuration and inputs for that case. These tests run server setup with `SETUP_ONLY=true`, so they can verify configuration, downloads, and generated files without starting Minecraft.

A scenario can include a `require.sh` to check whether its prerequisites are available in the test environment, such as a required environment variable. It runs before the scenario; a non-zero exit status skips that test. For example, this skips a test when `CF_API_KEY` is not set:

```bash title="require.sh"
[[ -n "${CF_API_KEY:-}" ]] || exit 1
```

Since `require.sh` runs on the host, it sees the variables provided by the CI workflow. These are the ones typically checked:

- `EXTENDED_TESTS`: opt-in flag for slower or network-heavy scenarios; the CI workflows don't set it, so those scenarios only run when it is exported locally
- `CF_API_KEY`: CurseForge API key, which is only available to trusted runs
- `MINECRAFT_VERSION`: the Minecraft version of the CI matrix entry, such as `latest` or `1.12.2`
- `VARIANT`: the image variant of the CI matrix entry, such as `java21-alpine`
- `GH_TOKEN`: GitHub token used for API calls that would otherwise be rate limited

A `require_inside.sh` works the same way, but runs inside a container of the image under test, which is useful when a test depends on the image's contents or Java variant. Checking for JVM runtime files is a good use of it. For example, this skips a test that needs the JDWP agent, which some Java variants such as GraalVM do not include:

```bash title="require_inside.sh"
[[ -f /opt/java/openjdk/lib/libjdwp.so ]] || exit 1
```

Add a `verify.sh` to assert that setup produced the expected files or contents. It runs only after setup succeeds, with the scenario's `data` directory mounted at `/data`; a non-zero exit status fails the test. See the [`mc-image-helper assert` command documentation](https://github.com/itzg/mc-image-helper#assert) for available assertions. For example, use it to check that setup downloaded an expected mod:

```bash title="verify.sh"
mc-image-helper assert fileExists "/data/mods/ExplorersCompass-1.16.5-1.1.2-forge.jar"
```

Run the test suite with `tests/test.sh`. For a focused setup-only check, run `bash tests/setuponlytests/test.sh <scenario>` from the repository root, where `<scenario>` is the directory name under `tests/setuponlytests` (for example, `defaults`). The pull request workflow runs the suite, so prefer setup-only tests for new scenarios.

Tests under `tests/fulltests` start Minecraft and wait for the monitor to confirm that the server is healthy. Keep this suite limited to maintained tests that provide essential full-startup coverage; adding every scenario there would increase pull request validation time.

## Building the image with a new release of a tool

In this exapmle, let's say that [mc-image-helper](https://github.com/itzg/mc-image-helper) has been [released](https://github.com/itzg/mc-image-helper/releases) at 1.56.0, but the corresponding changes in the image [scripts](https://github.com/itzg/docker-minecraft-server/tree/23205471db9814cff9c6602361dbc6cdd6c4230a/scripts) need to be tested against that version while updating [the Dockerfile](https://github.com/itzg/docker-minecraft-server/blob/23205471db9814cff9c6602361dbc6cdd6c4230a/Dockerfile#L58).

```yaml title="tests/manual/optional-projects/compose.yml" hl_lines="7"
services:
  mc:
    build:
      # ...or wherever you cloned the docker-minecraft-server repo
      context: ../../..
      args:
        MC_HELPER_VERSION: 1.56.0
    environment:
      EULA: true
      TYPE: "FABRIC"
      MODRINTH_PROJECTS: |
        fabric-api
        pl3xmap?:beta
    ports:
      - "25565:25565/tcp"
    volumes:
      - ./data:/data
```

## Using development copy of tools

In the cloned repo, such as [`mc-image-helper`](https://github.com/itzg/mc-image-helper), install the distribution locally by running:

```shell
./gradlew installDist
```

The distribution will be installed in the project's `build/install/mc-image-helper`. Obtain the absolute path to that directory use in the next step.

Refer to the instructions above to mount any locally modified image scripts or build a local copy of the image using or with alternate `BASE_IMAGE`, as described above:

```shell
docker build -t itzg/minecraft-server .
```

Mount the local mc-image-helper distribution directory as a volume in the container at the path `/usr/share/mc-image-helper`, such as

```shell
docker run -it --rm \
  -v /path/to/mc-image-helper/build/install/mc-image-helper:/usr/share/mc-image-helper \
  -e EULA=true \
  itzg/minecraft-server
```

In a compose file, include the volume mount in the `volumes` section of the container definition:

```yaml
services:
  mc:
    # ... usual container definition
    volumes:
      - /path/to/mc-image-helper/build/install/mc-image-helper:/usr/share/mc-image-helper:ro
```

For Go base tools, run

```shell
goreleaser release --snapshot --clean
```

Clone [itzg/github-releases-proxy](https://github.com/itzg/github-releases-proxy) and run it according to the instructions shown there.

In the Docker build, configure the following 

```shell
--build-arg GITHUB_BASEURL=http://host.docker.internal:8080 \
--build-arg APPS_REV=1
```

and declare one or more version overrides, such as

```
--build-arg MC_HELPER_VERSION=1.8.1-SNAPSHOT
```

## Generating release notes

The following git command can be used to provide the bulk of release notes content:

```shell script
git log --invert-grep --grep "^ci:" --grep "^misc:" --grep "^docs:" --pretty="* %s" 1.1.0..1.2.0
```
