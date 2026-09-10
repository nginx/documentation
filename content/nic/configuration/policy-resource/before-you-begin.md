---
title: Before you begin
weight: 100
toc: false
f5-content-type: concept
f5-product: NGINX Ingress Controller
f5-docs: DOCS-596
f5-description: Overview of the Policy resource and how it works together with VirtualServer, VirtualServerRoute, and Ingress resources.
f5-summary: >
  The Policy resource lets you define reusable configuration, such as access control, rate limiting, authentication, and WAF, for NGINX Ingress Controller.
  This page introduces the Policy resource and the other resources it depends on.
f5-keywords: "nginx, nginx ingress controller, nic, policy resource, custom resource, virtualserver, virtualserverroute, ingress, kubernetes"
f5-audience: developer, operator
---

Use a Policy resource to define reusable configuration, such as access control, CORS, egress mTLS, and WAF. Attach that configuration to [VirtualServer and VirtualServerRoute resources]({{< ref "/nic/configuration/virtualserver-and-virtualserverroute-resources.md" >}}) or [Ingress resources]({{< ref "/nic/configuration/ingress-resources" >}}).

A Policy resource is a [Custom Resource](https://kubernetes.io/docs/concepts/extend-kubernetes/api-extension/custom-resources/).

A Policy resource works together with [VirtualServer and VirtualServerRoute resources]({{< ref "/nic/configuration/virtualserver-and-virtualserverroute-resources.md" >}}) and [Ingress resources]({{< ref "/nic/configuration/ingress-resources" >}}). Create these resources separately before you attach a policy to them.

## What's next

Learn about the [policy specification]({{< ref "/nic/configuration/policy-resource/policy-specification.md" >}}) and the supported policy types.
