---
title: Policy specification
weight: 200
toc: true
f5-content-type: concept
f5-product: NGINX Ingress Controller
f5-description: The Policy resource specification, supported policy types, and the rule that a Policy can define only one policy type.
f5-summary: >
  Describes the `.spec` of a Policy resource, the full list of supported policy types, and where you can apply each type.
  Explains the rule that a single Policy resource can define only one policy type, and how to combine multiple policies when you need more than one behavior.
f5-keywords: "nginx ingress controller, nic, policy resource, policy specification, policy types, kubernetes custom resource"
f5-audience: developer, operator
---

A `Policy` resource defines exactly one policy type under `.spec`.

Supported policy types are:

- `accessControl`
- `rateLimit`
- `apiKey`
- `basicAuth`
- `jwt`
- `ingressMTLS`
- `egressMTLS`
- `oidc`
- `oidcNative`
- `cache`
- `cors`
- `waf`
- `externalAuth`
- `hsts`

{{% table %}}

| Policy type | Description | VirtualServer / VirtualServerRoute | Ingress |
| --- | --- | --- | --- |
| [`accessControl`]({{< ref "/nic/configuration/policy-resource/policy-reference.md#accesscontrol" >}}) | Allows or denies requests based on the client IP address. | Yes | Yes, with `nginx.org/policies` |
| [`cors`]({{< ref "/nic/configuration/policy-resource/policy-reference.md#cors" >}}) | Configures Cross-Origin Resource Sharing (CORS) headers. | Yes | Yes, with `nginx.org/policies` |
| [`egressMTLS`]({{< ref "/nic/configuration/policy-resource/policy-reference.md#egressmtls" >}}) | Configures mutual TLS (mTLS) authentication and certificate verification for upstream connections. | Yes | Yes, with `nginx.org/policies` |
| [`ingressMTLS`]({{< ref "/nic/configuration/policy-resource/policy-reference.md#ingressmtls" >}}) | Configures mTLS client certificate verification. | Yes | Yes, with `nginx.org/policies` |
| [`waf`]({{< ref "/nic/configuration/policy-resource/policy-reference.md#waf" >}}) | Configures WAF and log configuration policies for [NGINX AppProtect]({{< ref "/nic/integrations/app-protect-waf/configuration.md" >}}). | Yes | Yes, with `nginx.com/policies` |
| [`externalAuth`]({{< ref "/nic/configuration/policy-resource/policy-reference.md#externalauth" >}}) | Authenticates client requests using an external authentication server. | Yes | Yes, with `nginx.org/policies` |
| [`rateLimit`]({{< ref "/nic/configuration/policy-resource/policy-reference.md#ratelimit" >}}) | Controls the request-processing rate for a defined key. | Yes | No |
| [`apiKey`]({{< ref "/nic/configuration/policy-resource/policy-reference.md#apikey" >}}) | Authorizes requests that include a valid API key in a specified header or query parameter. | Yes | No |
| [`basicAuth`]({{< ref "/nic/configuration/policy-resource/policy-reference.md#basicauth" >}}) | Authenticates client requests using HTTP Basic authentication credentials. | Yes | No |
| [`jwt`]({{< ref "/nic/configuration/policy-resource/policy-reference.md#jwt-using-a-local-kubernetes-secret" >}}) | Authenticates client requests using JSON Web Tokens (JWT). Requires NGINX Plus. | Yes | No |
| [`oidc`]({{< ref "/nic/configuration/policy-resource/policy-reference.md#oidc" >}}) | Configures NGINX Plus as a relying party for OpenID Connect (OIDC) authentication. | Yes | No |
| [`oidcNative`]({{< ref "/nic/configuration/policy-resource/policy-reference.md#oidcnative" >}}) | Configures NGINX Plus as a relying party for OIDC authentication using the built-in native module. | Yes | Yes, with `nginx.com/policies` |
| [`cache`]({{< ref "/nic/configuration/policy-resource/policy-reference.md#cache" >}}) | Configures proxy caching for serving cached content. | Yes | No |
| [`hsts`]({{< ref "/nic/configuration/policy-resource/policy-reference.md#hsts" >}}) | Configures [HTTP Strict Transport Security](https://www.nginx.com/blog/http-strict-transport-security-hsts-and-nginx/) (HSTS) to enforce secure connections to the server. | Yes | No |

{{% /table %}}

{{< call-out "note" >}}

NGINX Ingress Controller added Policy resource support for Ingress objects through the [`nginx.org/policies`]({{< ref "/nic/configuration/ingress-resources/advanced-configuration-with-annotations.md" >}}) annotation in v5.4.0.

{{< /call-out >}}

## Important rule: one policy type per resource

A `Policy` resource must define exactly one policy type under `.spec`. If you need multiple behaviors, create multiple policies and reference them together.

The following example is valid:

```yaml
apiVersion: k8s.nginx.org/v1
kind: Policy
metadata:
  name: allow-localhost
spec:
  accessControl:
    allow:
    - 10.0.0.0/8
```

The following example is **not** valid, because it defines two policy types in the same resource:

```yaml
apiVersion: k8s.nginx.org/v1
kind: Policy
metadata:
  name: invalid-policy
spec:
  accessControl:
    allow:
    - 10.0.0.0/8
  cors:
    allowOrigin:
    - https://example.com
```

## What's next

Learn how to [apply policies to resources]({{< ref "/nic/configuration/policy-resource/applying-policies.md" >}}).
