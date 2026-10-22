---
title: "Upgrade NGINX Ingress Controller"
weight: 900
toc: true
f5-content-type: how-to
f5-product: NGINX Ingress Controller
---

This document describes how to upgrade F5 NGINX Ingress Controller when a new version releases.

It covers the necessary steps for minor versions as well as major versions (Such as 3.x to 4.x).

Many of the nuances in upgrade paths relate to how custom resource definitions (CRDs) are managed.

## Minor NGINX Ingress Controller upgrades

### Upgrade NGINX Ingress Controller CRDs

{{< call-out class="note" >}} If you are running NGINX Ingress Controller v3.x, you should read [Upgrade from NGINX Ingress Controller v3.x to v4.0.0]({{< ref "/nic/install/upgrade.md#upgrade-from-3x-to-4x" >}}) before continuing. {{< /call-out >}}

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

{{< call-out class="note" >}} The following warning is expected and can be ignored: `Warning: kubectl apply should be used on resource created by either kubectl create --save-config or kubectl apply`.

Check the [release notes](https://www.github.com/nginx/kubernetes-ingress/releases) for a new release for any special upgrade procedures.
{{< /call-out >}}

### Upgrade NGINX Ingress Controller charts

Once the CRDs have been upgraded, you can then upgrade the release chart.

{{< call-out class="note" title="Note" >}}
When upgrading to version 5.6.0 or later, if you configured NGINX Service Mesh previously, remove any related values from the Helm chart before upgrading. These settings only applied to previous NGINX Service Mesh deployments. Users who never deployed service mesh are unaffected.
{{< /call-out >}}

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

## Migrate ExternalDNS DNSEndpoint resources to externaldns.k8s.io

ExternalDNS v0.21.0 and later reads `DNSEndpoint` resources only from the upstream `externaldns.k8s.io/v1alpha1` API group. By default, NGINX Ingress Controller writes `DNSEndpoint` resources to its own `externaldns.nginx.org/v1` group. To use ExternalDNS v0.21.0 or later, switch NGINX Ingress Controller to the upstream group.

Use one of these settings to choose the group:

- Helm: `controller.externalDNSGroupVersion`. For more information, see [Helm chart parameters]({{< ref "/nic/install/helm/parameters.md" >}}).
- Command-line argument: [`-external-dns-group-version`]({{< ref "/nic/configuration/global-configuration/command-line-arguments.md#cmdoption-external-dns-group-version" >}}).

NGINX Ingress Controller doesn't ship the upstream `DNSEndpoint` CRD. Install it yourself, either with the ExternalDNS Helm chart or from the ExternalDNS repository:

```shell
kubectl apply -f https://raw.githubusercontent.com/kubernetes-sigs/external-dns/v0.21.0/config/crd/standard/dnsendpoints.externaldns.k8s.io.yaml
```

If NGINX Ingress Controller doesn't manage any DNS records yet, install the CRD and set the upstream group. If you have existing records, follow the steps in [Migrate in stages](#migrate-in-stages) to keep every DNS record in place.

The role-based access control (RBAC) permissions depend on how you installed NGINX Ingress Controller:

- The Helm chart grants access only to the group you select.
- The manifest `deployments/rbac/rbac.yaml` grants access to both groups. You can change the argument without editing RBAC.

### Understand the migration risks

NGINX Ingress Controller doesn't convert or delete existing `DNSEndpoint` resources. You control the cut-over, and the order of the steps protects your DNS records.

{{< call-out class="warning" title="Install the upstream CRD and verify the new DNSEndpoint before ExternalDNS reads it" >}}

If you run ExternalDNS with `--policy=sync`, don't let ExternalDNS read the `externaldns.k8s.io` group before NGINX Ingress Controller populates it. When the CRD exists but has no matching objects, ExternalDNS treats the empty result as valid. It then deletes every DNS record it owns.

With `--policy=upsert-only`, ExternalDNS doesn't delete records, so the records stay in place.

A missing CRD or missing RBAC is safer: ExternalDNS fails to start and doesn't change any records. A `DNSEndpoint` that exists but is empty or out of date is as dangerous as no object at all.

{{< /call-out >}}

If the cluster doesn't serve the group you select, NGINX Ingress Controller exits at startup with this error:

```text
Cannot enable external-dns: API group/version "externaldns.k8s.io/v1alpha1" is not served by the cluster; install the DNSEndpoint CRD for it
```

The new pods go into `CrashLoopBackOff`. Your DNS records stay in place, because the old object remains and ExternalDNS still reads it. The effect on traffic depends on your rollout strategy:

- Deployment with the default `RollingUpdate` strategy: the old NGINX Ingress Controller pods keep serving traffic.
- DaemonSet, or a Deployment with the `Recreate` strategy: the replaced pods are gone. The affected nodes have no running NGINX Ingress Controller until you install the CRD.

After you install the CRD, the new pods start without further action. NGINX Ingress Controller checks for the CRD only at startup. If someone removes the CRD later, NGINX Ingress Controller doesn't detect it.

### Migrate in stages

Migrate before you upgrade ExternalDNS to v0.21.0 or later. ExternalDNS v0.20.x and earlier reads either group, which makes a staged migration possible. Complete the check for each step before you start the next one.

| Step | Action | Check before you continue |
| ---- | ------ | ------------------------- |
| 0 | Install the upstream `DNSEndpoint` CRD. An NGINX Ingress Controller upgrade doesn't install it. | `kubectl get crd dnsendpoints.externaldns.k8s.io` succeeds. |
| 1 | Upgrade NGINX Ingress Controller. Keep the group at the default, `externaldns.nginx.org/v1`. | DNS records are unchanged. The `externaldns.nginx.org/v1` object still exists and is current. |
| 2 | Set the Helm value `controller.externalDNSGroupVersion: externaldns.k8s.io/v1alpha1`, or the argument `-external-dns-group-version=externaldns.k8s.io/v1alpha1`. | Don't continue until the `externaldns.k8s.io/v1alpha1` object exists. Its `.spec.endpoints` must match the targets and time-to-live (TTL) of the old object. The new NGINX Ingress Controller pods must be Ready. |
| 3 | Remove `--crd-source-apiversion` from your ExternalDNS v0.20.x configuration. The default of this argument is `externaldns.k8s.io/v1alpha1`, so ExternalDNS now reads the upstream group. | `status.observedGeneration` matches `metadata.generation` on the new object. After one full sync interval, ExternalDNS logs `All records are already up to date`. |
| 4 | Upgrade ExternalDNS to v0.21.0 or later. | The same check as step 3. |
| 5 | Delete the old `externaldns.nginx.org/v1` object. | DNS records are unchanged. |

Steps 3 through 5 don't change any DNS records. The old and new objects have the same name and namespace. ExternalDNS builds its ownership label from these values (`crd/<NAMESPACE>/<NAME>`). As a result, the TXT registry record stays the same, and ExternalDNS finds no changes to make.

Keep steps 2 and 3 short and separate:

- Do steps 2 and 3 close together. After step 2, NGINX Ingress Controller stops updating the old object, but ExternalDNS still reads it. ExternalDNS doesn't publish VirtualServer changes that you make between the two steps.
- Don't combine step 3 with step 4. ExternalDNS v0.21.0 and later ignores `--crd-source-apiversion`, so step 4 also switches the group. If you make both changes at once and your records change, you can't tell which change caused it.

To confirm that ExternalDNS read the new object, compare its observed generation with its generation:

```shell
kubectl get dnsendpoints.externaldns.k8s.io <VIRTUALSERVER_NAME> -o jsonpath='{.status.observedGeneration}/{.metadata.generation}'
```

Replace `<VIRTUALSERVER_NAME>` with the name of your VirtualServer. The `DNSEndpoint` has the same name.

When the two values match, ExternalDNS read the resource. ExternalDNS sets `status.observedGeneration` when it reads the resource, before it sends records to your DNS provider. A match confirms that ExternalDNS read the resource, not that the DNS record is live.

### Roll back a migration

Until you delete the old object in step 5, you can return to the starting state. Revert both settings together:

1. Set `controller.externalDNSGroupVersion` (or `-external-dns-group-version`) back to `externaldns.nginx.org/v1`.
1. Add `--crd-source-apiversion=externaldns.nginx.org/v1` back to your ExternalDNS configuration. If you already upgraded ExternalDNS, roll it back to v0.20.x. ExternalDNS v0.21.0 and later can't read the `externaldns.nginx.org` group.

If you revert only one setting, ExternalDNS reads a group that NGINX Ingress Controller doesn't write to. This causes the same empty result that the warning in [Understand the migration risks](#understand-the-migration-risks) describes.

If you skip step 5, the old object isn't left behind forever. NGINX Ingress Controller sets an owner reference from each `DNSEndpoint` to its VirtualServer. When you delete the VirtualServer, Kubernetes deletes the old object too.

NGINX Ingress Controller manages only the group you select. It never deletes objects in the other group. To delete the old object in step 5, use `kubectl delete` with your own credentials. With a Helm installation, the NGINX Ingress Controller service account loses its permissions on `externaldns.nginx.org` after step 2.

## Upgrade from 3.x to 4.x

{{< call-out class="warning" title="This upgrade path is intended for 3.x to 4.0.0 only" >}}

The instructions in this section are intended only for users upgrading from NGINX Ingress Controller 3.x to 4.0.0. Internal changes meant that backwards compability was not possible, requiring extra steps to upgrade.

{{< /call-out >}}

This section provides step-by-step instructions for upgrading NGINX Ingress Controller from version v3.x to v4.0.0.

There are two necessary steps required

- Update the `apiVersion` value of custom resources
- Configure structured logging.

If you want to use NGINX Plus, you will also need to follow the [Create a license Secret]({{< ref "/nic/install/license-secret.md" >}}) topic.

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

{{< call-out class="warning" >}}

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

{{< call-out class="note" >}} These options apply to NGINX Ingress Controller logs, and do not affect NGINX logs. {{< /call-out >}}

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

If you're using [NGINX Plus]({{< ref "/nic/overview/nginx-plus.md" >}}) with NGINX Ingress Controller, you should read the [Create a license Secret]({{< ref "/nic/install/license-secret.md" >}}) topic to set up your NGINX Plus license.

The topic also contains guidance for [sending reports to NGINX Instance Manager]({{< ref "/nic/install/license-secret.md#nim">}}), which is necessary for air-gapped environments.

Earlier versions required usage reporting through the cluster connector. This is no longer needed because it's now built into NGINX Plus.

## Upgrade a version older than v3.1.0

Starting in version 3.1.0, NGINX Ingress Controller uses updated Helm resource names, labels, and annotations to follow Helm best practices. [See the changes.](https://github.com/nginx/kubernetes-ingress/pull/3606)

When you upgrade with Helm from a version earlier than 3.1.0, some resources such as `Deployment`, `DaemonSet`, and `Service` are recreated. This causes downtime.

To reduce downtime, update all resources to use the new naming convention. The following steps help you do that.

{{< call-out class="note" >}} The following steps apply to both 2.x and 3.0.x releases.  {{</ call-out >}}

The steps you should follow depend on your Helm release name:

{{< tabs name="upgrade-helm" >}}

{{% tab name="nginx-ingress" %}}

Use `kubectl describe` on deployment/daemonset to get the `Selector` value:

```shell
kubectl describe deployments -n <NAMESPACE>
```

Replace `<NAMESPACE>` with the Kubernetes namespace where NGINX Ingress Controller is installed.

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
Normal  ScalingReplicaSet  9m11s  deployment-controller  Scaled up replica set nginx-ingress-nginx-ingress-<OLD_VERSION> to 1
Normal  ScalingReplicaSet  101s   deployment-controller  Scaled up replica set nginx-ingress-nginx-ingress-<NEW_VERSION> to 1
Normal  ScalingReplicaSet  98s    deployment-controller  Scaled down replica set nginx-ingress-nginx-ingress-<OLD_VERSION> to 0 from 1
```

Replace `<OLD_VERSION>` with the version you're upgrading from and `<NEW_VERSION>` with the version you're upgrading to.

{{% /tab %}}

{{< tab name="Other release names" >}}

Use `kubectl describe` on deployment/daemonset to get the `Selector` value:

```shell
kubectl describe deployment/daemonset -n <NAMESPACE>
```

Copy the key=value under ```Selector```, such as:

```shell
Selector: app=<RELEASE_NAME>-nginx-ingress
```

Replace `<RELEASE_NAME>` with the name of your Helm release.

Check out the latest available tag using `git checkout v{{< nic-version >}}`

Go to `/kubernetes-ingress/charts/nginx-ingress`.

Update the `selectorLabels: {}` field in the `values.yaml` file located at `/kubernetes-ingress/charts/nginx-ingress` with the copied `Selector` value.

```shell
selectorLabels: {app: <RELEASE_NAME>-nginx-ingress}
```

Run `helm upgrade` with following arguments set:

```shell
--set serviceNameOverride="<RELEASE_NAME>-nginx-ingress"
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
Normal  ScalingReplicaSet  9m11s  deployment-controller  Scaled up replica set test-release-nginx-ingress-<OLD_VERSION> to 1
Normal  ScalingReplicaSet  101s   deployment-controller  Scaled up replica set test-release-nginx-ingress-<NEW_VERSION> to 1
Normal  ScalingReplicaSet  98s    deployment-controller  Scaled down replica set test-release-nginx-ingress-<OLD_VERSION> to 0 from 1
```

{{% /tab %}}

{{< /tabs >}}

## Custom NGINX templates

If you use custom NGINX configuration templates, review and apply any upstream template changes before upgrading. For more information, see [Custom templates]({{< ref "/nic/configuration/global-configuration/custom-templates.md" >}}).

{{< call-out "warning" "Upgrading to version 5.5 or later">}}
In version 5.5, the default server block was removed from `main-template` and is now generated by `ingress-template`. You must update both templates before upgrading. If you had customizations inside the default server block in your `main-template`, the patch will remove them. Migrate those changes to your `ingress-template` manually.
{{< /call-out >}}

1. Clone the repository:

   ```shell
   git clone https://github.com/nginx/kubernetes-ingress.git
   ```

2. Generate a diff between the version you are upgrading from and the version you are upgrading to. For `main-template` and `ingress-template`, use `version1`. For `virtualserver-template` and `transportserver-template`, use `version2`:

   ```shell
   git diff v<CURRENT_VERSION>..v<TARGET_VERSION> -- internal/configs/version1/<TEMPLATE_FILE> > upstream.patch
   git diff v<CURRENT_VERSION>..v<TARGET_VERSION> -- internal/configs/version2/<TEMPLATE_FILE> > upstream.patch
   ```

   Replace the placeholders as follows:

   - `<CURRENT_VERSION>`: the version you're upgrading from
   - `<TARGET_VERSION>`: the version you're upgrading to
   - `<TEMPLATE_FILE>`: the name of the template file

3. Extract your custom template from the ConfigMap to a local file. The valid key names are `main-template`, `ingress-template`, `virtualserver-template`, and `transportserver-template`:

   ```shell
   kubectl get configmap <NAME> -n nginx-ingress -o jsonpath='{.data.<TEMPLATE_KEY>}' > my-template.tmpl
   ```

   Replace `<NAME>` with the name of the resource and `<TEMPLATE_KEY>` with the key of the template in your ConfigMap.

4. Apply the patch to your custom template:

   ```shell
   patch my-template.tmpl < upstream.patch
   ```

   If the patch fails to apply some changes, review the rejected changes in `my-template.tmpl.rej` and apply them by manually.

5. Update the template key with the patched content. If you manage your ConfigMap directly, update the relevant key in your manifest and run `kubectl apply -f <YOUR_CONFIGMAP.YAML>`. If you use Helm, set the key under `controller.config.entries` in your values file and run `helm upgrade`.
