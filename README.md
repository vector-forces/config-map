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

Use `extraEnv` when an app needs full Kubernetes `EnvVar` entries, such as
references to one or more existing secrets:

```yaml
extraEnv:
  - name: DB_PASSWORD
    valueFrom:
      secretKeyRef:
        name: dev-secrets
        key: 89d3c644-e086-415a-9ff4-b4d900802240
  - name: API_TOKEN
    valueFrom:
      secretKeyRef:
        name: shared-api-secrets
        key: api-token
```

The same value can be passed from CI/CD with Helm JSON:

```bash
helm upgrade --install "${APP_NAME}" ./app-chart \
  --set-json 'extraEnv=[{"name":"DB_PASSWORD","valueFrom":{"secretKeyRef":{"name":"dev-secrets","key":"89d3c644-e086-415a-9ff4-b4d900802240"}}},{"name":"API_TOKEN","valueFrom":{"secretKeyRef":{"name":"shared-api-secrets","key":"api-token"}}}]'
```

Use host networking with an added container capability when an app must run
network tools from the node network namespace, such as `arping`:

```yaml
hostNetwork: true
dnsPolicy: ClusterFirstWithHostNet

container:
  securityContext:
    capabilities:
      add:
        - NET_RAW

extraEnv:
  - name: DB_PASSWORD
    valueFrom:
      secretKeyRef:
        name: dev-secretts
        key: 89d3c644-e086-415a-9ff4-b4d900802240
```

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
