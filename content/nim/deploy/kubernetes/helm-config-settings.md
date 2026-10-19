---
f5-docs: DOCS-1112
title: Configurable Helm settings
toc: true
weight: 300
f5-content-type: reference
f5-product: F5 NGINX Instance Manager
description: "Helm chart parameters, defaults, and examples for deploying F5 NGINX Instance Manager on Kubernetes."
f5-summary: >
  Look up Helm chart parameters and defaults for deploying F5 NGINX Instance Manager on Kubernetes.
  Use the version-specific reference and examples to customize values.yaml for your environment.
---

This reference lists Helm settings for F5 NGINX Instance Manager. The defaults below match the released `nim` chart **2.3.1**, for NGINX Instance Manager **2.23.1**.

## NGINX Instance Manager Helm chart settings {#helm-settings}

For a direct installation of `nginx-stable/nim`, use the parameter names below without a `nim.` prefix. For example:

```yaml
nmsClickhouse:
  mode: internal
core:
  persistence:
    enabled: true
```

The Helm release name doesn't add a prefix to values. If you use this chart as a dependency, follow the parent chart's dependency name or alias.

To check the defaults for your chart version, first [add the Helm repository]({{< ref "/nim/deploy/kubernetes/deploy-using-helm.md#add-repository" >}}). Then run:

```shell
helm show values nginx-stable/nim --version <CHART_VERSION>
```

Replace `<CHART_VERSION>` with your chart version, such as `2.3.1`. See the [chart version table]({{< ref "/nim/deploy/kubernetes/deploy-using-helm.md#install-the-chart" >}}) for application versions.

Use `helm upgrade` with `-f <MY_VALUES_FILE>` to apply changes. Replace `<MY_VALUES_FILE>` with your values file path. Follow the [upgrade instructions]({{< ref "/nim/deploy/kubernetes/deploy-using-helm.md#upgrade-nginx-instance-manager" >}}) for the complete command.

In the tables, `null` means unset, `""` means an empty string, `[]` means an empty list, and `{}` means an empty map. Resource requests are chart defaults, not sizing recommendations for every workload.

### General settings

{{< table >}}

| Parameter | Description | Default |
|---|---|---|
| `adminPasswordHash` | Required admin password hash. Generate one with `openssl passwd -6 '<YOUR_PASSWORD>'`, replacing `<YOUR_PASSWORD>` with your password. | `null` |
| `imagePullSecrets` | Kubernetes Secrets for pulling images from a private registry. | `[]` |
| `nameOverride` | Name used by the chart's fullname helper when `fullnameOverride` is empty. | `nms` |
| `fullnameOverride` | Full name for shared resources, including the ServiceAccount and Secrets. | `nms` |
| `commonLabels` | Extra labels for resources that use the common-label helper. | `{}` |
| `podLabels` | Extra pod labels for ClickHouse, API Gateway, Core, DPM, Ingestion, Integrations, Security Monitoring, and Vault. | `{}` |
| `podAnnotations` | Extra pod annotations. This optional setting has no entry in the default values file. | Unset |
| `serviceAccount.annotations` | Extra ServiceAccount annotations. | `{}` |
| `serviceAccount.labels` | Extra ServiceAccount labels. | `{}` |
| `serviceAccount.name` | ServiceAccount name used by pods. If you change `fullnameOverride`, set this to the same name or an existing ServiceAccount. | `nms` (template default) |
| `openshift.enabled` | Use the chart's OpenShift settings. | `false` |
| `global.utility` | Create the utility Deployment with zero replicas for maintenance tasks. | `false` |
| `global.nmsModules` | Advanced module configuration supplied by module charts. | `{}` |
| `nimLivenessAddress` | Address for internal liveness checks. | `apigw` |
| `log.encoding` | Log format: `console` or `json`. | `console` |
| `log.level` | Log level: `debug`, `info`, `warn`, `error`, `panic`, or `fatal`. | `error` |
| `agent.secure` | Require agent client-certificate checks for the gateway's agent gRPC endpoints. | `false` |
| `networkPolicies.enabled` | Create the chart's NetworkPolicies. | `true` |
| `networkPolicies.apigw.ingressFrom` | NetworkPolicy peers allowed to reach the API Gateway. See the example below. | `[{ipBlock: {cidr: "0.0.0.0/0"}}]` |

