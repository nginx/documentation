---
title: Use Manifests to install NGINX Gateway Fabric with NGINX Plus
linkTitle: NGINX Plus
weight: 200
toc: true
nd-content-type: how-to
nd-product: FABRIC
---

This page describes how to use Manifests to install NGINX Gateway Fabric with NGINX Plus.

It explains the requirements for NGINX Gateway Fabric, how to deploy NGINX Gateway Fabric, its custom resource definitions (CRDs) and the Gateway API resources.

By following these instructions, you will finish with a functional NGINX Gateway Fabric instance for your Kubernetes cluster.

## Before you begin

To complete this guide, you will need the following pre-requisites:

- An active NGINX Plus subscription (Purchased or trial)
- [A supported Kubernetes version]({{< ref "/ngf/overview/technical-specifications.md" >}})
- A functional Kubernetes cluster

## Download your JSON web token

{{< include "/ngf/installation/nginx-plus/download-jwt.md" >}}

## Create license and registry secrets

{{< include "/k8s/create-license-registry-secret.md" >}}

## Install the Gateway API resources

{{< include "/ngf/installation/manifests/api-resources" >}}

## Add certificates for secure authentication

{{< include "/ngf/installation/manifests/secure-certificates.md" >}}

## Deploy the NGINX Gateway Fabric CRDs

{{< include "/ngf/installation/manifests/crds.md" >}}

## Deploy NGINX Gateway Fabric

By default, NGINX Gateway Fabric is installed in the **nginx-gateway** namespace.

If you want to deploy it in another namespace, you must modify the Manifest files

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/deploy/nginx-plus/deploy.yaml
```

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