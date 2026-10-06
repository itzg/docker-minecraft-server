A [Cleanroom server](https://cleanroommc.com/) can be automatically downloaded, upgraded, and run by setting the environment variable `TYPE` to "CLEANROOM".

!!! example

    ```shell
    docker run -e TYPE=CLEANROOM ...
    ```
    
    or in a compose file
    ```yaml
        environment:
          TYPE: CLEANROOM
    ```

Cleanroom is a loader specified for Minecraft 1.12.2, since then `VERSION` will be ignored. By default, the latest version of Cleanroom will be selected. You can also choose a specific Cleanroom version by setting `CLEANROOM_LOADER_VERSION` with that version, such as "0.6.13-alpha".

!!! example

    ```shell
    docker run -e TYPE=CLEANROOM -e CLEANROOM_LOADER_VERSION=0.6.13-alpha -e CLEANROOM_INSTALLER_VERSION=0.1.4 ...
    ```
    
    or in a compose file
    ```yaml
        environment:
          TYPE: CLEANROOM
          CLEANROOM_LOADER_VERSION: "0.6.13-alpha"
    ```

You can also specify installer version. By default, the latest version of installer will be selected. You can also choose a specific installer version by setting `CLEANROOM_INSTALLER_VERSION` with that version, such as "0.1.4".

!!! example

    ```shell
    docker run -e TYPE=CLEANROOM -e CLEANROOM_INSTALLER_VERSION=0.1.4 ...
    ```
    
    or in a compose file
    ```yaml
        environment:
          TYPE: CLEANROOM
          CLEANROOM_INSTALLER_VERSION: "0.1.4"
    ```

!!! note

    You do not need to setup this unless required. The installer come from Cleanroom support multi-version installation compare to legacy installer.

To use a pre-downloaded Cleanroom installer, place it in a location mounted into the container and specify the container path with `CLEANROOM_FROM_FILE`. To download a Cleanroom installer from a custom location, such as your own file repository, specify the URL with `CLEANROOM_FROM_URL`.

In both of the cases above, there is no need for the `CLEANROOM_LOADER_VERSION` or `CLEANROOM_INSTALLER_VERSION` variables.

!!! note

    By default, legacy installer are supported but limited support will be provided if asked.

!!! note

    If an error occurred while installing Cleanroom, it might be possible to resolve by temporarily setting `CLEANROOM_FORCE_REINSTALL` to "true". Be sure to remove that variable after successfully starting the server.

Specified installer version is configurable via environment variables:

- `CLEANROOM_INSTALLER_VERSION`: used to specific installer version, default is latest

URLs configurable via environment variables:

- `CLEANROOM_MAVEN_URL`: default is https://maven.cleanroommc.com
