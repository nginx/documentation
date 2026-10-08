---
title: Session Persistence
weight: 1100
toc: true
f5-content-type: how-to
f5-product: NGINX Gateway Fabric
f5-docs:
---

Learn how to configure session persistence using NGINX Gateway Fabric.

## Overview

In this guide, you’ll learn how to configure session persistence for your application. Session persistence ensures that multiple requests from the same client are consistently routed to the same backend Pod. This is useful when your application maintains in-memory state (for example, shopping carts or user sessions). NGINX Gateway Fabric supports cookie-based session persistence for both NGINX Open Source and NGINX Plus, configured using the `sessionPersistence` field directly on `HTTPRoute` and `GRPCRoute` resources.

In this guide, you will deploy two applications:

- An application configured with cookie-based session persistence.
- A regular application with default load-balancing.

These applications will showcase the benefits of session persistence for stateful workloads.

The NGINX directive discussed in this guide is [`sticky cookie`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#sticky).

## Note

{{< call-out class="important" >}}Session Persistence is a Gateway API field from the experimental release channel and is subject to change.{{< /call-out >}}

{{< call-out class="warning" title="Deprecated" >}}The experimental `sessionPersistence` field on `HTTPRouteRule` and `GRPCRouteRule` is deprecated. [GEP-1619](https://gateway-api.sigs.k8s.io/geps/gep-1619/#deprecated-route-inline-and-backendtrafficpolicy-session-persistence) moves session persistence configuration to the [`Backend`](https://gateway-api.sigs.k8s.io/geps/gep-4894/) resource, and the route-level field will be removed once `Backend` session persistence reaches the Standard channel. Expect to migrate your routes to the new API in a future release.{{< /call-out >}}

## Before you begin

[Install]({{< ref "/ngf/install/nginx-plus.md" >}}) NGINX Gateway Fabric with experimental features enabled.

{{< include "/ngf/installation/install-gateway-api-experimental-features.md" >}}

## Setup

Create the `tea` and `latte` applications:

```yaml
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tea
spec:
  replicas: 2
  selector:
    matchLabels:
      app: tea
  template:
    metadata:
      labels:
        app: tea
    spec:
      containers:
      - name: tea
        image: nginxdemos/nginx-hello:plain-text
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: tea
spec:
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
    name: http
  selector:
    app: tea
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: latte
spec:
  replicas: 2
  selector:
    matchLabels:
      app: latte
  template:
    metadata:
      labels:
        app: latte
    spec:
      containers:
      - name: latte
        image: nginxdemos/nginx-hello:plain-text
        ports:
        - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: latte
spec:
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
    name: http
  selector:
    app: latte
EOF
```

This creates two Service resources and multiple Pods in the default namespace. The multiple replicas are needed to demonstrate stickiness to backend Pods.

```shell
kubectl get all -o wide
```

```text
NAME                                 READY   STATUS    RESTARTS   AGE     IP            NODE                 NOMINATED NODE   READINESS GATES
pod/latte-d5f64f67f-9t2j5            1/1     Running   0          3h19m   10.244.0.96   kind-control-plane   <none>           <none>
pod/latte-d5f64f67f-drwc6            1/1     Running   0          3h19m   10.244.0.98   kind-control-plane   <none>           <none>
pod/tea-859766c68c-cnb8n             1/1     Running   0          3h19m   10.244.0.93   kind-control-plane   <none>           <none>
pod/tea-859766c68c-kttkb             1/1     Running   0          3h19m   10.244.0.97   kind-control-plane   <none>           <none>

NAME                    TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE     SELECTOR
service/latte           ClusterIP   10.96.42.39    <none>        80/TCP    3h19m   app=latte
service/tea             ClusterIP   10.96.81.103   <none>        80/TCP    3h19m   app=tea
```

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
      hostname: "*.example.com"
EOF
```

After creating the Gateway resource, NGINX Gateway Fabric will provision an NGINX Pod and Service fronting it to route traffic. Verify the gateway is created:

```shell
kubectl describe gateways.gateway.networking.k8s.io gateway
```

Verify the status is `Accepted`:

```text
Status:
  Addresses:
    Type:   IPAddress
    Value:  10.96.36.219
  Conditions:
    Last Transition Time:  2026-01-09T05:40:37Z
    Message:               The Gateway is accepted
    Observed Generation:   1
    Reason:                Accepted
    Status:                True
    Type:                  Accepted
    Last Transition Time:  2026-01-09T05:40:37Z
    Message:               The Gateway is programmed
    Observed Generation:   1
    Reason:                Programmed
    Status:                True
    Type:                  Programmed
```

Save the public IP address and port(s) of the Gateway into shell variables:

```text
GW_IP=XXX.YYY.ZZZ.III
GW_PORT=<port number>
```

{{< call-out class="note" >}}In a production environment, you should have a DNS record for the external IP address that is exposed, and it should refer to the hostname that the gateway will forward for.{{< /call-out >}}

## Configure cookie-based session persistence

You can configure session persistence by specifying the `sessionPersistence` field on an `HTTPRouteRule` or `GRPCRouteRule`. This configuration is translated to the `sticky cookie` directive on the NGINX data plane. In this guide, you’ll create a `tea` HTTPRoute with `sessionPersistence` configured at the rule level and then verify how traffic behaves when the route has multiple backend Pods.

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: tea
spec:
  parentRefs:
  - name: gateway
    sectionName: http
  hostnames:
  - "cafe.example.com"
  rules:
  - matches:
    - path:
        type: Exact
        value: /tea
    backendRefs:
    - name: tea
      port: 80
    sessionPersistence:
      sessionName: "cookie-tea"
      type: Cookie
      absoluteTimeout: 24h
      cookieConfig:
        lifetimeType: Permanent
EOF
```

Verify the `tea` HTTPRoute is `Accepted`:

```text
Status:
  Parents:
    Conditions:
      Last Transition Time:  2025-12-10T00:15:12Z
      Message:               The Route is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
      Last Transition Time:  2025-12-10T00:15:12Z
      Message:               All references are resolved
      Observed Generation:   1
      Reason:                ResolvedRefs
      Status:                True
      Type:                  ResolvedRefs
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
```

Next, verify that the tea upstream has a sticky cookie directive configured, which is responsible for issuing the session cookie and its attributes. The `sticky cookie` directive’s attributes are derived from the `sessionPersistence` configuration, such as the expiry (24h) and the route path (`/tea`). Inspect the NGINX configuration with:

```shell
kubectl exec -it deployments/gateway-nginx -- nginx -T
```

```text
upstream default_tea_80_tea_default_0 {
    random two least_conn;
    zone default_tea_80_tea_default_0 1m;
    sticky cookie cookie-tea expires=24h path=/tea;
    state /var/lib/nginx/state/default_tea_80.conf;
}
```

In this example, the `tea` `Service` has two backend Pods with IPs `10.244.0.93` and `10.244.0.97`. We’ll send five requests to the `/tea` endpoint and observe that all responses are served by the same backend Pod, demonstrating cookie-based session persistence.

First, send a request to `/tea` and store the session cookie:

```shell
curl -v -c /tmp/tea-cookies.txt \
  -H "Host: cafe.example.com" \
  http://localhost:8080/tea
```

You’ll see a cookie being set, for example:

```text
* Added cookie cookie-tea="2878e97a4c7a8406b791aa0bd0b2f145" for domain cafe.example.com, path /tea, expire 1765417195
< Set-Cookie: cookie-tea=2878e97a4c7a8406b791aa0bd0b2f145; expires=Thu, 11-Dec-25 01:39:55 GMT; max-age=86400; path=/tea
```

Next, send five requests using the stored cookie:

```shell
for i in $(seq 5); do
  echo "Request #$i"
  curl -s -b /tmp/tea-cookies.txt \
    -H "Host: cafe.example.com" \
    http://localhost:8080/tea \
    | grep -E 'Server (address|name)'
  echo
done
```

All responses are served by the same backend Pod, `tea-859766c68c-cnb8n` with IP `10.244.0.93:8080`, confirming session persistence:

```text
Request #1
Server address: 10.244.0.93:8080
Server name: tea-859766c68c-cnb8n

Request #2
Server address: 10.244.0.93:8080
Server name: tea-859766c68c-cnb8n

Request #3
Server address: 10.244.0.93:8080
Server name: tea-859766c68c-cnb8n

Request #4
Server address: 10.244.0.93:8080
Server name: tea-859766c68c-cnb8n

Request #5
Server address: 10.244.0.93:8080
Server name: tea-859766c68c-cnb8n
```

## Regular application

We’ll create routing rules for the `latte` application without any session affinity or persistence settings and then verify how the traffic behaves.

Let’s create the `latte` HTTPRoute:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: latte
spec:
  parentRefs:
  - name: gateway
    sectionName: http
  hostnames:
  - "cafe.example.com"
  rules:
  - matches:
    - path:
        type: Exact
        value: /latte
    backendRefs:
    - name: latte
      port: 80
EOF
```

Verify the NGINX configuration:

```shell
kubectl exec -it deployments/gateway -- nginx -T
```

```text
upstream default_latte_80 {
    random two least_conn;
    zone default_latte_80 1m;
    state /var/lib/nginx/state/default_latte_80.conf;
}
```

In this example, the `latte` Service currently has two backend Pods with IPs `10.244.0.96` and `10.244.0.98`. We’ll send five requests to the `/latte` endpoint and observe which backend Pod serves each response to understand how a regular backend behaves without any session affinity or persistence configured.

```shell
for i in $(seq 5); do
  echo "Request #$i"
  curl -s -H "Host: cafe.example.com" \
    http://localhost:8080/latte \
    | grep -E 'Server (address|name)'
  echo
done
```

You will see responses coming from both backend Pods, for example:

```text
Request #1
Server address: 10.244.0.98:8080
Server name: latte-d5f64f67f-drwc6

Request #2
Server address: 10.244.0.96:8080
Server name: latte-d5f64f67f-9t2j5

Request #3
Server address: 10.244.0.98:8080
Server name: latte-d5f64f67f-drwc6

Request #4
Server address: 10.244.0.98:8080
Server name: latte-d5f64f67f-drwc6

Request #5
Server address: 10.244.0.96:8080
Server name: latte-d5f64f67f-9t2j5
```

Because there is no session persistence configured for `latte`, traffic is distributed across both backend Pods according to the default load-balancing method, and requests from the same client are not guaranteed to hit the same Pod.

## Further reading

- [Session Persistence](https://gateway-api.sigs.k8s.io/reference/api-spec/main/spec/?h=sessionpersistence#sessionpersistence).
- [API reference]({{< ref "/ngf/reference/api.md" >}}): all configuration fields for the `UpstreamSettingsPolicy` API.