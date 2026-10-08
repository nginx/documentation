---
title: Define IP address allowlists and denylists
description: Create an AccessPolicy to define IP address allowlists or denylists for a Gateway, HTTPRoute, or GRPCRoute.
weight: 800
toc: true
f5-content-type: how-to
f5-product: F5 NGINX Gateway Fabric
f5-keywords: NGINX Gateway Fabric, AccessPolicy, access control, IP allowlist, IP denylist, allow list, deny list, CIDR, client IP address, Gateway API, Kubernetes
f5-summary: >
  Create an AccessPolicy that lists client IP addresses and CIDR ranges, and attach it to a Gateway, HTTPRoute, or GRPCRoute.
  AccessPolicy is the NGINX Gateway Fabric custom policy for IP-based access control.
  This guide covers the AccessPolicy fields, the validation rules, and how to check the policy status.
f5-audience: operator
---

## Overview

Use an AccessPolicy to define an IP address allowlist or denylist in F5 NGINX Gateway Fabric. An AccessPolicy holds a list of rules. Each rule names a client IP address or a CIDR range. The `action` field sets whether the rules form an allowlist or a denylist.

AccessPolicy is an [inherited policy attachment](https://gateway-api.sigs.k8s.io/reference/policy-attachment/). You can attach an AccessPolicy to a Gateway, an HTTPRoute, or a GRPCRoute in the same namespace as the policy.

In this guide, you create an AccessPolicy for a Gateway and an AccessPolicy for an HTTPRoute. Then you check the status of each policy and its target. The guide also explains how NGINX combines the rules from the two policies.

## Before you begin

- [Install]({{< ref "/ngf/install/_index.md" >}}) NGINX Gateway Fabric.

## Deploy an example application

1. Create the `coffee` Deployment and Service:

    ```yaml
    kubectl apply -f - <<EOF
    apiVersion: apps/v1
    kind: Deployment
    metadata:
      name: coffee
    spec:
      replicas: 1
      selector:
        matchLabels:
          app: coffee
      template:
        metadata:
          labels:
            app: coffee
        spec:
          containers:
          - name: coffee
            image: nginxdemos/nginx-hello:plain-text
            ports:
            - containerPort: 8080
    ---
    apiVersion: v1
    kind: Service
    metadata:
      name: coffee
    spec:
      ports:
      - port: 80
        targetPort: 8080
        protocol: TCP
        name: http
      selector:
        app: coffee
    EOF
    ```

1. Create a Gateway named `gateway`:

    ```yaml
    kubectl apply -f - <<EOF
    apiVersion: gateway.networking.k8s.io/v1
    kind: Gateway
    metadata:
      name: gateway
    spec:
      gatewayClassName: nginx
      listeners:
      - name: http
        port: 80
        protocol: HTTP
    EOF
    ```

1. Create an HTTPRoute named `coffee` that sends requests for `cafe.example.com/coffee` to the `coffee` Service:

    ```yaml
    kubectl apply -f - <<EOF
    apiVersion: gateway.networking.k8s.io/v1
    kind: HTTPRoute
    metadata:
      name: coffee
    spec:
      parentRefs:
      - name: gateway
        sectionName: http
      hostnames:
      - "cafe.example.com"
      rules:
      - matches:
        - path:
            type: PathPrefix
            value: /coffee
        backendRefs:
        - name: coffee
          port: 80
    EOF
    ```

## Create an AccessPolicy for a Gateway

Attach an AccessPolicy to a Gateway to set access rules for every route attached to that Gateway.

1. Create an AccessPolicy named `gateway-denylist` that targets the `gateway` Gateway:

    ```yaml
    kubectl apply -f - <<EOF
    apiVersion: gateway.nginx.org/v1alpha1
    kind: AccessPolicy
    metadata:
      name: gateway-denylist
    spec:
      targetRefs:
      - group: gateway.networking.k8s.io
        kind: Gateway
        name: gateway
      action: Deny
      rules:
      - name: blocked-range
        source:
          type: IPAddress
          ipAddress:
            address: 198.51.100.0/24
      - name: blocked-client
        source:
          type: IPAddress
          ipAddress:
            address: 203.0.113.7
    EOF
    ```

    This AccessPolicy defines a denylist with two rules. The first rule matches the `198.51.100.0/24` CIDR range. The second rule matches the single address `203.0.113.7`.

1. Check the status of the AccessPolicy:

    ```shell
    kubectl describe accesspolicies.gateway.nginx.org gateway-denylist
    ```

    Verify that the `Accepted` condition has the status `True`. The following sample output is truncated:

    ```text
    Status:
      Ancestors:
        Ancestor Ref:
          Group:      gateway.networking.k8s.io
          Kind:       Gateway
          Name:       gateway
          Namespace:  default
        Conditions:
          Message:               The Policy is accepted
          Observed Generation:   1
          Reason:                Accepted
          Status:                True
          Type:                  Accepted
        Controller Name:         gateway.nginx.org/nginx-gateway-controller
    ```

1. Check the status of the Gateway:

    ```shell
    kubectl describe gateways.gateway.networking.k8s.io gateway
    ```

    Look for the `AccessPolicyAffected` condition. This condition shows that a valid AccessPolicy targets the Gateway:

    ```text
    Status:
      Conditions:
        Message:               The AccessPolicy is applied to the resource
        Observed Generation:   1
        Reason:                PolicyAffected
        Status:                True
        Type:                  AccessPolicyAffected
    ```

## Create an AccessPolicy for a route

Attach an AccessPolicy to an HTTPRoute or a GRPCRoute to set access rules for one application.

1. Create an AccessPolicy named `coffee-allowlist` that targets the `coffee` HTTPRoute:

    ```yaml
    kubectl apply -f - <<EOF
    apiVersion: gateway.nginx.org/v1alpha1
    kind: AccessPolicy
    metadata:
      name: coffee-allowlist
    spec:
      targetRefs:
      - group: gateway.networking.k8s.io
        kind: HTTPRoute
        name: coffee
      action: Allow
      rules:
      - name: office-network
        source:
          type: IPAddress
          ipAddress:
            address: 192.0.2.0/24
      - name: office-network-ipv6
        source:
          type: IPAddress
          ipAddress:
            address: 2001:db8::/32
    EOF
    ```

    This AccessPolicy defines an allowlist with an IPv4 CIDR range and an IPv6 CIDR range.

1. Check the status of the AccessPolicy:

    ```shell
    kubectl describe accesspolicies.gateway.nginx.org coffee-allowlist
    ```

    Verify that the `Accepted` condition has the status `True`.

1. Check the status of the HTTPRoute:

    ```shell
    kubectl describe httproutes.gateway.networking.k8s.io coffee
    ```

    Look for the `AccessPolicyAffected` condition in the route status. The condition has the status `True` and the reason `PolicyAffected`.

## AccessPolicy fields

An AccessPolicy has the following fields in its `spec`:

- `targetRefs`: A list of 1 to 10 resources in the same namespace as the policy. Each entry has the group `gateway.networking.k8s.io` and the kind `Gateway`, `HTTPRoute`, or `GRPCRoute`. One AccessPolicy can't target a Gateway and a route at the same time.
- `action`: Set to `Allow` to define an allowlist, or `Deny` to define a denylist.
- `rules`: A list of 1 to 64 rules. Each rule has these fields:
  - `name`: A name that's unique in the policy. The name must be a lowercase DNS subdomain name of 1 to 63 characters, such as `office-network` or `rule.one`.
  - `source`: The request source for the rule. Set `type` to `IPAddress`, and set `ipAddress.address` to an IPv4 address, an IPv6 address, or a CIDR range. If you leave out `source`, the rule matches requests from any source.

More than one AccessPolicy can target the same resource. NGINX Gateway Fabric merges these policies and doesn't mark any of them as `Conflicted`.

## How NGINX applies the access rules

NGINX Gateway Fabric turns each AccessPolicy into NGINX `allow` and `deny` directives. NGINX checks a request against these rules in order and stops at the first match. When NGINX blocks a request, it returns a `403 Forbidden` response.

The `action` field also sets what happens to a request that matches no rule:

- `Allow`: NGINX blocks the request.
- `Deny`: NGINX passes the request.

A rule without a `source` matches every client. In an `Allow` policy, this rule passes all requests. In a `Deny` policy, this rule blocks all requests.

### Gateway and route policies

An AccessPolicy for a Gateway applies to every HTTPRoute and GRPCRoute attached to that Gateway. An AccessPolicy for a route applies only to that route. A route without its own AccessPolicy uses the Gateway rules. If the Gateway has no AccessPolicy either, the route accepts requests from all clients.

When a Gateway and a route both have AccessPolicies, NGINX Gateway Fabric combines them for that route:

- **Deny rules add up**: NGINX blocks a request that matches any Gateway or route Deny rule. A route policy can't override a Gateway Deny rule. This holds even when a route Allow rule lists the same address.
- **Route Allow rules narrow the Gateway Allow rules**: NGINX passes only the addresses that both the Gateway and route Allow rules include. A route Allow rule can't pass an address outside the Gateway Allow rules. If the route and Gateway Allow addresses don't overlap, NGINX blocks all requests to the route.
- **Allow rules from one level apply unchanged**: If only the Gateway has an Allow policy, the Gateway Allow rules apply to the route. If only the route has an Allow policy, the route Allow rules apply.
- **Deny rules come first**: NGINX checks every Deny rule before it checks the Allow rules.

When several AccessPolicies with the same `action` target one resource, NGINX Gateway Fabric merges all of their rules.

The following table shows the result for `cafe.example.com/coffee` after you create the two AccessPolicies in this guide. The `gateway-denylist` rules still apply to the `coffee` route.

| Client IP address | Result | Reason |
|---|---|---|
| `198.51.100.25` | Blocked | Matches a `gateway-denylist` rule |
| `192.0.2.10` | Passed | Matches a `coffee-allowlist` rule |
| `2001:db8::10` | Passed | Matches a `coffee-allowlist` rule |
| Any other address | Blocked | Matches no rule, and `coffee-allowlist` is an allowlist |

### Client IP address behind a proxy

NGINX compares the rules with the client IP address of each request. If a load balancer or proxy forwards the traffic, NGINX receives the IP address of that proxy instead. To match the rules against the original client address, set up `rewriteClientIP` in the NginxProxy resource. For the steps, see [Configure PROXY protocol and RewriteClientIP settings]({{< ref "/ngf/how-to/data-plane-configuration.md#configure-proxy-protocol-and-rewriteclientip-settings" >}}).

## Troubleshooting

### Kubernetes rejects the AccessPolicy

**Symptom**: `kubectl apply` returns an error, and Kubernetes doesn't create the AccessPolicy. The error includes one of these messages:

- `AccessRule` names must be unique
- Cannot mix `Gateway` kind with `HTTPRoute` or `GRPCRoute` kinds in `targetRefs`
- `TargetRef` Kind must be one of: `Gateway`, `HTTPRoute`, or `GRPCRoute`
- `TargetRef` Kind and Name combination must be unique
- `ipAddress` must be set when type is `IPAddress`

**Cause**: The AccessPolicy custom resource definition (CRD) checks the policy when you apply it. The policy breaks one of the rules in [AccessPolicy fields](#accesspolicy-fields).

**Fix**: Correct the field that the message names, and apply the AccessPolicy again. For example, to target a Gateway and a route, create two AccessPolicies.

### The AccessPolicy status is Invalid

**Symptom**: The AccessPolicy has an `Accepted` condition with the status `False` and the reason `Invalid`. The condition message includes the text "must be a valid IPv4/IPv6 address or CIDR range" and names the field, such as `spec.rules[0].source.ipAddress.address`. The target Gateway or route doesn't get the `AccessPolicyAffected` condition from this AccessPolicy.

**Cause**: A value in `ipAddress.address` isn't a valid IPv4 address, IPv6 address, or CIDR range.

**Fix**: Change the value to a valid address or CIDR range, such as `192.0.2.10` or `192.0.2.0/24`. Then apply the AccessPolicy again.

## References

For more information, see:

- [Custom policies]({{< ref "/ngf/overview/custom-policies.md" >}})
- [API reference]({{< ref "/ngf/reference/api.md" >}})
