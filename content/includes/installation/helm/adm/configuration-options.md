---
docs: DOCS-1317
---

To modify a configuration for an existing release, run the `helm upgrade` command and use `-f <my-values-file>`, where `my-values-file` is a path to a values file with your desired configuration.

The following table lists the configurable parameters and default values used by the App Delivery Manager chart when installing from a Helm chart.

{{<bootstrap-table "table table-striped table-bordered">}}
| Parameter | Description | Default |
|:-----------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------|:--------------------------|
| `nms-adm.adm.logLevel`                        | Set the log level for the backend API service. The log level can be `fatal`, `error`, `warning`, `info`, or `debug` | `info` |
| `nms-adm.adm.image.repository`                | Repository name and path for the `adm` image. | `adm` |
| `nms-adm.adm.image.tag`                       | Tag used for pulling images from registry. | `latest` |
| `nms-adm.adm.image.pullPolicy`                | Image pull policy. | `IfNotPresent` |
| `nms-adm.adm.container.port.http`             | TCP port for the pod to listen on. | `8039` |
| `nms-adm.adm.container.port.db`               | Port to use for Dqlite. | `7811` |
| `nms-adm.adm.service.httpPort`                | TCP port for the service to listen on. | `8039` |
| `nms-adm.adm.resources.requests.cpu`          | CPU resource limits to allow for the `adm` pods. | `500m` |
| `nms-adm.adm.resources.requests.memory`       | Memory resource limits to allow for the `api` pods. | `512Mi` |
| `nms-adm.adm.persistence.enabled`             | Optionally disable persistent storage, used for database data. | `true` |
| `nms-adm.adm.persistence.claims`              | An array of persistent volume claims, can be modified to use an existing PVC. | See [Dqlite](#adm-dqlite-configuration) and [Templates](#adm-templates-configuration).|
{{</bootstrap-table>}}

##### App Delivery Manager Dqlite Configuration {#adm-dqlite-configuration}

```yaml
  - name: dqlite
    existingClaim:
    size: 500Mi
    accessMode: ReadWriteOnce
```

##### App Delivery Manager Templates Configuration {#adm-templates-configuration}
The following volume persists the App Delivery Manager templates' directories and preserves the new files a user may add to the templates directory.

```yaml
  - name: templates
    existingClaim:
    size: 500Mi
    accessMode: ReadWriteOnce
```
