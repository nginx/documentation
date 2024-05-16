---
docs: DOCS-1321
---

The following table lists the configurable parameters and default values for the NGINX Management Suite platform when installing from a Helm chart.

To modify a configuration for an existing release, run the `helm upgrade` command and use `-f <my-values-file>`, where `my-values-file` is a path to a values file with your desired configuration.

{{<bootstrap-table "table table-bordered table-striped table-responsive table-sm">}}

| Parameter | Description | Default |
|:-----------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------|:--------------------------|
| `nms-hybrid.adminPasswordHash`                        | The hashed value of the password for the  admin user.<br>To generate the hash using `openssl`, run a command similar to the following example: `openssl passwd -1 "YouPassword123#"` | N/A |
| `nms-hybrid.nmsClickhouse.enabled`                    | Enable this if external ClickHouse is not used. | `true` |
| `nms-hybrid.nmsClickhouse.fullnameOverride`           | Modify the name of ClickHouse resources. | `clickhouse` |
| `nms-hybrid.nmsClickhouse.image.repository`           | Repository name and path public ClickHouse image. | `clickhouse/clickhouse-server` |
| `nms-hybrid.nmsClickhouse.image.tag`                  | Tag used for pulling images from registry. | `21.3.20.1-alpine` |
| `nms-hybrid.nmsClickhouse.image.pullPolicy`           | Image pull policy. | `IfNotPresent` |
| `nms-hybrid.nmsClickhouse.user`                       | Username to connect to the ClickHouse server as. | N/A |
| `nms-hybrid.nmsClickhouse.password`                   | Password for the ClickHouse server. | N/A |
| `nms-hybrid.nmsClickhouse.service.name`               | ClickHouse service name. | `clickhouse` |
| `nms-hybrid.nmsClickhouse.service.rpcPort`            | ClickHouse service port. | `9000` |
| `nms-hybrid.nmsClickhouse.resources.requests.cpu`     | Minimum required CPU on a node to run ClickHouse server. | `500m` |
| `nms-hybrid.nmsClickhouse.resources.requests.memory`  | Minimum required memory on a node to run ClickHouse server. | `1Gi` |
| `nms-hybrid.nmsClickhouse.persistence.enabled`        | Use PVCs to persist ClickHouse data. | `true` |
| `nms-hybrid.nmsClickhouse.persistence.existingClaim`  | Name of an existing Persistent Volume Claim (PVC) to use for ClickHouse persistence | N/A |
| `nms-hybrid.nmsClickhouse.persistence.storageClass`   | Storage Class to use for creating a ClickHouse PVC |  |
| `nms-hybrid.nmsClickhouse.persistence.volumeName`     | Name to use a ClickHouse PVC volume |  |
| `nms-hybrid.nmsClickhouse.persistence.accessMode`     | PVC access mode for ClickHouse | `ReadWriteOnce` |
| `nms-hybrid.nmsClickhouse.persistence.size`           | PVC size ClickHouse | `1G` |
| `nms-hybrid.nmsClickhouse.tolerations`                | List your Kubernetes tolerations, if any | See [Kubernetes Taints And Tolerations](#kubernetes-taints-and-tolerations) |
| `nms-hybrid.externalClickhouse.address`               | Address of external ClickHouse service. |  |
| `nms-hybrid.externalClickhouse.user`                  | User of external ClickHouse service. |  |
| `nms-hybrid.externalClickhouse.password`              | Password of external ClickHouse service. |  |
| `nms-hybrid.serviceAccount.annotations`               | Set custom annotations for the service account used by NGINX Management Suite. | `{}` |
| `nms-hybrid.apigw.name`                               | Name used for API Gateway resources. | `apigw` |
| `nms-hybrid.apigw.tlsSecret`                          | By default, this helm chart creates its own Certificate Authority (CA) to self-sign the HTTPS server cert key pairs; these are not managed by NGINX Management Suite. You can bring your own NGINX API Gateway certificates for hosting the HTTPS NGINX Management Suite server by setting "tlsSecret" to an existing Kubernetes secret name in the namespace targeted by the chart. The secret should include `tls.crt`, `tls.key`, and `ca.pem` in the data object. We recommend using a self-provisioned "tlsSecret" for production scenarios.<br /><br />For an example, refer to the "Use your own certificates" section in [Frequently Used Helm Configurations]({{< relref "/nms/installation/kubernetes/frequently-used-helm-configs.md#use-your-own-certificates" >}}). |  |
| `nms-hybrid.apigw.image.repository`                   | Repository name and path for the `apigw` image. | `apigw` |
| `nms-hybrid.apigw.image.tag`                          | Tag used for pulling images from registry. | `latest` |
| `nms-hybrid.apigw.image.pullPolicy`                   | Image pull policy. | `IfNotPresent` |
| `nms-hybrid.apigw.container.port.https`               | Container HTTPS port. | `443` |
| `nms-hybrid.apigw.service.name`                       | Service name. | `apigw` |
| `nms-hybrid.apigw.service.type`                       | Service type. Options: `ClusterIp`, `LoadBalancer`, `NodePort` | `ClusterIp` |
| `nms-hybrid.apigw.service.httpsPort`                  | Service HTTPS port. | `443` |
| `nms-hybrid.apigw.resources.requests.cpu`             | Minimum required CPU on a node to run `core`. | `250m` |
| `nms-hybrid.apigw.resources.requests.memory`          | Minimum required memory on a node to run `core`. | `256Mi` |
| `nms-hybrid.apigw.tolerations`                        | List your Kubernetes tolerations, if any | See [Kubernetes Taints And Tolerations](#kubernetes-taints-and-tolerations) |
| `nms-hybrid.core.name`                                | Name used for API Gateway resources. | `core` |
| `nms-hybrid.core.image.repository`                    | Repository name and path for the `core` image. | `core` |
| `nms-hybrid.core.image.tag`                           | Tag used for pulling images from registry. | `latest` |
| `nms-hybrid.core.image.pullPolicy`                    | Image pull policy. | `IfNotPresent` |
| `nms-hybrid.core.container.port.http`                 | Container HTTP port. | `8033` |
| `nms-hybrid.core.container.port.db`                   | Container database port. | `7891` |
| `nms-hybrid.core.container.port.grpc`                 | Container gRPC port. | `8038` |
| `nms-hybrid.core.service.httpPort`                    | Service HTTPS port. | `8033` |
| `nms-hybrid.core.service.grpcPort`                    | Service HTTPS port. | `8038` |
| `nms-hybrid.core.resources.requests.cpu`              | Minimum required CPU on a node to run `core`. | `500m` |
| `nms-hybrid.core.resources.requests.memory`           | Minimum required memory on a node to run `core`. | `512Mi` |
| `nms-hybrid.core.persistence.enabled`                 | Enable persistence for `core` service. | `true` |
| `nms-hybrid.core.persistence.claims`                  | An array of persistent volume claims for Dqlite and secrets, can be modified to use an existing PVC. | See [Dqlite](#nim-dqlite-storage-configuration) and [Secrets](#nim-sercets-storage-configuration) |
| `nms-hybrid.core.persistence.storageClass`            | Storage Class to use for creating a `core` PVC |  |
| `nms-hybrid.core.persistence.volumeName`              | Name to use a `core` PVC volume |  |
| `nms-hybrid.core.tolerations`                        | List your Kubernetes tolerations, if any | See [Kubernetes Taints And Tolerations](#kubernetes-taints-and-tolerations) |
| `nms-hybrid.dpm.name`                                 | Name used for `dpm`. | `dpm` |
| `nms-hybrid.dpm.image.repository`                     | Repository name and path for the `dpm` image. | `dpm` |
| `nms-hybrid.dpm.image.tag`                            | Tag used for pulling images from registry. | `latest` |
| `nms-hybrid.dpm.image.pullPolicy`                     | Image pull policy. | `IfNotPresent` |
| `nms-hybrid.dpm.container.port.http`                  | Container HTTP port. | `8034` |
| `nms-hybrid.dpm.container.port.nats`                  | Container database port. | `9100` |
| `nms-hybrid.dpm.container.port.db`                    | Container database port. | `7890` |
| `nms-hybrid.dpm.container.port.grpc`                  | Container gRPC port. | `8036` |
| `nms-hybrid.dpm.service.name`                         | Service name. | `nms` |
| `nms-hybrid.dpm.service.httpPort`                     | Service HTTPS port. | `8034` |
| `nms-hybrid.dpm.service.grpcPort`                     | Service HTTPS port. | `8036` |
| `nms-hybrid.dpm.service.natsPort`                     | Service HTTPS port. | `9100` |
| `nms-hybrid.dpm.resources.requests.cpu`               | Minimum required CPU on a node to run `dpm`. | `500m` |
| `nms-hybrid.dpm.resources.requests.memory`            | Minimum required memory on a node to run `dpm`. | `512Mi` |
| `nms-hybrid.dpm.persistence.enabled`                  | Enable persistence for `dpm` service. | `true` |
| `nms-hybrid.dpm.persistence.claims`                   | An array of persistent volume claims for Dqlite and NATS, can be modified to use an existing PVC. | See [Dqlite](#nim-dqlite-storage-configuration) and [NATS streaming](#nim-nats-storage-configuration) |
| `nms-hybrid.dpm.persistence.storageClass`             | Storage Class to use for creating a `dpm` PVC |  |
| `nms-hybrid.dpm.persistence.volumeName`               | Name to use a `dpm` PVC volume |  |
| `nms-hybrid.dpm.tolerations`                          | List your Kubernetes tolerations, if any | See [Kubernetes Taints And Tolerations](#kubernetes-taints-and-tolerations) |
| `nms-hybrid.ingestion.name`                           | Name used for `ingestion`. | `ingestion` |
| `nms-hybrid.ingestion.image.repository`               | Repository name and path for the `dpm` image. | `ingestion` |
| `nms-hybrid.ingestion.image.tag`                      | Tag used for pulling images from registry. | `latest` |
| `nms-hybrid.ingestion.image.pullPolicy`               | Image pull policy. | `IfNotPresent` |
| `nms-hybrid.ingestion.replicaCount`                   | Number of replicas of `ingestion` to run. | `1` |
| `nms-hybrid.ingestion.container.port.grpc`            | Container HTTP port. | `8035` |
| `nms-hybrid.ingestion.service.name`                   | Service name. | `nms` |
| `nms-hybrid.ingestion.service.grpcPort`               | Service HTTPS port. | `8035` |
| `nms-hybrid.ingestion.resources.requests.cpu`         | Minimum required CPU on a node to run `ingestion`. | `500m` |
| `nms-hybrid.ingestion.resources.requests.memory`      | Minimum required memory on a node to run `ingestion`. | `512Mi` |
| `nms-hybrid.ingestion.tolerations`                    | List your Kubernetes tolerations, if any | See [Kubernetes Taints And Tolerations](#kubernetes-taints-and-tolerations) |
| `nms-hybrid.integrations.name`                        | Name used for `integrations`. | `integrations` |
| `nms-hybrid.integrations.image.repository`            | Repository name and path for the `integrations` image. | `integrations` |
| `nms-hybrid.integrations.image.tag`                   | Tag used for pulling images from registry. | `latest` |
| `nms-hybrid.integrations.image.pullPolicy`            | Image pull policy. | `IfNotPresent` |
| `nms-hybrid.integrations.container.port.http`         | Container HTTP port. | `8037` |
| `nms-hybrid.integrations.container.port.db`           | Container database port. | `7892` |
| `nms-hybrid.integrations.service.name`                | Service name. | `nms` |
| `nms-hybrid.integrations.service.httpPort`            | Service HTTPS port. | `8037` |
| `nms-hybrid.integrations.resources.requests.cpu`      | Minimum required CPU on a node to run `integrations`. | `500m` |
| `nms-hybrid.integrations.resources.requests.memory`   | Minimum required memory on a node to run `integrations`. | `512Mi` |
| `nms-hybrid.integrations.persistence.enabled`         | Enable persistence for `integrations` service. | `true` |
| `nms-hybrid.integrations.persistence.claims`          | An array of persistent volume claims for Dqlite, can be modified to use an existing PVC. | See [Dqlite](#nim-dqlite-storage-configuration) - size is `1Gi` |
| `nms-hybrid.integrations.persistence.storageClass`    | Storage Class to use for creating a `integrations` PVC |  |
| `nms-hybrid.integrations.persistence.volumeName`      | Name to use a `integrations` PVC volume |  |
| `nms-hybrid.integrations.tolerations`                 | List your Kubernetes tolerations, if any | See [Kubernetes Taints And Tolerations](#kubernetes-taints-and-tolerations) |
| `nms-hybrid.utility.name`                             | Name used for `utility`. | `utility` |
| `nms-hybrid.utility.image.repository`                 | Repository name and path for the `utility` image. | `utility` |
| `nms-hybrid.utility.image.tag`                        | Tag used for pulling images from registry. | `latest` |
| `nms-hybrid.utility.image.pullPolicy`                 | Image pull policy. | `IfNotPresent` |

{{</bootstrap-table>}}

##### Instance Manager Dqlite Storage Configuration

```yaml
  - name: dqlite
    existingClaim:
    size: 500Mi
    accessMode: ReadWriteOnce
```

##### Instance Manager Secrets Storage Configuration

```yaml
  - name: secrets
    existingClaim:
    size: 128Mi
    accessMode: ReadWriteOnce
```

##### Instance Manager NATS Storage Configuration

```yaml
  - name: nats-streaming
    existingClaim:
    size: 1Gi
    accessMode: ReadWriteOnce
```

##### Kubernetes Taints and Tolerations

The following example snippet shows a toleration on an Instance Manager APIGW deployment. In this example, Kubernetes will tolerate the "NoExecute" effect for 60 seconds before evicting the pod from the tainted node.

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
