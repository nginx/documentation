---
docs: DOCS-1651
title: "Deploy using Helm"
toc: true
weight: 100
doctypes:
- task
tags:
- docs
---

## Overview

{{< include "/nim/decoupling/note-legacy-nms-references.md" >}}

This guide provides a step-by-step tutorial on how to set up F5 NGINX Instance Manager on a Kubernetes cluster using Helm. You'll learn how to download and use Docker images and customize your deployment.

### About Helm

Helm charts are pre-configured packages of Kubernetes resources deployed with a single command. They let you define, install, and upgrade Kubernetes applications easily.

Helm charts consist of files that describe a group of related Kubernetes resources, like deployments, services, and ingress. They also allow you to manage dependencies between applications, making it easier to deploy multi-tier or complex applications.

{{< call-out "important" "Supportability considerations" >}} NGINX Instance Manager **does not** support [OpenShift](https://www.redhat.com/en/technologies/cloud-computing/openshift). For better compatibility, use [NGINX Ingress Controller](https://docs.nginx.com/nginx-ingress-controller/). {{< /call-out >}}

---

## Before you begin

To deploy NGINX Instance Manager using a Helm chart, you need:

{{< bootstrap-table "table table-striped table-bordered" >}}
| Requirements | Notes                                                                                                                                                                                                                                                                                                                                                                                                                  |
| ----------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Docker 20.10 or later (linux/amd64)                                                 | [Docker documentation](https://docs.docker.com/get-docker)                                                                                                                                                                                                                                                                                                                                                                                     |
| <span style=" white-space: nowrap;">Kubernetes 1.21.3 or later (linux/amd64)</span> | Ensure your client can [access the Kubernetes API server](https://kubernetes.io/docs/concepts/security/controlling-access/). The Helm chart will enable persistent storage using the default storage class in your Kubernetes cluster. More info is available in [Dynamic Volume Provisioning](https://kubernetes.io/docs/concepts/storage/dynamic-provisioning/). |
| kubectl 1.21.3 or later                                                             | [kubectl documentation](https://kubernetes.io/docs/tasks/tools/#kubectl)                                                                                                                                                                                                                                                                                                                                                                         |
| Helm 3.10.0 or later                                                                | [Helm installation guide](https://helm.sh/docs/intro/install/)                                                                                                                                                                                                                                                                                                                                                                                     |
| OpenSSL 1.1.1 or later                                                              | [OpenSSL source](https://www.openssl.org/source/)                                                                                                                                                                                                                                                                                                                                                                                         |
| `tar` 1.20 or later                                                                 | The `tar` tool is usually installed by default. Check your version with `tar --version`. If `tar` is missing or outdated, install it from your distribution’s package manager (like YUM for CentOS/RHEL or APT for Debian/Ubuntu).                                                                                                                                                             |

{{< /bootstrap-table >}}



---

## Get the NGINX Instance Manager images

### Using Docker

### Using Helm with a JWT token

You can use your NGINX JWT as a Docker configuration secret with Helm charts.

Create a Docker registry secret on the cluster, using the JWT token as the username and `none` as the password. The Docker server is `private-registry.nginx.com`.

{{< note >}} Make sure there are no extra characters or spaces when copying the JWT token. They can invalidate the token and cause 401 errors during authentication. {{< /note >}}

```shell
kubectl create secret docker-registry regcred \
--docker-server=private-registry.nginx.com \
--docker-username=<JWT Token> \
--docker-password=none
```

{{< warning >}} 

You might see a warning about `--password` being insecure. 

This can be ignored (since no password is used), but if others have access to this system, delete the JWT token and clear your shell history after deployment.

{{< /warning >}}

To confirm the secret is created:

```shell
kubectl get secret regcred --output=yaml
```

You can now use this secret for Helm deployments and point the charts to the public registry.

---

## Add the Helm repository

{{< note >}} You need Helm 3.10.0 or later for these steps. {{< /note >}}

Run these commands to install the NGINX Instance Manager chart from the Helm repository:

```shell
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
```

The first command adds the `nginx-stable` repository to your local Helm repo list. The second updates the list to ensure you have the latest versions of the charts.

---

## Create a Helm deployment values.yaml file

The `values.yaml` file customizes the Helm chart installation without editing the chart itself. You can specify image repositories, environment variables, resource requests, and more.

1. Create a `values.yaml` file similar to this example:

    - In the `imagePullSecrets` section, add the credentials for your private Docker registry.
    - Change the version tag to the version of NGINX Instance Manager you would like to install. See "Install the chart" below for versions.

    {{< see-also >}} For more on creating a secret, see Kubernetes [Pull an Image from a Private Registry](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/). {{</ see-also >}}

    ```yaml
    nms-hybrid:
        imagePullSecrets:
            - name: regcred
        apigw:
            image:
                repository: private-registry.nginx.com/nms-apigw
                tag: <version>
        core:
            image:
                repository: private-registry.nginx.com/nms-core
                tag: <version>
        dpm:
            image:
                repository: private-registry.nginx.com/nms-dpm
                tag: <version>
        ingestion:
            image:
                repository: private-registry.nginx.com/nms-ingestion
                tag: <version>
        integrations:
            image:
                repository: private-registry.nginx.com/nms-integrations
                tag: <version>
        utility:
            image:
                repository: private-registry.nginx.com/nms-utility
                tag: <version>
    ```

    This file specifies the Docker images for `apigw`, `core`, `dpm`, `ingestion`, `integrations`, and `utility`. It also indicates that a secret called `regcred` should be used for pulling images.

1. Save and close the `values.yaml` file.

---



## Install the chart

Run the `helm install` command to deploy NGINX Instance Manager:

1. Replace `<path-to-your-values.yaml>` with the path to your `values.yaml` file.
1. Replace `YourPassword123#` with a secure password (containing a mix of uppercase, lowercase letters, numbers, and special characters).

   {{< important >}} Remember to save the password for future use. Only the encrypted password is stored, and there's no way to recover or reset it if lost. {{< /important >}}

(Optional) Replace `<nms-chart-version>` with the desired chart version. If omitted, the latest version will be installed.

```shell
helm install -n nms \
--set nms-hybrid.adminPasswordHash=$(openssl passwd -6 'YourPassword123#') \
nms nginx-stable/nms \
--create-namespace \
-f <path-to-your-values.yaml> \
[--version <chart-version>] \
--wait
```

To help you choose the right NGINX Instance Manager chart version, see the table in:

{{< include "nim/kubernetes/nms-chart-supported-module-versions.md" >}}

---

## Validate the deployment

Check the status of the deployment:

```shell
helm -n nms status nms
```

The status should show `STATUS: deployed` if successful.

---

## Access the web interface

{{< include "nim/kubernetes/access-webui-helm.md" >}}

---

## Add a license

A valid license is required to use all NGINX Instance Manager features.

For instructions on downloading and applying a license, see [Add a License]({{< relref "/nim/admin-guide/license/add-license.md" >}}).

---

## Upgrade NGINX Instance Manager

To upgrade:

1. [Update the Helm repository list](#add-helm-repository).
1. [Adjust your `values.yaml` file](#create-a-helm-deployment-values.yaml-file) if needed.
1. To upgrade the NGINX instance deployment, run the following command. This command updates the `nms` deployment with a new version from the `nginx-stable/nms` repository. It also hashes the provided password and uses the `values.yaml` file at the path you specify.

   ```bash
    helm upgrade -n nms \
    --set nms-hybrid.adminPasswordHash=$(openssl passwd -6 'YourPassword123#') \
    nms nginx-stable/nms \
    -f <path-to-your-values.yaml> \
    [--version <nms-chart-version>] \
    --wait
   ```

   - Replace `<path-to-your-values.yaml>` with the path to the `values.yaml` file you created]({{< relref "/nim/deploy/kubernetes/deploy-using-helm.md#configure-chart" >}}).
   - Replace `YourPassword123#` with a secure password that includes uppercase and lowercase letters, numbers, and special characters.
   
      {{<call-out "important" "Save the password!" "" >}} Save this password for future use. Only the encrypted password is stored in Kubernetes, and you can’t recover or reset it later. {{</call-out>}}
   - (Optional) Replace <nms-chart-version> with the desired version number. If you don’t specify a version, the latest version will be installed.


---

## Uninstall NGINX Instance Manager {#helm-uninstall-nim}

To uninstall:

```bash
helm uninstall --namespace nms nms
```

This deletes the `nms` application and all associated Kubernetes resources.

---

## Manage network policies

To apply network policies for NGINX Instance Manager, ensure Kubernetes has a [network plugin](https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/network-plugins/) installed before the Helm chart installation.

By default, the following network policies will be created in the release namespace:

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

To disable network policies, update the `values.yaml` file:

```yaml
networkPolicies:
    # Set this to true to enable network policies for NGINX Instance Manager.
    enabled: false
```

---

## Troubleshooting

For instructions on creating a support package to share with NGINX Customer Support, see [Create a Support Package from a Helm Installation]({{< relref "/nms/support/k8s-support-package.md" >}}).

