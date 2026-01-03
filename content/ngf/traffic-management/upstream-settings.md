---
title: Upstream Settings Policy API
weight: 900
toc: true
type: how-to
nd-product: FABRIC
nd-docs: DOCS-1845
---

Learn how to use the `UpstreamSettingsPolicy` API.

## Overview

The `UpstreamSettingsPolicy` API allows Application Developers to configure the behavior of a connection between NGINX and the upstream applications.

The settings in `UpstreamSettingsPolicy` correspond to the following NGINX directives:

- [`zone`](<https://nginx.org/en/docs/http/ngx_http_upstream_module.html#zone>)
- [`keepalive`](<https://nginx.org/en/docs/http/ngx_http_upstream_module.html#keepalive>)
- [`keepalive_requests`](<https://nginx.org/en/docs/http/ngx_http_upstream_module.html#keepalive_requests>)
- [`keepalive_time`](<https://nginx.org/en/docs/http/ngx_http_upstream_module.html#keepalive_time>)
- [`keepalive_timeout`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#keepalive_timeout)
- [`random`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#random)
- [`least_conn`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#least_conn)
- [`least_time`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#least_time)
- [`upstream`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#upstream)
- [`ip_hash`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#ip_hash)
- [`hash`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#hash)
- [`variables`](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#variables)

`UpstreamSettingsPolicy` is a [Direct Policy Attachment](https://gateway-api.sigs.k8s.io/reference/policy-attachment/) that can be applied to one or more services in the same namespace as the policy.
`UpstreamSettingsPolicies` can only be applied to HTTP or gRPC services, in other words, services that are referenced by an HTTPRoute or GRPCRoute.

See the [custom policies]({{< ref "/ngf/overview/custom-policies.md" >}}) document for more information on policies.

This guide will show you how to use the `UpstreamSettingsPolicy` API to configure the load balancing method, upstream zone size and keepalives for your applications.

For all the possible configuration options for `UpstreamSettingsPolicy`, see the [API reference]({{< ref "/ngf/reference/api.md" >}}).

---

## Before you begin

- [Install]({{< ref "/ngf/install/" >}}) NGINX Gateway Fabric.

## Setup

Create the `coffee` and `tea` example applications:

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
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: tea
spec:
  replicas: 1
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
EOF
```

This will create two services and pods in the default namespace:

```shell
kubectl get svc,pod -n default
```

```text
NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)   AGE
service/coffee       ClusterIP   10.244.0.14     <none>        80/TCP    23h
service/tea          ClusterIP   10.244.0.15     <none>        80/TCP    23h

NAME                          READY   STATUS    RESTARTS   AGE
pod/coffee-676c9f8944-n9g6n   1/1     Running   0          23h
pod/tea-6fbfdcb95d-cf84d      1/1     Running   0          23h
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

After creating the Gateway resource, NGINX Gateway Fabric will provision an NGINX Pod and Service fronting it to route traffic.

Save the public IP address and port of the NGINX Service into shell variables:

```text
GW_IP=XXX.YYY.ZZZ.III
GW_PORT=<port number>
```

Lookup the name of the NGINX pod and save into shell variable:

```text
NGINX_POD_NAME=<NGINX Pod>
```

{{< call-out "note" >}}In a production environment, you should have a DNS record for the external IP address that is exposed, and it should refer to the hostname that the gateway will forward for.{{< /call-out >}}

Create HTTPRoutes for the `coffee` and `tea` applications:

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
            type: Exact
            value: /coffee
      backendRefs:
        - name: coffee
          port: 80
---
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
EOF
```

Test the configuration:

You can send traffic to the `coffee` and `tea` applications using the external IP address and port for the NGINX Service.

Send a request to `coffee`:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee
```

This request should receive a response from the `coffee` Pod:

```text
Server address: 10.244.0.9:8080
Server name: coffee-76c7c85bbd-cf8nz
```

Send a request to `tea`:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/tea
 ```

This request should receive a response from the `tea` Pod:

```text
Server address: 10.244.0.9:8080
Server name: tea-76c7c85bbd-cf8nz
```

---

## Configure load balancing methods

You can use `UpstreamSettingsPolicy` to configure the load balancing method for the `coffee` and `tea` applications. In this example, the `coffee` service uses the `random two least_time=header` method, and the `tea` service uses the `hash consistent` method with `$upstream_addr` as the hash key. 

{{< call-out "note" >}} You need to specify an NGINX [variable](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#variables) as `hashMethodKey` when using load balancing methods `hash` and `hash consistent` .{{< /call-out >}}

Create the following `UpstreamSettingsPolicy` resources:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: UpstreamSettingsPolicy
metadata:
  name: lb-method
spec:
  targetRefs:
  - group: core
    kind: Service
    name: coffee
  loadBalancingMethod: "random two least_time=header"
EOF
```

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: UpstreamSettingsPolicy
metadata:
  name: lb-method-hash
spec:
  targetRefs:
  - group: core
    kind: Service
    name: tea
  loadBalancingMethod: "hash consistent"
  hashMethodKey: "$upstream_addr"
EOF
```

These two `UpstreamSettingsPolicy` resources target the `coffee` and `tea` Services and configure different load balancing methods for their upstreams. Verify that the `UpstreamSettingsPolicies` are `Accepted`:

```shell
kubectl describe upstreamsettingspolicies.gateway.nginx.org lb-method
```

You should see the following status:

```text
Status:
  Ancestors:
    Ancestor Ref:
      Group:      gateway.networking.k8s.io
      Kind:       Gateway
      Name:       gateway
      Namespace:  default
    Conditions:
      Last Transition Time:  2025-12-09T20:41:55Z
      Message:               The Policy is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
```

The `lb-method-hash` policy should show the same `Accepted` condition.

Next, verify that the policies have been applied to the `coffee` and `tea` upstreams by inspecting the NGINX configuration:

```shell
kubectl exec -it -n <NGINX-pod-namespace> $NGINX_POD_NAME -- nginx -T
```

You should see the `random two least_time=header` directive on the `coffee` upstreams and `hash $upstream_addr consistent` in the `tea` upstream:

```text
upstream default_coffee_80 {
    random two least_time=header;
    zone default_coffee_80 1m;
    state /var/lib/nginx/state/default_coffee_80.conf;
    keepAlive 16;
}

upstream default_tea_80 {
    hash $upstream_addr consistent;
    zone default_tea_80 1m;
    state /var/lib/nginx/state/default_tea_80.conf;
    keepAlive 16;
}
```

{{< call-out "note" >}}
NGINX Open Source supports the following load-balancing methods: `round_robin`, `least_conn`, `ip_hash`, `hash`, `hash consistent`, `random`, `random two`, and `random two least_conn`.
NGINX Plus supports all of the methods available in NGINX Open Source, and adds the following methods: `random two least_time=header`, `random two least_time=last_byte`, `least_time header`, `least_time last_byte`, `least_time header inflight`, and `least_time last_byte inflight`.
{{< /call-out >}}

## Configure upstream zone size

To set the upstream zone size to 1 megabyte for both the `coffee` and `tea` services, create the following `UpstreamSettingsPolicy`:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: UpstreamSettingsPolicy
metadata:
  name: 1m-zone-size
spec:
  targetRefs:
  - group: core
    kind: Service
    name: tea
  - group: core
    kind: Service
    name: coffee
  zoneSize: 1m
EOF
```

This `UpstreamSettingsPolicy` targets both the `coffee` and `tea` services we created in the setup by specifying both services in the `targetRefs` field. It limits the upstream zone size of the `coffee` and `tea` services to 1 megabyte.

Verify that the `UpstreamSettingsPolicy` is Accepted:

```shell
kubectl describe upstreamsettingspolicies.gateway.nginx.org 1m-zone-size
```

You should see the following status:

```text
Status:
  Ancestors:
    Ancestor Ref:
      Group:      gateway.networking.k8s.io
      Kind:       Gateway
      Name:       gateway
      Namespace:  default
    Conditions:
      Last Transition Time:  2025-01-07T20:06:55Z
      Message:               Policy is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
Events:                      <none>
```

Next, verify that the policy has been applied to the `coffee` and `tea` upstreams by inspecting the NGINX configuration:

```shell
kubectl exec -it -n <NGINX-pod-namespace> $NGINX_POD_NAME -- nginx -T
```

You should see the `zone` directive in the `coffee` and `tea` upstreams both specify the size `1m`:

```text
upstream default_coffee_80 {
    random two least_conn;
    zone default_coffee_80 1m;

    server 10.244.0.14:8080;
    keepAlive 16;
}

upstream default_tea_80 {
    random two least_conn;
    zone default_tea_80 1m;

    server 10.244.0.15:8080;
    keepAlive 16;
}
```

## Enable keepalive connections

By default, the `keepAlive` directive is enabled with a value of 16. You can override this value or disable `keepAlive` entirely by configuring an `UpstreamSettingsPolicy`. To disable keepalive, set the connections field to 0.

The following example creates an `UpstreamSettingsPolicy` that configures keepalive connections for the `coffee` Service with a value of 32:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: UpstreamSettingsPolicy
metadata:
  name: upstream-keepalives
spec:
  targetRefs:
  - group: core
    kind: Service
    name: coffee
  keepAlive:
    connections: 32
EOF
```

This `UpstreamSettingsPolicy` targets the `coffee` service in the `targetRefs` field. It sets the number of keepalive connections to 32, which activates the cache for connections to the service's pods and sets the maximum number of idle connections to 32.

Verify that the `UpstreamSettingsPolicy` is Accepted:

```shell
kubectl describe upstreamsettingspolicies.gateway.nginx.org upstream-keepalives
```

You should see the following status:

```text
Status:
  Ancestors:
    Ancestor Ref:
      Group:      gateway.networking.k8s.io
      Kind:       Gateway
      Name:       gateway
      Namespace:  default
    Conditions:
      Last Transition Time:  2025-01-07T20:06:55Z
      Message:               Policy is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
Events:                      <none>
```

Next, verify that the policy has been applied to the `coffee` upstreams, by inspecting the NGINX configuration:

```shell
kubectl exec -it -n <NGINX-pod-namespace> $NGINX_POD_NAME -- nginx -T
```

You should see that the `coffee` upstream has the `keepalive` directive set to 32:

```text
upstream default_coffee_80 {
    random two least_conn;
    zone default_coffee_80 1m;

    server 10.244.0.14:8080;
    keepalive 32;
}
```

To disable `keepAlive` directive lets create an `UpstreamSettingsPolicy` targeting the `tea` service with value 0:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: UpstreamSettingsPolicy
metadata:
  name: upstream-unset-keepAlive
spec:
  targetRefs:
  - group: core
    kind: Service
    name: tea
  keepAlive:
    connections: 0
EOF
```

Verify that the `UpstreamSettingsPolicy` is Accepted:

```shell
kubectl describe upstreamsettingspolicies.gateway.nginx.org upstream-unset-keepAlive
```

You should see the following status:

```text
Status:
  Ancestors:
    Ancestor Ref:
      Group:      gateway.networking.k8s.io
      Kind:       Gateway
      Name:       gateway
      Namespace:  default
    Conditions:
      Last Transition Time:  2026-01-03T00:35:45Z
      Message:               The Policy is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
```

Next, verify that the policy has been applied to the `tea` upstream, by inspecting the NGINX configuration:

```shell
kubectl exec -it -n <NGINX-pod-namespace> $NGINX_POD_NAME -- nginx -T

```text
upstream default_tea_80 {
    random two least_conn;
    zone default_tea_80 1m;

    server 10.244.0.15:8080;
}
```

---

## Further reading

- [Custom policies]({{< ref "/ngf/overview/custom-policies.md" >}}): learn about how NGINX Gateway Fabric custom policies work.
- [API reference]({{< ref "/ngf/reference/api.md" >}}): all configuration fields for the `UpstreamSettingsPolicy` API.
