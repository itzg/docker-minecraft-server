# A Form to Load New Config Files to Paper MC

In this example, we illustrate how to efficiently load and manage different configuration files to optimize a Paper Minecraft server. To implement this, it is necessary to create a dedicated repository where the configuration files can be stored and later retrieved. The repository should adhere to a specific structure to facilitate seamless integration with your Docker setup. Notably, the configurations must be organized into a folder named after the version of Minecraft you are using.

For reference, I have provided this [repository](https://github.com/Alpha018/paper-config-optimized), which contains optimized configuration files for the latest version of Minecraft. You can use this repository by linking directly to the configuration files in your Docker file, as demonstrated in the example below.

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

