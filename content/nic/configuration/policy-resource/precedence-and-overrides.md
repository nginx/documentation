---
title: Policy precedence and override rules
weight: 500
toc: true
f5-content-type: concept
f5-product: NGINX Ingress Controller
f5-description: Precedence and override rules NGINX Ingress Controller uses when multiple policies of the same type apply to a resource.
f5-summary: >
  Explains how NGINX Ingress Controller resolves policy precedence when the same policy type is referenced at more than one scope.
  Covers VirtualServer, VirtualServerRoute, and Ingress, including mergeable Ingress.
f5-keywords: "nginx ingress controller, nic, policy precedence, policy override, virtualserver, virtualserverroute, ingress, mergeable ingress"
f5-audience: developer, operator
---

When more than one policy of the same type applies to a resource, NGINX Ingress Controller uses precedence rules to decide which policy takes effect.

## VirtualServer and VirtualServerRoute

Policy precedence goes from broader scope to narrower scope:

- `VirtualServer.spec.policies`
- `VirtualServer.route.policies`
- `VirtualServerRoute.subroute.policies`

If the same policy type appears at multiple levels, the more specific level wins. For example:

- Route-level `accessControl` overrides spec-level `accessControl`.
- Subroute-level `cors` overrides route-level `cors`.

## Ingress and mergeable Ingress

For Ingress:

- Policies apply to the whole Ingress.
- With mergeable Ingress, minion policies override master policies of the same type.

## What's next

See the [policy type reference]({{< ref "/nic/configuration/policy-resource/policy-reference.md" >}}) for the fields and merging behavior of each policy type.
