---
docs: DOCS-1651
title: Deploy using Helm
toc: true
weight: 100
type:
- how-to
---

## Overview

{{< include "/nim/decoupling/note-legacy-nms-references.md" >}}

This guide explains how to deploy F5 NGINX Instance Manager on a Kubernetes or OpenShift cluster using Helm. You’ll learn how to download and use Docker images and customize your deployment.

{{< note >}} Starting in NGINX Instance Manager 2.19, you can deploy NGINX Instance Manager on an OpenShift cluster using Helm. {{< /note >}}

### About Helm

Helm charts are pre-configured packages of Kubernetes resources deployed with a single command. They let you define, install, and upgrade Kubernetes applications easily.

Helm charts consist of files that describe a group of related Kubernetes resources, like deployments, services, and ingress. They also allow you to manage dependencies between applications, making it easier to deploy multi-tier or complex applications.

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

- **Kubernetes**:

  ```shell
  kubectl create namespace nms
  ```

  ```shell
  kubectl create secret docker-registry regcred \
  --docker-server=private-registry.nginx.com \
  --docker-username=<JWT Token> \
  --docker-password=none \
  -n nms
  ```

- **OpenShift**:

  ```shell
  oc new-project nms
  ```

  ```shell
  oc create secret docker-registry regcred \
  --docker-server=private-registry.nginx.com \
  --docker-username=<JWT Token> \
  --docker-password=none \
  -n nms
  ```

{{< warning >}}

You might see a warning about `--password` being insecure.

This can be ignored (since no password is used), but if others have access to this system, delete the JWT token and clear your shell history after deployment.

{{< /warning >}}

To confirm the secret is created:

- **Kubernetes**:

  ```shell
  kubectl get secret regcred --output=yaml -n nms
  ```

- **OpenShift**:

  ```shell
  oc get secret regcred --output=yaml -n nms
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

The `values.yaml` file customizes the Helm chart installation without modifying the chart itself. You can use it to specify image repositories, environment variables, resource requests, and other settings.

1. Create a `values.yaml` file similar to this example:

    - In the `imagePullSecrets` section, add the credentials for your private Docker registry.
    - Change the version tag to the version of NGINX Instance Manager you would like to install. See "Install the chart" below for versions.
    - If deploying on OpenShift, add the `openshift.enabled: true` setting.

    {{< see-also >}} For details on creating a secret, see Kubernetes [Pull an Image from a Private Registry](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/). {{</ see-also >}}

    ```yaml
    imagePullSecrets:
        - name: regcred
    apigw:
        image:
            repository: private-registry.nginx.com/nms/apigw
            tag: <version>
    core:
        image:
            repository: private-registry.nginx.com/nms/core
            tag: <version>
    dpm:
        image:
            repository: private-registry.nginx.com/nms/dpm
            tag: <version>
    ingestion:
        image:
            repository: private-registry.nginx.com/nms/ingestion
            tag: <version>
    integrations:
        image:
            repository: private-registry.nginx.com/nms/integrations
            tag: <version>
    secmon:
        image:
            repository: private-registry.nginx.com/nms/secmon
            tag: <version>
    utility:
        image:
            repository: private-registry.nginx.com/nms/utility
            tag: <version>
    ```

    {{< note >}} Starting in NGINX Instance Manager 2.19, the `secmon` pod is included in the NGINX Instance Manager deployment. {{< /note >}}

2. Save and close the `values.yaml` file.

---

## Enabling OpenShift

If deploying on OpenShift, include this setting in the `values.yaml` file:

```yaml
openshift:
  enabled: true
