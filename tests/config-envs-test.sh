#!/usr/bin/env bash

set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
chart="$repo_root/charts/collate-ai-proxy"
rendered=$(mktemp)
secret_rendered=$(mktemp)
legacy_rendered=$(mktemp)
trap 'rm -f "$rendered" "$secret_rendered" "$legacy_rendered"' EXIT

assert_contains() {
  local file=$1
  local expected=$2

  if ! grep -Fq -- "$expected" "$file"; then
    echo "expected rendered manifest to contain: $expected" >&2
    exit 1
  fi
}

helm template caip "$chart" >"$rendered"

for expected in \
  'name: LOG_LEVEL' \
  'value: "INFO"' \
  'name: BASE_BUILDER_LOG_LEVEL' \
  'name: TOOL_RESULT_DEFAULT_MAX_CHARS' \
  'value: "20000"' \
  'name: TOOL_RESULT_LARGE_PAYLOAD_MAX_CHARS' \
  'value: "200000"' \
  'name: LLM_PROVIDER_MODEL_TYPE_ADVANCED' \
  'value: "anthropic.claude-opus-4-8,anthropic.claude-opus-4-7"' \
  'name: LLM_DYNAMIC_MAX_ITERATIONS' \
  'value: "100"' \
  'name: LLM_AZURE_OPENAI_AUTH_TYPE' \
  'value: "api_key"' \
  'name: BOT_JWT_TOKEN' \
  'name: VECTOR_SEARCH_CONTEXT_THRESHOLD' \
  'value: "0.55"' \
  'name: VECTOR_SEARCH_CONTEXT_SIZE' \
  'value: "40"' \
  'name: MAX_CONTEXT_ITEMS' \
  'value: "25"' \
  'name: OPENMETADATA_CLUSTER_NAME' \
  'name: SECRET_MANAGER' \
  'name: SECRETS_MANAGER_PREFIX' \
  'name: SECRETS_MANAGER_BOT_NAME' \
  'name: SECRETS_MANAGER_REGION' \
  'name: SECRETS_MANAGER_VAULT_NAME' \
  'name: SECRETS_MANAGER_PROJECT_ID' \
  'name: SECRETS_MANAGER_K8S_NAMESPACE' \
  'name: SECRETS_MANAGER_K8S_IN_CLUSTER' \
  'name: SENTRY_ENABLED' \
  'name: SENTRY_DSN' \
  'name: SENTRY_ENVIRONMENT' \
  'name: SENTRY_SERVER_NAME' \
  'name: SENTRY_TRACES_SAMPLE_RATE' \
  'name: SENTRY_DEBUG' \
  'name: SENTRY_RELEASE' \
  'name: SENTRY_CAPTURE_SPAN_ATTRIBUTES'; do
  assert_contains "$rendered" "$expected"
done

helm template caip "$chart" \
  --set-string config.client.botJwtToken='inline-token' \
  --set-string config.client.botJwtTokenSecretRef.name='caip-secrets' \
  --set-string config.client.botJwtTokenSecretRef.key='bot-jwt' \
  --set-string config.sentry.dsn='https://inline@example.invalid/1' \
  --set-string config.sentry.dsnSecretRef.name='caip-secrets' \
  --set-string config.sentry.dsnSecretRef.key='sentry-dsn' >"$secret_rendered"

assert_contains "$secret_rendered" 'name: BOT_JWT_TOKEN'
assert_contains "$secret_rendered" 'key: "bot-jwt"'
assert_contains "$secret_rendered" 'name: SENTRY_DSN'
assert_contains "$secret_rendered" 'key: "sentry-dsn"'

helm template caip "$chart" --set config.llmProvider.dynamicMaxIterations=50 >"$legacy_rendered"
assert_contains "$legacy_rendered" 'name: LLM_DYNAMIC_MAX_ITERATIONS'
assert_contains "$legacy_rendered" 'value: "50"'
