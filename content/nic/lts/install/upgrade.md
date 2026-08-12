---
title: "Upgrade NGINX Ingress Controller LTS"
weight: 900
toc: true
f5-content-type: how-to
f5-product: NGINX Ingress Controller
---

This document describes how to upgrade F5 NGINX Ingress Controller LTS to a new patch release.

Many of the nuances in upgrade paths relate to how custom resource definitions (CRDs) are managed.

## Upgrading to a new LTS patch release

### Upgrade NGINX Ingress Controller LTS CRDs

To upgrade the CRDs, pull the Helm chart source, then use _kubectl apply_:

```shell
helm pull oci://ghcr.io/nginx/charts/nginx-ingress-lts --untar --version {{< nic-lts-helm-version >}}
kubectl apply -f crds/
```

Alternatively, CRDs can be upgraded without pulling the chart by running:

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/kubernetes-ingress/v{{< nic-lts-version >}}/deploy/crds.yaml
```

In the above command, `v{{< nic-lts-version >}}` represents the version of the NGINX Ingress Controller LTS release rather than the Helm chart version.

{{< call-out "note" >}} The following warning is expected and can be ignored: `Warning: kubectl apply should be used on resource created by either kubectl create --save-config or kubectl apply`.

Check the [release notes](https://www.github.com/nginx/kubernetes-ingress/releases) for a new release for any special upgrade procedures.
{{< /call-out >}}

### Upgrade NGINX Ingress Controller LTS charts

Once the CRDs have been upgraded, you can then upgrade the release chart.

The command depends on if you installed the chart using the registry or from source.

To upgrade a release named _my-release_, use the following command:

{{< tabs name="upgrade-chart" >}}

{{% tab name="OCI registry" %}}

```shell
helm upgrade my-release oci://ghcr.io/nginx/charts/nginx-ingress-lts --version {{< nic-lts-helm-version >}}
```

{{% /tab %}}

{{% tab name="Source" %}}

```shell
helm upgrade my-release .
```

{{% /tab %}}

{{< /tabs >}}

