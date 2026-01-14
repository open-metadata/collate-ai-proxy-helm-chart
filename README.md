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
