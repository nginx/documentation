---
title: Upgrade with Helm
draft: false
toc: true
description: This guide explains how to upgrade F5 NGINX Service Mesh using Helm.
weight: 300
nd-docs: DOCS-700
type:
- how-to
---

You can upgrade to the latest mesh version from the version immediately before it (for example, from v1.6.0 to v1.7.0). F5 NGINX Service Mesh doesn't support skipping versions.

{{< call-out "important" >}}
Check out the [Version-specific Notes]({{< ref "#version-specific-notes" >}}) section prior to upgrading to see if there are any extra details required for the version you are using.
{{< /call-out >}}

## Upgrade via Helm

### 1. Upgrade the CRDs

Helm does not upgrade the CRDs during a release upgrade. Before you upgrade a release you must download the chart from GitHub and run the following command to upgrade the CRDs:

```bash
git clone https://github.com/nginxinc/nginx-service-mesh
cd nginx-service-mesh/helm-chart
git checkout v2.0.0
kubectl apply -f crds/
```

The following warning is expected and can be ignored: `Warning: kubectl apply should be used on resource created by either kubectl create --save-config or kubectl apply.`

### 2. Upgrade the Release

To upgrade the release `nsm` in the `nginx-mesh` namespace:

#### Upgrade via Repository

```bash
helm repo update
helm upgrade nsm nginx-stable/nginx-service-mesh  --namespace nginx-mesh --wait
```

#### Upgrade via Source

```bash
helm upgrade nsm . --namespace nginx-mesh --wait
```

Once the upgrade is complete, if your applications support rolling updates, re-roll using the following command:

```bash
kubectl rollout restart <resource type>/<resource name>
```

Otherwise, the application Pods need to be deleted and re-created.

## Manual Upgrade

This upgrade method is the most disruptive, as it involves fully removing the existing mesh and deploying the newer version.

If breaking changes are introduced between versions, or you wish to change the [deployment configuration]( {{< ref "/mesh/get-started/install/install-with-helm.md#configuration-options" >}} ), then a manual upgrade strategy is necessary.

Some deployment configuration fields can be updated after the mesh has already been deployed, avoiding the need for manual upgrades. Those fields are discussed in the [API reference]( {{< ref "api-usage.md#modifying-the-global-mesh-configuration" >}} ) guide.

### 1. Save Custom Resources
{{< call-out "warning" >}}
When you manually upgrade NGINX Service Mesh, all of your Custom Resources will be deleted. This includes TrafficSplits, TrafficTargets, RateLimits, and so on.
{{< /call-out >}}

Before you proceed with the upgrade, run the commands shown below to back up your Custom Resources.

```bash
kubectl get trafficsplits.split.smi-spec.io -A -o yaml > trafficsplits.yaml
kubectl get traffictargets.access.smi-spec.io -A -o yaml > traffictargets.yaml
kubectl get httproutegroups.specs.smi-spec.io -A -o yaml > httproutegroups.yaml
kubectl get tcproutes.specs.smi-spec.io -A -o yaml > tcproutes.yaml
kubectl get ratelimits.specs.smi.nginx.com -A -o yaml > ratelimits.yaml
kubectl get circuitbreakers.specs.smi.nginx.com -A -o yaml > circuitbreakers.yaml
```

### 2. Remove NGINX Service Mesh

1. Uninstall the release `nsm` in the `nginx-mesh` namespace:

    ```bash
    helm uninstall nsm --namespace nginx-mesh
    ```

    Change the release or namespace names as necessary for your deployment.

1. Delete the CRDs:

    ```bash
    kubectl delete crd -l app.kubernetes.io/part-of==nginx-service-mesh
    ```

1. Delete the mesh namespace:

    ```bash
    kubectl delete namespace nginx-mesh
    ```

### 3. Install NGINX Service Mesh

#### Install via Repository

```bash
helm repo update
helm install nsm nginx-stable/nginx-service-mesh --namespace nginx-mesh --create-namespace --wait
```

#### Install via Source

```bash
helm install nsm . --namespace nginx-mesh --create-namespace --wait
```

### 4. Redeploy policies and sidecars

Use the backups you made earlier to recreate your custom resources:

```bash
kubectl create -f trafficsplits.yaml -f traffictargets.yaml -f httproutegroups.yaml -f tcproutes.yaml -f ratelimits.yaml -f circuitbreakers.yaml
```

If your applications support rolling updates, re-roll using the following command:

```bash
kubectl rollout restart <resource type>/<resource name>
```

Otherwise, the application Pods need to be re-created.


## Version-specific Notes

### Telemetry Configurations prior to v1.7.0

When upgrading from NGINX Service Mesh prior to v1.7, any tracing settings that do not correspond to an OpenTelemetry configuration will be removed. To deploy OpenTelemetry services and configure your mesh for OpenTelemetry tracing refer to the [Monitoring and Tracing]({{< ref "/mesh/guides/monitoring-and-tracing.md" >}}) guide.

### Upgrading from v1.6.0 to 1.7.0 in OpenShift

Due to changes in the CSI Driver in version 1.7.0 of NGINX Service Mesh for OpenShift, a manual upgrade is necessary to ensure volumes are properly unmounted and remounted.

The CSI volumes must be unmounted from existing applications before redeploying the mesh.

Follow these steps ***after*** [#2 Removing NGINX Service Mesh]({{< ref "#2-remove-nginx-service-mesh" >}}) in the manual upgrade steps above.

If your applications support rolling updates, re-roll using the following command:

```bash
kubectl rollout restart <resource type>/<resource name>
```

Otherwise, the application Pods need to be deleted. The list of resources that need to be re-rolled are printed out when removing the mesh.

Once all applications have their sidecars removed, and the `csi-driver-sentinel` Job in the `nginx-mesh` namespace has been automatically deleted, you can proceed to [#3 Install NGINX Service Mesh]({{< ref "#3-install-nginx-service-mesh" >}}) in the manual upgrade steps above.

For more context on OpenShift and the CSI Driver, see the [OpenShift Considerations]({{< ref "/mesh/get-started/platform-setup/openshift.md" >}}).
