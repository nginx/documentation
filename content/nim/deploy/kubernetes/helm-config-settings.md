---
docs: DOCS-1112
title: Configurable helm settings
toc: true
weight: 300
nd-content-type:
- reference
nd-product: NIM
---

This reference guide lists the configurable Helm chart parameters and default settings for NGINX Instance Manager.

## NGINX Instance Manager Helm chart settings {#helm-settings}

{{< call-out "important" "legacy chart name" >}}
In version 2.20.0, we renamed the Helm chart from `nms-hybrid` to `nim` when we moved it to its own repository. For versions 2.19.0 and earlier, use `nms-hybrid` instead of `nim` in each parameter name.
{{< /call-out >}}

To update an existing release, run `helm upgrade` with the `-f <my-values-file>` flag, where `<my-values-file>` is the path to your values file.

{{< bootstrap-table "table table-bordered table-striped table-responsive table-sm" >}}

| Parameter                                   | Description                                                                                                                                                                                                                                                         | Default    |
|:--------------------------------------------|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|:-----------|
| `nim.adminPasswordHash`                     | The hashed value of the password for the admin user.<br>To generate a hash using OpenSSL, run `openssl passwd -1 "YourPassword123#"`                                                                                                                               | N/A        |
| `nim.nmsClickhouse.mode`                    | Controls ClickHouse deployment:<br>- `internal` (default, in-cluster)<br>- `external` (requires `nim.externalClickhouse.address`)<br>- `disabled` (lightweight mode). Available in the `nim` chart 2.20.0 and later.                                                 | `internal` |
| `nms-hybrid.nmsClickhouse.enabled`          | (legacy, available in `nms-hybrid` chart 2.19.0 and earlier) Enable ClickHouse when using the legacy chart.                                                                                                                                                          | `true`     |
| `nim.nmsClickhouse.fullnameOverride`        | Modify the name of ClickHouse resources.                                                                                                                                                                                                                            | `clickhouse` |
| `nim.nmsClickhouse.image.repository`        | Repository path for the public ClickHouse image.                                                                                                                                                                                                                    | `clickhouse/clickhouse-server` |
| `nim.nmsClickhouse.image.tag`               | Tag used for pulling ClickHouse images from the registry.                                                                                                                                                                                                           | `21.3.20.1-alpine` |
| `nim.nmsClickhouse.image.pullPolicy`        | Image pull policy.                                                                                                                                                                                                                                                   | `IfNotPresent` |
| `nim.nmsClickhouse.user`                    | Username for the ClickHouse server.                                                                                                                                                                                                                                  | N/A        |
| `nim.nmsClickhouse.password`                | Password for the ClickHouse server.                                                                                                                                                                                                                                  | N/A        |
| `nim.nmsClickhouse.service.name`            | ClickHouse service name.                                                                                                                                                                                                                                             | `clickhouse` |
| `nim.nmsClickhouse.service.rpcPort`         | ClickHouse service port.                                                                                                                                                                                                                                             | `9000`     |
| `nim.nmsClickhouse.resources.requests.cpu`  | Minimum required CPU to run the ClickHouse server.                                                                                                                                                                                                                   | `500m`     |
| `nim.nmsClickhouse.resources.requests.memory` | Minimum required memory to run the ClickHouse server.                                                                                                                                                                                                               | `1Gi`      |
| `nim.nmsClickhouse.persistence.enabled`     | Use a PVC to persist ClickHouse data.                                                                                                                                                                                                                                | `true`     |
| `nim.nmsClickhouse.persistence.existingClaim` | Name of an existing PVC to use for ClickHouse persistence.                                                                                                                                                                                                             | N/A        |
| `nim.nmsClickhouse.persistence.storageClass` | Storage class for creating a ClickHouse PVC.                                                                                                                                                                                                                         |            |
| `nim.nmsClickhouse.persistence.volumeName`  | Name to use for a ClickHouse PVC volume.                                                                                                                                                                                                                             |            |
| `nim.nmsClickhouse.persistence.accessMode`  | PVC access mode for ClickHouse.                                                                                                                                                                                                                                       | `ReadWriteOnce` |
| `nim.nmsClickhouse.persistence.size`        | PVC size for ClickHouse.                                                                                                                                                                                                                                              | `1G`       |
| `nim.nmsClickhouse.tolerations`             | List of Kubernetes tolerations if any.                                                                                                                                                                                                                                | See [Kubernetes taints and tolerations](#kubernetes-taints-and-tolerations) |
| `nim.externalClickhouse.address`            | Address of the external ClickHouse service.                                                                                                                                                                                                                           |            |
| `nim.externalClickhouse.user`               | User for the external ClickHouse service.                                                                                                                                                                                                                            |            |
| `nim.externalClickhouse.password`           | Password for the external ClickHouse service.                                                                                                                                                                                                                        |            |
| `nim.serviceAccount.annotations`            | Set custom annotations for the service account used by NGINX Instance Manager.                                                                                                                                                                                         | `{}`       |
| `nim.apigw.name`                            | Name for API Gateway resources.                                                                                                                                                                                                                                       | `apigw`    |
| `nim.apigw.tlsSecret`                       | By default, the chart creates its own CA to self-sign HTTPS server certs. To bring your own certificates, set `tlsSecret` to an existing Kubernetes secret in the target namespace. The secret must include `tls.crt`, `tls.key`, and `ca.pem`. See [Use your own certificates]({{< ref "/nim/deploy/kubernetes/frequently-used-helm-configs.md#use-your-own-certificates" >}}). |            |
| `nim.apigw.image.repository`                | Repository path for the `apigw` image.                                                                                                                                                                                                                                 | `apigw`    |
| `nim.apigw.image.tag`                       | Tag used for pulling `apigw` images.                                                                                                                                                                                                                                  | `latest`   |
| `nim.apigw.image.pullPolicy`                | Image pull policy.                                                                                                                                                                                                                                                     | `IfNotPresent` |
| `nim.apigw.container.port.https`            | Container HTTPS port.                                                                                                                                                                                                                                                  | `443`      |
| `nim.apigw.service.name`                    | Service name.                                                                                                                                                                                                                                                          | `apigw`    |
| `nim.apigw.service.type`                    | Service type (`ClusterIp`, `LoadBalancer`, `NodePort`).                                                                                                                                                                                                               | `ClusterIp` |
| `nim.apigw.service.httpsPort`               | Service HTTPS port.                                                                                                                                                                                                                                                    | `443`      |
| `nim.apigw.resources.requests.cpu`          | Minimum required CPU to run `apigw`.                                                                                                                                                                                                                                   | `250m`     |
| `nim.apigw.resources.requests.memory`       | Minimum required memory to run `apigw`.                                                                                                                                                                                                                                | `256Mi`    |
| `nim.apigw.tolerations`                     | List of Kubernetes tolerations if any.                                                                                                                                                                                                                                | See [Kubernetes taints and tolerations](#kubernetes-taints-and-tolerations) |
| `nim.core.name`                             | Name for core resources.                                                                                                                                                                                                                                               | `core`     |
| `nim.core.image.repository`                 | Repository path for the `core` image.                                                                                                                                                                                                                                   | `core`     |
| `nim.core.image.tag`                        | Tag used for pulling `core` images.                                                                                                                                                                                                                                     | `latest`   |
| `nim.core.image.pullPolicy`                 | Image pull policy.                                                                                                                                                                                                                                                     | `IfNotPresent` |
| `nim.core.container.port.http`              | Container HTTP port.                                                                                                                                                                                                                                                    | `8033`     |
| `nim.core.container.port.db`                | Container database port.                                                                                                                                                                                                                                               | `7891`     |
| `nim.core.container.port.grpc`              | Container gRPC port.                                                                                                                                                                                                                                                                                                     | `8038`   |
| `nim.core.service.httpPort`                 | Service HTTP port.                                                                                                                                                                                                                                                      | `8033`                 |
| `nim.core.service.grpcPort`                 | Service gRPC port.                                                                                                                                                                                                                                                                                                     | `8038`   |
| `nim.core.resources.requests.cpu`           | Minimum required CPU to run `core`.                                                                                                                                                                                                                                      | `500m`     |
| `nim.core.resources.requests.memory`        | Minimum required memory to run `core`.                                                                                                                                                                                                                                   | `512Mi`    |
| `nim.core.persistence.enabled`              | Enable persistence for `core`.                                                                                                                                                                                                                                          | `true`     |
| `nim.core.persistence.claims`               | Array of PVCs for Dqlite and secrets. Modify to use an existing PVC.                                                                                                                                                                                                     | See [Dqlite storage](#nim-dqlite-storage-configuration) and [Secrets storage](#nim-secrets-storage-configuration) |
| `nim.core.persistence.storageClass`         | Storage class for creating a `core` PVC.                                                                                                                                                                                                                                 |            |
| `nim.core.persistence.volumeName`           | Name for a `core` PVC volume.                                                                                                                                                                                                                                            |            |
| `nim.core.tolerations`                      | List of Kubernetes tolerations if any.                                                                                                                                                                                                                                   | See [Kubernetes taints and tolerations](#kubernetes-taints-and-tolerations) |
| `nim.dpm.name`                              | Name for `dpm` resources.                                                                                                                                                                                                                                                | `dpm`      |
| `nim.dpm.image.repository`                  | Repository path for the `dpm` image.                                                                                                                                                                                                                                      | `dpm`      |
| `nim.dpm.image.tag`                         | Tag used for pulling `dpm` images.                                                                                                                                                                                                                                        | `latest`   |
| `nim.dpm.image.pullPolicy`                  | Image pull policy.                                                                                                                                                                                                                                                                                                     | `IfNotPresent`|   
| `nim.dpm.container.port.http`               | Container HTTP port.                                                                                                                                                                                                                                                      | `8034`     |
| `nim.dpm.container.port.nats`               | Container NATS port.                                                                                                                                                                                                                                                      | `9100`     |
| `nim.dpm.container.port.db`                 | Container database port.                                                                                                                                                                                                                                                  | `7890`     |
| `nim.dpm.container.port.grpc`               | Container gRPC port.                                                                                                                                                                                                                                                      | `8036`     |
{{</ bootstrap-table >}}

## NGINX Instance Manager dqlite storage configuration

```yaml
- name: dqlite
  existingClaim:
  size: 500Mi
  accessMode: ReadWriteOnce
```

## NGINX Instance Manager secrets storage configuration

```yaml
  - name: secrets
    existingClaim:
    size: 128Mi
    accessMode: ReadWriteOnce
```

## NGINX Instance Manager NATS storage configuration

```yaml
  - name: nats-streaming
    existingClaim:
    size: 1Gi
    accessMode: ReadWriteOnce
```

## Kubernetes taints and tolerations

This example shows how to set the API Gateway pod to wait 60 seconds when Kubernetes applies the NoExecute taint (which marks a node as unschedulable) before it removes the pod.

```yaml
tolerations:
  - key: "node.kubernetes.io/unreachable"
    operator: "Exists"
    effect: "NoExecute"
    tolerationSeconds: 60
  - key: "node.kubernetes.io/network-unavailable"
    operator: "Exists"
    effect: "NoExecute"
    tolerationSeconds: 60
```

For more information, refer to the official Kubernetes [Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/) documentation.
