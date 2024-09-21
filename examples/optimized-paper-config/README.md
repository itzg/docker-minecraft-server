
# Repository Proposal for Optimized Minecraft Configurations for Paper

This repository provides a set of optimized configuration files for Minecraft servers, focusing on improving performance and reducing lag. These configurations are based on community best practices and have been tested. You can also use your config file; you just need to replace the env var with another repo. It's important to follow the structure of a config file version like this [repo](https://github.com/Alpha018/paper-config-optimized).

## Usage

You can directly use the optimized configuration files from this repository by accessing them through the GitHub raw URLs. Simply replace the env var like the docker compose with any other repo with different configurations.

To use the raw files, you can download or link to them using the following pattern:

```yaml
services:
  mc:
    image: itzg/minecraft-server
    container_name: paper
    environment:
      EULA: "true"
      TYPE: "PAPER"
      VIEW_DISTANCE: 10
      MEMORY: 2G
      PAPER_CONFIG_REPO: "https://raw.githubusercontent.com/[your-username]/[your-repository]/main/[file-path]"
    ports:
      - "25565:25565"
    volumes:
      - mc-paper:/data
    restart: unless-stopped
volumes:
  mc-paper: {}
```

For example:

```yaml
services:
  mc:
    image: itzg/minecraft-server
    container_name: paper
    environment:
      EULA: "true"
      TYPE: "PAPER"
      VIEW_DISTANCE: 10
      MEMORY: 2G
      PAPER_CONFIG_REPO: "https://raw.githubusercontent.com/Alpha018/paper-config-optimized/main"
    ports:
      - "25565:25565"
    volumes:
      - mc-paper:/data
    restart: unless-stopped
volumes:
  mc-paper: {}
```

Feel free to explore and use the configurations in this repo to enhance your Minecraft server's performance.

## Contribution

If you'd like to improve or suggest changes to these configurations, feel free to submit a pull request in this [repository](https://github.com/Alpha018/paper-config-optimized). We welcome contributions from the community!

