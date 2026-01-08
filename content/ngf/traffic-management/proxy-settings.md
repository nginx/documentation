---
title: Proxy Settings Policy API
toc: true
weight: 1200
nd-content-type: how-to
nd-product: FABRIC
nd-docs: DOCS-0000
---

Learn how to use the `ProxySettingsPolicy` API.

## Overview

The `ProxySettingsPolicy` API allows Cluster Operators and Application Developers to configure the connection behavior between NGINX Gateway Fabric and upstream applications (backends).

The settings in `ProxySettingsPolicy` correspond to the following NGINX directives:

- [`proxy_buffering`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_buffering)
- [`proxy_buffer_size`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_buffer_size)
- [`proxy_buffers`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_buffers)
- [`proxy_busy_buffers_size`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html#proxy_busy_buffers_size)

`ProxySettingsPolicy` is an [Inherited PolicyAttachment](https://gateway-api.sigs.k8s.io/reference/policy-attachment/) that can be applied to a Gateway, HTTPRoute, or GRPCRoute in the same namespace as the `ProxySettingsPolicy`.

When applied to a Gateway, the settings specified in the `ProxySettingsPolicy` affect all HTTPRoutes and GRPCRoutes attached to the Gateway. This allows Cluster Operators to set defaults for all applications using the Gateway.

When applied to an HTTPRoute or GRPCRoute, the settings in the `ProxySettingsPolicy` affect only the route they are applied to. This allows Application Developers to set values for their applications based on their application's behavior or requirements. Settings applied to an HTTPRoute or GRPCRoute take precedence over settings applied to a Gateway. See the [custom policies]({{< ref "/ngf/overview/custom-policies.md" >}}) document for more information on policies.

This guide will show you how to use the `ProxySettingsPolicy` API to configure proxy buffering for your applications.

For all the possible configuration options for `ProxySettingsPolicy`, see the [API reference]({{< ref "/ngf/reference/api.md" >}}).

## Before you begin

- [Install]({{< ref "/ngf/install/" >}}) NGINX Gateway Fabric.

Create the coffee and tea example applications:

```yaml
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/examples/proxy-settings-policy/app.yaml
```

The coffee application is designed to generate large responses (10KB headers and 5MB body) to demonstrate buffering requirements. The tea application returns standard responses.

Create a Gateway:

```yaml
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/examples/proxy-settings-policy/gateway.yaml
```

After creating the Gateway resource, NGINX Gateway Fabric will provision an NGINX Pod and Service fronting it to route traffic.

Create HTTPRoutes for the coffee and tea applications:

```yaml
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/examples/proxy-settings-policy/httproutes.yaml
```

Save the public IP address and port of the NGINX Service into shell variables:

```text
GW_IP=XXX.YYY.ZZZ.III
GW_PORT=<port number>
```

{{< call-out "note" >}}

In a production environment, you should have a DNS record for the external IP address that is exposed, and it should refer to the hostname that the gateway will forward for.

{{< /call-out >}}

Test the configuration:

You can send traffic to the coffee and tea applications using the external IP address and port for the NGINX Service.

Send a request to tea:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/tea
```

This request should receive a response from the tea Pod:

```text
Server address: 10.244.0.9:8080
Server name: tea-76c7c85bbd-cf8nz
```

Now send a request to coffee:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee
```

This request will fail with a 502 Bad Gateway error:

```text
<html>
<head><title>502 Bad Gateway</title></head>
<body>
<center><h1>502 Bad Gateway</h1></center>
<hr><center>nginx</center>
</body>
</html>
```

This error occurs because the coffee application generates a 10KB response header, which exceeds NGINX's default `proxy_buffer_size` (typically 4KB-8KB). You can verify this by checking the NGINX data plane logs:

```shell
kubectl logs <gateway-nginx-pod-name>
```

Replace `<gateway-nginx-pod-name>` with the name of your NGINX Gateway Fabric data plane Pod (in the same namespace as your Gateway). You should see an error similar to:

```text
[error] upstream sent too big header while reading response header from upstream, client: 127.0.0.1, server: cafe.example.com, request: "GET /coffee HTTP/1.1", upstream: "http://10.244.0.7:8080/coffee", host: "cafe.example.com:8080"
```

This demonstrates why proper proxy buffering configuration is essential for applications that generate large response headers or bodies.

## Configure proxy buffering

### Set default proxy buffering for the Gateway

To set default proxy buffering settings for the Gateway created during setup, add the following `ProxySettingsPolicy`:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: ProxySettingsPolicy
metadata:
  name: gateway-proxy-settings
spec:
  targetRefs:
  - group: gateway.networking.k8s.io
    kind: Gateway
    name: gateway
  buffering:
    bufferSize: "4k"
    buffers:
      number: 8
      size: "4k"
    busyBuffersSize: "16k"
EOF
```

This `ProxySettingsPolicy` targets the Gateway we created in the setup by specifying it in the `targetRefs` field. It configures the following proxy buffering settings:

- `bufferSize: "4k"`: Sets the buffer size for reading the first part of the response (usually headers) to 4KB
- `buffers.number: 8` and `buffers.size: "4k"`: Allocates 8 buffers of 4KB each for reading the response body (32KB total)
- `busyBuffersSize: "16k"`: Sets the maximum size of buffers that can be busy sending data to the client while still receiving from upstream

Since this policy is applied to the Gateway, it will affect all HTTPRoutes and GRPCRoutes attached to the Gateway. All requests to the coffee and tea applications will use these buffering settings.

Verify that the `ProxySettingsPolicy` is Accepted:

```shell
kubectl describe proxysettingspolicies.gateway.nginx.org gateway-proxy-settings
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
      Last Transition Time:  2026-01-08T10:03:29Z
      Message:               Policy is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
Events:                      <none>
```

You can also verify that the policy was applied to the Gateway by checking the Gateway's status:

```shell
kubectl describe gateway gateway
```

Look for the `ProxySettingsPolicyAffected` condition in the Gateway status:

```text
Status:
  Conditions:
    Last Transition Time:  2026-01-08T10:03:29Z
    Message:               The ProxySettingsPolicy is applied to the resource
    Observed Generation:   1
    Reason:                PolicyAffected
    Status:                True
    Type:                  ProxySettingsPolicyAffected
```

This condition indicates that a `ProxySettingsPolicy` has been successfully applied to the Gateway.

Test the configuration by sending requests to both applications:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/tea
```

The tea application should respond normally with the configured buffering settings.

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee
```

The coffee application will still fail with a 502 Bad Gateway error because the Gateway-level policy's `bufferSize: "4k"` is not large enough to handle the coffee app's 10KB response headers. We'll fix this in the next section by applying a route-specific policy.

### Set different proxy buffering for a route

To set different proxy buffering settings for a particular route, you can create another `ProxySettingsPolicy` that targets the route:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: ProxySettingsPolicy
metadata:
  name: coffee-proxy-settings
spec:
  targetRefs:
  - group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: coffee
  buffering:
    # Increase buffer size to handle large response headers (>10KB)
    bufferSize: "16k"
    # Configure more and larger buffers to handle 5MB response body
    buffers:
      number: 16
      size: "64k"
    # Set busy buffers size to allow more data to be sent to client
    # while still receiving from upstream
    busyBuffersSize: "128k"
EOF
```

This `ProxySettingsPolicy` targets the coffee HTTPRoute we created in the setup by specifying it in the `targetRefs` field. It sets larger buffering values specifically for the coffee application:

- `bufferSize: "16k"`: Increases the buffer size to 16KB to accommodate the coffee app's 10KB response headers
- `buffers.number: 16` and `buffers.size: "64k"`: Allocates 16 buffers of 64KB each (1MB total) to efficiently handle the 5MB response body
- `busyBuffersSize: "128k"`: Allows more data to be sent to the client while still receiving from the upstream

Since this policy is applied to the coffee HTTPRoute, it will only affect the coffee HTTPRoute. The `ProxySettingsPolicy` we created in the previous step will continue to affect all other routes attached to the Gateway, including the tea route.

Verify that the `ProxySettingsPolicy` is Accepted:

```shell
kubectl describe proxysettingspolicies.gateway.nginx.org coffee-proxy-settings
```

You should see the following status:

```text
Status:
  Ancestors:
    Ancestor Ref:
      Group:      gateway.networking.k8s.io
      Kind:       HTTPRoute
      Name:       coffee
      Namespace:  default
    Conditions:
      Last Transition Time:  2026-01-08T10:03:29Z
      Message:               Policy is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
Events:                      <none>
```

Notice that the Ancestor Ref in the status is the coffee HTTPRoute instead of the Gateway.

You can also verify that the policy was applied to the HTTPRoute by checking the route's status:

```shell
kubectl describe httproute coffee
```

Look for the `ProxySettingsPolicyAffected` condition in the HTTPRoute status:

```text
Status:
  Parents:
    Conditions:
      <...>
      Last Transition Time:  2026-01-08T10:03:29Z
      Message:               The ProxySettingsPolicy is applied to the resource
      Observed Generation:   1
      Reason:                PolicyAffected
      Status:                True
      Type:                  ProxySettingsPolicyAffected
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
    Parent Ref:
      Group:         gateway.networking.k8s.io
      Kind:          Gateway
      Name:          gateway
      Namespace:     default
      Section Name:  http
```

Test that the policy is configured by sending requests to both applications:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee
```

The coffee application should now successfully return the large response with the increased buffer settings. The request will complete successfully, and you'll receive the 5MB response body.

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/tea
```

The tea application continues to use the Gateway-level buffering settings since no route-specific policy is applied to it.

To configure a `ProxySettingsPolicy` for a GRPCRoute, you can specify the GRPCRoute in the `spec.targetRefs`:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: ProxySettingsPolicy
metadata:
  name: grpc-proxy-settings
spec:
  targetRefs:
  - group: gateway.networking.k8s.io
    kind: GRPCRoute
    name: my-grpc-route
  buffering:
    bufferSize: "8k"
    buffers:
      number: 16
      size: "8k"
    busyBuffersSize: "32k"
EOF
```

### Disable proxy buffering

In some scenarios, you may want to disable buffering entirely to allow responses to be streamed directly to clients as they're received from upstream servers. This is useful for:

- Server-sent events (SSE)
- Long-polling connections
- Large file downloads where memory usage is a concern
- Real-time data streams

To disable buffering for a route:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: ProxySettingsPolicy
metadata:
  name: coffee-streaming
spec:
  targetRefs:
  - group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: coffee
  buffering:
    disable: true
EOF
```

With buffering disabled, NGINX Gateway Fabric will pass responses from the upstream server to the client synchronously, without buffering them in memory.

## Important considerations

### Response headers always require buffering

Even when `disable: true` is set to disable response body buffering, NGINX still needs to buffer response headers. The `bufferSize` field controls the buffer size for headers and applies regardless of the `disable` setting.

If your upstream server sends large response headers (for example, many cookies or custom headers), you must ensure `bufferSize` is large enough to accommodate them, even when buffering is disabled:

```yaml
apiVersion: gateway.nginx.org/v1alpha1
kind: ProxySettingsPolicy
metadata:
  name: streaming-with-large-headers
spec:
  targetRefs:
  - group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: my-route
  buffering:
    disable: true
    bufferSize: "16k"  # Ensure this is large enough for response headers
```

**Common scenario:** If you set `disable: true` at the HTTPRoute level to enable streaming, but the route returns large headers, you may see `502 Bad Gateway` errors with the message "upstream sent too big header" in the NGINX error logs. In this case, you need to either:

1. Set `bufferSize` at the HTTPRoute level along with `disable: true`, OR
2. Ensure the Gateway-level `bufferSize` is large enough (and only set `disable: true` at the route level)

### Field-level inheritance and conflicts

ProxySettingsPolicy uses field-level inheritance. When both a Gateway and an HTTPRoute/GRPCRoute have ProxySettingsPolicies applied:

- Each individual field (such as `bufferSize`, `disable`, `busyBuffersSize`) can be independently overridden
- Setting a field at the route level overrides that field from the gateway level
- Other fields continue to inherit from the gateway

**Example:**

```yaml
# Gateway policy
buffering:
  bufferSize: "16k"      # Large enough for headers
  buffers:
    number: 16
    size: "64k"

# Route policy
buffering:
  disable: true          # Disables body buffering
  # bufferSize NOT specified - inherits 16k from Gateway ✓
  # buffers NOT specified - inherited but ignored because buffering is disabled
```

### Buffer configuration constraints

When configuring `busyBuffersSize`, NGINX requires that it must satisfy two constraints:

1. **Must be larger than `bufferSize`**: `busyBuffersSize` > `bufferSize`
2. **Must be less than total buffers minus one buffer**: `busyBuffersSize` < (`buffers.number` × `buffers.size`) - `buffers.size`

For example, with `buffers: {number: 8, size: "4k"}` (32KB total), valid values for `busyBuffersSize` are between `bufferSize` (exclusive) and 28KB (exclusive).

**Validation limitation:** NGINX Gateway Fabric validates these constraints only when all fields are set in the same policy. If you set `busyBuffersSize` in one policy and `buffers` in another (via inheritance), you are responsible for ensuring the merged configuration satisfies NGINX's requirements. If the constraints are violated, NGINX will fail to reload and log an error.

## See also

- [Custom policies]({{< ref "/ngf/overview/custom-policies.md" >}}): learn about how NGINX Gateway Fabric custom policies work.
- [API reference]({{< ref "/ngf/reference/api.md" >}}): all configuration fields for the `ProxySettingsPolicy` API.
