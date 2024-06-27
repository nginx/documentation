---
docs: DOCS-000
title: Deploy Instance Manager 2.17 and later
toc: true
weight: 100
---

## Introduction

This guide provides a step-by-step tutorial on how to set up F5 Instance Manager on a Kubernetes cluster using Helm. Learn how to download and use Docker images, and customize your deployment.

{{< note >}} This guide applies to Instance Manager 2.17 and later. 

For newer versions, view the [Deploy Instance Manager 2.16 and earlier]({{< relref "/nms/installation/kubernetes/deploy-instance-manager-old.md" >}}) topic. {{< /note >}}

### About Instance Manager

{{< include "nim/nim-description.md" >}}

### About Helm

{{< include "nim/helm-description.md" >}}

## Before You Begin

To deploy Instance Manager using a Helm chart, you need the following:

{{< bootstrap-table "table table-striped table-bordered" >}}
| Requirements |Notes                                                                                                                                                                                                                                                                                                                                                                                                                   |
| ----------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Docker 20.10 or later (linux/amd64)                                                 | https://docs.docker.com/get-docker/                                                                                                                                                                                                                                                                                                                                                                                     |
| <span style=" white-space: nowrap;">Kubernetes 1.21.3 or later (linux/amd64)</span> | Ensure your client can [access the Kubernetes API server](https://kubernetes.io/docs/concepts/security/controlling-access/). Note: by default the Helm chart will enable persistent storage using the default storage class configured in your Kubernetes cluster. Documentation around this topic can be found here: [Dynamic Volume Provisioning](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/). |
| kubectl 1.21.3 or later                                                             | https://kubernetes.io/docs/tasks/tools/#kubectl                                                                                                                                                                                                                                                                                                                                                                         |
| Helm 3.10.0 or later                                                                | https://helm.sh/docs/intro/install/                                                                                                                                                                                                                                                                                                                                                                                     |
| OpenSSL 1.1.1 or later                                                              | https://www.openssl.org/source/                                                                                                                                                                                                                                                                                                                                                                                         |
| `tar` 1.20 or later                                                                 | <p>The `tar` archiving tool is usually installed by default. To see which version of `tar` you have installed, run `tar --version`. </p> <p>If `tar` is not installed or the version is too old, follow the instructions for your Linux distribution to install a supported version from a package manager such as YUM (CentOS, RHEL) or APT (Debian, Ubuntu). </p>                                                     |

{{< /bootstrap-table >}}

---

## Add Helm Repository

{{< note >}} To complete the steps in the section, you need to have [Helm 3.10.0](https://helm.sh/docs/intro/install/) or later installed.{{< /note >}}

{{< include "installation/helm/add-helm-repo.md" >}}

---

## Create a Helm Deployment values.yaml File

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

To enforce existing network policies for NGINX Management Suite, Kubernetes must have a [network plugin](https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/network-plugins/) installed before Helm chart installation.

When enabled, the following network policies will be created in the release namespace.

```shell
kubectl get netpol -n nms
```
```text
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

## Install Chart

Run the `helm install` command to install Instance Manager using the Helm chart:

1. Replace `<path-to-your-values.yaml>` with the path to the [values.yaml file you created](#configure-chart).
1. Replace `YourPassword123#` with a secure password that contains a combination of uppercase and lowercase letters, numbers, and special characters.

    {{< important >}} Make sure to copy and save the password for future reference. Only the encrypted password is stored in Kubernetes. There's no way to recover or reset a lost password. {{< /important >}}

- (Optional) Replace `<nms-chart-version>` with the desired version: the table below lists module compatibility. Omitting this flag will install the latest version.

```shell
helm install -n nms --set nms-hybrid.adminPasswordHash=$(openssl passwd -6 'YourPassword123#') nms nginx-stable/nms --create-namespace -f <path-to-your-values.yaml> [--version <chart-version>] --wait
```

To help you choose the right NGINX Management Suite chart version, refer to the following table, which provides information about the compatible modules for each version.

{{< include "installation/helm/nms-chart-supported-module-versions.md" >}}

---

## Validate Deployment

Run the following command to check the status of the deployment:

```shell
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

## Upgrade Instance Manager

To upgrade Instance Manager, take the following steps:

1. [Update the local Helm repository list](#add-helm-repository)
1. [Make any necessary adjustments to your *values.yaml* file](#configure-chart)
1. {{< include "installation/helm/helm-upgrade-nms.md" >}}

---

## Uninstall Instance Manager {#helm-uninstall-nim}

{{< warning >}} Uninstalling Instance Manager uninstalls **the entire NGINX Management Suite**. {{< /warning >}}

To uninstall Instance Manager, run the following command:

```bash
helm uninstall --namespace nms nms
```

This helm command uninstalls the app named `nms` from the namespace `nms`. 

It deletes all of the Kubernetes resources associated with the app, including any deployments, pods, services, and configmaps.

---

## Configurable Helm Settings

{{< include "installation/helm/nim/configuration-options.md" >}}

---

## Troubleshooting

{{< include "support/troubleshooting-guide.md" >}}

For guidance on how to create a support package containing system and service details to share with NGINX Customer Support, refer to the guide [Create a Support Package from a Helm Installation]({{< relref "/nms/support/k8s-support-package.md" >}}).