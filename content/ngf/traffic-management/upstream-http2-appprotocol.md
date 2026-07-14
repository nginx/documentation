---
title: Configure upstream HTTP/2 through Service appProtocol
toc: true
weight: 1600
f5-content-type: how-to
f5-product: FABRIC
f5-docs: DOCS-0000
description: Configure NGINX Gateway Fabric to use HTTP/2 for upstream connections by setting appProtocol to kubernetes.io/h2c on a Kubernetes Service port.
f5-keywords: NGINX Gateway Fabric, HTTP/2, upstream HTTP/2, appProtocol, kubernetes.io/h2c, proxy_http_version, h2c, upstream connections, Service appProtocol, Gateway API, HTTPRoute, GRPCRoute
f5-summary: This guide describes how to configure NGINX Gateway Fabric to proxy requests to upstream services over HTTP/2 by setting appProtocol to kubernetes.io/h2c on a Kubernetes Service port. Using HTTP/2 for upstream connections enables multiplexing and reduces latency for services that support it. This guide is for operators and developers who have NGINX Gateway Fabric installed and are familiar with Kubernetes Services and the Gateway API.
---

Learn how to configure NGINX Gateway Fabric to use HTTP/2 when proxying requests to upstream services using the Service port's `appProtocol` field.

## Overview

The appProtocol field on a Kubernetes Service port provides a way to specify an application protocol. Controllers such as NGINX Gateway Fabric may use this field to enable protocol-specific functionality for supported protocols. For more information, view the official [Kubernetes Service Documentation](https://kubernetes.io/docs/concepts/services-networking/service/#application-protocol).

When a Kubernetes Service port has `appProtocol` set to `kubernetes.io/h2c`, NGINX Gateway Fabric configures the corresponding NGINX location to use HTTP/2 for upstream connections by setting the [`proxy_http_version`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_http_version) directive to `2` in the NGINX configuration.

## Before you begin

- [Install]({{< ref "/ngf/install/" >}}) NGINX Gateway Fabric.

## Set up

Create the **coffee** application in Kubernetes by copying and pasting the following block into your terminal:

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
    appProtocol: kubernetes.io/h2c
  selector:
    app: coffee
EOF
```

Setting `appProtocol: kubernetes.io/h2c` on the Service port tells NGINX Gateway Fabric to use HTTP/2 for upstream connections to this Service.

Run the following command to verify the resources were created:

```shell
kubectl get pods,svc
```

Your output should include a **coffee** pod and the **coffee** service:

```text
NAME                          READY   STATUS    RESTARTS   AGE
pod/coffee-654ddf664b-q28ps   1/1     Running   0          10s

NAME                 TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE
service/coffee       ClusterIP   10.96.30.58   <none>        80/TCP    10s
```

## Create the Gateway API resources

Create a Gateway:

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

Verify the gateway is created:

```shell
kubectl describe gateways.gateway.networking.k8s.io gateway
```

Verify the status is `Accepted`:

```text
Status:
  Addresses:
    Type:                  IPAddress
    Value:                 10.96.69.11
  Attached Listener Sets:  0
  Conditions:
    Last Transition Time:  2026-06-03T05:21:38Z
    Message:               The Gateway is accepted
    Observed Generation:   1
    Reason:                Accepted
    Status:                True
    Type:                  Accepted
    Last Transition Time:  2026-06-03T05:21:38Z
    Message:               The Gateway is programmed
    Observed Generation:   1
    Reason:                Programmed
    Status:                True
    Type:                  Programmed
```

Create the **coffee** HTTPRoute:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: coffee
spec:
  parentRefs:
  - name: gateway
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

## Verify the NGINX configuration

Inspect the NGINX configuration to confirm that `proxy_http_version 2` is set for the **coffee** location:

```shell
kubectl exec -it deployments/gateway-nginx -- nginx -T
```

Look for the location block that routes traffic to the **coffee** upstream. It should contain `proxy_http_version 2`:

```nginx
location /coffee {
    ...
    proxy_http_version 2;
    proxy_pass http://default_coffee_80;
    ...
}
```

## Important Notes

- `kubernetes.io/h2c` is supported on HTTPRoutes and GRPCRoutes. It isn't supported on TLSRoutes.
- When NGINX Gateway Fabric detects `kubernetes.io/h2c`, it also omits the `proxy_set_header Upgrade` and `proxy_set_header Connection` directives from the location block, because those headers are HTTP/1.1-specific and aren't used in HTTP/2 connections.

### Other supported appProtocols

In addition to the `kubernetes.io/h2c` `appProtocol`, NGINX Gateway Fabric recognizes `kubernetes.io/ws` and `kubernetes.io/wss` as described in [RFC 6455](https://www.rfc-editor.org/info/rfc6455/).

These `appProtocols` reference WebSocket over cleartext and WebSocket over TLS respectively and are supported natively by our default NGINX configuration. `kubernetes.io/ws` is only supported on HTTPRoutes and `kubernetes.io/wss` is only supported on TLSRoutes or on HTTPRoutes with an associated BackendTLSPolicy.

If an `appProtocol` on a Service port is referenced by an unsupported Route type, that backendRef will be considered invalid and status will be written to the Route.

NGINX Gateway Fabric is conformant to the information in [GEP-1911](https://gateway-api.sigs.k8s.io/geps/gep-1911/), which should be referenced for more detailed information.

## Troubleshooting

- For NGINX to set `proxy_http_version 2` for a location, all valid backend references in the routing rule must have `appProtocol: kubernetes.io/h2c` set on their Service ports. If any valid backend doesn't use `kubernetes.io/h2c`, NGINX falls back to the default HTTP/1.1.

## See also

- [Backend Protocol](https://gateway-api.sigs.k8s.io/guides/user-guides/backend-protocol/): the Gateway API guide for the `appProtocol` field.
- [GEP-1911](https://gateway-api.sigs.k8s.io/geps/gep-1911/): for more details on how NGINX Gateway Fabric interacts with `appProtocols`.
- [proxy_http_version NGINX directive](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_http_version).