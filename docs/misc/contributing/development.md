## Adding a server type

Adding a new server `TYPE` can vary due to the complexity of obtaining and configuring each type; however, the addition of any server type includes at least the following steps:

1. Copy an existing "start-deploy*" script, such as [start-deployFabric](https://github.com/itzg/docker-minecraft-server/blob/master/scripts/start-deployFabric) and rename it accordingly making sure to retain the "start-deploy" prefix
2. Modify the type-specific behavior between the "start-utils" preamble and the hand-off to `start-setupWorld` at the end of the script 
3. Develop and test the changes using the [iterative process described below](#iterative-script-development)
4. Add a case-entry to the `case "${TYPE^^}"` in [start-configuration](https://github.com/itzg/docker-minecraft-server/blob/master/scripts/start-configuration)
5. Add a section to the [docs](https://github.com/itzg/docker-minecraft-server/tree/master/docs). It is recommended to copy-modify an existing section to retain a similar wording and level of detail
6. [Submit a pull request](https://github.com/itzg/docker-minecraft-server/pulls)

## Iterative script development

Individual scripts can be iteratively developed, debugged, and tested using the following procedure.

First, build a baseline of the image to include the packages needed by existing or new scripts:

PowerShell: (Example of building and testing ForgeAPI)
```powershell
$env:FOLDER_TO_TEST="forgeapimods_projectids"
$env:IMAGE_TO_TEST="mc-dev"
docker build -t $env:IMAGE_TO_TEST .
pushd "tests/setuponlytests/$env:FOLDER_TO_TEST/"
docker-compose run mc
docker-compose down -v --remove-orphans
popd
```

PowerShell: Building different images of Java for testing
```powershell
$env:BASE_IMAGE='eclipse-temurin:8u312-b07-jre'
$env:IMAGE_TO_TEST="mc-dev"
docker build --build-arg BASE_IMAGE=$env:BASE_IMAGE -t $env:IMAGE_TO_TEST .
```

Bash: (Example of building and testing ForgeAPI)
```bash
export FOLDER_TO_TEST="forgeapimods_file"
export IMAGE_TO_TEST="mc-dev"
docker build -t $IMAGE_TO_TEST .
pushd tests/setuponlytests/$FOLDER_TO_TEST/
docker-compose run mc
docker-compose down -v --remove-orphans
popd
```

Using the baseline image, an interactive container can be started to iteratively run the scripts to be developed. By attaching the current workspace directory, you can use the local editor of your choice to iteratively modify scripts while using the container to run them.

```shell
docker run -it --rm -v ${PWD}:/image/scripts --entrypoint bash mc-dev
```

From within the container you can run individual scripts via the attached `/image/scripts/` path; however, be sure to set any environment variables expected by the scripts by either `export`ing them manually:

```shell
export VERSION=1.12.2
/image/scripts/start-deployFabric
```

...or pre-pending script execution:

```shell
VERSION=1.12.2 /image/scripts/start-deployFabric
```

!!! note

    You may want to temporarily add an `exit` statement near the end of your script to isolate execution to just the script you're developing.

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
