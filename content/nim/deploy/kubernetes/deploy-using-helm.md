---
docs: DOCS-1651
title: Deploy using Helm
toc: true
weight: 100
type:
- how-to
---

## Overview

You can deploy F5 NGINX Instance Manager on Kubernetes using Helm. This method is quick, scalable, and supports both standard and lightweight modes.

### New in 2.20.0

Starting with version 2.20.0, NGINX Instance Manager supports **lightweight mode**, which skips ClickHouse and disables metrics collection, ideal for simpler setups or resource-limited environments.

- Lightweight mode requires NGINX Agent v2.41.1 or later.

{{< call-out "note" "Chart renamed in NIM 2.20.0" >}}
The Helm chart has been renamed from `nginx-stable/nms-hybrid` to `nginx-stable/nim`.  
Make sure to update your chart references if you’re using version 2.20.0 or later.
{{< /call-out >}}


---

## Requirements

To deploy NGINX Instance Manager using a Helm chart, you need:

{{< bootstrap-table "table table-striped table-bordered" >}}
| Requirements                                 | Notes                                                                                                                                                                                                                  |
|----------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Docker 20.10 or later (linux/amd64)          | [Docker documentation](https://docs.docker.com/get-docker/)                                                                                                                                                            |
| Kubernetes 1.21.3 or later (linux/amd64)     | Ensure your client can [access the Kubernetes API server](https://kubernetes.io/docs/concepts/overview/components/#kube-apiserver). Helm uses the default storage class for persistent volume provisioning.            |
| `kubectl` 1.21.3 or later                    | [kubectl documentation](https://kubernetes.io/docs/reference/kubectl/)                                                                                                                                                 |
| Helm 3.10.0 or later                         | [Helm installation guide](https://helm.sh/docs/intro/install/)                                                                                                                                                         |
| OpenSSL 1.1.1 or later                       | [OpenSSL source](https://www.openssl.org/source/)                                                                                                                                                                      |
| `tar` 1.20 or later                          | The `tar` tool is usually installed by default. Check with `tar --version`.                                                                                                                                            |
| `values.yaml` file with `nmsClickhouse.mode` | Optional. Defaults to `internal`. Set to `external` or `disabled` to use an external ClickHouse instance or enable lightweight mode. In `external` mode, set `nim.externalClickhouse.address` to your ClickHouse host. |
| NGINX subscription JWT                       | Required to authenticate with `private-registry.nginx.com` to pull the image. Download your JWT from [MyF5](https://my.f5.com/manage/s/) under **My Products & Plans > Subscriptions**.                                |
{{</ bootstrap-table >}}

---

## Set up image registry access for NGINX Instance Manager

You can use your NGINX JWT as a Docker configuration secret with Helm charts.

Create a Docker registry secret on the cluster, using the JWT token as the username and `none` as the password. The Docker server is `private-registry.nginx.com`.

{{< call-out "note" "Note" >}}
Make sure there are no extra characters or spaces when copying the JWT token. They can invalidate the token and cause 401 errors during authentication.
{{< /call-out >}}

### Kubernetes

```shell
kubectl create namespace nim
kubectl create secret docker-registry regcred \
  --docker-server=private-registry.nginx.com \
  --docker-username=<NGINX JWT Token> \
  --docker-password=none \
  -n nim
```

### OpenShift

```shell
oc new-project nim && \
oc create secret docker-registry regcred \
  --docker-server=private-registry.nginx.com \
  --docker-username=<NGINX JWT Token> \
  --docker-password=none \
  -n nim
```

{{< call-out "note" "Note" >}}
You might see a warning that `--password` is insecure. In this case, it’s safe to ignore—none is used as a placeholder.

As a best practice, you can delete the JWT token and clear your shell history after deployment if others have access to the system.
{{< /call-out >}}

### Confirm the secret

- Kubernetes

    ```shell
    kubectl get secret regcred --output=yaml -n nim
    ```

- OpenShift

    ```shell
    oc get secret regcred --output=yaml -n nim
    ```

You can now use this secret for Helm deployments and point the chart to the private registry.

---

## Add the repository {#add-repository}

Run the following commands to add the official NGINX Helm repository and update your local chart list.

```shell
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
```

---

## Create a values.yaml file {#configure-values-yaml}

Create a file named `values.yaml` using the following example. This file customizes your NGINX Instance Manager deployment with Helm.

The values file lets you:

- Set the deployment mode
- Provide registry credentials
- Specify image sources for each NIM service

Set `nmsClickhouse.mode` to control ClickHouse deployment:

| Mode       | Description                                                                                |
|------------|--------------------------------------------------------------------------------------------|
| `internal` | Deploys ClickHouse in the cluster (default).                                               |
| `external` | Connects to an external ClickHouse instance and requires `nim.externalClickhouse.address`. |
| `disabled` | Disables ClickHouse and enables lightweight mode (no metrics).                             |

{{< call-out "note" "See also" >}}
See the [Helm chart configuration settings](
https://docs.nginx.com/nginx-instance-manager/deploy/kubernetes/helm-config-settings/
) guide for a complete list of chart parameters.
{{< /call-out >}}

```yaml
nmsClickhouse:
  mode: internal # options: internal, external, disabled

# when mode is external, uncomment and set this:
# externalClickhouse:
#   address: <clickhouse-host>:<port>

imagePullSecrets:
  - name: regcred

apigw:
  image:
    repository: private-registry.nginx.com/nms/apigw
    tag: 2.20.0

core:
  image:
    repository: private-registry.nginx.com/nms/core
    tag: 2.20.0

dpm:
  image:
    repository: private-registry.nginx.com/nms/dpm
    tag: 2.20.0

ingestion:
  image:
    repository: private-registry.nginx.com/nms/ingestion
    tag: 2.20.0

integrations:
  image:
    repository: private-registry.nginx.com/nms/integrations
    tag: 2.20.0

secmon:
  image:
    repository: private-registry.nginx.com/nms/secmon
    tag: 2.20.0

utility:
  image:
    repository: private-registry.nginx.com/nms/utility
    tag: 2.20.0
```

These values are required when pulling images from the NGINX private registry. The chart does not auto-resolve image tags. Update the tag: fields to match the NGINX Instance Manager version you want to install.

Use the file with the `-f values.yaml` flag when installing the chart.

{{< call-out "note" "OpenShift support" >}}
OpenShift support was added in NGINX Instance Manager 2.19. To enable it, add the setting `openshift.enabled: true` to your `values.yaml` file.  
For more details, see [Appendix: OpenShift security constraints](#appendix-openshift-security-constraints).
{{< /call-out >}}

---

## Install the chart

Install NGINX Instance Manager using Helm. The `adminPasswordHash` sets the default admin password.

```shell
helm install nim nginx-stable/nim \
  -n nim \
  --create-namespace \
  --set adminPasswordHash=$(openssl passwd -6 '<your-password>') \
  -f <your-values.yaml> \
  --version <chart-version> \
  --wait
```

- Replace `<your-password>` with your preferred admin password.
- Replace `<your-values.yaml>` with the path to your customized values.yaml file.
- Replace `<chart-version>` with the version you want to install (for example, `2.0.0`).

**Note:** You can set the ClickHouse mode at install time instead of editing `values.yaml`:

For lightweight mode (no ClickHouse):

```shell
--set nmsClickhouse.mode=disabled
```

For external ClickHouse:

```shell
--set nmsClickhouse.mode=external \
--set nim.externalClickhouse.address=<clickhouse-host>:<port>
```

**Validate the deployment**

After installation, run the following command to confirm the deployment was successful:

```shell
helm status nim -n nim
```

You should see `STATUS: deployed` in the output.

---

## Access the web interface

{{< include "nim/kubernetes/access-webui-helm.md" >}}

---

## Add a license

A valid license is required to use all NGINX Instance Manager features.

For instructions on downloading and applying a license, see [Add a License]({{< ref "/nim/admin-guide/add-license.md" >}}).

---

### Upgrade NGINX Instance Manager

To upgrade your deployment:

1. [Update the Helm repository list](#add-repository).
2. [Review and adjust your `values.yaml` file](#configure-values-yaml) as needed.
3. Run the following command to upgrade the deployment. This command uses the current chart version from the `nginx-stable/nim` repository and applies the configuration from your `values.yaml` file.

```shell
helm upgrade nim nginx-stable/nim \
  -n nim \
  --set adminPasswordHash=$(openssl passwd -6 '<your-password>') \
  -f <path-to-your-values.yaml> \
  --version <chart-version> \
  --wait
```

- Replace `<your-password>` with your preferred admin password.
- Replace `<your-values.yaml>` with the path to your customized values.yaml file.
- Replace `<chart-version>` with the version you want to install (for example, `2.0.0`).


{{< call-out "important" "Save the password!" >}}
Only the encrypted version of the admin password is stored in Kubernetes. If you lose it, it can’t be recovered or reset.
Make sure to save the password in a secure place.
{{< /call-out >}}

{{< call-out "note" "Upgrading from earlier versions" >}}
If you’re upgrading from a deployment that used the legacy `nms` chart or release name, you’ll need to update the chart reference and adjust the release name as needed.
The latest chart is now called `nginx-stable/nim`, and `nim` is the recommended release name.
{{< /call-out >}}

---

## Uninstall NGINX Instance Manager {#helm-uninstall-nim}

To uninstall NGINX Instance Manager, run:

```shell
helm uninstall <release-name> -n <namespace>
```

This command removes the deployment and all Kubernetes resources managed by the Helm chart.

For example, if you used the default release and namespace names:

```shell
helm uninstall nim -n nim
```

---

## Manage network policies

If you plan to use network policies, make sure your Kubernetes cluster has a supported [network plugin](https://kubernetes.io/docs/concepts/extend-kubernetes/compute-storage-net/network-plugins/) installed **before** you install the Helm chart.

By default, the Helm chart creates a set of network policies for NGINX Instance Manager in the deployment namespace.

To view them:

- **Kubernetes**:

    ```shell
    kubectl get netpol -n <namespace>
    ```

- **OpenShift**:

    ```shell
    oc get netpol -n <namespace>
    ```

The number and names of network policies vary depending on the deployment mode (standard vs. lightweight). For example, in standard mode, you might see output like this:

```text
NAME         POD-SELECTOR                     AGE
apigw        app.kubernetes.io/name=apigw     2m
core         app.kubernetes.io/name=core      2m
dpm          app.kubernetes.io/name=dpm       2m
ingestion    app.kubernetes.io/name=ingestion 2m
secmon       app.kubernetes.io/name=secmon    2m
```

If you’re using lightweight mode, your output may include fewer entries.

To disable network policies, add the following to your `values.yaml` file:

```yaml
networkPolicies:
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

3. (Optional) Replace `<chart-version>` with the desired chart version. If omitted, the latest version will be installed.

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

1. [Update the Helm repository list](#add-repository).
2. [Adjust your `values.yaml` file](#create-a-helm-deployment-values.yaml-file) if needed.
3. To upgrade the NGINX Instance Manager deployment, run the following command. This command updates the `nms` deployment with a new version from the `nginx-stable/nms` repository. It also hashes the provided password and uses the `values.yaml` file at the path you specify.
4. Replace `<chart-version>` with the desired chart version 1.15.0 or lower. If omitted, it will lead to an unsuccessful deployment as it will try to upgrade to the latest vesrion 1.16.0 or later.

   ```shell
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

For instructions on creating a support package to share with NGINX Customer Support, see [Create a Support Package from a Helm Installation]({{< ref "nim/support/k8s-support-package.md" >}}).

---

## Appendix: OpenShift security constraints {#appendix-openshift-security-constraints}

OpenShift restricts containers from running as root by default. To support NGINX Instance Manager, the Helm chart creates a custom Security Context Constraint (SCC) when you set:

```yaml
openshift:
  enabled: true
```

This ensures pods can run with the user IDs required by NGINX Instance Manager services.

{{< call-out "note" "Note" >}}
If you see permission errors during deployment, your user account might not have access to manage SCCs. Contact a cluster administrator to request access.
{{< /call-out >}}

To verify that the SCC was created after installing the Helm chart, run:

```shell
oc get scc nms-restricted-v2-scc --output=yaml
```

---

## Next steps

- [Add NGINX Open Source and NGINX Plus instances to NGINX Instance Manager]({{< ref "nim/nginx-instances/add-instance.md" >}})
