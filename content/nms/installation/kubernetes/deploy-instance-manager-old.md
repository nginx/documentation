---
docs: DOCS-1081
doctypes:
- tutorial
tags:
- docs
title: Deploy Instance Manager 2.16 and earlier
toc: true
weight: 200
---

## Introduction

This guide provides a step-by-step tutorial on how to set up Instance Manager on a Kubernetes cluster using Helm. Learn how to download and use Docker images, and customize your deployment.

{{< note >}} This guide applies to Instance Manager 2.16 and earlier.

For newer versions, view the [Deploy Instance Manager 2.17 and later]({{< relref "/nms/installation/kubernetes/deploy-instance-manager.md" >}}) topic. {{< /note >}}

### About Instance Manager

{{< include "nim/nim-description.md" >}}

### About Helm

{{< include "nim/helm-description.md" >}}

---

## Before You Begin

To deploy Instance Manager using a Helm chart, you need the following:

{{< bootstrap-table "table table-striped table-bordered" >}}

| Requirements                                                                        | Notes                                                                                                                                                                                                                                                                                                                                                                                                                   |
| ----------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Private&nbsp;Docker&nbsp;registry&nbsp;                                             | You need to have an externally-accessible [private Docker registry](https://docs.docker.com/registry/deploying/) to which you can push the container images.                                                                                                                                                                                                                                                            |
| Docker 20.10 or later (linux/amd64)                                                 | https://docs.docker.com/get-docker/                                                                                                                                                                                                                                                                                                                                                                                     |
| <span style=" white-space: nowrap;">Kubernetes 1.21.3 or later (linux/amd64)</span> | Ensure your client can [access the Kubernetes API server](https://kubernetes.io/docs/concepts/security/controlling-access/). Note: by default the Helm chart will enable persistent storage using the default storage class configured in your Kubernetes cluster. Documentation around this topic can be found here: [Dynamic Volume Provisioning](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/). |
| kubectl 1.21.3 or later                                                             | https://kubernetes.io/docs/tasks/tools/#kubectl                                                                                                                                                                                                                                                                                                                                                                         |
| Helm 3.10.0 or later                                                                | https://helm.sh/docs/intro/install/                                                                                                                                                                                                                                                                                                                                                                                     |
| OpenSSL 1.1.1 or later                                                              | https://www.openssl.org/source/                                                                                                                                                                                                                                                                                                                                                                                         |
| `tar` 1.20 or later                                                                 | <p>The `tar` archiving tool is usually installed by default. To see which version of `tar` you have installed, run `tar --version`. </p> <p>If `tar` is not installed or the version is too old, follow the instructions for your Linux distribution to install a supported version from a package manager such as YUM (CentOS, RHEL) or APT (Debian, Ubuntu). </p>                                                     |

{{< /bootstrap-table >}}

---

## Add Helm Repository {#add-helm-repository}

{{<note>}} To complete the steps in the section, you need to have [Helm 3.10.0](https://helm.sh/docs/intro/install/) or later installed.{{</note>}}

{{< include "installation/helm/add-helm-repo.md" >}}

---

## Download Helm Package {#download-helm-package}

Take the following steps to download and extract the Helm page on your host:

1. Go to the [MyF5 website](https://my.f5.com/manage/s/downloads), then select **Resources > Downloads**.
2. In the **Select Product Family** list, select **NGINX**.
3. In the **Product Line** list, select **F5 NGINX Instance Manager**.
4. Select the following download options:

   - **Product version**: Select the version of Instance Manager that you want to install.
   - **Linux distribution**: Select `helmchart`.
   - **Distribution Version**: Defaults to the helmchart version determined by the **Product Version**.
   - **Architecture**: Defaults to `k8s`.

5. In the **Download Files** section, download the `nms-helm-<version>.tar.gz` file.

6. Make a directory to extract the Helm package into:

   ``` shell
   mkdir -p nms-docker-images
   ```

7. Extract the package into the target directory:

    ``` shell
    tar -xzf nms-helm-<version>.tar.gz -C nms-docker-images
    ```

    <br>

    The extracted files include the following Docker images:

    **Docker images**

    - `nms-apigw-<version>.tar.gz`
    - `nms-core-<version>.tar.gz`
    - `nms-dpm-<version>.tar.gz`
    - `nms-ingestion-<version>.tar.gz`
    - `nms-integrations-<version>.tar.gz`
    - `nms-utility-<version>.tar.gz`

---

## Load Docker Images {#load-docker-images}

{{< note >}} To complete the commands in this section, you need to have [Docker 20.10 or later](https://docs.docker.com/get-docker/) installed. {{< /note >}}

1. Change to the directory where you [extracted the Docker images](#extract-helm-bundle):

   ``` shell
   cd nms-docker-images
   ```

1. Load the Docker images:

   ``` bash
   docker load -i nms-apigw-<version>.tar.gz
   docker load -i nms-core-<version>.tar.gz
   docker load -i nms-ingestion-<version>.tar.gz
   docker load -i nms-dpm-<version>.tar.gz
   docker load -i nms-integrations-<version>.tar.gz
   docker load -i nms-utility-<version>.tar.gz
   ```

   This set of commands loads the Docker images from the specified `tar.gz` archives. Replace `<version>` with the product version you specified when downloading the Helm bundle.

   The output looks similar to the following:

   ``` shell {linenos=table,hl_lines=[7]}
   $ docker load -i nms-apigw-<version>.tar.gz
   1b5933fe4b5: Loading layer [==================================================>]  5.796MB/5.796MB
   fbe0fc9bcf95: Loading layer [==================================================>]  17.86MB/17.86MB
   ...
   112ae1f604e0: Loading layer [==================================================>]   67.8MB/67.8MB
   4b6a693b90f4: Loading layer [==================================================>]  3.072kB/3.072kB
   Loaded image: nms-apigw:2.9.1
   ```

   {{<important>}}For the output of each `docker load` command, note the loaded image's name and tag. You will need to reference these images and tags in the next section when pushing the images to your private registry.

   For example, in the output directly above, `nms-apigw` is the image name and `2.9.1` is the tag.  The tag `2.9.1` could differ depending on the product version you [downloaded from MyF5](#download-nms-helm-bundle).{{</important>}}

---

## Push Images to Private Registry {#push-images-private-registry}

{{<note>}}To complete the steps in this section, you need an [externally accessible private Docker registry](https://docs.docker.com/registry/deploying/) to push the container images to.{{</note>}}

To push the Docker images to your private registry, take the following steps:

- Replace `<my-docker-registry:port>` with your private Docker registry and port (if needed).

- Replace `<version>` with the tag you noted when [loading the Docker images](#load-nms-docker-images) above.

1. Log in to your private registry:

    ```bash
    docker login <my-docker-registry:port>
    ```

1. Tag the images with the version you noted when [loading the Docker images](#load-nms-docker-images) above.

    ```bash
    docker tag nms-apigw:<version> <my-docker-registry:port>/nms-apigw:<version>
    docker tag nms-core:<version> <my-docker-registry:port>/nms-core:<version>
    docker tag nms-dpm:<version> <my-docker-registry:port>/nms-dpm:<version>
    docker tag nms-ingestion:<version> <my-docker-registry:port>/nms-ingestion:<version>
    docker tag nms-integrations:<version> <my-docker-registry:port>/nms-integrations:<version>
    docker tag nms-utility:<version> <my-docker-registry:port>/nms-utility:<version>
    ```

    For example:

     ```bash
    docker tag nms-apigw:2.9.1 myregistryhost:5000/nms-apigw:2.9.1
    ...
    ```

1. Push the images to your private registry:

    ```bash
    docker push <my-docker-registry:port>/nms-apigw:<version>
    docker push <my-docker-registry:port>/nms-core:<version>
    docker push <my-docker-registry:port>/nms-dpm:<version>
    docker push <my-docker-registry:port>/nms-ingestion:<version>
    docker push <my-docker-registry:port>/nms-integrations:<version>
    docker push <my-docker-registry:port>/nms-utility:<version>
    ```

    For example:

     ```bash
    docker push myregistryhost:5000/nms-apigw:2.9.1
    ...
    ```

---

## Create a Helm Deployment values.yaml File {#configure-chart}

`values.yaml` is a Helm configuration file you can use to customize the installation of a [Helm chart](#what-is-a-helm-chart) without editing the chart itself. Values can be used to specify different image repositories and tags, set environment variables, configure resource requests and limits, and more.

1. Create a `values.yaml` file similar to the following example:

    - Replace `<my-docker-registry:port>` with your private Docker registry and port (if needed).
    - Replace `<version>` with the tag you used when [pushing the images to your private registry](#push-images-private-registry).
    - In the `imagePullSecrets` section, add the credentials for your private Docker registry.

        {{< see-also >}} For instructions on creating a secret, see the Kubernetes topic [Pull an Image from a Private Registry](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/). {{</ see-also >}}

    ```yaml
    nms-hybrid:
        imagePullSecrets:
            - name: regcred
        apigw:
            image:
                repository: <my-docker-registry:port>/nms-apigw
                tag: <version>
        core:
            image:
                repository: <my-docker-registry:port>/nms-core
                tag: <version>
        dpm:
            image:
                repository: <my-docker-registry:port>/nms-dpm
                tag: <version>
        ingestion:
            image:
                repository: <my-docker-registry:port>/nms-ingestion
                tag: <version>
        integrations:
            image:
                repository: <my-docker-registry:port>/nms-integrations
                tag: <version>
        utility:
            image:
                repository: <my-docker-registry:port>/nms-utility
                tag: <version>
    ```

    This `values.yaml` file specifies the Docker images to be used for the `apigw`, `core`, `dpm`, `ingestion`, `integrations` and `utility` components, including the repository (`<my-docker-registry:port>`) and tag (`version`) of each image. It also specifies that a secret called `regcred` should be used for image pulls.

1. Save and close the `values.yaml` file.

---

## Manage Network Policies

To enforce existing network policies for NGINX Management Suite, Kubernetes must have a [network plugin](https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/network-plugins/) installed before helm chart installation.

When enabled, the following network policies will be created in the release namespace.

``` shell
kubectl get netpol -n nms
NAME           POD-SELECTOR                          AGE
apigw          app.kubernetes.io/name=apigw          4m47s
clickhouse     app.kubernetes.io/name=clickhouse     4m47s
core           app.kubernetes.io/name=core           4m47s
dpm            app.kubernetes.io/name=dpm            4m47s
ingestion      app.kubernetes.io/name=ingestion      4m47s
integrations   app.kubernetes.io/name=integrations   4m47s
utility        app.kubernetes.io/name=integrations   4m47s
```

To disable the existing network policies, update the `values.yaml` file as shown below:

```yaml
 networkPolicies:
	 # Setting this to true enables network policies for NGINX Management Suite.
	 enabled: false
```

---

## Install Chart {#install-chart}

{{<note>}}To complete the steps in this section, you need to have [OpenSSL 1.1.1](https://www.openssl.org/source/) or later installed.{{</note>}}

Run the `helm install` command to install Instance Manager from the Helm chart:

- Replace `<path-to-your-values.yaml>` with the path to the [values.yaml file you created](#configure-chart).
- Replace `YourPassword123#` with a secure password that contains a combination of uppercase and lowercase letters, numbers, and special characters.

    {{< important >}}Make sure to copy and save the password for future reference. Only the encrypted password is stored in Kubernetes. There's no way to recover or reset a lost password.{{< /important >}}

- (Optional) Replace `<nms-chart-version>` with the desired version; see the table below for the available versions. Alternatively, you can omit this flag to install the latest version.

```bash
helm install -n nms --set nms-hybrid.adminPasswordHash=$(openssl passwd -6 'YourPassword123#') nms nginx-stable/nms --create-namespace -f <path-to-your-values.yaml> [--version <chart-version>] --wait
```

&nbsp;

To help you choose the right NGINX Management Suite chart version, refer to the following table, which provides information about the compatible modules for each version.

{{< include "installation/helm/nms-chart-supported-module-versions.md" >}}

---

## Validate Deployment {#validate-deployment}

Run the following command to check the status of the deployment:

``` shell
helm -n nms status nms
```

This `helm` command shows the status of the app called `nms` in the namespace `nms`. The command displays the release name, chart version, last deployment time, and current status.

The status should be `STATUS: deployed` if the deployment was successful.

---

## Access Web Interface

{{< include "installation/helm/access-webui-helm.md" >}}

---

## Add License

A valid license is required to make full use of all the features in Instance Manager.

Refer to the [Add a License]({{< relref "/nms/installation/add-license.md" >}}) topic for instructions on how to download and apply a trial license, subscription license, or Flexible Consumption Program license.

---

## Upgrade Instance Manager {#helm-upgrade-nim}

To upgrade Instance Manager, take the following steps:

1. Repeat the steps above to:

   - [Download Helm Package](#download-helm-package)
   - [Load Docker Images](#load-docker-images)
   - [Push Images to Private Docker Registry](#push-images-private-registry)
   - [Configure values.yaml file to pull from your private Docker registry](#configure-chart).

2. {{< include "installation/helm/helm-upgrade-nms.md" >}}

---

## Uninstall Instance Manager {#helm-uninstall-nim}

Uninstalling Instance Manager also uninstalls the entire NGINX Management Suite.

To uninstall Instance Manager, run the following command:

```bash
helm uninstall --namespace nms nms
```

This helm command uninstalls the app named `nms` from the namespace `nms`. It deletes all of the Kubernetes resources associated with the app, including any deployments, pods, services, and configmaps.

---

## Configurable Helm Settings

{{< include "installation/helm/nim/configuration-options.md" >}}

---

## Troubleshooting

{{< include "support/troubleshooting-guide.md" >}}

For guidance on how to create a support package containing system and service details to share with NGINX Customer Support, refer to the guide [Create a Support Package from a Helm Installation]({{< relref "/nms/support/k8s-support-package.md" >}}).