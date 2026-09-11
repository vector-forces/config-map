{{/*
Return the chart name.
*/}}
{{- define "app-chart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the Kubernetes object base name.
*/}}
{{- define "app-chart.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else if .Values.app.name -}}
{{- .Values.app.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name (include "app-chart.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Return the namespace to use for namespaced resources.
*/}}
{{- define "app-chart.namespace" -}}
{{- default .Release.Namespace .Values.app.namespace -}}
{{- end -}}

{{/*
Return the chart label.
*/}}
{{- define "app-chart.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels.
*/}}
{{- define "app-chart.labels" -}}
helm.sh/chart: {{ include "app-chart.chart" . }}
{{ include "app-chart.selectorLabels" . }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{ if .Values.app.labels }}
{{ toYaml .Values.app.labels }}
{{ end }}
{{- end -}}

{{/*
Selector labels.
*/}}
{{- define "app-chart.selectorLabels" -}}
app.kubernetes.io/name: {{ include "app-chart.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app: {{ include "app-chart.fullname" . }}
{{- end -}}

{{/*
ServiceAccount name.
*/}}
{{- define "app-chart.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (include "app-chart.fullname" .) .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end -}}

{{/*
ConfigMap name.
*/}}
{{- define "app-chart.configMapName" -}}
{{- default (include "app-chart.fullname" .) .Values.configMap.name -}}
{{- end -}}

{{/*
Secret name.
*/}}
{{- define "app-chart.secretName" -}}
{{- default (include "app-chart.fullname" .) .Values.secret.name -}}
{{- end -}}

{{/*
PVC name.
*/}}
{{- define "app-chart.pvcName" -}}
{{- default (include "app-chart.fullname" .) .Values.persistence.claimName -}}
{{- end -}}
