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
patches:
  # Example of using a patch to set external service name for mc-router to pick up
  - path: set-external-servername.yml
```

### mc.env
```
EULA=true
TYPE=FORGE
```

###

```yaml
apiVersion: v1
kind: Service
metadata:
  name: mc
  annotations:
    mc-router.itzg.me/externalServerName: forge.example.com
```