{{< /table >}}

Use Kubernetes `namespaceSelector` and `podSelector` peers when you need to allow an ingress controller in another namespace. For example:

```yaml
networkPolicies:
  apigw:
    ingressFrom:
      - namespaceSelector:
          matchLabels:
            kubernetes.io/metadata.name: ingress-nginx
        podSelector:
          matchLabels:
            app.kubernetes.io/name: ingress-nginx
```

Replace the namespace and pod labels with those of your ingress controller. Use Helm's `--namespace` option to select the deployment namespace.

### ClickHouse

{{< table >}}

| Parameter | Description | Default |
|---|---|---|
| `nmsClickhouse.mode` | `internal` deploys ClickHouse, `external` uses an existing server, and `disabled` selects lightweight mode without metrics. | `internal` |
| `nmsClickhouse.fullnameOverride` | Name for ClickHouse resources, including its Service. | `clickhouse` |
| `nmsClickhouse.image.repository` | ClickHouse image repository. | `mirror.gcr.io/clickhouse/clickhouse-server` |
| `nmsClickhouse.image.tag` | ClickHouse image tag. | `24.8.12.28-alpine` |
| `nmsClickhouse.image.pullPolicy` | Image pull policy. | `IfNotPresent` |
| `nmsClickhouse.auth.username` | ClickHouse username. | `default` |
| `nmsClickhouse.auth.password` | ClickHouse password when no existing Secret is set. | `""` |
| `nmsClickhouse.auth.existingSecret` | Existing Secret that contains the ClickHouse password. | `""` |
| `nmsClickhouse.auth.existingSecretKey` | Password key in the existing Secret. | `""` |
| `nmsClickhouse.service.rpcPort` | Native protocol port. | `9000` |
| `nmsClickhouse.service.httpPort` | HTTP port exposed by the container and Service. | `8123` |
| `nmsClickhouse.resources.requests.cpu` | CPU request. | `120m` |
| `nmsClickhouse.resources.requests.memory` | Memory request. | `1Gi` |
| `nmsClickhouse.persistence.enabled` | Use persistent storage for ClickHouse data. | `true` |
| `nmsClickhouse.persistence.existingClaim` | Existing persistent volume claim (PVC). In chart 2.3.1, also set `nmsClickhouse.fullnameOverride` to this claim name. | `null` |
| `nmsClickhouse.persistence.storageClass` | Storage class. An empty value uses the cluster default. Use `-` to request no storage class. | `""` |
| `nmsClickhouse.persistence.volumeName` | Persistent volume to bind to the generated claim. | `""` |
| `nmsClickhouse.persistence.accessMode` | Claim access mode. | `ReadWriteOnce` |
| `nmsClickhouse.persistence.size` | Claim size. | `1Gi` |
| `nmsClickhouse.tolerations` | Pod tolerations. See [Taints and tolerations](#kubernetes-taints-and-tolerations). | `[]` |
| `externalClickhouse.address` | External ClickHouse host and native protocol port. Required when `nmsClickhouse.mode` is `external`. | `null` |
| `externalClickhouse.auth.username` | External ClickHouse username. | `null` |
| `externalClickhouse.auth.password` | External ClickHouse password when no existing Secret is set. | `""` |
| `externalClickhouse.auth.existingSecret` | Existing Secret that contains the external ClickHouse password. | `""` |
| `externalClickhouse.auth.existingSecretKey` | Password key in the existing Secret. | `""` |

{{< /table >}}

Set both `auth.existingSecret` and `auth.existingSecretKey` to use a password Secret. The existing Secret takes precedence over `auth.password`. The older `user` and `password` fields outside `auth` don't apply to chart 2.3.1.

### API Gateway

{{< table >}}

| Parameter | Description | Default |
|---|---|---|
| `apigw.name` | Name for API Gateway resources, including its Service. | `apigw` |
| `apigw.image.repository` | API Gateway image repository. | `apigw` |
| `apigw.image.tag` | API Gateway image tag. | `2.23.1` |
| `apigw.image.pullPolicy` | Image pull policy. | `IfNotPresent` |
| `apigw.tlsSecret` | Existing `kubernetes.io/tls` Secret with `tls.crt` and `tls.key`. An empty value uses a chart-generated certificate. | `""` |
| `apigw.serverName` | NGINX `server_name`. Accepts one name or a space-separated list. An empty value uses `_`. | `""` |
| `apigw.tlsReload.enabled` | Watch the mounted certificate and send `SIGHUP` to NGINX when it rotates. | `false` |
| `apigw.service.type` | Service type: `ClusterIP`, `LoadBalancer`, or `NodePort`. | `ClusterIP` |
| `apigw.service.externalIPs` | External IP addresses for the Service. | `[]` |
| `apigw.service.httpsPort` | Service HTTPS port. | `443` |
| `apigw.service.nodePortHttps` | Fixed NodePort when the Service type is `NodePort`. If unset, Kubernetes allocates the port. | `null` |
| `apigw.resources.requests.cpu` | CPU request. | `100m` |
| `apigw.resources.requests.memory` | Memory request. | `256Mi` |
| `apigw.tolerations` | Pod tolerations. | `[]` |
| `apigw.nginxWorkerConnections` | NGINX `worker_connections`. | `1024` (template default) |
| `apigw.nginxWorkerRlimitNofile` | NGINX `worker_rlimit_nofile`. | `4096` (template default) |
| `replicaCount` | API Gateway replica count only. If unset, Kubernetes defaults to one replica. | Unset |

{{< /table >}}

The container listens on port `8443`. The Service forwards its HTTPS port to this container port. `apigw.container.port.https` and `apigw.service.name` don't control these settings in chart 2.3.1.

For certificate setup, see [Use external TLS certificates]({{< ref "/nim/deploy/kubernetes/configure-external-certs.md" >}}). For worker tuning, see [Optimize NGINX proxy gateway]({{< ref "/nim/system-configuration/configure-gateway.md#update-worker-settings-with-helm" >}}).

### Core

{{< table >}}

| Parameter | Description | Default |
|---|---|---|
| `core.name` | Core resource name. | `core` |
| `core.image.repository` | Image repository. | `core` |
| `core.image.tag` | Image tag. | `2.23.1` |
| `core.image.pullPolicy` | Image pull policy. | `IfNotPresent` |
| `core.container.port.http` | Container HTTP port. | `8033` |
| `core.container.port.db` | Container database port. | `7891` |
| `core.container.port.grpc` | Container gRPC port. | `8038` |
| `core.service.httpPort` | Service HTTP port. | `8033` |
| `core.service.grpcPort` | Service gRPC port. | `8038` |
| `core.resources.requests.cpu` | CPU request. | `10m` |
| `core.resources.requests.memory` | Memory request. | `512Mi` |
| `core.persistence.enabled` | Use persistent storage. | `true` |
| `core.persistence.claims` | Claims for dqlite and secrets. | See [Core storage](#nim-dqlite-storage-configuration) |
| `core.persistence.storageClass` | Storage class. Empty uses the cluster default. Use `-` for no storage class. | `""` |
| `core.persistence.volumeName` | Persistent volume to bind to generated claims. | `""` |
| `core.tolerations` | Pod tolerations. | `[]` |

{{< /table >}}

### Dataplane Manager

{{< table >}}

| Parameter | Description | Default |
|---|---|---|
| `dpm.name` | Dataplane Manager resource name. | `dpm` |
| `dpm.image.repository` | Image repository. | `dpm` |
| `dpm.image.tag` | Image tag. | `2.23.1` |
| `dpm.image.pullPolicy` | Image pull policy. | `IfNotPresent` |
| `dpm.container.port.http` | Container HTTP port. | `8034` |
| `dpm.container.port.grpc` | Container gRPC port. | `8036` |
| `dpm.container.port.nats` | Container NATS port. | `9100` |
| `dpm.container.port.db` | Container database port. | `7890` |
| `dpm.service.httpPort` | Service HTTP port. | `8034` |
| `dpm.service.grpcPort` | Service gRPC port. | `8036` |
| `dpm.service.natsPort` | Service NATS port. | `9100` |
| `dpm.resources.requests.cpu` | CPU request. | `100m` |
| `dpm.resources.requests.memory` | Memory request. | `512Mi` |
| `dpm.persistence.enabled` | Use persistent storage. | `true` |
| `dpm.persistence.claims` | Claims for dqlite and NATS data. | See [DPM storage](#nim-nats-storage-configuration) |
| `dpm.persistence.storageClass` | Storage class. Empty uses the cluster default. Use `-` for no storage class. | `""` |
| `dpm.persistence.volumeName` | Persistent volume to bind to generated claims. | `""` |
| `dpm.tolerations` | Pod tolerations. | `[]` |

{{< /table >}}

### Ingestion

{{< table >}}

| Parameter | Description | Default |
|---|---|---|
| `ingestion.name` | Ingestion resource name. | `ingestion` |
| `ingestion.image.repository` | Image repository. | `ingestion` |
| `ingestion.image.tag` | Image tag. | `2.23.1` |
| `ingestion.image.pullPolicy` | Image pull policy. | `IfNotPresent` |
| `ingestion.replicaCount` | Replica count. | `1` |
| `ingestion.container.port.http` | Container HTTP port. | `8040` |
| `ingestion.container.port.grpc` | Container gRPC port. | `8035` |
| `ingestion.service.httpPort` | Service HTTP port. | `8040` |
| `ingestion.service.grpcPort` | Service gRPC port. | `8035` |
| `ingestion.resources.requests.cpu` | CPU request. | `100m` |
| `ingestion.resources.requests.memory` | Memory request. | `512Mi` |
| `ingestion.tolerations` | Pod tolerations. | `[]` |

{{< /table >}}

### Integrations

{{< table >}}

| Parameter | Description | Default |
|---|---|---|
| `integrations.name` | Integrations resource name. | `integrations` |
| `integrations.image.repository` | Image repository. | `integrations` |
| `integrations.image.tag` | Image tag. | `2.23.1` |
| `integrations.image.pullPolicy` | Image pull policy. | `IfNotPresent` |
| `integrations.container.modeOfOperation` | Licensing mode: `connected` or `disconnected`. | `connected` |
| `integrations.container.port.http` | Container HTTP port. | `8037` |
| `integrations.container.port.db` | Container database port. | `7892` |
| `integrations.container.port.licenseDB` | License database port in chart 2.3.1. | `7893` |
| `integrations.service.httpPort` | Service HTTP port. | `8037` |
| `integrations.resources.requests.cpu` | CPU request. | `100m` |
| `integrations.resources.requests.memory` | Memory request. | `512Mi` |
| `integrations.persistence.enabled` | Use persistent storage. | `true` |
| `integrations.persistence.claims` | Claims for dqlite and proxy certificates. | See [Integrations storage](#integrations-storage-configuration) |
| `integrations.persistence.storageClass` | Storage class. Empty uses the cluster default. Use `-` for no storage class. | `""` |
| `integrations.persistence.volumeName` | Persistent volume to bind to generated claims. | `""` |
| `integrations.tolerations` | Pod tolerations. | `[]` |

{{< /table >}}

### Security Monitoring

{{< table >}}

| Parameter | Description | Default |
|---|---|---|
| `secmon.name` | Security Monitoring resource name. | `secmon` |
| `secmon.image.repository` | Image repository. | `secmon` |
| `secmon.image.tag` | Image tag. | `2.23.1` |
| `secmon.image.pullPolicy` | Image pull policy. | `IfNotPresent` |
| `secmon.replicaCount` | Replica count. | `1` |
| `secmon.container.port.http` | Container HTTP port. | `8039` |
| `secmon.service.httpPort` | Service HTTP port. | `8039` |
| `secmon.resources.requests.cpu` | CPU request. | `100m` |
| `secmon.resources.requests.memory` | Memory request. | `512Mi` |
| `secmon.tolerations` | Pod tolerations. | `[]` |

{{< /table >}}

### Utility

Set `global.utility` to `true` to create the utility Deployment. It starts with zero replicas. See [Back up and restore]({{< ref "/nim/admin-guide/backup-and-recovery.md" >}}) for maintenance procedures.

{{< table >}}

| Parameter | Description | Default |
|---|---|---|
| `utility.name` | Utility resource name. | `utility` |
| `utility.image.repository` | Image repository. | `utility` |
| `utility.image.tag` | Image tag. | `2.23.1` |
| `utility.image.pullPolicy` | Image pull policy. | `IfNotPresent` |
| `utility.tolerations` | Pod tolerations. | `[]` |

{{< /table >}}

### Labels and security contexts

For each of `nmsClickhouse`, `apigw`, `core`, `dpm`, `ingestion`, `integrations`, and `secmon`, you can set these labels. Replace `<SERVICE>` with a service name.

{{< table >}}

| Parameter | Description | Default |
|---|---|---|
| `<SERVICE>.service.labels` | Extra Service labels. | `{}` |
| `<SERVICE>.pod.labels` | Extra pod labels. | `{}` |

{{< /table >}}

The security context fields below set the pod user, group, and volume group. Replace `<SERVICE>` with a service from the next table.

{{< table >}}

| Parameter | Description |
|---|---|
| `<SERVICE>.securityContext.runAsUser` | User ID for the pod's processes. |
| `<SERVICE>.securityContext.runAsGroup` | Primary group ID. |
| `<SERVICE>.securityContext.fsGroup` | Group ID for mounted volumes. |

{{< /table >}}

{{< table >}}

| Service | `runAsUser` | `runAsGroup` | `fsGroup` |
|---|---|---|---|
| `nmsClickhouse` | `101` | `101` | `101` |
| `apigw` | `101` | `101` | `101` |
| `core` | `1000` | `1000` | `1000` |
| `dpm` | `1000` | `1000` | `1000` |
| `ingestion` | `1000` | `1000` | `1000` |
| `integrations` | `1000` | `1000` | `1000` |
| `secmon` | `1000` | `1000` | `1000` |
| `utility` | `1000` | `1000` | `1000` |

{{< /table >}}

When `openshift.enabled` is `true`, the chart uses the following settings instead of the per-service values. Leave them unset for OpenShift to assign IDs.

{{< table >}}

| Parameter | Default |
|---|---|
| `openshift.securityContext.runAsUser` | `null` |
| `openshift.securityContext.runAsGroup` | `null` |
| `openshift.securityContext.fsGroup` | `null` |

{{< /table >}}

### External service certificates

Use these settings to supply certificates for internal mutual TLS (mTLS). Follow [Use external TLS certificates]({{< ref "/nim/deploy/kubernetes/configure-external-certs.md" >}}) for Secret contents and setup.

{{< table >}}

| Parameter | Description | Default |
|---|---|---|
| `externalCerts.ca.enabled` | Use a pre-created CA Secret instead of generating one. | `false` |
| `externalCerts.ca.secretName` | CA Secret name override. | `""` |
| `externalCerts.core.enabled` | Use pre-created Core certificates. | `false` |
| `externalCerts.core.secretName` | Core Secret name override. | `""` |
| `externalCerts.dpm.enabled` | Use pre-created DPM certificates. | `false` |
| `externalCerts.dpm.secretName` | DPM Secret name override. | `""` |
| `externalCerts.ingestion.enabled` | Use pre-created Ingestion certificates. | `false` |
| `externalCerts.ingestion.secretName` | Ingestion Secret name override. | `""` |
| `externalCerts.integrations.enabled` | Use pre-created Integrations certificates. | `false` |
| `externalCerts.integrations.secretName` | Integrations Secret name override. | `""` |
| `externalCerts.secmon.enabled` | Use pre-created Security Monitoring certificates. | `false` |
| `externalCerts.secmon.secretName` | Security Monitoring Secret name override. | `""` |
| `externalCerts.apigw.enabled` | Use pre-created API Gateway client certificates. | `false` |
| `externalCerts.apigw.secretName` | API Gateway client Secret name override. | `""` |

{{< /table >}}

If a Secret name is empty, the chart derives it from its fullname. With the default fullname `nms`, the names are `nms-ca`, `nms-core-certs`, `nms-dpm-certs`, `nms-ingestion-certs`, `nms-integrations-certs`, `nms-secmon-certs`, and `nms-apigw-client-certs`.

### Forward proxy

{{< table >}}

| Parameter | Description | Default |
|---|---|---|
| `proxyConfig.proxyEnable` | Use a forward proxy. | `false` |
| `proxyConfig.proxyHost` | Proxy hostname. | `""` |
| `proxyConfig.proxyPort` | Proxy port. | `3128` |
| `proxyConfig.proxyProtocol` | Proxy protocol: `http` or `https`. | `http` |
| `proxyConfig.proxyAuthRequired` | Use basic authentication with the proxy. | `false` |
| `proxyConfig.proxyUsername` | Basic authentication username. | `""` |
| `proxyConfig.proxyPassword` | Basic authentication password. | `""` |
| `proxyConfig.proxySslVerify` | Verify the proxy certificate. In chart 2.3.1, an explicit `false` also renders as `true`. | `true` |

{{< /table >}}

See [Use a third-party forward proxy]({{< ref "/nim/system-configuration/configure-forward-proxy.md" >}}) for proxy requirements.

### Vault

Use `externalVault.address` for an existing Vault server. See [Use Vault for storing secrets]({{< ref "/nim/system-configuration/configure-vault.md" >}}) for the required token and server setup.

The bundled `nmsVault` settings are for development only.

In chart 2.3.1, setting `nmsVault.enabled` to `true` fails template rendering. The Vault label templates use a different values path. Use an existing Vault server for this version.

{{< table >}}

| Parameter | Description | Default |
|---|---|---|
| `externalVault.address` | External Vault address. | `null` |
| `nmsVault.enabled` | Request the development Vault Deployment. | `false` |
| `nmsVault.fullnameOverride` | Name for development Vault resources. | `vault` |
| `nmsVault.image.repository` | Development Vault image repository. | `vault` |
| `nmsVault.image.tag` | Development Vault image tag. | `1.12.2` |
| `nmsVault.image.pullPolicy` | Image pull policy. | `IfNotPresent` |
| `nmsVault.service.rpcPort` | Vault port. | `8200` |

{{< /table >}}

<span id="nginx-instance-manager-dqlite-storage-configuration"></span>

## Core dqlite storage configuration {#nim-dqlite-storage-configuration}

Core uses a `500Mi` dqlite claim and a `128Mi` secrets claim. Use the complete array when you override `core.persistence.claims`:

```yaml
core:
  persistence:
    claims:
      - name: dqlite
        existingClaim: null
        size: 500Mi
        accessMode: ReadWriteOnce
      - name: secrets
        existingClaim: null
        size: 128Mi
        accessMode: ReadWriteOnce
```

<span id="nginx-instance-manager-secrets-storage-configuration"></span>

## Core secrets storage configuration {#nim-secrets-storage-configuration}

The `secrets` entry in the [Core claim array](#nim-dqlite-storage-configuration) stores secrets. To reuse a claim, set that entry's `existingClaim` to its name. Create the claim before installation.

<span id="nginx-instance-manager-nats-storage-configuration"></span>

## DPM dqlite and NATS storage configuration {#nim-nats-storage-configuration}

DPM uses separate `1Gi` claims for dqlite and NATS data:

```yaml
dpm:
  persistence:
    claims:
      - name: dqlite
        existingClaim: null
        size: 1Gi
        accessMode: ReadWriteOnce
      - name: nats-streaming
        existingClaim: null
        size: 1Gi
        accessMode: ReadWriteOnce
```

The `nats-streaming` claim name remains in the chart for the NATS data volume.

## Integrations storage configuration

Integrations uses a `1Gi` dqlite claim and a `128Mi` proxy-certificate claim:

```yaml
integrations:
  persistence:
    claims:
      - name: dqlite
        existingClaim: null
        size: 1Gi
        accessMode: ReadWriteOnce
      - name: proxy-certs
        existingClaim: null
        size: 128Mi
        accessMode: ReadWriteOnce
```

For DPM and Integrations, set `existingClaim` on each entry to reuse a pre-created claim. Helm replaces claim arrays rather than merging individual entries, so include both claims when you override an array.

## Kubernetes taints and tolerations

Set tolerations under the service name. This example lets the API Gateway pod remain bound to an unreachable node for 60 seconds before eviction:

```yaml
apigw:
  tolerations:
    - key: node.kubernetes.io/unreachable
      operator: Exists
      effect: NoExecute
      tolerationSeconds: 60
```

For more information, see Kubernetes [Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/).

## Earlier chart versions

Starting with NGINX Instance Manager 2.20.0, the chart name is `nginx-stable/nim`. Its first chart version is `2.0.0`.

For NGINX Instance Manager 2.19.x, use `nginx-stable/nms-hybrid`. Direct installations use root-level values. For older `nginx-stable/nms` installations, values for the dependency use the `nms-hybrid` prefix.

These older charts use `nmsClickhouse.enabled` instead of `nmsClickhouse.mode`. Check your chart's values and follow the [version-specific installation instructions]({{< ref "/nim/deploy/kubernetes/deploy-using-helm.md#helm-deployment-for-nginx-instance-manager-219" >}}) before applying settings from this reference.