```

{{< note >}} The NIM deployment on OpenShift has been tested with OpenShift v4.13.0 Server. {{< /note >}}

### How OpenShift handles security constraints

When `openshift.enabled: true` is set in the `values.yaml` file, the NGINX Instance Manager deployment automatically creates a **custom [Security Context Constraints](https://docs.redhat.com/en/documentation/openshift_container_platform/4.13/html/authentication_and_authorization/managing-pod-security-policies) (SCCs)** and links it to the Service Account used by all pods.

By default, OpenShift enforces strict security policies that require containers to run as **non-root** users. The NGINX Instance Manager deployment needs specific user IDs (UIDs) for certain services, such as **1000** for `nms` and **101** for `nginx` and `clickhouse`. Since the default SCCs do not allow these UIDs, a **custom SCC** is created. This ensures that the deployment can run with the necessary permissions while maintaining OpenShift’s security standards. The custom SCC allows these UIDs by setting the `runAsUser` field, which controls which users can run containers.

{{< note >}} If you’re encountering errors with the custom SCC, you may not have permissions to access the Security Context Constraints resource. Please contact a Cluster Administrator to request access, either through a cluster role binding or by adjusting your user role. {{< /note >}}

To verify that the custom SCC has been created, after installing the helm chart, run:

```shell
oc get scc nms-restricted-v2-scc --output=yaml
```

---

## Install the chart

Run the `helm install` command to deploy NGINX Instance Manager:

1. Replace `<path-to-your-values.yaml>` with the path to your `values.yaml` file.
1. Replace `YourPassword123#` with a secure password (containing a mix of uppercase, lowercase letters, numbers, and special characters).

   {{< important >}} Remember to save the password for future use. Only the encrypted password is stored, and there's no way to recover or reset it if lost. {{< /important >}}

(Optional) Replace `<chart-version>` with the desired chart version. If omitted, the latest version will be installed. Currently only version 2.19.0 is supported.

```shell
helm install -n nms \
--set adminPasswordHash=$(openssl passwd -6 'YourPassword123#') \
nms nginx-stable/nms-hybrid \
--create-namespace \
-f <path-to-your-values.yaml> \
[--version <chart-version>] \
--wait
```

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

For instructions on downloading and applying a license, see [Add a License]({{< ref "/nim/admin-guide/license/add-license.md" >}}).

---

## Upgrade NGINX Instance Manager

To upgrade:

