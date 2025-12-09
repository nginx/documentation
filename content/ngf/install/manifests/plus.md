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