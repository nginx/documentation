---
# We use sentence case and present imperative tone
title: "Upgrade NGINX Ingress Controller"
# Weights are assigned in increments of 100: determines sorting order
weight: 500
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NIC 
---

This document describes how to upgrade F5 NGINX Ingress Controller when a new version releases. 

It covers the necessary steps for minor versions as well as major versions (Such as 3.x to 4.x).

Many of the nuances in upgrade paths relate to how custom resource definitions (CRDs) are managed.

## Minor NGINX Ingress Controller upgrades

### Upgrade NGINX Ingress Controller CRDs

{{< call-out "note" >}} If you are running NGINX Ingress Controller v3.x, you should read [Upgrade from NGINX Ingress Controller v3.x to v4.0.0]({{< ref "/nic/installation/upgrade-version.md#upgrade-from-3x-to-4x" >}}) before continuing. {{< /call-out >}}

To upgrade the CRDs, pull the Helm chart source, then use _kubectl apply_:

```shell
helm pull oci://ghcr.io/nginx/charts/nginx-ingress --untar --version {{< nic-helm-version >}}
kubectl apply -f crds/
```

Alternatively, CRDs can be upgraded without pulling the chart by running:

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/kubernetes-ingress/v{{< nic-version >}}/deploy/crds.yaml
```

In the above command, `v{{< nic-version >}}` represents the version of the NGINX Ingress Controller release rather than the Helm chart version.

{{< call-out "note" >}} The following warning is expected and can be ignored: `Warning: kubectl apply should be used on resource created by either kubectl create --save-config or kubectl apply`.

Check the [release notes](https://www.github.com/nginx/kubernetes-ingress/releases) for a new release for any special upgrade procedures.
{{< /call-out >}}

### Upgrade NGINX Ingress Controller charts

Once the CRDs have been upgraded, you can then upgrade the release chart.

The command depends on if you installed the chart using the registry or from source.

To upgrade a release named _my-release_, use the following command:

{{< tabs name="upgrade-chart" >}}

{{% tab name="OCI registry" %}}

```shell
helm upgrade my-release oci://ghcr.io/nginx/charts/nginx-ingress --version {{< nic-helm-version >}}
```

{{% /tab %}}

{{% tab name="Source" %}}

```shell
helm upgrade my-release .
```

{{% /tab %}}

{{< /tabs >}}

## Upgrade from 3.x to 4.x

{{< call-out "warning" "This upgrade path is intended for 3.x to 4.0.0 only" >}}

The instructions in this section are intended only for users upgrading from NGINX Ingress Controller 3.x to 4.0.0. Internal changes meant that backwards compability was not possible, requiring extra steps to upgrade.

{{< /call-out >}}

This section provides step-by-step instructions for upgrading NGINX Ingress Controller from version v3.x to v4.0.0.

There are two necessary steps required

- Update the `apiVersion` value of custom resources
- Configure structured logging.

If you want to use NGINX Plus, you will also need to follow the [Create a license Secret]({{< ref "/nic/installation/create-license-secret.md" >}}) topic.

### Update custom resource apiVersion

If you're using Helm chart version `v2.x`, update your `GlobalConfiguration`, `Policy`, and `TransportServer` resources from `apiVersion: k8s.nginx.org/v1alpha1` to `apiVersion: k8s.nginx.org/v1` before upgrading to NGINX Ingress Controller 4.0.0.

If the Helm chart you have been using is `v1.0.2` or earlier (NGINX Ingress Controller `v3.3.2`), upgrade to Helm chart `v1.4.2` (NGINX Ingress Controller `v3.7.2`) before updating your GlobalConfiguration, Policy, and TransportServer resources.

The example below shows the change for a Policy resource: you must do the same for all GlobalConfiguration and TransportServer resources.

{{< tabs name="resource-version-update" >}}

{{% tab name="Before" %}}

```yaml
apiVersion: k8s.nginx.org/v1alpha1
kind: Policy
metadata:
  name: rate-limit-policy
