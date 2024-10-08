{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "osdu-developer-service.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "osdu-developer-service.fullname" -}}
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
{{- define "osdu-developer-service.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "osdu-developer-service.labels" -}}
helm.sh/chart: {{ include "osdu-developer-service.chart" . }}
{{ include "osdu-developer-service.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "osdu-developer-service.selectorLabels" -}}
app.kubernetes.io/name: {{ include "osdu-developer-service.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "osdu-developer-service.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "osdu-developer-service.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Determine if the installation type is enabled
*/}}
{{- define "osdu-developer-service.isEnabled" -}}
  {{- $installationType := .Values.installationType | default "osduCore" -}}
  {{- if eq $installationType "osduReference" -}}
    {{- if hasKey .Values "osduReferenceEnabled" -}}
      {{- if eq .Values.osduReferenceEnabled "true" }}1{{else}}0{{end -}}
    {{- else -}}
      {{- 0 -}}
    {{- end -}}
  {{- else if eq $installationType "osduCore" -}}
    {{- if hasKey .Values "osduCoreEnabled" -}}
      {{- if eq .Values.osduCoreEnabled "true" }}1{{else}}0{{end -}}
    {{- else -}}
      {{- 0 -}}
    {{- end -}}
  {{- else -}}
    {{- 0 -}}
  {{- end -}}
{{- end }}