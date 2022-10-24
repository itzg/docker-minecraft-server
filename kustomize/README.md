## Example

### kustomization.yml
```yaml
nameSuffix: "-forge"
commonLabels:
  server: forge
bases:
  - https://github.com/itzg/docker-minecraft-server.git/kustomize/base
configMapGenerator:
  - name: mc
    envs:
      - mc.env
```

### mc.env
```shell
EULA=true
TYPE=FORGE
```