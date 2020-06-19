Individual scripts can be iteratively developed and tested using the following procedure.

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
