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
Create the name of the service account to use
*/}}
{{- define "caip.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "caip.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Container image to deploy
*/}}
{{- define "caip.image" -}}
{{- $tag := coalesce .Values.image.tag .Chart.AppVersion -}}
{{- if .Values.image.repository }}
{{- printf "%s:%s" .Values.image.repository $tag -}}
{{- else if and .Values.accountId .Values.region }}
{{- printf "%s.dkr.ecr.%s.amazonaws.com/collate/ai-proxy:%s" (toString .Values.accountId) .Values.region $tag -}}
{{- else }}
{{- printf "collate/ai-proxy:%s" $tag -}}
{{- end }}
{{- end }}
