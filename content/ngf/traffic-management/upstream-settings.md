---
title: Upstream Settings Policy API
weight: 1000
toc: true
f5-content-type: how-to
f5-product: NGINX Gateway Fabric
f5-docs: DOCS-1845
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
- [`health_check`](https://nginx.org/en/docs/http/ngx_http_upstream_hc_module.html#health_check) (NGINX Plus only)

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
kubectl get svc,pod
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

{{< call-out class="note" >}} You need to specify an NGINX [variable](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#variables) as `hashMethodKey` when using load balancing methods `hash` and `hash consistent` .{{< /call-out >}}

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
  hashMethodKey: "\$upstream_addr"
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
kubectl exec -it deployments/gateway-nginx -- nginx -T
```

You should see the `random two least_time=header` directive on the `coffee` upstreams and `hash $upstream_addr consistent` in the `tea` upstream:

```text
upstream default_coffee_80 {
    random two least_conn;
    zone default_coffee_80 1m;
    state /var/lib/nginx/state/default_coffee_80.conf;
}

upstream default_tea_80 {
    hash $upstream_addr consistent;
    zone default_tea_80 1m;
    state /var/lib/nginx/state/default_tea_80.conf;
}
```

{{< call-out class="note" >}}
NGINX Open Source supports the following load-balancing methods: `round_robin`, `least_conn`, `ip_hash`, `hash`, `hash consistent`, `random`, `random two`, `random two least_conn`, and `least_time`.
NGINX Plus supports all of the methods available in NGINX Open Source, and adds the following methods: `random two least_time=header` and `random two least_time=last_byte`.
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
kubectl exec -it deployments/gateway-nginx -- nginx -T
```

You should see the `zone` directive in the `coffee` and `tea` upstreams both specify the size `1m`:

```text
upstream default_coffee_80 {
    random two least_conn;
    zone default_coffee_80 1m;

    server 10.244.0.14:8080;
}

upstream default_tea_80 {
    random two least_conn;
    zone default_tea_80 1m;

    server 10.244.0.15:8080;
}
```

## Enable keepalive connections

By default, the `keepalive` directive is omitted, which results in the default NGINX `keepalive` value being used. You can override this value or disable `keepAlive` entirely by configuring an UpstreamSettingsPolicy. To disable keepalive, set the connections field to 0.

The following example creates an `UpstreamSettingsPolicy` that configures keepalive connections for the `coffee` Service with a value of 24:

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
    connections: 24
EOF
```

This `UpstreamSettingsPolicy` targets the `coffee` service in the `targetRefs` field. It sets the number of keepalive connections to 24, which activates the cache for connections to the service's pods and sets the maximum number of idle connections to 24.


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
kubectl exec -it deployments/gateway-nginx -- nginx -T
```

You should see that the `coffee` upstream has the `keepalive` directive set to 24:

```text
upstream default_coffee_80 {
    random two least_conn;
    zone default_coffee_80 1m;

    server 10.244.0.14:8080;
    keepalive 24;
}
```

To disable the `keepalive` directive, lets create an `UpstreamSettingsPolicy` targeting the `tea` service with value 0:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: UpstreamSettingsPolicy
metadata:
  name: upstream-unset-keepalive
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
kubectl describe upstreamsettingspolicies.gateway.nginx.org upstream-unset-keepalive
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
kubectl exec -it deployments/gateway-nginx -- nginx -T
```

```text
upstream default_tea_80 {
    random two least_conn;
    zone default_tea_80 1m;

    server 10.244.0.15:8080;
    keepalive 0;
}
```

## Configure health checks

Health checks let NGINX detect backend endpoints that are running but can't serve requests, then stop routing traffic to them. NGF supports two kinds through `UpstreamSettingsPolicy.spec.healthCheck`:

- Passive checks (`spec.healthCheck.passive`) work on both NGINX Open Source and NGINX Plus: NGINX monitors the responses to real client requests and marks a server unavailable after repeated failures.
- Active checks (`spec.healthCheck.active`) work on NGINX Plus only: NGINX sends probe requests to a dedicated health-check location and marks a server unavailable when those probes fail.

When `healthCheck` isn't set, NGF adds no health-check configuration and NGINX uses its default behavior for the upstream.

{{< call-out class="important" >}}Active health checks require NGINX Plus. If you set `spec.healthCheck.active` on NGINX Open Source, NGINX Gateway Fabric rejects the policy: its status shows an `Accepted: False` condition with the reason `Invalid`, and NGINX applies no configuration, with no disruptive effect. If you're unsure which edition your data plane runs, apply the policy and check its status, or ask your cluster operator. See [Advanced features with NGINX Plus]({{< ref "/ngf/overview/nginx-plus.md" >}}).{{< /call-out >}}

Health checks apply only to Layer 7 (HTTP, HTTPS, and gRPC) upstreams, that is, Services referenced by an HTTPRoute or GRPCRoute. They don't apply to L4/stream (TCP, UDP, or TLSRoute) upstreams.

### Configure a passive health check

Two fields configure a passive health check:

- `maxFails` (integer, minimum 0): the number of consecutive failed attempts within `failTimeout` that mark a server unavailable. A value of `0` turns off this accounting. Maps to the `max_fails` parameter on the `server` directive.
- `failTimeout` (duration, for example `5s`): the window in which `maxFails` failures mark a server unavailable, and how long the server then stays unavailable. Maps to the `fail_timeout` parameter on the `server` directive.

The following `UpstreamSettingsPolicy` configures a passive health check for the `coffee` Service:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: UpstreamSettingsPolicy
metadata:
  name: example-passive-hc
spec:
  targetRefs:
  - group: core
    kind: Service
    name: coffee
  healthCheck:
    passive:
      maxFails: 3
      failTimeout: 5s
EOF
```

Verify that the `UpstreamSettingsPolicy` is Accepted:

```shell
kubectl describe upstreamsettingspolicies.gateway.nginx.org example-passive-hc
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
      Last Transition Time:  2026-01-07T20:06:55Z
      Message:               Policy is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
Events:                      <none>
```

Next, verify that the policy has been applied to the `coffee` upstream by inspecting the NGINX configuration:

```shell
kubectl exec -it deployments/gateway-nginx -- nginx -T
```

You should see `max_fails` and `fail_timeout` set on the `server` directive in the `coffee` upstream:

```text
upstream default_coffee_80 {
    random two least_conn;
    zone default_coffee_80 1m;

    server 10.244.0.14:8080 max_fails=3 fail_timeout=5s;
}
```

### Configure an active health check (NGINX Plus)

Active health checks probe your backends on a schedule, separate from client traffic. Set the fields under `spec.healthCheck.active`:

- `interval` (duration): the time between checks.
- `jitter` (duration): a random delay added to each check.
- `fails` (integer, minimum 1): consecutive failed checks before a server is considered unhealthy.
- `passes` (integer, minimum 1): consecutive passed checks before a server is considered healthy again.
- `path` (string): the URI for probe requests. The default is `/`. Mutually exclusive with `grpc`. Maps to the `uri` parameter on the `health_check` directive.
- `port` (integer, 1 through 65535): the port used for the health-check connection.
- `match.status` (string): the expected response status codes for a check to pass. The default is any 2xx or 3xx code. It accepts an optional leading `!` for negation and space-separated codes or ranges, for example `"200"`, `"! 500"`, `"200 204"`, or `"200-399"`. Mutually exclusive with `grpc`.
- `mandatory` (boolean): require every newly added server to pass a check before it receives traffic. This requirement warms up new endpoints.
- `persistent` (boolean): keep a server's pre-reload state across reloads. Requires `mandatory: true`.
- `keepAliveTime` (duration): how long NGINX reuses a single keepalive connection for health-check requests before opening a new one.
- `timeout.connect`, `timeout.read`, and `timeout.send` (durations): the timeouts for health-check requests.
- `headers` (list, maximum 16): request headers to send with each check. NGINX Plus always sets `Host`, `User-Agent`, and `Connection`, which you can't override. A header name can contain only alphanumeric characters or `-`. NGINX Gateway Fabric also rejects the names `host`, `connection`, and `upgrade` (case-insensitive), even when they meet that format rule. A value can't contain line breaks, but it can include NGINX variables such as `$remote_addr`.

For gRPC upstreams, configure the check through `spec.healthCheck.active.grpc`. The check follows the [gRPC health-checking protocol](https://github.com/grpc/grpc/blob/master/doc/health-checking.md), and the `grpc` field is mutually exclusive with `path` and `match`. The `grpc` field contains two settings:

- `service` (string): the gRPC service to check. If you don't set it, NGINX checks the health of the whole server.
- `status` (string): the gRPC status code that counts as healthy. Set it only if your service doesn't implement the gRPC health-checking protocol. Use a status name, such as `UNIMPLEMENTED`, or its number, such as `12`.

{{< call-out class="important" >}}CRD validation enforces two constraints on these fields. A policy that sets `persistent: true` without `mandatory: true`, or that sets `grpc` together with `path` or `match`, is rejected: its status shows an `Accepted: False` condition with the reason `Invalid`.{{< /call-out >}}

Active health checks require the upstream to have a shared-memory zone. Set the `zoneSize` field in the same policy, as the active example below shows, or see [Configure upstream zone size]({{< ref "/ngf/traffic-management/upstream-settings.md#configure-upstream-zone-size" >}}) for details.

If a valid BackendTLSPolicy targets the same Service, active health checks use TLS as well. The health-check location connects over HTTPS, or over gRPC with TLS for a gRPC check. It verifies the backend certificate with the certificate authority (CA) certificate and hostname from the BackendTLSPolicy. You don't need to add TLS settings to the `UpstreamSettingsPolicy`. To set up a BackendTLSPolicy, see [Securing backend traffic using mutual TLS]({{< ref "/ngf/traffic-security/secure-backend.md" >}}).

The following `UpstreamSettingsPolicy` configures an active health check for the `tea` Service:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: UpstreamSettingsPolicy
metadata:
  name: example-active-hc
spec:
  targetRefs:
  - group: core
    kind: Service
    name: tea
  zoneSize: 1m
  healthCheck:
    active:
      interval: 10s
      jitter: 3s
      fails: 3
      passes: 2
      path: /healthz
      match:
        status: "! 500"
      mandatory: true
      persistent: true
      keepAliveTime: 60s
      timeout:
        connect: 2s
        read: 2s
        send: 2s
EOF
```

Verify that the `UpstreamSettingsPolicy` is Accepted:

```shell
kubectl describe upstreamsettingspolicies.gateway.nginx.org example-active-hc
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
      Last Transition Time:  2026-01-07T20:06:55Z
      Message:               Policy is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
Events:                      <none>
```

NGINX Plus generates a dedicated internal `location` containing the `health_check` directive. Because the policy sets `match.status`, it also generates a `match` block that the `health_check` directive references through `match=`. The `server` directive in the upstream doesn't change. Inspect the NGINX configuration:

```shell
kubectl exec -it deployments/gateway-nginx -- nginx -T
```

You should see a `location` with the `health_check` directive and its `match` block:

```text
server {
    location @hc-default_tea_80 {
        internal;
        proxy_connect_timeout 2s;
        proxy_read_timeout 2s;
        proxy_send_timeout 2s;
        proxy_pass http://default_tea_80;
        health_check interval=10s jitter=3s fails=3 passes=2 uri=/healthz mandatory persistent keepalive_time=60s match=default_tea_80_match;
    }
}

match default_tea_80_match {
    status ! 500;
}
```

### Configure an active health check for a gRPC service

For a gRPC upstream, set `spec.healthCheck.active.grpc` instead of `path` and `match`. The check uses the [gRPC health-checking protocol](https://github.com/grpc/grpc/blob/master/doc/health-checking.md), and `grpc.service` names the service to query. This example targets a `grpc-backend` Service referenced by a GRPCRoute rather than the HTTP `coffee` and `tea` Services from the setup:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: UpstreamSettingsPolicy
metadata:
  name: example-grpc-hc
spec:
  targetRefs:
  - group: core
    kind: Service
    name: grpc-backend
  zoneSize: 1m
  healthCheck:
    active:
      interval: 10s
      fails: 3
      passes: 2
      grpc:
        service: my.grpc.Service
EOF
```

Verify that the `UpstreamSettingsPolicy` is Accepted:

```shell
kubectl describe upstreamsettingspolicies.gateway.nginx.org example-grpc-hc
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
      Last Transition Time:  2026-01-07T20:06:55Z
      Message:               Policy is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
Events:                      <none>
```

For a gRPC check, the health-check location uses the `grpc_pass` directive instead of `proxy_pass`. Its `health_check` directive includes `type=grpc`, and `grpc_service=my.grpc.Service` for this example. To confirm, run `nginx -T` as in the [active health check example for the `tea` Service]({{< ref "/ngf/traffic-management/upstream-settings.md#configure-an-active-health-check-nginx-plus" >}}).

## Enable routing to Service ClusterIPs

The ability to configure NGINX to route to the Service ClusterIP and port instead of individual Pod IPs can be useful in service mesh scenarios or when working with other Kubernetes controllers/operators that require traffic to flow to the Service IP address.

View the IP address of the `coffee` backend pod and verify it matches the IP address in the `coffee` upstream:

```shell
kubectl get endpoints coffee
```

```text
NAME     ENDPOINTS         AGE
coffee   10.244.0.8:8080   13m
```

```shell
kubectl exec -it deployments/gateway-nginx -- nginx -T
```

```text
upstream default_coffee_80 {
    random two least_conn;
    zone default_coffee_80 1m;


    server 10.244.0.8:8080;
    keepalive 32;
}
```

The following example creates an `UpstreamSettingsPolicy` that configures NGINX to route to the coffee Service ClusterIP instead of the individual backend Pod IPs by using the `useClusterIP` field:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: UpstreamSettingsPolicy
metadata:
  name: upstream-clusterip
spec:
  targetRefs:
  - group: core
    kind: Service
    name: coffee
  useClusterIP: true
EOF
```

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
      Last Transition Time:  2026-05-28T21:49:20Z
      Message:               The Policy is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
Events:                      <none>
```

{{< call-out "note" >}}This setting applies only when the target Service has a ClusterIP. For headless Services (ClusterIP: None) and ExternalName Services, normal endpoint resolution is used instead. Additionally, this setting is also not applied to L4/stream upstreams.{{< /call-out >}}

View the IP address of the `coffee` Service and verify it matches the IP address in the `coffee` upstream:

```shell
kubectl get service coffee
```

```text
NAME     TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE
coffee   ClusterIP   10.96.23.26   <none>        80/TCP    16m
```


```shell
kubectl exec -it deployments/gateway-nginx -- nginx -T
```

```text
upstream default_coffee_80 {
    random two least_conn;
    zone default_coffee_80 1m;


    server 10.96.23.26:80;
    keepalive 32;
}
```

---

## Route upstream traffic to the Service ClusterIP

By default, NGINX Gateway Fabric resolves each backend Service to its individual Pod IPs and uses those as the upstream servers. Setting `useClusterIP` to `true` in an `UpstreamSettingsPolicy` configures NGINX to route to the Service's ClusterIP and port instead, so the upstream contains a single server (the Service VIP). This is useful for service mesh compatibility and for controllers or operators that require traffic to traverse the Service VIP.

You can also enable this globally for all Services through the `useClusterIP` field of the `NginxProxy` resource. When both are configured for the same Service, the `UpstreamSettingsPolicy` value takes precedence. See [Data plane configuration]({{< ref "/ngf/how-to/data-plane-configuration.md" >}}) for the global setting.

{{< call-out "note" >}} Because the upstream contains only the Service VIP as a single server, you lose NGINX's load balancing across the backend Pods. Traffic is instead load balanced by the Kubernetes Service (kube-proxy), so the load balancing and keepalive settings of an `UpstreamSettingsPolicy` no longer apply to that Service. `useClusterIP` applies only when the target Service has a ClusterIP; headless (`ClusterIP: None`) and ExternalName Services fall back to the default Pod IP resolution. {{< /call-out >}}

To route to the ClusterIP of the `coffee` service, create the following `UpstreamSettingsPolicy`:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: UpstreamSettingsPolicy
metadata:
  name: coffee-cluster-ip
spec:
  targetRefs:
  - group: core
    kind: Service
    name: coffee
  useClusterIP: true
EOF
```

Verify that the `UpstreamSettingsPolicy` is Accepted:

```shell
kubectl describe upstreamsettingspolicies.gateway.nginx.org coffee-cluster-ip
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

Find the ClusterIP of the `coffee` service:

```shell
kubectl get service coffee
```

Next, verify that the `coffee` upstream targets that ClusterIP by inspecting the NGINX configuration:

```shell
kubectl exec -it deployments/gateway-nginx -- nginx -T
```

You should see a single `server` in the `coffee` upstream set to the Service ClusterIP and port (`10.244.0.14` is the ClusterIP in this example):

```nginx
upstream default_coffee_80 {
    random two least_conn;
    zone default_coffee_80 512k;

    server 10.244.0.14:80;
    keepalive 16;
}
```

---

## Further reading

- [Custom policies]({{< ref "/ngf/overview/custom-policies.md" >}}): learn about how NGINX Gateway Fabric custom policies work.
- [API reference]({{< ref "/ngf/reference/api.md" >}}): all configuration fields for the `UpstreamSettingsPolicy` API.
- [NGINX health check module](https://nginx.org/en/docs/http/ngx_http_upstream_hc_module.html): optional background on the active health check directives available in NGINX Plus.
