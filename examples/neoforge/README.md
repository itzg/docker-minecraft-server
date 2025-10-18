# NeoForge Examples

This directory contains examples for running NeoForge Minecraft servers.

## Basic NeoForge Server

The `docker-compose.yml` file demonstrates a basic NeoForge server setup with the latest beta version.

```bash
docker-compose up -d
```

## NeoForge with Fabric Mod Support (Connector)

The `docker-compose-connector.yml` file demonstrates how to run a NeoForge server with Fabric mod support using the [Connector](https://modrinth.com/mod/connector) mod.

### How it works

When the Connector mod is included in your `MODRINTH_PROJECTS` list, the container automatically:

1. Downloads NeoForge-compatible versions of all mods
2. Downloads Fabric-compatible versions of all mods (including Fabric-only mods)
3. Connector mod enables the Fabric mods to run on the NeoForge server

This allows you to use popular Fabric performance mods like Sodium, Lithium, and Iris on your NeoForge server.

### Usage

```bash
docker-compose -f docker-compose-connector.yml up -d
```

### Included Mods in Example

- **connector**: Enables Fabric mod compatibility on NeoForge
- **fabric-api**: Core Fabric API (required by most Fabric mods)
- **sodium**: Graphics optimization mod (Fabric)
- **lithium**: Server performance optimization mod (Fabric)
- **iris**: Shaders mod (Fabric)

### Adding More Mods

Simply add more mod slugs to the `MODRINTH_PROJECTS` environment variable. You can mix NeoForge-native and Fabric mods - as long as Connector is in the list, both will be downloaded and work together.

Example:

```yaml
MODRINTH_PROJECTS: |
  connector
  fabric-api
  sodium
  lithium
  iris
  jei
  create
```

### Requirements

- The Connector mod must be included in your `MODRINTH_PROJECTS` list
- Most Fabric mods also require `fabric-api` to function properly
