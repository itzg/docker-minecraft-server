This directory provides a base to use with [kubectl kustomize](https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/).

## Example overlay content

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
```
EULA=true
TYPE=FORGE
```