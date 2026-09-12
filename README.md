# Vector Forces Deployments

This repository contains one reusable Helm chart and one generic values file.
The chart is published as an OCI Helm chart to GitHub Container Registry.

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
  --set-string app.name="${APP_NAME}" \
  --set-string app.namespace="${APP_NAMESPACE}" \
  --set-string image.repository="${IMAGE_REPOSITORY}" \
  --set-string image.tag="${IMAGE_TAG}" \
  --set container.port="${CONTAINER_PORT}" \
  --set service.targetPort="${CONTAINER_PORT}" \
  --set ingress.enabled=true \
  --set-string ingress.host="${INGRESS_HOST}"
```

After this chart is published, app CI/CD can deploy without checking out this
repository:

```bash
helm upgrade --install "${APP_NAME}" \
  oci://ghcr.io/vector-forces/charts/app-chart \
  --version 0.1.0 \
  --namespace "${APP_NAMESPACE}" \
  --create-namespace \
  --set-string app.name="${APP_NAME}" \
  --set-string app.namespace="${APP_NAMESPACE}" \
  --set-string image.repository="${IMAGE_REPOSITORY}" \
  --set-string image.tag="${IMAGE_TAG}" \
  --set container.port="${CONTAINER_PORT}" \
  --set service.targetPort="${CONTAINER_PORT}" \
  --set ingress.enabled=true \
  --set-string ingress.host="${INGRESS_HOST}"
```

For CI/CD, set the image tag from the commit SHA:

```bash
helm upgrade --install "${APP_NAME}" \
  oci://ghcr.io/vector-forces/charts/app-chart \
  --version 0.1.0 \
  --namespace "${APP_NAMESPACE}" \
  --create-namespace \
  --set-string app.name="${APP_NAME}" \
  --set-string app.namespace="${APP_NAMESPACE}" \
  --set-string image.repository="${IMAGE_REPOSITORY}" \
  --set-string image.tag="${GITHUB_SHA}" \
  --set container.port="${CONTAINER_PORT}" \
  --set service.targetPort="${CONTAINER_PORT}" \
  --set ingress.enabled=true \
  --set-string ingress.host="${INGRESS_HOST}"
```

Keep real app names, domains, and environment-specific settings in your CI/CD
variables or local shell environment instead of committing them to this repo.

To publish a new chart version, update `version` in `app-chart/Chart.yaml` and
push to `main`. The workflow in `.github/workflows/publish-chart.yml` publishes
that chart version to GHCR. If GitHub creates the package as private, make the
package public once from the GitHub package settings.

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
