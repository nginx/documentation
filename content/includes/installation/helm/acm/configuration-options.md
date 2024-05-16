---
docs: DOCS-1314
---

The following table lists the configurable parameters and default values used by the API Connectivity Manager chart when installing from a Helm chart.

To modify a configuration for an existing release, run the `helm upgrade` command and use `-f <my-values-file>`, where `my-values-file` is a path to a values file with your desired configuration.

{{<bootstrap-table "table table-striped table-bordered">}}

| Parameter | Description | Default |
|:-----------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------|:--------------------------|
| `nms-acm.acm.logLevel`                        | Set the log level for the backend API service. The log level can be `fatal`, `error`, `warning`, `info`, or `debug` | `info` |
| `nms-acm.acm.image.repository`                | Repository name and path for the `acm` image. | `acm` |
| `nms-acm.acm.image.tag`                       | Tag used for pulling images from registry. | `latest` |
| `nms-acm.acm.image.pullPolicy`                | Image pull policy. | `IfNotPresent` |
| `nms-acm.acm.container.port.http`             | TCP port for the pod to listen on. | `8037` |
| `nms-acm.acm.container.port.db`               | Port to use for Dqlite. | `9300` |
| `nms-acm.acm.metrics.enabled`                 | Enable metrics. | `false` |
| `nms-acm.acm.service.httpPort`                | TCP port for the service to listen on. | `8037` |
| `nms-acm.acm.resources.requests.cpu`          | CPU resource limits to allow for the `acm` pods. | `500m` |
| `nms-acm.acm.resources.requests.memory`       | Memory resource limits to allow for the `api` pods. | `512Mi` |
| `nms-acm.acm.persistence.enabled`             | Optionally disable persistent storage, used for database data. | `true` |
| `nms-acm.acm.persistence.claims`              | An array of persistent volume claims, can be modified to use an existing PVC. | See the [Dqlite](#acm-dqlite-configuration) configuration section below. |
| `nms-acm.acm.devportal.credentials.enabled`    | Enables the [Create Credentials Endpoint on the Developer Portal]({{< relref "/nms/acm/how-to/infrastructure/enable-create-credentials.md" >}}) | `false` |
| `nms-acm.acm.devportal.credentials.ssl`    | This should be set to true if mTLS has been configured between API Connectivity Manager and the Developer Portal, for more information see [Create Credentials Endpoint on the Developer Portal]({{< relref "/nms/acm/how-to/infrastructure/enable-create-credentials.md" >}}) | `false` |
| `nms-acm.acm.devportal.client.caSecret.name`   | This should be set if an unknown Certificate Authority is needed for communication with the Developer Portal in order to provide a CA certificate. This should be set to the name of the secret in the release namespace that contains the CA certificate. | Blank |
| `nms-acm.acm.devportal.client.caSecret.key`    | This should be set if an unknown Certificate Authority is needed for communication with the Developer Portal in order to provide a CA certificate. This should be set to the key of the secret in the release namespace that contains the CA certificate.  | Blank |

{{</bootstrap-table>}}

##### API Connectivity Manager Dqlite Storage Configuration {#acm-dqlite-configuration}

```yaml
  - name: dqlite
    existingClaim:
    size: 500Mi
    accessMode: ReadWriteOnce
```