1. [Update the Helm repository list](#add-helm-repository).
1. [Adjust your `values.yaml` file](#create-a-helm-deployment-values.yaml-file) if needed.
1. To upgrade the NGINX Instance Manager deployment, run the following command. This command updates the `nms` deployment with a new version from the `nginx-stable/nms-hybrid` repository. It also hashes the provided password and uses the `values.yaml` file at the path you specify.

(Optional) Replace `<chart-version>` with the desired chart version. If omitted, the latest version will be installed. Currently only version 2.19.0 is supported.

   ```bash
    helm upgrade -n nms \
    --set adminPasswordHash=$(openssl passwd -6 'YourPassword123#') \
    nms nginx-stable/nms-hybrid \
    -f <path-to-your-values.yaml> \
    [--version <chart-version>] \
    --wait
   ```

   - Replace `<path-to-your-values.yaml>` with the path to the `values.yaml` file you created]({{< ref "/nim/deploy/kubernetes/deploy-using-helm.md#configure-chart" >}}).
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

- **Kubernetes**:

  ```shell
  kubectl get netpol -n nms
  ```

- **OpenShift**:

  ```shell
  oc get netpol -n nms
  ```
  **Output**:

  ```text
  NAME           POD-SELECTOR                          AGE
  apigw          app.kubernetes.io/name=apigw          4m47s
  clickhouse     app.kubernetes.io/name=clickhouse     4m47s
  core           app.kubernetes.io/name=core           4m47s
  dpm            app.kubernetes.io/name=dpm            4m47s
  ingestion      app.kubernetes.io/name=ingestion      4m47s
  integrations   app.kubernetes.io/name=integrations   4m47s
  secmon         app.kubernetes.io/name=secmon         4m47s
  utility        app.kubernetes.io/name=integrations   4m47s
  ```

To disable network policies, update the `values.yaml` file:

```yaml
nms-hybrid:
   networkPolicies:
      # Set this to true to enable network policies for NGINX Instance Manager.
      enabled: false
```

---

## Helm Deployment for NGINX Instance Manager 2.18 or lower

### Create a Helm deployment values.yaml file

The `values.yaml` file customizes the Helm chart installation without modifying the chart itself. You can use it to specify image repositories, environment variables, resource requests, and other settings.

1. Create a `values.yaml` file similar to this example:

    - In the `imagePullSecrets` section, add the credentials for your private Docker registry.
    - Change the version tag to the version of NGINX Instance Manager you would like to install. See "Install the chart" below for versions.

    {{< see-also >}} For details on creating a secret, see Kubernetes [Pull an Image from a Private Registry](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/). {{</ see-also >}}

    ```yaml
    nms-hybrid:
        imagePullSecrets:
            - name: regcred
        apigw:
            image:
                repository: private-registry.nginx.com/nms/apigw
                tag: <version>
        core:
            image:
                repository: private-registry.nginx.com/nms/core
                tag: <version>
        dpm:
            image:
                repository: private-registry.nginx.com/nms/dpm
                tag: <version>
        ingestion:
            image:
                repository: private-registry.nginx.com/nms/ingestion
                tag: <version>
        integrations:
            image:
                repository: private-registry.nginx.com/nms/integrations
                tag: <version>
        utility:
            image:
                repository: private-registry.nginx.com/nms/utility
                tag: <version>
    ```

2. Save and close the `values.yaml` file.

---

### Install the chart

Run the `helm install` command to deploy NGINX Instance Manager:

1. Replace `<path-to-your-values.yaml>` with the path to your `values.yaml` file.
2. Replace `YourPassword123#` with a secure password (containing a mix of uppercase, lowercase letters, numbers, and special characters).

   {{< important >}} Remember to save the password for future use. Only the encrypted password is stored, and there's no way to recover or reset it if lost. {{< /important >}}

3. Replace `<chart-version>` with the desired chart version 1.15.0 or lower. If omitted, it will lead to an unsuccessful deployment as it will try to install the latest vesrion 1.16.0 or later.

```shell
helm install -n nms \
--set nms-hybrid.adminPasswordHash=$(openssl passwd -6 'YourPassword123#') \
nms nginx-stable/nms \
--create-namespace \
-f <path-to-your-values.yaml> \
--version <chart-version> \
--wait
```

To help you choose the right NGINX Instance Manager chart version, see the table in:

{{< include "nim/kubernetes/nms-chart-supported-module-versions.md" >}}

---

### Upgrade NGINX Instance Manager

To upgrade:

1. [Update the Helm repository list](#add-helm-repository).
2. [Adjust your `values.yaml` file](#create-a-helm-deployment-values.yaml-file) if needed.
3. To upgrade the NGINX Instance Manager deployment, run the following command. This command updates the `nms` deployment with a new version from the `nginx-stable/nms` repository. It also hashes the provided password and uses the `values.yaml` file at the path you specify.
4. Replace `<chart-version>` with the desired chart version 1.15.0 or lower. If omitted, it will lead to an unsuccessful deployment as it will try to upgrade to the latest vesrion 1.16.0 or later.

   ```bash
    helm upgrade -n nms \
    --set nms-hybrid.adminPasswordHash=$(openssl passwd -6 'YourPassword123#') \
    nms nginx-stable/nms \
    -f <path-to-your-values.yaml> \
    --version <chart-version> \
    --wait
   ```

   - Replace `<path-to-your-values.yaml>` with the path to the `values.yaml` file you created]({{< ref "/nim/deploy/kubernetes/deploy-using-helm.md#configure-chart" >}}).
   - Replace `YourPassword123#` with a secure password that includes uppercase and lowercase letters, numbers, and special characters.

      {{<call-out "important" "Save the password!" "" >}} Save this password for future use. Only the encrypted password is stored in Kubernetes, and you can’t recover or reset it later. {{</call-out>}}

---

## Troubleshooting

For instructions on creating a support package to share with NGINX Customer Support, see [Create a Support Package from a Helm Installation]({{< ref "/nms/support/k8s-support-package.md" >}}).

