---
title: Use Manifests to install experimental NGINX Gateway Fabric versions
linkTitle: Experimental
weight: 300
toc: true
nd-content-type: reference
nd-product: FABRIC
---

This page describes how to use Manifests to install experimental NGINX Gateway Fabric versions.

The deployment process is similar to other installation procedures, and can be done with NGINX Open Source or NGINX Plus.

{{< call-out "note" >}}

Using experimental NGINX Gateway Fabric versions can allow you to test API resources from upcoming releases as outlined by the [Milestone Roadmap](https://github.com/orgs/nginx/projects/10/views/5).

For information on API resource support, view the [Gateway API compatibility]({{< ref "/ngf/overview/gateway-api-compatibility.md" >}}) topic.

{{< /call-out >}}

The main requirement for installing experimental NGINX Gateway Fabric versions is to change the URL for each resource during the installation steps.

Each of the following sections provides the necessary replacement URL and any other necessary information.

## API resources

The Gateway API resources from the experimental channel include everything in the standard release channel.

To install API resources from the experimental channel, run the following command:

```shell
kubectl kustomize "https://github.com/nginx/nginx-gateway-fabric/config/crd/gateway-api/experimental?ref=v{{< version-ngf >}}" | kubectl apply -f -
```

## Custom resource definitions

The custom resource definitions (CRDs) for an experimental NGINX Gateway Fabric release are the same as a regular deployment, and do not require replacement.

## NGINX Gateway Fabric deployment

{{< call-out "warning" >}}

To install an experimental NGINX Gateway Fabric version, you **must** also install [experimental API resources](#api-resources). They cannot be mis-matched.

{{< /call-out >}}

To deploy an experimental NGINX Gateway Fabric instance, use the command based on your NGINX type:

{{< tabs name="nginx-version" >}}

{{% tab name="NGINX Open Source" %}}

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/deploy/experimental/deploy.yaml
```

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/deploy/nginx-plus-experimental/deploy.yaml
```

{{% /tab %}}

{{< /tabs >}}