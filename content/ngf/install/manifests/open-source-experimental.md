---
title: Use Manifests to install NGINX Gateway Fabric (experimental) with NGINX Open Source
linkTitle: NGINX Open Source (experimental)
weight: 300
toc: true
nd-content-type: how-to
nd-product: FABRIC
nd-docs: DOCS-1429
---

This page describes how to use Manifests to install NGINX Gateway Fabric (experimental) with NGINX Open Source.

It explains how to install the Gateway API resources and add authentication certificates, then deploy NGINX Gateway Fabric and its custom resource definitions.

Using experimental NGINX Gateway Fabric versions allows to test API resources from upcoming releases as outlined by the [Milestone Roadmap](https://github.com/orgs/nginx/projects/10/views/5).

By following these instructions, you will finish with a functional NGINX Gateway Fabric instance for your Kubernetes cluster.

{{< call-out "note" >}} 

To learn which Gateway API resources NGINX Gateway Fabric currently supports, view the [Gateway API Compatibility]({{< ref "/ngf/overview/gateway-api-compatibility.md" >}}) topic.

{{< /call-out >}}

## Before you begin

To complete this guide, you will need the following pre-requisites:

- [A supported Kubernetes version]({{< ref "/ngf/overview/technical-specifications.md" >}})
- A functional Kubernetes cluster
- [cert-manager](https://cert-manager.io/docs/installation/)

## Install the Gateway API resources

{{< include "/ngf/installation/manifests/api-resources-experimental.md" >}}

You should also create the _nginx-gateway_ namespace, which is used by the Manifest files by default:

```shell
kubectl create namespace nginx-gateway
```

## Add certificates for secure authentication

{{< include "/ngf/installation/manifests/secure-certificates.md" >}}

## Deploy the custom resource definitions

{{< include "/ngf/installation/manifests/crds.md" >}}

## Deploy NGINX Gateway Fabric

By default, NGINX Gateway Fabric is installed in the **nginx-gateway** namespace.

If you want to deploy it in another namespace, you must modify the Manifest files.

Your next step is dependent on how you intend to expose NGINX Gateway Fabric:

{{< tabs name="install-manifests" >}}

{{% tab name="Default" %}}

To deploy NGINX Gateway Fabric with NGINX Open Source, use this `kubectl` command:

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/deploy/experimental/deploy.yaml
```

{{% /tab %}}

{{% tab name="AWS NLB" %}}

To deploy NGINX Gateway Fabric with NGINX Open Source, use this `kubectl` command:

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/deploy/experimental/deploy.yaml
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

{{< /tabs >}}

{{< details summary="Example output" >}}

```text
namespace/nginx-gateway configured
serviceaccount/nginx-gateway created
serviceaccount/nginx-gateway-cert-generator created
role.rbac.authorization.k8s.io/nginx-gateway-cert-generator created
clusterrole.rbac.authorization.k8s.io/nginx-gateway configured
rolebinding.rbac.authorization.k8s.io/nginx-gateway-cert-generator created
clusterrolebinding.rbac.authorization.k8s.io/nginx-gateway configured
service/nginx-gateway created
deployment.apps/nginx-gateway created
job.batch/nginx-gateway-cert-generator created
gatewayclass.gateway.networking.k8s.io/nginx created
nginxgateway.gateway.nginx.org/nginx-gateway-config created
nginxproxy.gateway.nginx.org/nginx-gateway-proxy-config created
```

{{< /details >}}

## Verify the deployment

{{< include "/ngf/installation/manifests/verify-deployment.md" >}}

## Access NGINX Gateway Fabric

{{< include "/ngf/installation/expose-nginx-gateway-fabric.md" >}}

## Next steps

{{< include "/ngf/installation/next-steps.md" >}}