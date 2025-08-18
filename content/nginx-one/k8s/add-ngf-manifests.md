---
title: Connect NGINX Gateway Fabric with Manifests
toc: true
weight: 300
nd-content-type: how-to
nd-product: NGINX One
---

This document explains how to connect F5 NGINX Gateway Fabric to F5 NGINX One Console with Manifests.
Connecting NGINX Gateway Fabric to NGINX One Console enables centralized monitoring of all controller instances.

Once connected, you'll see a **read-only** configuration of NGINX Gateway Fabric. For each instance, you can review:

- Read-only configuration file
- Unmanaged SSL/TLS certificates for Control Planes

## Before you begin

Log in to NGINX One Console. If you need more information, review our [Get started guide]({{< ref "/nginx-one/getting-started.md#before-you-begin" >}}).

{{< include "/ngf/installation/install-manifests-prereqs.md" >}}

### Create a data plane key

{{< include "/nginx-one/how-to/generate-data-plane-key.md" >}}

### Create a Kubernetes secret with the data plane key

{{< include "/nginx-one/how-to/k8s-secret-dp-key.md" >}}

## Install Gateway API resources
<!-- Corresponds to step 2 in the UX -->
{{< include "/ngf/installation/install-gateway-api-resources.md" >}}

## Deploy NGINX Gateway Fabric CRDs
<!-- Corresponds to step 3 in the UX -->

{{< include "/ngf/installation/deploy-ngf-crds.md" >}}

## Deploy NGINX Gateway Fabric

Specify the data plane key Secret name in the `--nginx-one-dataplane-key-secret` command-line argument of the nginx-gateway container.

{{< include "/ngf/installation/deploy-ngf-manifests.md" >}}

## Verify a connection to NGINX One Console

{{< include "/nginx-one/how-to/verify-connection.md" >}}

## Troubleshooting

{{< include "/nginx-one/how-to/ngf-troubleshooting.md" >}}

## References

For more details, see:

- [Install NGINX Gateway Fabric with Manifests]({{< ref "/ngf/install/manifests.md" >}})

