---
title: Rate Limit Policy API
toc: true
weight: 1500
nd-content-type: how-to
nd-product: FABRIC
nd-docs: DOCS-0000
---

Learn how to use the `RateLimitPolicy` API.

## Overview

The `RateLimitPolicy` API allows Cluster Operators and Application Developers to configure NGINX Gateway Fabric to set rate limits on its provisioned NGINX instances.

The settings in `RateLimitPolicy` correspond to the following NGINX directives:

- [`limit_req`](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req)
- [`limit_req_zone`](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req_zone)
- [`limit_req_dry_run`](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req_dry_run)
- [`limit_req_log_level`](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req_log_level)
- [`limit_req_status`](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req_status)

`RateLimitPolicy` is an [Inherited PolicyAttachment](https://gateway-api.sigs.k8s.io/reference/policy-attachment/) that can be applied to a Gateway, HTTPRoute, or GRPCRoute in the same namespace as the `RateLimitPolicy`.

When applied to a Gateway, the settings specified in the `RateLimitPolicy` affect all HTTPRoutes and GRPCRoutes attached to the Gateway. This allows Cluster Operators to set defaults for all applications using the Gateway. The NGINX directives will be set at the `http` context. 

When applied to an HTTPRoute or GRPCRoute, the settings in the `RateLimitPolicy` affect only the route they are applied to. This allows Application Developers to set values for their applications based on their application's behavior or requirements. The `limit_req_zone` NGINX directive will be set at the `http` context, while the other NGINX directives will be set at the `location` context. 

Rate Limit directives applied to an HTTPRoute or GRPCRoute will be applied alongside the Rate Limit directives applied to a Gateway. Requests to an upstream will pass through all `limit_req` directives at the applicable `http` and `location` contexts. If any directive’s configured rate is exceeded, the request will be delayed. As a result, there is no way for a `RateLimitPolicy` set on an HTTPRoute or GRPCRoute to "override" settings set by a `RateLimitPolicy` attached to a Gateway.

This guide will show you how to use the `RateLimitPolicy` API to configure rate limiting for your applications.

For all the possible configuration options for `RateLimitPolicy`, see the [API reference]({{< ref "/ngf/reference/api.md" >}}).

## Before you begin

- [Install]({{< ref "/ngf/install/" >}}) NGINX Gateway Fabric.

Create a few example applications:

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/examples/rate-limit-policy/app.yaml
```

The example coffee, tea, and grpc-backend applications will be used to show various rate limiting configurations.

Create a Gateway:

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/examples/rate-limit-policy/gateway.yaml
```

Create routes for the applications:

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/examples/rate-limit-policy/routes.yaml
```

This will create HTTPRoutes for the coffee and tea applications, and a GRPCRoute for the grpc-backend.

After creating the Gateway resource, NGINX Gateway Fabric will provision an NGINX Pod and Service fronting it to route traffic.
Verify the gateway is created:

```shell
kubectl describe gateways.gateway.networking.k8s.io gateway
```

Verify the status is `Accepted`:

```text
Status:
  Addresses:
    Type:   IPAddress
    Value:  10.96.94.152
  Conditions:
    Last Transition Time:  2026-01-15T22:15:47Z
    Message:               The Gateway is accepted
    Observed Generation:   1
    Reason:                Accepted
    Status:                True
    Type:                  Accepted
    Last Transition Time:  2026-01-15T22:15:47Z
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

{{< call-out "note" >}}

In a production environment, you should have a DNS record for the external IP address that is exposed, and it should refer to the hostname that the gateway will forward for.

{{< /call-out >}}

Test the configuration:

You can send traffic to the coffee and tea applications using the external IP address and port for the NGINX Service.

Send a request to coffee:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee
```

This request should receive a response from the coffee Pod:

```text
Server address: 10.244.0.22:8080
Server name: coffee-654ddf664b-6mwtb
```

Send a request to tea:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/tea
```

This request should receive a response from the tea Pod:

```text
Server address: 10.244.0.23:8080
Server name: tea-75bc9f4b6d-g9t84
```

Before we enable rate limiting, try sending multiple requests to coffee:

```shell
for i in `seq 1 10`; do curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee; done
```

You should see all successful responses in quick succession as we have not configured any rate limiting rules yet.

## Configure Rate Limiting

### Set Rate Limiting on an HTTPRoute

To set rate limit settings for the coffee HTTPRoute created during setup, add the following `RateLimitPolicy`:

```shell
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: RateLimitPolicy
metadata:
  name: route-rate-limit
spec:
  targetRefs:
  - group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: coffee
  rateLimit:
    local:
      rules:
      - zoneSize: 10m
        key: "\$binary_remote_addr"
        rate: 1r/s
        burst: 3
EOF
```

This `RateLimitPolicy` targets the coffee HTTPRoute we created in the setup by specifying it in the `targetRefs` field. It configures the following rate limit settings:

- `zoneSize: "10m"`: Sets the zoneSize that will keep states for various keys.
- `key: "$binary_remote_addr"`: Sets the key to which the rate limit is applied to be the client IP address. This means that requests from different client IP addresses get rate limited separately.
- `rate: "1r/s"`: Sets the rate of requests permitted per key to 1 request per second.
- `burst: "3"`: Sets the maximum burst size of requests to 3. Excessive requests are delayed until their number exceeds the maximum burst size of 3, in which case the request is terminated with an error.

Verify that the `RateLimitPolicy` is Accepted:

```shell
kubectl describe ratelimitpolicies.gateway.nginx.org route-rate-limit
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
      Last Transition Time:  2026-01-15T22:17:46Z
      Message:               The Policy is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
Events:                      <none>
```

You can also verify that the policy was applied to the HTTPRoute by checking the HTTPRoute's status:

```shell
kubectl describe httproute coffee
```

Look for the `RateLimitPolicyAffected` condition in the HTTPRoute status:

```text
Status:
  Conditions:
      Last Transition Time:  2026-01-15T22:17:46Z
      Message:               The RateLimitPolicy is applied to the resource
      Observed Generation:   1
      Reason:                PolicyAffected
      Status:                True
      Type:                  RateLimitPolicyAffected
```

This condition indicates that a `RateLimitPolicy` has been successfully applied to the HTTPRoute.

Test the configuration by sending a request to the coffee application:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee
```

This request should receive a response from the coffee Pod:

```text
Server address: 10.244.0.22:8080
Server name: coffee-654ddf664b-6mwtb
```

When processing a single request, the rate limiting configuration has no noticeable effect. Try to exceed the
set rate limit with a script that sends multiple requests.

```shell
for i in `seq 1 10`; do curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee; done
```

You should see all successful responses from the coffee Pod, but they should be spaced apart roughly one second each as
expected through the rate limiting configuration.

Using the same script on the tea application, we can see there are no rate limit settings applied to the tea application:

```shell
for i in `seq 1 10`; do curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/tea; done
```

### Set Rate Limiting on a GRPCRoute

RateLimitPolicy can also target GRPCRoutes. To do so, re-use the policy created for the coffee HTTPRoute and add an additional targetRef:

```shell
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: RateLimitPolicy
metadata:
  name: route-rate-limit
spec:
  targetRefs:
  - group: gateway.networking.k8s.io
    kind: HTTPRoute
    name: coffee
  - group: gateway.networking.k8s.io
    kind: GRPCRoute
    name: grpc-route
  rateLimit:
    local:
      rules:
      - zoneSize: 10m
        key: "\$binary_remote_addr"
        rate: 1r/s
        burst: 3
EOF
```

This will let the `RateLimitPolicy` affect both the coffee HTTPRoute and the grpc-route GRPCRoute.

{{< call-out "note" >}}

RateLimitPolicy does not allow mixing Gateway kind with HTTPRoute or GRPCRoute kinds in targetRefs.

{{< /call-out >}}

Verify that the `RateLimitPolicy` is Accepted:

```shell
kubectl describe ratelimitpolicies.gateway.nginx.org route-rate-limit
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
      Last Transition Time:  2026-01-15T22:19:35Z
      Message:               The Policy is accepted
      Observed Generation:   2
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
    Ancestor Ref:
      Group:      gateway.networking.k8s.io
      Kind:       GRPCRoute
      Name:       grpc-route
      Namespace:  default
    Conditions:
      Last Transition Time:  2026-01-15T22:19:35Z
      Message:               The Policy is accepted
      Observed Generation:   2
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
Events:                      <none>
```

You can also verify that the policy was applied to the GRPCRoute by checking the GRPCRoute's status:

```shell
kubectl describe grpcroute grpc-route
```

Look for the `RateLimitPolicyAffected` condition in the GRPCRoute status:

```text
Status:
  Conditions:
      Last Transition Time:  2026-01-15T22:19:35Z
      Message:               The RateLimitPolicy is applied to the resource
      Observed Generation:   1
      Reason:                PolicyAffected
      Status:                True
      Type:                  RateLimitPolicyAffected
```

This condition indicates that a `RateLimitPolicy` has been successfully applied to the GRPCRoute.

#### Send gRPC traffic

To access the application and test the `RateLimitPolicy` has been applied to the GRPCRoute, we will use [grpcurl](https://github.com/fullstorydev/grpcurl?tab=readme-ov-file#installation]).

To test our application, we will need to create a separate `.proto` source file since we are running things locally. 

Create a new file named `grpc.proto` with these contents:

```proto
syntax = "proto3";

option go_package = "google.golang.org/grpc/examples/helloworld/helloworld";
option java_multiple_files = true;
option java_package = "io.grpc.examples.helloworld";
option java_outer_classname = "HelloWorldProto";

package helloworld;

// The greeting service definition.
service Greeter {
  // Sends a greeting
  rpc SayHello (HelloRequest) returns (HelloReply) {}
}

// The request message containing the user's name.
message HelloRequest {
  string name = 1;
}

// The response message containing the greetings
message HelloReply {
  string message = 1;
}
```

In the same directory, test our gRPC application through grpcurl:

```shell
grpcurl -plaintext -proto grpc.proto -authority grpc.example.com -d '{"name": "exact"}' ${GW_IP}:${GW_PORT} helloworld.Greeter/SayHello
```

The request should receive a response from the gRPC backend:

```text
{
    "message": "Hello exact"
}
```

When processing a single request, the rate limiting configuration has no noticeable effect. Try to exceed the
set rate limit with a script that sends multiple requests.

```shell
for i in `seq 1 10`; do grpcurl -plaintext -proto grpc.proto -authority grpc.example.com -d '{"name": "exact"}' ${GW_IP}:${GW_PORT} helloworld.Greeter/SayHello; done
```

You should see all successful responses from the grpc-backend, but they should be spaced apart roughly one second each as
expected through the rate limiting configuration.

### Set Rate Limiting on a Gateway

Before setting rate limiting on the Gateway, verify that the tea application isn't affected by any rate limit configuration. 

```shell
for i in `seq 1 10`; do curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/tea; done
```

You should see that these requests have successful responses with no delays.

To set rate limit settings for the Gateway we created in the setup, add the following `RateLimitPolicy`:

```shell
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: RateLimitPolicy
metadata:
  name: gateway-rate-limit
spec:
  targetRefs:
  - group: gateway.networking.k8s.io
    kind: Gateway
    name: gateway
  rateLimit:
    local:
      rules:
      - zoneSize: 10m
        key: "\$binary_remote_addr"
        rate: 10r/s
EOF
```

This `RateLimitPolicy` targets the Gateway we created in the setup by specifying it in the `targetRefs` field. Additionally, it omits the `burst` field, meaning any excessive requests will cause an error code to be returned.

Since this policy is applied to the Gateway, it will affect all HTTPRoutes and GRPCRoutes attached to the Gateway.

Verify that the `RateLimitPolicy` is Accepted:

```shell
kubectl describe ratelimitpolicies.gateway.nginx.org gateway-rate-limit
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
      Last Transition Time:  2026-01-15T22:23:38Z
      Message:               The Policy is accepted
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

Look for the `RateLimitPolicyAffected` condition in the Gateway status:

```text
Status:
  Conditions:
    Last Transition Time:  2026-01-15T22:23:38Z
    Message:               The RateLimitPolicy is applied to the resource
    Observed Generation:   1
    Reason:                PolicyAffected
    Status:                True
    Type:                  RateLimitPolicyAffected
```

This condition indicates that a `RateLimitPolicy` has been successfully applied to the Gateway.

Verify that the tea application is affected by the rate limit configuration:

```shell
for i in `seq 1 10`; do curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/tea; done
```

Even though there is no `RateLimitPolicy` specifically targeting the tea HTTPRoute, since the HTTPRoute is attached to the Gateway, it is affected by the policy. There should be a mix of successful responses alongside `503` error codes (default error code). This is expected because of the omission of the `burst` field in this `RateLimitPolicy`, causing the excessive requests to have an error code returned as the response instead of being delayed. For more information on underlying NGINX configuration of the `limit_req_module`, see the official [NGINX documentation](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html).

The `RateLimitPolicy` attached to the Gateway will affect all Routes, meaning the coffee HTTPRoute and grpc-route GRPCRoute are also affected by this policy. In NGINX, a request will pass through all `limit_req` directives that apply to it, if any of the rates are exceeded, that request will be delayed and subject to the rules of that `limit_req`. In this case, since the `RateLimitPolicy` attached to the Routes has the same `key` and has a lower rate of `1r/s`, requests sent to the coffee and grpc-backend under the rate of `10r/s` will still get delayed by the `1r/s` rate.

To test this, send five requests to the coffee application: 

```shell
for i in `seq 1 5`; do curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee; done
```

The requests will each be delayed at a rate of one request per second.

### View and Configure Rate Limit Logs

For each request that is rate limited by NGINX, a log message is associated with it. 

Send a few requests to both tea and coffee applications:

```shell
for i in `seq 1 5`; do curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee; done
```

```shell
for i in `seq 1 5`; do curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/tea; done
```

View the NGINX logs:

```shell
kubectl logs <gateway-nginx-pod-name>
```

```text
127.0.0.1 - - [15/Jan/2026:20:44:57 +0000] "GET /coffee HTTP/1.1" 200 161 "-" "curl/8.7.1"
2026/01/15 20:44:57 [warn] 5788#5788: *2927 delaying request, excess: 0.943, by zone "default_rl_route-rate-limit_rule0", client: 127.0.0.1, server: cafe.example.com, request: "GET /coffee HTTP/1.1", host: "cafe.example.com:8080"
127.0.0.1 - - [15/Jan/2026:20:44:58 +0000] "GET /coffee HTTP/1.1" 200 161 "-" "curl/8.7.1"
2026/01/15 20:44:58 [info] 5788#5788: *2925 client 127.0.0.1 closed keepalive connection
2026/01/15 20:44:58 [warn] 5788#5788: *2930 delaying request, excess: 0.885, by zone "default_rl_route-rate-limit_rule0", client: 127.0.0.1, server: cafe.example.com, request: "GET /coffee HTTP/1.1", host: "cafe.example.com:8080"
127.0.0.1 - - [15/Jan/2026:20:44:59 +0000] "GET /coffee HTTP/1.1" 200 161 "-" "curl/8.7.1"
...
127.0.0.1 - - [15/Jan/2026:20:45:05 +0000] "GET /tea HTTP/1.1" 200 155 "-" "curl/8.7.1"
127.0.0.1 - - [15/Jan/2026:20:45:05 +0000] "GET /tea HTTP/1.1" 503 190 "-" "curl/8.7.1"
2026/01/15 20:45:05 [error] 5788#5788: *2938 limiting requests, excess: 0.500 by zone "default_rl_gateway-rate-limit_rule0", client: 127.0.0.1, server: cafe.example.com, request: "GET /tea HTTP/1.1", host: "cafe.example.com:8080"
127.0.0.1 - - [15/Jan/2026:20:45:05 +0000] "GET /tea HTTP/1.1" 200 155 "-" "curl/8.7.1"
127.0.0.1 - - [15/Jan/2026:20:45:05 +0000] "GET /tea HTTP/1.1" 503 190 "-" "curl/8.7.1"
2026/01/15 20:45:05 [error] 5788#5788: *2941 limiting requests, excess: 0.610 by zone "default_rl_gateway-rate-limit_rule0", client: 127.0.0.1, server: cafe.example.com, request: "GET /tea HTTP/1.1", host: "cafe.example.com:8080"
...
```

You should be able to see NGINX logs at the default `error` log level showing NGINX limiting requests. Since the `coffee` application has `burst=3`, the requests are delayed and are all met with the `200` status code, while the `tea` application doesn't have `burst`, meaning all excessive requests are met with a `503`. 

Both the error log level and status code are adjustable in the `RateLimitPolicy`:

```shell
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: RateLimitPolicy
metadata:
  name: gateway-rate-limit
spec:
  targetRefs:
  - group: gateway.networking.k8s.io
    kind: Gateway
    name: gateway
  rateLimit:
    local:
      rules:
      - zoneSize: 10m
        key: "\$binary_remote_addr"
        rate: 10r/s
    logLevel: "warn"
    rejectCode: 429
EOF
```

This will change the logLevel to `warn` and the rejectCode to `429`. 

Send some requests to the tea application with the new logLevel and rejectCode:

```shell
for i in `seq 1 5`; do curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/tea; done
```

Viewing the NGINX logs we can see the changes:

```shell
kubectl logs <gateway-nginx-pod-name>
```

```text
127.0.0.1 - - [21/Jan/2026:18:55:39 +0000] "GET /tea HTTP/1.1" 200 155 "-" "curl/8.7.1"
127.0.0.1 - - [21/Jan/2026:18:55:39 +0000] "GET /tea HTTP/1.1" 429 162 "-" "curl/8.7.1"
2026/01/21 18:55:39 [warn] 1290#1290: *595 limiting requests, excess: 0.580 by zone "default_rl_gateway-rate-limit_rule0", client: 127.0.0.1, server: cafe.example.com, request: "GET /tea HTTP/1.1", host: "cafe.example.com:8080"
127.0.0.1 - - [21/Jan/2026:18:55:39 +0000] "GET /tea HTTP/1.1" 200 155 "-" "curl/8.7.1"
127.0.0.1 - - [21/Jan/2026:18:55:39 +0000] "GET /tea HTTP/1.1" 429 162 "-" "curl/8.7.1"
2026/01/21 18:55:39 [warn] 1292#1292: *598 limiting requests, excess: 0.470 by zone "default_rl_gateway-rate-limit_rule0", client: 127.0.0.1, server: cafe.example.com, request: "GET /tea HTTP/1.1", host: "cafe.example.com:8080"
2026/01/21 18:55:39 [warn] 1293#1293: *599 limiting requests, excess: 0.020 by zone "default_rl_gateway-rate-limit_rule0", client: 127.0.0.1, server: cafe.example.com, request: "GET /tea HTTP/1.1", host: "cafe.example.com:8080"
127.0.0.1 - - [21/Jan/2026:18:55:39 +0000] "GET /tea HTTP/1.1" 429 162 "-" "curl/8.7.1"
```

## Important Notes

### RateLimitPolicies set on a Gateway and Route

Since Routes are affected by all `RateLimitPolicies` on a Gateway, there is no way for a `RateLimitPolicy` attached to a Route to overwrite/negate a rule set by one on a Gateway.

### Conflicts 

When multiple `RateLimitPolicies` select the same targetRef and specify any of dryRun, logLevel, or rejectCode, only one policy will be applied. The controller selects the policy with the highest priority (based on time created, if created at the same time, ties are calculated on alphabetical order sorting of the policy name) and rejected policies will have the `Accepted` Condition set to false with the reason `Conflicted`.

### Dry Run

The [limit_req_dry_run](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req_dry_run) NGINX directive can be enabled by setting `spec.rateLimit.dryRun` to `true`. In this mode, rate limit is not applied, but the number of excessive requests is accounted as usual in the shared memory zone.

## See also

- [NGINX limit_req_module](https://nginx.org/en/docs/http/ngx_http_limit_req_module.html): for more information on the underlying NGINX directives.
- [Custom policies]({{< ref "/ngf/overview/custom-policies.md" >}}): learn about how NGINX Gateway Fabric custom policies work.
- [API reference]({{< ref "/ngf/reference/api.md" >}}): all configuration fields for the `RateLimitPolicy` API.
