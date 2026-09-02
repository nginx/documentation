---
title: Ingress-specific policy behavior
weight: 400
toc: true
f5-content-type: concept
f5-product: NGINX Ingress Controller
f5-description: Ingress-specific limitations and behavior for Policy resources, including WAF, egress mTLS, and mergeable Ingress.
f5-summary: >
  Explains how Policy support on Ingress resources differs from VirtualServer and VirtualServerRoute support.
  Covers WAF policy annotations, egress mTLS TLS requirements, and how policies behave on master and minion Ingresses.
f5-keywords: "nginx ingress controller, nic, ingress, policy resource, waf, egress mtls, mergeable ingress, master, minion"
f5-audience: developer, operator
---

Ingress resources support Policy resources, but with some differences from VirtualServer and VirtualServerRoute resources. Review the following behavior before you attach a policy to an Ingress.

## Ingress doesn't support every policy type

Ingress policy support is narrower than VirtualServer support. If you need route-level control for features like JWT, OIDC (NJS), cache, or rate limiting, use VirtualServer and VirtualServerRoute instead.

## WAF on Ingress must use "nginx.com/policies"

WAF is a Plus-only feature. When you use a WAF policy with Ingress, reference it through:

```yaml
metadata:
  annotations:
    nginx.com/policies: waf-policy
```

Don't attach WAF to Ingress with `nginx.org/policies`.

{{< call-out "important" >}}

On Ingress, `nginx.org/policies` and `nginx.com/policies` aren't interchangeable. Reference WAF policies only through `nginx.com/policies`.

{{< /call-out >}}

## Egress mTLS on Ingress only configures TLS parameters

`egressMTLS` defines how NGINX authenticates to the upstream and verifies the upstream certificate. It doesn't switch the upstream transport from plain HTTP to HTTPS.

For Ingress, you still need the upstream connection itself to use TLS. Common ways to do this include:

- `nginx.org/ssl-services` for HTTPS upstreams
- `nginx.org/grpc-services` for gRPC upstreams

For example:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: webapp-ingress
  annotations:
    nginx.org/policies: egress-mtls-policy
    nginx.org/ssl-services: "secure-app"
spec:
  ingressClassName: nginx
  rules:
  - host: webapp.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: secure-app
            port:
              number: 8443
```

Without upstream TLS, the egress mTLS policy has TLS settings but no TLS connection to apply them to. NGINX then typically sends plain HTTP to an HTTPS upstream port.

{{< call-out class="note" >}}

For Ingress, `egressMTLS` configures how NGINX uses TLS when connecting to the upstream. It doesn't decide whether the upstream connection uses TLS. Configure that separately, for example with `nginx.org/ssl-services` or `nginx.org/grpc-services`.

{{< /call-out >}}

## Mergeable Ingress behavior

For mergeable Ingress:

- Policies on the master apply to inherited minion configuration.
- Policies on the minion override policies of the same type from the master.

This matches the general expectation that a more specific resource overrides a broader one.

For `egressMTLS`, there is one extra detail:

- The master or standard Ingress policy applies at server scope.
- The minion override applies at location scope, so the minion can replace the value set by the master.

## What's next

Learn about [policy precedence and override rules]({{< ref "/nic/configuration/policy-resource/precedence-and-overrides.md" >}}).
