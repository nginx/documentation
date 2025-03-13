---
docs: DOCS-1112
title: Configurable Helm settings
toc: true
weight: 300
type:
- reference
---

{{< include "/nim/decoupling/note-legacy-nms-references.md" >}}

This reference guide lists the configurable Helm chart parameters and default settings for NGINX Instance Manager.

## NGINX Instance Manager Helm chart settings {#helm-settings}

The following table lists the configurable parameters and default values for NGINX Instance Manager when installing from a Helm chart.

To modify a configuration for an existing release, run the `helm upgrade` command and use `-f <my-values-file>`, where `<my-values-file>` is the path to a values file with your desired configuration.

{{<bootstrap-table "table table-bordered table-striped table-responsive table-sm">}}

| Parameter | Description | Default |
|:-----------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------|:--------------------------|
| `nms-hybrid.adminPasswordHash`                        | The hashed value of the password for the admin user.<br>To generate the hash using `openssl`, run a command like: `openssl passwd -1 "YourPassword123#"` | N/A |
| `nms-hybrid.nmsClickhouse.enabled`                    | Enable this if external ClickHouse is not used. | `true` |
| `nms-hybrid.nmsClickhouse.fullnameOverride`           | Modify the name of ClickHouse resources. | `clickhouse` |
| `nms-hybrid.nmsClickhouse.image.repository`           | Repository name and path for the public ClickHouse image. | `clickhouse/clickhouse-server` |
| `nms-hybrid.nmsClickhouse.image.tag`                  | Tag used for pulling images from the registry. | `21.3.20.1-alpine` |
| `nms-hybrid.nmsClickhouse.image.pullPolicy`           | Image pull policy. | `IfNotPresent` |
| `nms-hybrid.nmsClickhouse.user`                       | Username to connect to the ClickHouse server. | N/A |
| `nms-hybrid.nmsClickhouse.password`                   | Password for the ClickHouse server. | N/A |
| `nms-hybrid.nmsClickhouse.service.name`               | ClickHouse service name. | `clickhouse` |
| `nms-hybrid.nmsClickhouse.service.rpcPort`            | ClickHouse service port. | `9000` |
| `nms-hybrid.nmsClickhouse.resources.requests.cpu`     | Minimum required CPU to run the ClickHouse server. | `500m` |
| `nms-hybrid.nmsClickhouse.resources.requests.memory`  | Minimum required memory to run the ClickHouse server. | `1Gi` |
| `nms-hybrid.nmsClickhouse.persistence.enabled`        | Use PVCs to persist ClickHouse data. | `true` |
| `nms-hybrid.nmsClickhouse.persistence.existingClaim`  | Name of an existing Persistent Volume Claim (PVC) to use for ClickHouse persistence. | N/A |
| `nms-hybrid.nmsClickhouse.persistence.storageClass`   | Storage class to use for creating a ClickHouse PVC. |  |
| `nms-hybrid.nmsClickhouse.persistence.volumeName`     | Name to use for a ClickHouse PVC volume. |  |
| `nms-hybrid.nmsClickhouse.persistence.accessMode`     | PVC access mode for ClickHouse. | `ReadWriteOnce` |
| `nms-hybrid.nmsClickhouse.persistence.size`           | PVC size for ClickHouse. | `1G` |
| `nms-hybrid.nmsClickhouse.tolerations`                | List of Kubernetes tolerations, if any. | See [Kubernetes taints and tolerations](#kubernetes-taints-and-tolerations) |
| `nms-hybrid.externalClickhouse.address`               | Address of the external ClickHouse service. |  |
| `nms-hybrid.externalClickhouse.user`                  | User of the external ClickHouse service. |  |
| `nms-hybrid.externalClickhouse.password`              | Password of the external ClickHouse service. |  |
| `nms-hybrid.serviceAccount.annotations`               | Set custom annotations for the service account used by NGINX Instance Manager. | `{}` |
| `nms-hybrid.apigw.name`                               | Name used for API Gateway resources. | `apigw` |
| `nms-hybrid.apigw.tlsSecret`                          | By default, this Helm chart creates its own Certificate Authority (CA) to self-sign HTTPS server cert key pairs. These are not managed by NGINX Instance Manager. You can bring your own NGINX API Gateway certificates for hosting the HTTPS server by setting `tlsSecret` to an existing Kubernetes secret name in the targeted namespace. The secret should include `tls.crt`, `tls.key`, and `ca.pem` in the data object. Using a self-provisioned "tlsSecret" is recommended for production.<br><br>Refer to the "Use your own certificates" section in [Frequently used Helm configurations]({{< relref "/nim/deploy/kubernetes/frequently-used-helm-configs.md#use-your-own-certificates" >}}) for an example. |  |
| `nms-hybrid.apigw.image.repository`                   | Repository name and path for the `apigw` image. | `apigw` |
| `nms-hybrid.apigw.image.tag`                          | Tag used for pulling images from the registry. | `latest` |
| `nms-hybrid.apigw.image.pullPolicy`                   | Image pull policy. | `IfNotPresent` |
| `nms-hybrid.apigw.container.port.https`               | Container HTTPS port. | `443` |
| `nms-hybrid.apigw.service.name`                       | Service name. | `apigw` |
| `nms-hybrid.apigw.service.type`                       | Service type (options: `ClusterIp`, `LoadBalancer`, `NodePort`). | `ClusterIp` |
| `nms-hybrid.apigw.service.httpsPort`                  | Service HTTPS port. | `443` |
| `nms-hybrid.apigw.resources.requests.cpu`             | Minimum required CPU to run `apigw`. | `250m` |
| `nms-hybrid.apigw.resources.requests.memory`          | Minimum required memory to run `apigw`. | `256Mi` |
| `nms-hybrid.apigw.tolerations`                        | List of Kubernetes tolerations, if any. | See [Kubernetes taints and tolerations](#kubernetes-taints-and-tolerations) |
| `nms-hybrid.core.name`                                | Name used for core resources. | `core` |
| `nms-hybrid.core.image.repository`                    | Repository name and path for the `core` image. | `core` |
| `nms-hybrid.core.image.tag`                           | Tag used for pulling images from the registry. | `latest` |
| `nms-hybrid.core.image.pullPolicy`                    | Image pull policy. | `IfNotPresent` |
| `nms-hybrid.core.container.port.http`                 | Container HTTP port. | `8033` |
| `nms-hybrid.core.container.port.db`                   | Container database port. | `7891` |
| `nms-hybrid.core.container.port.grpc`                 | Container gRPC port. | `8038` |
| `nms-hybrid.core.service.httpPort`                    | Service HTTP port. | `8033` |
| `nms-hybrid.core.service.grpcPort`                    | Service gRPC port. | `8038` |
| `nms-hybrid.core.resources.requests.cpu`              | Minimum required CPU to run `core`. | `500m` |
| `nms-hybrid.core.resources.requests.memory`           | Minimum required memory to run `core`. | `512Mi` |
| `nms-hybrid.core.persistence.enabled`                 | Enable persistence for `core` service. | `true` |
| `nms-hybrid.core.persistence.claims`                  | An array of persistent volume claims for Dqlite and secrets. Can be modified to use an existing PVC. | See [Dqlite](#nim-dqlite-storage-configuration) and [Secrets](#nim-secrets-storage-configuration) |
| `nms-hybrid.core.persistence.storageClass`            | Storage class to use for creating a `core` PVC. |  |
| `nms-hybrid.core.persistence.volumeName`              | Name to use for a `core` PVC volume. |  |
| `nms-hybrid.core.tolerations`                         | List of Kubernetes tolerations, if any. | See [Kubernetes taints and tolerations](#kubernetes-taints-and-tolerations) |
| `nms-hybrid.dpm.name`                                 | Name used for `dpm`. | `dpm` |
| `nms-hybrid.dpm.image.repository`                     | Repository name and path for the `dpm` image. | `dpm` |
| `nms-hybrid.dpm.image.tag`                            | Tag used for pulling images from the registry. | `latest` |
| `nms-hybrid.dpm.image.pullPolicy`                     | Image pull policy. | `IfNotPresent` |
| `nms-hybrid.dpm.container.port.http`                  | Container HTTP port. | `8034` |
| `nms-hybrid.dpm.container.port.nats`                  | Container NATS port. | `9100` |
| `nms-hybrid.dpm.container.port.db`                    | Container database port. | `7890` |
| `nms-hybrid.dpm.container.port.grpc`                  | Container gRPC port. | `8036` |

{{</bootstrap-table>}}

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

The following example snippet shows a toleration for an NGINX Instance Manager API Gateway deployment. In this example, Kubernetes will tolerate the "NoExecute" effect for 60 seconds before evicting the pod from the tainted node.

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
