---
title: Modifying config files
---

## Replacing variables inside configs

Sometimes you have mods or plugins that require configuration information that is only available at deploy-time. For example if you need to configure a plugin to connect to a database, you don't want to include this information in your Git repository or Docker image.
Or maybe you have some runtime information like the server name that needs to be set in your config files after the container starts.

For those cases there is the option to replace defined variables inside your configs with environment variables defined at container runtime.

When the environment variable `REPLACE_ENV_IN_PLACE` is set to `true` (the default), the startup script will go through all files inside the container's `/data` path and replace variables that match the container's environment variables. Variables can instead (or in addition to) be replaced in files sync'ed from `/plugins`, `/mods`, and `/config` by setting `REPLACE_ENV_DURING_SYNC` to `true` (defaults to `false`).

Variables that you want to replace need to be declared inside curly brackets and prefixed with a dollar sign, such as  `${CFG_YOUR_VARIABLE}`, which is same as many scripting languages.

You can also change `REPLACE_ENV_VARIABLE_PREFIX`, which defaults to "CFG_", to limit which environment variables are allowed to be used. For example, with "CFG_" as the prefix, the variable `${CFG_DB_HOST}` would be substituted, but not `${DB_HOST}`. The prefix can be set to an empty string to allow for matching any variable name.

If you want to use a file's content for value, such as when using secrets mounted as files, declare the placeholder named like normal in the file and declare an environment variable named the same but with the suffix `_FILE`.

For example, a `my.cnf` file could contain:

```
[client]
password = ${CFG_DB_PASSWORD}
```

...a secret declared in the compose file with:
```yaml
secrets:
  db_password:
    external: true
```

...and finally the environment variable would be named with a `_FILE` suffix and point to the mounted secret:
```yaml
    environment:
      CFG_DB_PASSWORD_FILE: /run/secrets/db_password
```

Variables will be replaced in files with the following extensions:
`.yml`, `.yaml`, `.txt`, `.cfg`, `.conf`, `.properties`.

Specific files can be excluded by listing their name (without path) in the variable `REPLACE_ENV_VARIABLES_EXCLUDES`.

Paths can be excluded by listing them in the variable `REPLACE_ENV_VARIABLES_EXCLUDE_PATHS`. Path
excludes are recursive. Here is an example:
```
REPLACE_ENV_VARIABLES_EXCLUDE_PATHS="/data/plugins/Essentials/userdata /data/plugins/MyPlugin"
```

Here is a full example where we want to replace values inside a `database.yml`.

```yml

---
database:
  host: ${CFG_DB_HOST}
  name: ${CFG_DB_NAME}
  password: ${CFG_DB_PASSWORD}
```

This is how your `docker-compose.yml` file could look like:

```yml
# Other docker-compose examples in /examples

services:
  minecraft:
    image: itzg/minecraft-server
    ports:
      - "25565:25565"
    volumes:
      - "mc:/data"
    environment:
      EULA: "TRUE"
      ENABLE_RCON: "true"
      RCON_PASSWORD: "testing"
      RCON_PORT: 28016
      # enable env variable replacement
      REPLACE_ENV_VARIABLES: "TRUE"
      # define an optional prefix for your env variables you want to replace
      ENV_VARIABLE_PREFIX: "CFG_"
      # and here are the actual variables
      CFG_DB_HOST: "http://localhost:3306"
      CFG_DB_NAME: "minecraft"
      CFG_DB_PASSWORD_FILE: "/run/secrets/db_password"

volumes:
  mc:
  rcon:

secrets:
  db_password:
    file: ./db_password
```

## Patching existing files

JSON path based patches can be applied to one or more existing files by setting the variable `PATCH_DEFINITIONS` to the path of a directory that contains one or more [patch definition json files](https://github.com/itzg/mc-image-helper#patchdefinition) or a [patch set json file](https://github.com/itzg/mc-image-helper#patchset). 

The `file` and `value` fields of the patch definitions may contain `${...}` variable placeholders. The allowed environment variables in placeholders can be restricted by setting `REPLACE_ENV_VARIABLE_PREFIX`, which defaults to "CFG_".

The following example shows a patch-set file where various fields in the `paper.yaml` configuration file can be modified and added:

```json
{
  "patches": [
    {
      "file": "/data/paper.yml",
      "ops": [
        {
          "$set": {
            "path": "$.verbose",
            "value": true
          }
        },
        {
          "$set": {
            "path": "$.settings['velocity-support'].enabled",
            "value": "${CFG_VELOCITY_ENABLED}",
            "value-type": "bool"
          }
        },
        {
          "$put": {
            "path": "$.settings",
            "key": "my-test-setting",
            "value": "testing"
          }
        }
      ]
    }
  ]
}
```

Supports the file formats:
- JSON
- JSON5
- Yaml
- TOML, but processed output is not pretty
