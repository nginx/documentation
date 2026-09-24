---
title: Before you begin
weight: 100
toc: false
f5-content-type: concept
f5-product: NGINX Ingress Controller
---

Use a Policy resource to configure features like access control and rate limiting. Add this configuration to your [VirtualServer, VirtualServerRoute resources]({{< ref "/nic/lts/configuration/virtualserver-and-virtualserverroute-resources.md" >}}) and [Ingress resources]({{< ref "/nic/lts/configuration/ingress-resources" >}}).

A Policy resource is a [Custom Resource](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/).

This section is reference documentation for the Policy resource. For an example Policy for access control, see the [GitHub repository](https://github.com/nginx/kubernetes-ingress/blob/v{{< nic-lts-version >}}/examples/custom-resources/access-control).

A Policy resource works together with [VirtualServer, VirtualServerRoute resources]({{< ref "/nic/lts/configuration/virtualserver-and-virtualserverroute-resources.md" >}}) and [Ingress resources]({{< ref "/nic/lts/configuration/ingress-resources" >}}). Create these resources separately.

## What's next

Learn about the [policy specification]({{< ref "/nic/lts/configuration/policy-resource/policy-specification.md" >}}).
