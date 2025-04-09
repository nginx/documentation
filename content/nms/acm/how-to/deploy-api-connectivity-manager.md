---
description: The guide provides step-by-step instructions to deploy F5 NGINX API Connectivity
  Manager on Kubernetes using a Helm chart.
docs: DOCS-1276
title: Deploy API Connectivity Manager on Kubernetes
toc: true
weight: 20
type:
- how-to
---

## Requirements

Review the following requirements for API Connectivity Manager before continuing.

### Install Instance Manager

{{< important >}}To install API Connectivity Manager, you must first install Instance Manager. This is because API Connectivity Manager relies on features that are included with Instance Manager.{{< /important >}}

- [Deploy Instance Manager on Kubernetes]({{< ref "/nim/deploy/kubernetes/deploy-using-helm.md" >}})

### Dependencies with Instance Manager

Refer to the following table to see the module compatibility for each F5 NGINX Management Suite chart.

{{< include "nim/kubernetes/nms-chart-supported-module-versions.md" >}}


---

## Download Docker Image {#download-docker-image}

Follow these steps to download the Docker image for API Connectivity Manager:

1. Go to the [MyF5 website](https://my.f5.com/manage/s/downloads), then select **Resources > Downloads**.
1. In the **Select Product Family** list, select **NGINX**.
1. In the **Product Line** list, select **NGINX API Connectivity Manager**.
1. Select the following download options:

   - **Product version** -- Select the version of API Connectivity Manager you want to install. Make sure this version is compatible with the version of Instance Manager you installed as a prerequisite. Refer to the [Dependencies with Instance Manager](#dependencies-with-instance-manager) section above.
   - **Linux distribution** -- Select the Linux distribution you're deploying to. For example, **ubuntu**.
   - **Distribution Version** -- Select the Linux distribution's version. For example, **20.04**.
   - **Architecture** -- Select the architecture. For example, **amd64**.

1. In the **Download Files** section, download the `nms-acm-<version>-img.tar.gz` file.

---

## Load Docker Image {#load-docker-image}

{{< note >}} To complete the commands in this section, you need to have [Docker 20.10 or later](https://docs.docker.com/get-docker/) installed. {{< /note >}}


1. Change to the directory where you downloaded the Docker image:

   ``` shell
   cd <directory name>
   ```

1. Load the Docker image from the `nms-acm-<version>-img.tar.gz` archive:

   ``` shell
   docker load -i nms-acm-<version>-img.tar.gz
   ```

   The output looks similar to the following:

   ``` shell
   $ docker load -i nms-acm-<version>-img.tar.gz
   1b5933fe4b5: Loading layer [==================================================>]  5.796MB/5.796MB
   fbe0fc9bcf95: Loading layer [==================================================>]  17.86MB/17.86MB
   ...
   112ae1f604e0: Loading layer [==================================================>]   67.8MB/67.8MB
   4b6a693b90f4: Loading layer [==================================================>]  3.072kB/3.072kB
   Loaded image: nms-acm:1.5.0
   ```

   {{<important>}}
   Take note of the loaded image's name and tag.  You'll need to reference this information in the next section when pushing the image to your private registry.

   In the example output above, `nms-acm` is the image name and `1.5.0` is the tag.  The image name or tag could be different depending on the product version you downloaded from MyF5.
   {{</important>}}

---

## Push Image to Private Registry {#push-docker-image}

{{<note>}}To complete the steps in this section, you need an [externally-accessible private Docker registry](https://docs.docker.com/registry/deploying/) to push the container images to.{{</note>}}

To push the Docker images to your private registry, take the following steps:

- Replace `<my-docker-registry:port>` with your private Docker registry and port (if needed).

- Replace `<version>` with the tag you noted when [loading the Docker image](#load-acm-docker-image) above.

1. Log in to your private registry:

   ```shell
   docker login <my-docker-registry:port>
   ```

2. Tag the image with the image name and version you noted when [loading the Docker image](#load-acm-docker-image).

   ```shell
   docker tag nms-acm:<version> <my-docker-registry:port>/nms-acm:<version>
   ```

   For example:

   ```shell
   docker tag nms-acm:1.5 myregistryhost:5000/nms-acm:1.5
   ```

3. Push the image to your private registry:

   ```shell
   docker push <my-docker-registry:port>/nms-acm:<version>
   ```

   For example:

   ```shell
   docker push nms-acm:1.5 myregistryhost:5000/nms-acm:1.5
   ```

---

## Enable API Connectivity Manager

To enable the API Connectivity Manager Module, take the following steps:

1. Open the `values.yaml` file for editing.
1. Add the following snippet to the `values.yaml` file:

   - Replace `<my-docker-registry:port>` with your private Docker registry and port (if needed).
   - Replace `<version>` with the tag you noted when [loading the Docker image](#load-acm-docker-image) above.
   - In the `imagePullSecrets` section, add the credentials for your private Docker registry.

   ```yaml
   # values.yaml
   global:
       nmsModules:
           nms-acm:
               enabled: true
   nms-acm:
       imagePullSecrets:
       - name: regcred
       acm:
           image:
               repository: <my-docker-registry:port>/nms-acm
               tag: <version>
   ```

1. Close and save the `values.yaml` file.

---

## Upgrade NGINX Management Suite Deployment {#upgrade-nms}

{{< note >}} To complete the steps in this section, you need to have [OpenSSL 1.1.1](https://www.openssl.org/source/) or later installed. {{</ note >}}

Run the following command to upgrade the NGINX instance deployment:

- Replace `<path-to-your-values.yaml>` with the path to the [values.yaml file you created]({{< ref "/nim/deploy/kubernetes/deploy-using-helm.md#configure-chart" >}}).
- Replace `YourPassword123#` with a secure password that contains a combination of uppercase and lowercase letters, numbers, and special characters.

    {{< important >}}Make sure to copy and save the password for future reference. Only the encrypted password is stored in Kubernetes. There's no way to recover or reset a lost password.{{< /important >}}

- (Optional) Replace `<nms-chart-version>` with the desired version; see the table below for the available versions. Alternatively, you can omit this flag to install the latest version.

```bash
helm upgrade -n nms --set nms-hybrid.adminPasswordHash=$(openssl passwd -6 'YourPassword123#') nms nginx-stable/nms -f <path-to-your-values.yaml> [--version <nms-chart-version>] --wait
```

This command upgrades an existing Helm chart deployment named `nms` with a new version of the chart located in the `nginx-stable/nms` repository. It also sets the value of the `nms-hybrid.adminPasswordHash` to the hashed version of the provided password and uses a `values.yaml` file located at the provided path.

### Upgrade Existing API Connectivity Manager Deployment {#upgrade-acm-helm}

If you've already deployed API Connectivity Manager and would like to upgrade to a newer version, take the following steps:

1. Repeat the steps above to:

   - [Download Newer Docker Image](#download-docker-image)
   - [Load Docker Image](#load-docker-image)
   - [Push Image to Private Docker Registry](#push-docker-image)

2. Run the `helm upgrade` command above to [upgrade the NGINX Management Suite deployment](#upgrade-nms).

---

## Access Web Interface

{{< include "nim/kubernetes/access-webui-helm.md" >}}

---

## Add License

A valid license is required to make full use of all the features in API Connectivity Manager.

Refer to the [Add a License]({{< ref "/nim/admin-guide/license/add-license.md" >}}) topic for instructions on how to download and apply a trial license, subscription license, or Flexible Consumption Program license.

---

## Configurable Helm Settings

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
| `nms-acm.acm.devportal.credentials.enabled`    | Enables the [Create Credentials Endpoint on the Developer Portal]({{< ref "/nms/acm/how-to/infrastructure/enable-create-credentials.md" >}}) | `false` |
| `nms-acm.acm.devportal.credentials.ssl`    | This should be set to true if mTLS has been configured between API Connectivity Manager and the Developer Portal, for more information see [Create Credentials Endpoint on the Developer Portal]({{< ref "/nms/acm/how-to/infrastructure/enable-create-credentials.md" >}}) | `false` |
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


---

## Troubleshooting



For guidance on how to create a support package containing system and service details to share with NGINX Customer Support, refer to the guide [Create a Support Package from a Helm Installation]({{< ref "/nms/support/k8s-support-package.md" >}}).

---
