---
title: Apply policies to resources
weight: 300
toc: true
f5-content-type: how-to
f5-product: NGINX Ingress Controller
f5-description: How to attach Policy resources to VirtualServer, VirtualServerRoute, and Ingress resources.
f5-summary: >
  Shows how to reference a Policy resource from the `policies` field on VirtualServer and VirtualServerRoute resources, and from annotations on Ingress resources.
  Includes example YAML for each resource type.
f5-keywords: "nginx ingress controller, nic, apply policy, attach policy, virtualserver, virtualserverroute, ingress, nginx.org/policies, nginx.com/policies"
f5-audience: developer, operator
---

You can reference policies from VirtualServer, VirtualServerRoute, and Ingress resources. How you attach a policy depends on the resource type.

## VirtualServer

You can attach policies at:

- `spec.policies` for server-wide behavior
- `spec.routes[].policies` for route-specific behavior

Example:

```yaml
apiVersion: k8s.nginx.org/v1
kind: VirtualServer
metadata:
  name: cafe
spec:
  host: cafe.example.com
  policies:
  - name: access-policy
  upstreams:
  - name: coffee
    service: coffee-svc
    port: 80
  routes:
  - path: /coffee
    policies:
    - name: route-cors-policy
    action:
      pass: coffee
```

## VirtualServerRoute

You can attach policies at:

- `spec.subroutes[].policies`

Example:

```yaml
apiVersion: k8s.nginx.org/v1
kind: VirtualServerRoute
metadata:
  name: tea
spec:
  host: cafe.example.com
  upstreams:
  - name: tea
    service: tea-svc
    port: 80
  subroutes:
  - path: /tea
    policies:
    - name: subroute-policy
    action:
      pass: tea
```

## Ingress

Ingress uses annotations instead of a `policies` field.

Supported annotations are:

- `nginx.org/policies`
- `nginx.com/policies`

Example:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: webapp
  annotations:
    nginx.org/policies: access-policy,cors-policy
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
            name: webapp
            port:
              number: 80
```

## What's next

Learn about [ingress-specific policy behavior]({{< ref "/nic/configuration/policy-resource/ingress-specific-behavior.md" >}}).
