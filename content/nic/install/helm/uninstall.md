---
title: Use Helm to uninstall NGINX Ingress Controller
linkTitle: Uninstall
toc: true
weight: 400
nd-content-type: how-to
nd-product: INGRESS
---

This page describes how to use Helm to uninstall F5 NGINX Ingress Controller.

It explains how to remove the chart, then remove the custom resource definitions (CRDs).

By following these instructions, you will remove NGINX Ingress Controller from your Kubernetes cluster.

## Remove the Helm chart

To uninstall NGINX Ingress Controller, you must first remove the chart.

To remove a release named **\<my-release\>**, use the following command:

```shell
helm uninstall <my-release>
```

The command removes all the Kubernetes components associated with the release, then deletes the release itself.

## Remove the CRDs

After removing the release, pull the chart sources:

```shell
helm pull oci://ghcr.io/nginx/charts/nginx-ingress --untar --version {{< nic-helm-version >}}
```

{{< call-out "warning" >}} 

The next command will delete all corresponding custom resources in your cluster across all namespaces. 

Before using it, check there are no custom resources that you want to keep, and that there are no other NGINX Ingress Controller instances running in the cluster.

{{< /call-out >}}

Then use _kubectl_ to delete the CRDs:

```shell
kubectl delete -f crds/
```

{{< details summary="Example output" >}}

```text
customresourcedefinition.apiextensions.k8s.io "aplogconfs.appprotect.f5.com" deleted
customresourcedefinition.apiextensions.k8s.io "appolicies.appprotect.f5.com" deleted
customresourcedefinition.apiextensions.k8s.io "apusersigs.appprotect.f5.com" deleted
customresourcedefinition.apiextensions.k8s.io "apdoslogconfs.appprotectdos.f5.com" deleted
customresourcedefinition.apiextensions.k8s.io "apdospolicies.appprotectdos.f5.com" deleted
customresourcedefinition.apiextensions.k8s.io "dosprotectedresources.appprotectdos.f5.com" deleted
customresourcedefinition.apiextensions.k8s.io "dnsendpoints.externaldns.nginx.org" deleted
customresourcedefinition.apiextensions.k8s.io "globalconfigurations.k8s.nginx.org" deleted
customresourcedefinition.apiextensions.k8s.io "policies.k8s.nginx.org" deleted
customresourcedefinition.apiextensions.k8s.io "transportservers.k8s.nginx.org" deleted
customresourcedefinition.apiextensions.k8s.io "virtualserverroutes.k8s.nginx.org" deleted
customresourcedefinition.apiextensions.k8s.io "virtualservers.k8s.nginx.org" deleted
```

{{< /details >}}

{{< call-out "caution" "Shared resource versions">}}

If you run multiple NGINX Ingress Controller releases in your cluster with custom resources enabled, every release will share a single version of the CRDs.

When uninstalling a release, ensure that you don’t remove the CRDs until there are no other NGINX Ingress Controller releases running in the cluster.

The [Run multiple NGINX Ingress Controllers]({{< ref "/nic/install/multiple-controllers.md" >}}) topic has more details.

{{< /call-out >}}

## Remove secrets

If your deployment used NGINX Plus, you should also remove the secrets created for your license and the F5 registry.

```shell
kubectl delete secret nplus-license
```

{{< details summary="Example output" >}}

```text
secret "nplus-license" deleted
```

{{< /details >}}

```shell
kubectl delete secret regcred
```

{{< details summary="Example output" >}}

```text
secret "regcred" deleted
```

{{< /details >}}