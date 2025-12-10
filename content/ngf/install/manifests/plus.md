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

First, create the _nginx-gateway_ namespace, which is used by the Manifest files by default:

```shell
kubectl create namespace nginx-gateway
```

{{< call-out "note" >}}

The commands in the rest of this document should be run in the same directory as your **license.jwt** file.

JWTs are sensitive information and should be stored securely. Delete them after use to prevent unauthorized access.

{{< /call-out >}}

Once you have obtained your license JWT, create a Kubernetes secret using `kubectl create`:

```shell
kubectl create  -n nginx-gateway secret generic nplus-license --from-file license.jwt
```

Then create another Kubernetes secret to allow interactions with the F5 registry:

```shell
kubectl create -n nginx-gateway secret docker-registry regcred \
  --docker-server=private-registry.nginx.com \
  --docker-username=$(cat license.jwt) \
  --docker-password=none
```

You can verify the creation of the secrets using `kubectl get`:

```shell
kubectl get -n nginx-gateway secrets
```

{{< details summary="Example output" >}}

```text
NAME            TYPE                             DATA   AGE
nplus-license   Opaque                           1      31s
regcred         kubernetes.io/dockerconfigjson   1      22s
```

{{< /details >}}

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

{{< include "/ngf/installation/next-steps.md" >}}