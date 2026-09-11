# Vector Forces Deployments

This repository contains one reusable Helm chart and one generic values file.

```text
.
├── app-chart/
└── values/
    └── app.yaml
```

Deploy an app by passing the real app values at runtime:

```bash
helm upgrade --install "${APP_NAME}" ./app-chart \
  -f ./values/app.yaml \
  --namespace "${APP_NAMESPACE}" \
  --create-namespace \
  --set app.name="${APP_NAME}" \
  --set app.namespace="${APP_NAMESPACE}" \
  --set image.repository="${IMAGE_REPOSITORY}" \
  --set image.tag="${IMAGE_TAG}" \
  --set container.port="${CONTAINER_PORT}" \
  --set service.targetPort="${CONTAINER_PORT}" \
  --set ingress.enabled=true \
  --set ingress.host="${INGRESS_HOST}"
```

For CI/CD, set the image tag from the commit SHA:

```bash
helm upgrade --install "${APP_NAME}" ./app-chart \
  -f ./values/app.yaml \
  --namespace "${APP_NAMESPACE}" \
  --create-namespace \
  --set app.name="${APP_NAME}" \
  --set app.namespace="${APP_NAMESPACE}" \
  --set image.repository="${IMAGE_REPOSITORY}" \
  --set image.tag="${GITHUB_SHA}" \
  --set container.port="${CONTAINER_PORT}" \
  --set service.targetPort="${CONTAINER_PORT}" \
  --set ingress.enabled=true \
  --set ingress.host="${INGRESS_HOST}"
```

Keep real app names, domains, and environment-specific settings in your CI/CD
variables or local shell environment instead of committing them to this repo.

If an app exposes a health endpoint, enable probes in its values file:

```yaml
probes:
  liveness:
    enabled: true
    path: /health
  readiness:
    enabled: true
    path: /health
```