spec:
  rateLimit:
    rate: 1r/s
    key: ${binary_remote_addr}
    zoneSize: 10M
```

{{% /tab %}}

{{% tab name="After" %}}

```yaml
apiVersion: k8s.nginx.org/v1
kind: Policy
metadata:
  name: rate-limit-policy
spec:
  rateLimit:
    rate: 1r/s
    key: ${binary_remote_addr}
    zoneSize: 10M
```

{{% /tab %}}

{{< /tabs >}}

{{< call-out "warning" >}}

If a *GlobalConfiguration*, *Policy* or *TransportServer* resource is deployed with `apiVersion: k8s.nginx.org/v1alpha1`, it will be **deleted** during the upgrade process.

{{</ call-out >}}

After you move the custom resources to `v1`, run the following `kubectl` commands before upgrading to v4.0.0 Custom Resource Definitions (CRDs) to avoid webhook errors caused by leftover `v1alpha1` resources. For details, see [GitHub issue #7010](https://github.com/nginx/kubernetes-ingress/issues/7010).

```shell
kubectl patch customresourcedefinitions transportservers.k8s.nginx.org --subresource='status' --type='merge' -p '{"status":{"storedVersions": ["v1"]}}'
```

```shell
kubectl patch customresourcedefinitions globalconfigurations.k8s.nginx.org --subresource='status' --type='merge' -p '{"status":{"storedVersions": ["v1"]}}'
```

### Configure structured logging

To configure structured logging, you must update your log deployment arguments from an integer to a string. You can also choose different formats for the log output.

{{< note >}} These options apply to NGINX Ingress Controller logs, and do not affect NGINX logs. {{< /note >}}

| **Level arguments** | **Format arguments** |
|---------------------|----------------------|
| `trace`             | `json`               |
| `debug`             | `text`               |
| `info`              | `glog`               |
| `warning`           |                      |
| `error`             |                      |
| `fatal`             |                      |

{{< tabs name="structured logging" >}}

{{% tab name="Helm" %}}

The Helm value `controller.logLevel` is now a string instead of an integer.

To change the rendering of the log format, use the `controller.logFormat` key.

```yaml
controller:
    logLevel: info
    logFormat: json
```
{{% /tab %}}

{{% tab name="Manifests" %}}

The command line argument `-v` has been replaced with `-log-level`, and takes a string instead of an integer. The argument `-logtostderr` has also been deprecated.

To change the rendering of the log format, use the `-log-format` argument.

```yaml
args:
    - -log-level=info
    - -log-format=json
