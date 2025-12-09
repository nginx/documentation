---
title: Use Manifests to install NGINX Gateway Fabric with NGINX Open Source
linkTitle: NGINX Open Source
weight: 100
toc: true
nd-content-type: how-to
nd-product: FABRIC
nd-docs: DOCS-1429
---

This page describes how to use Manifests to install NGINX Gateway Fabric with NGINX Open Source.

It explains how to install the Gateway API resources and add certificates for secure authentication, then deploy NGINX Gateway Fabric and its CRDs (Custom resource definitions).

By following these instructions, you will finish with a functional NGINX Gateway Fabric instance for your Kubernetes cluster.

{{< call-out "note" >}} To learn which Gateway API resources NGINX Gateway Fabric currently supports, view the [Gateway API Compatibility]({{< ref "/ngf/overview/gateway-api-compatibility.md" >}}) topic. {{< /call-out >}}

## Before you begin

To complete this guide, you will need the following pre-requisites:

- [A supported Kubernetes version]({{< ref "/ngf/overview/technical-specifications.md" >}})
- A functional Kubernetes cluster
- [cert-manager](https://cert-manager.io/docs/installation/)

## Install the Gateway API resources

{{< include "/ngf/installation/manifests/api-resources.md" >}}

## Add certificates for secure authentication

{{< include "/ngf/installation/manifests/secure-certificates.md" >}}

## Deploy the NGINX Gateway Fabric CRDs

{{< include "/ngf/installation/manifests/crds.md" >}}

## Deploy NGINX Gateway Fabric

By default, NGINX Gateway Fabric is installed in the **nginx-gateway** namespace.

If you want to deploy it in another namespace, you must modify the Manifest files.

Your next step is dependent on how you intend to expose NGINX Gateway Fabric:

{{< tabs name="install-manifests" >}}

{{% tab name="Default" %}}

To deploy NGINX Gateway Fabric with NGINX Open Source, use this `kubectl` command:

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/deploy/default/deploy.yaml
```

{{% /tab %}}

{{% tab name="AWS NLB" %}}

To deploy NGINX Gateway Fabric with NGINX Open Source, use this `kubectl` command:

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/deploy/default/deploy.yaml
```

To set up an AWS Network Load Balancer service, add these annotations to your Gateway infrastructure field:

```yaml
spec:
  infrastructure:
    annotations:
      service.beta.kubernetes.io/aws-load-balancer-type: "external"
      service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: "ip"
```

{{% /tab %}}

{{% tab name="Azure" %}}

To deploy NGINX Gateway Fabric with NGINX Open Source and `nodeSelector`, use this `kubectl` command:

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/deploy/azure/deploy.yaml
```

{{% /tab %}}

{{% tab name="NodePort "%}}

To deploy NGINX Gateway Fabric with NGINX Open Source and a `NodePort` service, use this `kubectl` command:

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/deploy/nodeport/deploy.yaml
```

{{% /tab %}}

{{% tab name="OpenShift "%}}

To deploy NGINX Gateway Fabric with NGINX Open Source on OpenShift, use this `kubectl` command:

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/deploy/openshift/deploy.yaml
```

{{% /tab %}}

{{< /tabs >}}

{{< details summary="Example output" >}}

```text
namespace/nginx-gateway configured
serviceaccount/nginx-gateway created
serviceaccount/nginx-gateway-cert-generator created
role.rbac.authorization.k8s.io/nginx-gateway-cert-generator created
clusterrole.rbac.authorization.k8s.io/nginx-gateway created
rolebinding.rbac.authorization.k8s.io/nginx-gateway-cert-generator created
clusterrolebinding.rbac.authorization.k8s.io/nginx-gateway created
service/nginx-gateway created
deployment.apps/nginx-gateway created
job.batch/nginx-gateway-cert-generator created
gatewayclass.gateway.networking.k8s.io/nginx created
nginxgateway.gateway.nginx.org/nginx-gateway-config created
nginxproxy.gateway.nginx.org/nginx-gateway-proxy-config created
```

{{< /details >}}

## Verify the Deployment

{{< include "/ngf/installation/manifests/verify-deployment.md" >}}

## Access NGINX Gateway Fabric

{{< include "/ngf/installation/expose-nginx-gateway-fabric.md" >}}

## Next steps

- [Deploy a Gateway for data plane instances]({{< ref "/ngf/install/deploy-data-plane.md" >}})
- [Routing traffic to applications]({{< ref "/ngf/traffic-management/basic-routing.md" >}})

## edge versions

### API resources

Installing Gateway API resources from the experimental channel includes everything in the standard release channel plus additional experimental resources and fields.
NGINX Gateway Fabric currently supports a subset of the additional features provided by the experimental channel.
To install from the experimental channel, run the following:

```shell
kubectl kustomize "https://github.com/nginx/nginx-gateway-fabric/config/crd/gateway-api/experimental?ref=v{{< version-ngf >}}" | kubectl apply -f -
```

### CRDs

```shell
kubectl apply --server-side -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/main/deploy/crds.yaml

```

### NGF itself

{{< call-out "note" >}} Requires the Gateway APIs installed from the experimental channel. {{< /call-out >}}

#### OSS + Experimental

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/deploy/experimental/deploy.yaml
```

#### Plus + Experimental

The image is pulled from the NGINX Plus Docker registry, and the `imagePullSecretName` is the name of the Secret to use to pull the image.

The NGINX Plus JWT Secret used to run NGINX Plus is also specified in a volume mount and the `--usage-report-secret` parameter. These Secrets are created as part of the [Before you begin](#before-you-begin) section.

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/deploy/nginx-plus-experimental/deploy.yaml
```