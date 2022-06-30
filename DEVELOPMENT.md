## Adding a server type

Adding a new server `TYPE` can vary due to the complexity of obtaining and configuring each type; however, the addition of any server type includes at least the following steps:

1. Copy an existing "start-deploy*" script, such as [start-deployMohist](scripts/start-deployMohist) and rename it accordingly making sure to retain the "start-deploy" prefix
2. Modify the type-specific behavior between the "start-utils" preamble and the hand-off to `start-setupWorld` at the end of the script 
3. Develop and test the changes using the [iterative process described below](#iterative-script-development)
4. Add a case-entry to the `case "${TYPE^^}"` in [start-configuration](scripts/start-configuration)
5. Add a section to the [README](README.md). It is recommended to copy-modify an existing section to retain a similar wording and level of detail
6. [Submit a pull request](https://github.com/itzg/docker-minecraft-server/pulls)

## Iterative script development

Individual scripts can be iteratively developed, debugged, and tested using the following procedure.

First, build a baseline of the image to include the packages needed by existing or new scripts:

PowerShell: (Example of building and testing ForgeAPI)
```powershell
$env:MODS_FORGEAPI_KEY='$2a$...'
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
export MODS_FORGEAPI_KEY='$2a$...'
export FOLDER_TO_TEST="forgeapimods_file"
export IMAGE_TO_TEST="mc-dev"
docker build -t $IMAGE_TO_TEST .
pushd tests/setuponlytests/$FOLDER_TO_TEST/
docker-compose run mc
docker-compose down -v --remove-orphans
popd
```

Using the baseline image, an interactive container can be started to iteratively run the scripts to be developed. By attaching the current workspace directory, you can use the local editor of your choice to iteratively modify scripts while using the container to run them.

```shell script
docker run -it --rm -v ${PWD}:/scripts -e SCRIPTS=/scripts/ --entrypoint bash mc-dev
```

From within the container you can run individual scripts via the attached `/scripts/` path; however, be sure to set any environment variables expected by the scripts by either `export`ing them manually:

```shell script
export VANILLA_VERSION=1.12.2
/scripts/start-magma
```

...or pre-pending script execution:

```shell script
VANILLA_VERSION=1.12.2 /scripts/start-magma
```

> NOTE: You may want to temporarily add an `exit` statement near the end of your script to isolate execution to just the script you're developing.

## Using development copy of mc-image-helper

In the cloned copy of [`mc-image-helper`](https://github.com/itzg/mc-image-helper), create an up-to-date snapshot build of the tgz distribution using:

```shell
./gradlew distTar
```

Assuming [http-server](https://www.npmjs.com/package/http-server) is installed globally, start a static web server using:

```shell
http-server ./build/distributions -p 8080
```

Note the port that was selected by http-server and pass the build arguments, such as:

```shell
--build-arg MC_HELPER_VERSION=1.8.1-SNAPSHOT \
--build-arg MC_HELPER_BASE_URL=http://host.docker.internal:8080
```

Now the image can be built like normal, and it will install mc-image-helper from the locally built copy.

## Generating release notes

The following git command can be used to provide the bulk of release notes content:

```shell script
git log --invert-grep --grep "^ci:" --grep "^misc:" --grep "^docs:" --pretty="* %s" 1.1.0..1.2.0
```
