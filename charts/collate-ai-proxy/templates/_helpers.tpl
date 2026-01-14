{{/*
Expand the name of the chart.
*/}}
{{- define "caip.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "caip.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "caip.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "caip.labels" -}}
helm.sh/chart: {{ include "caip.chart" . }}
{{ include "caip.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "caip.selectorLabels" -}}
app.kubernetes.io/name: {{ include "caip.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Resolve LLM provider base URL based on configured provider type
*/}}
{{- define "caip.llmBaseUrl" -}}
{{- $llm := .Values.config.llmProvider | default (dict) -}}
{{- $type := $llm.type | default "" -}}
{{- $openAI := $llm.openAI | default (dict) -}}
{{- $anthropic := $llm.anthropic | default (dict) -}}
{{- $google := $llm.google | default (dict) -}}
{{- $bedrock := $llm.bedrock | default (dict) -}}
{{- $ollama := $llm.ollama | default (dict) -}}
{{- if eq $type "anthropic" -}}
{{- default "" $anthropic.baseUrl -}}
{{- else if eq $type "google" -}}
{{- default "" $google.baseUrl -}}
{{- else if eq $type "bedrock" -}}
{{- default "" $bedrock.baseUrl -}}
{{- else if eq $type "ollama" -}}
{{- default "" $ollama.baseUrl -}}
{{- else -}}
{{- default "" $openAI.baseUrl -}}
{{- end -}}
{{- end }}

{{/*
Resolve LLM provider API key based on configured provider type
*/}}
{{- define "caip.llmApiKey" -}}
{{- $llm := .Values.config.llmProvider | default (dict) -}}
{{- $type := $llm.type | default "" -}}
{{- $openAI := $llm.openAI | default (dict) -}}
{{- $anthropic := $llm.anthropic | default (dict) -}}
{{- $google := $llm.google | default (dict) -}}
{{- if eq $type "anthropic" -}}
{{- default "" $anthropic.apiKey -}}
{{- else if eq $type "google" -}}
{{- default "" $google.apiKey -}}
{{- else -}}
{{- default "" $openAI.apiKey -}}
{{- end -}}
{{- end }}

{{/*
Resolve LLM provider API version based on configured provider
*/}}
{{- define "caip.llmApiVersion" -}}
{{- $llm := .Values.config.llmProvider | default (dict) -}}
{{- $type := $llm.type | default "" -}}
{{- $openAI := $llm.openAI | default (dict) -}}
{{- $azure := $openAI.azureOpenAI | default (dict) -}}
{{- $anthropic := $llm.anthropic | default (dict) -}}
{{- if eq $type "anthropic" -}}
{{- default "" $anthropic.apiVersion -}}
{{- else -}}
{{- default "" $azure.apiVersion -}}
{{- end -}}
{{- end }}