```
{{% /tab %}}

{{< /tabs >}}

### Create License secret

If you're using [NGINX Plus]({{< ref "/nic/overview/nginx-plus.md" >}}) with NGINX Ingress Controller, you should read the [Create a license Secret]({{< ref "/nic/installation/create-license-secret.md" >}}) topic to set up your NGINX Plus license.

The topic also contains guidance for [sending reports to NGINX Instance Manager]({{< ref "/nic/installation/create-license-secret.md#nim">}}), which is necessary for air-gapped environments.

Earlier versions required usage reporting through the cluster connector. This is no longer needed because it's now built into NGINX Plus.

## Upgrade a version older than v3.1.0

Starting in version 3.1.0, NGINX Ingress Controller uses updated Helm resource names, labels, and annotations to follow Helm best practices. [See the changes.](https://github.com/nginx/kubernetes-ingress/pull/3606)

When you upgrade with Helm from a version earlier than 3.1.0, some resources such as `Deployment`, `DaemonSet`, and `Service` are recreated. This causes downtime.

To reduce downtime, update all resources to use the new naming convention. The following steps help you do that.

{{< call-out "note" >}} The following steps apply to both 2.x and 3.0.x releases.  {{</ call-out >}}

The steps you should follow depend on your Helm release name:

{{< tabs name="upgrade-helm" >}}

{{% tab name="nginx-ingress" %}}

Use `kubectl describe` on deployment/daemonset to get the `Selector` value:

```shell
kubectl describe deployments -n <namespace>
```

Copy the key=value under `Selector`, such as:

```shell
Selector: app=nginx-ingress-nginx-ingress
```

Check out the latest available tag using `git checkout v{{< nic-version >}}`

Go to `/kubernetes-ingress/charts/nginx-ingress`

Update the `selectorLabels: {}` field in the `values.yaml` file located at `/kubernetes-ingress/charts/nginx-ingress` with the copied `Selector` value.

```shell
selectorLabels: {app: nginx-ingress-nginx-ingress}
```

Run `helm upgrade` with following arguments set:

```shell
--set serviceNameOverride="nginx-ingress-nginx-ingress"
--set controller.name=""
--set fullnameOverride="nginx-ingress-nginx-ingress"
```

It might look like this:

```shell
helm upgrade nginx-ingress oci://ghcr.io/nginx/charts/nginx-ingress --version 0.19.0 --set controller.kind=deployment/daemonset --set controller.nginxplus=false/true --set controller.image.pullPolicy=Always --set serviceNameOverride="nginx-ingress-nginx-ingress" --set controller.name="" --set fullnameOverride="nginx-ingress-nginx-ingress" -f values.yaml
```

Once the upgrade process has finished, use `kubectl describe` on the deployment to verify the change by reviewing its events:

```text
    Type    Reason             Age    From                   Message
----    ------             ----   ----                   -------
Normal  ScalingReplicaSet  9m11s  deployment-controller  Scaled up replica set nginx-ingress-nginx-ingress-<old_version> to 1
Normal  ScalingReplicaSet  101s   deployment-controller  Scaled up replica set nginx-ingress-nginx-ingress-<new_version> to 1
Normal  ScalingReplicaSet  98s    deployment-controller  Scaled down replica set nginx-ingress-nginx-ingress-<old_version> to 0 from 1
```

{{% /tab %}}

{{< tab name="Other release names" >}}

Use `kubectl describe` on deployment/daemonset to get the `Selector` value:

```shell
kubectl describe deployment/daemonset -n <namespace>
```

Copy the key=value under ```Selector```, such as:

```shell
Selector: app=<helm_release_name>-nginx-ingress
```

Check out the latest available tag using `git checkout v{{< nic-version >}}`

Go to `/kubernetes-ingress/charts/nginx-ingress`.

Update the `selectorLabels: {}` field in the `values.yaml` file located at `/kubernetes-ingress/charts/nginx-ingress` with the copied `Selector` value.

```shell
selectorLabels: {app: <helm_release_name>-nginx-ingress}
```

Run `helm upgrade` with following arguments set:

```shell
--set serviceNameOverride="<helm_release_name>-nginx-ingress"
--set controller.name=""
```

It might look like this:

```shell
helm upgrade test-release oci://ghcr.io/nginx/charts/nginx-ingress --version 0.19.0 --set controller.kind=deployment/daemonset --set controller.nginxplus=false/true --set controller.image.pullPolicy=Always --set serviceNameOverride="test-release-nginx-ingress" --set controller.name="" -f values.yaml
```

Once the upgrade process has finished, use `kubectl describe` on the deployment to verify the change by reviewing its events:

```shell
Type    Reason             Age    From                   Message
----    ------             ----   ----                   -------
Normal  ScalingReplicaSet  9m11s  deployment-controller  Scaled up replica set test-release-nginx-ingress-<old_version> to 1
Normal  ScalingReplicaSet  101s   deployment-controller  Scaled up replica set test-release-nginx-ingress-<new_version> to 1
Normal  ScalingReplicaSet  98s    deployment-controller  Scaled down replica set test-release-nginx-ingress-<old_version> to 0 from 1
```

{{% /tab %}}

{{< /tabs >}}
