# Collate AI Proxy Helm Chart

This repository packages the Helm chart used to deploy the Collate AI Proxy (CAIP) as a standalone service.

## Layout

- `charts/collate-ai-proxy/` – main chart with templates, schema, and default values.

## Customization

Key fields worth adjusting before deployment:

- `image.repository` / `image.tag` – CAIP container image.
- `collate.hostAndPort` – URL to the Collate server the proxy reaches.
- `serviceAccount.*` – controls the ServiceAccount the deployment uses.
- `service.*` – service type and exposed ports.
- `extraEnvs`, `envFrom`, `volumes`, `volumeMounts` – customize runtime configuration.

Full schema validation is available via `charts/collate-ai-proxy/values.schema.json`.

### Service account options

- `serviceAccount.create: true` creates a ServiceAccount as part of the release. When `serviceAccount.name` is left empty, the chart auto-generates a name based on the release.
- Set `serviceAccount.name` to bind the deployment to a specific ServiceAccount. If `create` remains `true`, the chart will create that ServiceAccount; set `create: false` to reuse an existing one.
- `serviceAccount.annotations` propagates custom annotations to the created ServiceAccount, and `serviceAccount.automount` controls the default token mount behaviour on both the ServiceAccount and the pods.
