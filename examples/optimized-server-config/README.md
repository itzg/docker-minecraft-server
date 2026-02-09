# Optimized Server Configuration (Paper, Purpur, Pufferfish)

This example demonstrates how to automatically download and apply optimized configuration files for your Minecraft server from a remote Git repository. This is useful for maintaining a standard, high-performance configuration across multiple server instances.

## Features

- **Automatic Download**: Fetches `bukkit.yml`, `spigot.yml`, and server-specific configs (`paper-global.yml`, `purpur.yml`, `pufferfish.yml`) on startup.
- **Version Aware**: Downloads configurations from a folder matching your Minecraft version (e.g., `1.21.1`).
- **Base `server.properties`**: Optionally download a base `server.properties` file while still allowing environment variable overrides.

## Repository Structure

Your configuration repository should be structured by Minecraft version. For example:

```text
my-config-repo/
├── 1.21.1/
│   ├── bukkit.yml
│   ├── spigot.yml
│   ├── purpur.yml
│   ├── pufferfish.yml
│   └── server.properties
├── 1.20.4/
│   └── ...
└── README.md
```

## Docker Compose Examples

### 1. Paper Server

For Paper, use `PAPER_CONFIG_REPO`.

```yaml
version: "3.8"

services:
  mc:
    image: itzg/minecraft-server
    environment:
      EULA: "TRUE"
      TYPE: "PAPER"
      VERSION: "1.21.1"

      # URL to the root of your config repository (e.g. raw.githubusercontent.com)
      # The script automatically appends "/<VERSION>/<FILE>" to this URL.
      PAPER_CONFIG_REPO: "https://raw.githubusercontent.com/Alpha018/paper-config-optimized/refs/heads/main"
```

### 2. Purpur Server

For Purpur, use `PURPUR_CONFIG_REPO`.

```yaml
version: "3.8"

services:
  mc:
    image: itzg/minecraft-server
    environment:
      EULA: "TRUE"
      TYPE: "PURPUR"
      VERSION: "1.21.1"
      
      # URL to the root of your config repository (e.g. raw.githubusercontent.com)
      # The script automatically appends "/<VERSION>/<FILE>" to this URL.
      PURPUR_CONFIG_REPO: "https://raw.githubusercontent.com/Alpha018/paper-config-optimized/refs/heads/main"
```

### 2. Pufferfish Server

For Pufferfish, use `PUFFERFISH_CONFIG_REPO`.

```yaml
version: "3.8"

services:
  mc:
    image: itzg/minecraft-server
    environment:
      EULA: "TRUE"
      TYPE: "PUFFERFISH"
      VERSION: "1.21.1" # Must match a folder in your repo
      
      # Automagically download optimized configs (bukkit.yml, spigot.yml, pufferfish.yml)
      PUFFERFISH_CONFIG_REPO: "https://raw.githubusercontent.com/Alpha018/paper-config-optimized/refs/heads/main"
```

### 3. Downloading `server.properties` (Optional)

If you also want to download a base `server.properties` file from your repository, you must explicitly set `SERVER_PROPERTIES_REPO_URL`.

**Smart Feature**:

- If you provide a **base URL** (like the repo root), the script will automatically append `/<VERSION>/server.properties`.
- If you provide a **full URL** (ending in `.properties`), it will download that specific file.

**Crucial Note**: Environment variables (like `MOTD`, `DIFFICULTY`, `MAX_PLAYERS`) in your Docker Compose **WILL override** values in the downloaded file. This allows you to have a shared optimized base but customize specifics per instance.

```yaml
    environment:
      # ... other vars ...
      
      # Option A: Base URL (Smart)
      # Will look for: https://.../main/1.21.1/server.properties
      SERVER_PROPERTIES_REPO_URL: "https://raw.githubusercontent.com/Alpha018/paper-config-optimized/refs/heads/main"

      # Option B: Specific URL (Manual)
      # SERVER_PROPERTIES_REPO_URL: "https://gist.githubusercontent.com/.../server.properties"
      
      # These will OVERRIDE settings in the downloaded file
      MOTD: "My Custom Instance"
      MAX_PLAYERS: 50
```

## Supported Variables

| Variable | Description |
| :--- | :--- |
| `PAPER_CONFIG_REPO` | Base URL for Paper configs. Downloads `paper-global.yml`, `bukkit.yml`, `spigot.yml`, etc. |
| `PURPUR_CONFIG_REPO` | Base URL for Purpur configs. Downloads `purpur.yml`, `bukkit.yml`, `spigot.yml`. |
| `PUFFERFISH_CONFIG_REPO` | Base URL for Pufferfish configs. Downloads `pufferfish.yml`, `bukkit.yml`, `spigot.yml`. |
| `SERVER_PROPERTIES_REPO_URL` | Boolean/URL. Set to download `server.properties`. Can be a base URL or direct file link. |

## Contribution

Got ideas to squeeze even more performance out of these configs? Or maybe you found a better way to structure things?

I'd love to see your improvements! Feel free to open a Pull Request or an Issue in the [repository](https://github.com/Alpha018/paper-config-optimized). Let's make these configs the best they can be together.
