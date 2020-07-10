## Adding a server type

Adding a new server `TYPE` can vary due to the complexity of obtaining and configuring each type; however, the addition of any server type includes at least the following steps:

1. Copy an existing "start-deploy*" script, such as [start-deployMohist](start-deployMohist) and rename it accordingly making sure to retain the "start-deploy" prefix
2. Modify the type-specific behavior between the "start-utils" preamble and the hand-off to `start-finalSetupWorld` at the end of the script 
3. Develop and test the changes using the [iterative process described below](#iterative-script-development)
4. Add a case-entry to the `case "${TYPE^^}"` in [start-configuration](start-configuration)
5. Add a section to the [README](README.md). It is recommended to copy-modify an existing section to retain a similar wording and level of detail
6. [Submit a pull request](https://github.com/itzg/docker-minecraft-server/pulls)

## Iterative script development

Individual scripts can be iteratively developed, debugged, and tested using the following procedure.

First, build a baseline of the image to include the packages needed by existing or new scripts:

```shell script
docker build -t mc-dev .
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

## Multi-base-image variants

Several base-image variants are maintained in order to offer choices in JDK provider and version. The variants are maintained in their respective branches:
- openj9 
- openj9-nightly
- adopt11
- adopt13
- multiarch

The [docker-versions-create.sh](docker-versions-create.sh) script is configured with the branches to maintain and is used to merge changes from the master branch into the mulit-base variant branches. The script also manages git tagging the master branch along with the merged branches. So a typical use of the script would be like:

```shell script
./docker-versions-create.sh -s -t 1.2.0
```

> Most often the major version will be bumped unless a bug or hotfix needs to be published in which case the patch version should be incremented.

> The build and publishing of those branches and their tags is currently performed within Docker Hub.

## multiarch support

The [multiarch branch](https://github.com/itzg/docker-minecraft-server/tree/multiarch) supports running the image on amd64, arm64, and armv7 (aka RaspberryPi). Unlike the mainline branches, it is based on Ubuntu 18.04 since the openjdk package provided by Ubuntu includes full JIT support on all of the processor types.

The multiarch images are built and published by [a Github action](https://github.com/itzg/docker-minecraft-server/actions?query=workflow%3A%22Build+and+publish+multiarch%22), which [is configured in that branch](https://github.com/itzg/docker-minecraft-server/blob/multiarch/.github/workflows/build-multiarch.yml).

## Generating release notes

The following git command can be used to provide the bulk of release notes content:

```shell script
git log --invert-grep --grep "^ci:" --grep "^misc:" --grep "^docs:" --pretty="- %s" 1.1.0..1.2.0
```
