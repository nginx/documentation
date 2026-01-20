---
title: Snippets
weight: 800
toc: true
nd-content-type: how-to
nd-product: FABRIC
nd-docs: DOCS-1848
---

{{< call-out "important" >}}This guide previously showed how to use `SnippetsFilters` to configure Rate Limiting in NGINX. However, first-class support for Rate Limiting is now supported through the `RateLimitPolicy` API. This guide has been changed to provide an example for adding custom request and response headers containing NGINX variables. 

For a guide on how to configure Rate Limiting, see our guide on the [RateLimitPolicy API]({{< ref"./rate-limit.md" >}}). {{< /call-out >}}

This topic introduces Snippets, how to implement them using the `SnippetsFilter` and `SnippetsPolicy` APIs, and provides an example of how to use them to create custom request and response headers containing NGINX variables.

## Overview

Snippets allow users to insert NGINX configuration into different contexts of the NGINX configurations that NGINX Gateway Fabric generates.

Snippets should only be used by advanced NGINX users who need more control over the generated NGINX configuration, and only in cases where Gateway API resources or NGINX extension policies don't apply.

Users can configure Snippets through either the `SnippetsFilter` or `SnippetsPolicy` APIs.

`SnippetsFilter` can be an [HTTPRouteFilter](https://gateway-api.sigs.k8s.io/reference/spec/#gateway.networking.k8s.io/v1.HTTPRouteFilter) or [GRPCRouteFilter](https://gateway-api.sigs.k8s.io/reference/spec/#gateway.networking.k8s.io/v1.GRPCRouteFilter), that can be defined in an HTTPRoute/GRPCRoute rule and is intended to modify NGINX configuration specifically for that Route rule. `SnippetsFilter` is an `extensionRef` type filter, and must be in the same namespace as the Route it is referenced on.

`SnippetsPolicy` is a [Direct PolicyAttachment](https://gateway-api.sigs.k8s.io/reference/policy-attachment/) that can only be applied to a Gateway(s) in the same namespace as the `SnippetsPolicy`. `SnippetsPolicy` affects the Gateway and all Routes attached to it, and is meant to contrast the route-focused `SnippetsFilter`. 

## Disadvantages of Snippets

{{< call-out "warning" >}} We recommend managing NGINX configuration through Gateway API resources, [first-class policies]({{< ref "/ngf/overview/custom-policies.md" >}}), and other existing [NGINX extensions]({{< ref "/ngf/how-to/data-plane-configuration.md" >}})
before using Snippets. {{< /call-out >}}

Snippets are configured using the `SnippetsFilter` or `SnippetsPolicy` API, but are disabled by default due to their complexity and security implications.

Snippets have the following disadvantages:

- _Complexity_. Snippets require you to:
  - Understand NGINX configuration primitives to implement correct NGINX configuration.
  - Understand how NGINX Gateway Fabric generates NGINX configuration so that a Snippet doesn’t interfere with the other features in the configuration.
- _Decreased robustness_. An incorrect Snippet can invalidate NGINX configuration, causing reload failures. Until the snippet is fixed, it will prevent any new configuration updates, including updates for the other Gateway resources.
- _Security implications_. Snippets give access to NGINX configuration primitives, which are not validated by NGINX Gateway Fabric. For example, a Snippet can configure NGINX to serve the TLS certificates and keys used for TLS termination for Gateway resources.

## Best practices for Snippets

When using both `SnippetsPolicies` and `SnippetsFilters`, be sure to double check that the Snippets applied do not conflict and cause invalid NGINX configuration.

NGINX Gateway Fabric does not validate NGINX configuration in a Snippet. If the Snippet creates invalid NGINX configuration, NGINX Gateway Fabric will rollback to the latest valid configuration with a related log message outputted.

### SnippetsFilters

There are endless ways to use `SnippetsFilters` to modify NGINX configuration, and equal ways to generate invalid or undesired NGINX configuration. We have outlined a few best practices to keep in mind when using `SnippetsFilters` to keep NGINX Gateway Fabric functioning correctly:

1. Using the [Roles and Personas](https://gateway-api.sigs.k8s.io/concepts/roles-and-personas/) defined in the Gateway API, `SnippetsFilter` access should be limited to Cluster operators. Application developers should not be able to create, modify, or delete `SnippetsFilters` as they affect other applications. `SnippetsFilter` creates a natural split of responsibilities between the Cluster operator and the Application developer: the Cluster operator creates a `SnippetsFilter`; the Application developer references the `SnippetsFilter` in an HTTPRoute/GRPCRoute to enable it.
1. In a `SnippetsFilter`, only one Snippet per NGINX context is allowed, however multiple `SnippetsFilters` can be referenced in the same routing rule. As such, `SnippetsFilters` should not conflict with each other. If `SnippetsFilters` do conflict, they should not be referenced on the same routing rule.
1. `SnippetsFilters` that define Snippets targeting NGINX contexts `main`, `http`, or `http.server`, can potentially affect more than the routing rule they are referenced by. Proceed with caution and verify the behavior of the NGINX configuration before creating those `SnippetsFilters` in a production scenario.

### SnippetsPolicies

`SnippetsPolicies` share many of the same best practices as `SnippetsFilters` but with a couple of adjustments:

1. `SnippetsPolicy` access should be limited to Cluster operators. Additionally, since `SnippetsPolicies` use the `targetRefs` field to specify which resources to target, this means there is no need for an Application developer to reference it on a Route like the `SnippetsFilter` does. 

## Setup

To enable the `SnippetsFilter` and `SnippetsPolicy` APIs, [install]({{< ref "/ngf/install/" >}}) NGINX Gateway Fabric with these modifications:

- Using Helm: set the `nginxGateway.snippets.enable=true` Helm value.
- Using Kubernetes manifests: set the `--snippets` flag in the nginx-gateway container argument, add `snippetsfilters` and `snippetspolicies` to the RBAC rules with verbs `list` and `watch`, and add `snippetsfilters/status` and `snippetspolicies/status` to the RBAC rules with verb `update`. See this [example manifest](https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/main/deploy/snippets/deploy.yaml) for clarification.

Create the coffee and tea example applications:

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/examples/snippets/app.yaml
```

Create a Gateway:

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/examples/snippets/gateway.yaml
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

{{< call-out "note" >}} In a production environment, you should have a DNS record for the external IP address that is exposed, and it should refer to the hostname that the gateway will forward for. {{< /call-out >}}


Create HTTPRoutes for the coffee and tea applications:

```shell
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
            type: PathPrefix
            value: /tea
      backendRefs:
        - name: tea
          port: 80
EOF
```

Test the configuration:

You can send traffic to the coffee and tea applications using the external IP address and port for the NGINX Service.

Send a request to coffee:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee
```

This request should receive a response from the coffee Pod:

```text
Server address: 10.244.0.7:8080
Server name: coffee-76c7c85bbd-cf8nz
```

Send a request to tea:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/tea
```

This request should receive a response from the tea Pod:

```text
Server address: 10.244.0.6:8080
Server name: tea-76c7c85bbd-cf8nz
```

## Create a SnippetsFilter

Create a `SnippetsFilter` named `request-time-sf` by adding the following `SnippetsFilter`:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: SnippetsFilter
metadata:
  name: request-time-sf
spec:
  snippets:
    - context: http.server.location
      value: add_header request_processing_time "This is the custom response header we added in our SnippetsFilter that shows the request time in seconds - $request_time" always;
EOF
```

This `SnippetsFilter` defines a single Snippet at the `http.server.location` context which uses the `add_header` NGINX directive to add a custom header to any responses. In this case, we are adding a header that uses the `$request_time` NGINX variable which represents the request processing time. 

Verify that the `SnippetsFilter` is Accepted:

```shell
kubectl describe snippetsfilters.gateway.nginx.org request-time-sf
```

You should see the following status:

```text
Status:
  Controllers:
    Conditions:
      Last Transition Time:  2026-01-18T22:02:09Z
      Message:               The SnippetsFilter is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
Events:                      <none>
```

### Configure coffee HTTPRoute to reference SnippetsFilter

To use the `request-time-sf` `SnippetsFilter`, update the coffee HTTPRoute to reference it:

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
      filters:
        - type: ExtensionRef
          extensionRef:
            group: gateway.nginx.org
            kind: SnippetsFilter
            name: request-time-sf
      backendRefs:
        - name: coffee
          port: 80
EOF
```

Verify that the coffee HTTPRoute has been configured correctly:

```shell
kubectl describe httproutes.gateway.networking.k8s.io coffee
```

You should see the following conditions:

```text
CConditions:
      Last Transition Time:  2026-01-18T22:01:58Z
      Message:               The Route is accepted
      Observed Generation:   2
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
      Last Transition Time:  2026-01-18T22:01:58Z
      Message:               All references are resolved
      Observed Generation:   2
      Reason:                ResolvedRefs
      Status:                True
      Type:                  ResolvedRefs
```

Test that the `request-time-sf` `SnippetsFilter` is configured and has successfully applied the response header NGINX configuration changes.

Send a curl request to coffee with the `-v` flag:

```shell
curl -v --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee
```

The `request_processing_time` header we defined in the `SnippetsFilter` should be present in the response:

```text
...
* Request completely sent off
< HTTP/1.1 200 OK
< Server: nginx
< Date: Sat, 17 Jan 2026 00:30:13 GMT
< Content-Type: text/plain
< Content-Length: 160
< Connection: keep-alive
< Expires: Sat, 17 Jan 2026 00:30:12 GMT
< Cache-Control: no-cache
< request_processing_time: This is the custom response header we added in our SnippetsFilter that shows the request time in seconds - 0.004
...
```

Since the `SnippetsFilter` was only referenced on the coffee HTTPRoute and the context was `http.server.location`, the tea HTTPRoute should not be affected and any curl requests to it should not show the header. To verify send the same request to tea:

```shell
curl -v --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/tea
```

```text
...
* Request completely sent off
< HTTP/1.1 200 OK
< Server: nginx
< Date: Sat, 17 Jan 2026 00:31:44 GMT
< Content-Type: text/plain
< Content-Length: 154
< Connection: keep-alive
< Expires: Sat, 17 Jan 2026 00:31:43 GMT
< Cache-Control: no-cache
...
```

You should see that the `request_processing_time` header is not present.

## Create a SnippetsPolicy

Create a `SnippetsPolicy` named `local-time-sp` by adding the following `SnippetsPolicy`:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: SnippetsPolicy
metadata:
  name: local-time-sp
spec:
  targetRefs:
    - group: gateway.networking.k8s.io
      kind: Gateway
      name: gateway
  snippets:
    - context: http.server
      value: proxy_set_header my_request_time "This is the custom request header we added in our SnippetsPolicy which affects the whole Gateway! This is the local time - $time_local";
EOF
```

This `SnippetsPolicy` defines a single Snippet at the `http.server` context which uses the `proxy_set_header` NGINX directive to add a custom request header. In this case, we are adding a header that uses the `$time_local` NGINX variable which represents the local time the request was processed at. The `SnippetsPolicy` targets the Gateway we deployed earlier by specifying it in the `targetRefs` field, contrasting the `SnippetsFilter` API where a Route needs to reference the filter.

Verify that the `SnippetsPolicy` is Accepted:

```shell
kubectl describe snippetspolicies.gateway.nginx.org local-time-sp
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
      Last Transition Time:  2026-01-17T00:50:58Z
      Message:               The Policy is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
Events:                      <none>
```

Verify that the Gateway has been configured correctly:

```shell
kubectl describe gateway gateway
```

You should see the following condition:

```text
Status:
  Conditions:
    Last Transition Time:  2026-01-17T00:50:58Z
    Message:               The SnippetsPolicy is applied to the resource
    Observed Generation:   1
    Reason:                PolicyAffected
    Status:                True
    Type:                  SnippetsPolicyAffected
```

### Verify request header is present

The `SnippetsPolicy` targets the Gateway, meaning all attached Routes should be affected. This means that both the coffee and tea applications should be affected and should have a request header added to any requests to them. To verify the `SnippetsPolicy` is working, we will add an ephemeral container to our backend application, then use `tcpdump` to view the incoming request's details and verify our header is present.

Add an ephemeral container to the coffee application:

```shell
kubectl debug -it <coffee pod name> --image=nicolaka/netshoot
```

Once inside the ephemeral container, run `tcmpdump`:

```shell
tcpdump -i eth0 -A -s0
```

In a different terminal, send requests to the coffee application:

```shell
curl -v --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee
```

For the response to the curl request, you can see that the response header still exists:

```text
...
* Request completely sent off
< HTTP/1.1 200 OK
< Server: nginx
< Date: Sun, 18 Jan 2026 21:39:53 GMT
< Content-Type: text/plain
< Content-Length: 160
< Connection: keep-alive
< Expires: Sun, 18 Jan 2026 21:39:52 GMT
< Cache-Control: no-cache
< request_processing_time: This is the custom response header we added in our SnippetsFilter that shows the request time in seconds - 0.000
...
```

In the terminal running `tcpdump`, you should see the request header alongside other default headers:

```text
...
GET /coffee HTTP/1.1
my_request_time: This is the custom request header we added in our SnippetsPolicy which affects the whole Gateway! This is the local time - 18/Jan/2026:21:24:18 +0000
Host: cafe.example.com:8080
X-Forwarded-For: 127.0.0.1
X-Real-IP: 127.0.0.1
X-Forwarded-Proto: http
X-Forwarded-Host: cafe.example.com
X-Forwarded-Port: 80
User-Agent: curl/8.7.1
Accept: */*
...
```

Next, verify that requests to the tea application also contain that request header:

Add an ephemeral container to the tea application:

```shell
kubectl debug -it <tea pod name> --image=nicolaka/netshoot
```

Once inside the ephemeral container, run `tcmpdump`:

```shell
tcpdump -i eth0 -A -s0
```

In a different terminal, send requests to the tea application:

```shell
curl -v --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/tea
```

For the response to the curl request, you can see that the response header added in the `SnippetsFilter` to coffee is not present:

```text
...
* Request completely sent off
< HTTP/1.1 200 OK
< Server: nginx
< Date: Sun, 18 Jan 2026 21:39:53 GMT
< Content-Type: text/plain
< Content-Length: 160
< Connection: keep-alive
< Expires: Sun, 18 Jan 2026 21:39:52 GMT
< Cache-Control: no-cache
...
```

In the terminal running `tcpdump`, you should see the request header alongside other default headers:

```text
...
GET /coffee HTTP/1.1
my_request_time: This is the custom request header we added in our SnippetsPolicy which affects the whole Gateway! This is the local time - 18/Jan/2026:21:24:18 +0000
Host: cafe.example.com:8080
X-Forwarded-For: 127.0.0.1
X-Real-IP: 127.0.0.1
X-Forwarded-Proto: http
X-Forwarded-Host: cafe.example.com
X-Forwarded-Port: 80
User-Agent: curl/8.7.1
Accept: */*
...
```

This shows the `SnippetsPolicy` affecting all of the Gateway, in contrast to the `SnippetsFilter` that only affects the coffee HTTPRoute.

## Conclusion

Snippets are a powerful tool to modifying NGINX configuration unavailable in first-class policies. This example showed a simple Snippet adding request and response headers, but Snippets can contain any valid NGINX configuration, allowing users to fully customize configuration generated by NGINX Gateway Fabric and shape their NGINX configuration to fit their needs. 

However, as Snippets grow in complexity, because NGINX Gateway Fabric does not provide validation, the risk of generating invalid configuration due to conflicts in existing configuration grows and debugging can be challenging. This is one reason to try to keep Snippet configuration minimal, and to transition to using newly supported first-class polices and APIs if they provide the same NGINX configuration.

## Troubleshooting

If a `SnippetsFilter` or `SnippetsPolicy` is applied with a Snippet which includes an invalid NGINX configuration, NGINX will continue to operate with the last valid configuration and an event with the error will be outputted. No new configuration will be applied until the invalid Snippet is fixed.

An example of an error from the NGINX Gateway Fabric `nginx-gateway` container logs:

```text
{"level":"error","ts":"2026-01-18T21:54:44Z","logger":"eventHandler","msg":"Failed to update NGINX configuration","error":"msg: Config apply failed, rolling back config; error: failed to parse config invalid number of arguments in \"proxy_set_header\" directive in /etc/nginx/includes/SnippetsPolicy_location_default-local-time-sp.conf:3","stacktrace":"github.com/nginx/nginx-gateway-fabric/v2/internal/controller.(*eventHandlerImpl).waitForStatusUpdates\n\tgithub.com/nginx/nginx-gateway-fabric/v2/internal/controller/handler.go:298"}
```

An example of an error from the NGINX Pod's `nginx` container logs:

```text
time=2026-01-18T21:54:44.249Z level=ERROR msg="errors found during config apply, sending error status, rolling back config" err="failed to parse config invalid number of arguments in \"proxy_set_header\" directive in /etc/nginx/includes/SnippetsPolicy_location_default-local-time-sp.conf:3" correlation_id=1d701a88-2119-4dd4-9c7a-2b5b95c1b93d server_type=command
```

If a Gateway is affected by a `SnippetsFilter` or `SnippetsPolicy` that creates invalid NGINX configuration, it may also contain information in its conditions describing the error:

```text
Conditions:
    Last Transition Time:  2026-01-18T21:58:47Z
    Message:               The Gateway is accepted
    Observed Generation:   1
    Reason:                Accepted
    Status:                True
    Type:                  Accepted
    Last Transition Time:  2026-01-18T21:58:47Z
    Message:               The Gateway is not programmed due to a failure to reload nginx with the configuration: msg: Config apply failed, rolling back config; error: failed to parse config invalid number of arguments in "add_header" directive in /etc/nginx/includes/SnippetsFilter_http.server.location_default_request-time-sf.conf:1
    Observed Generation:   1
    Reason:                Invalid
    Status:                False
    Type:                  Programmed
...
Listeners:
    Attached Routes:  2
    Conditions:
      ...
      Last Transition Time:  2026-01-18T21:58:47Z
      Message:               The Listener is not programmed due to a failure to reload nginx with the configuration: msg: Config apply failed, rolling back config; error: failed to parse config invalid number of arguments in "add_header" directive in /etc/nginx/includes/SnippetsFilter_http.server.location_default_request-time-sf.conf:1
      Observed Generation:   1
      Reason:                Invalid
      Status:                False
      Type:                  Programmed
```

If a Route references a `SnippetsFilter` which cannot be resolved, the route will return a 500 HTTP error response on all requests.
The Route conditions will contain information describing the error:

```text
Conditions:
      Last Transition Time:  2026-01-18T22:01:13Z
      Message:               The Route is accepted
      Observed Generation:   3
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
      Last Transition Time:  2026-01-18T22:01:13Z
      Message:               Spec.rules[0].filters[0].extensionRef: Not found: {"group":"gateway.nginx.org","kind":"SnippetsFilter","name":"request-time-sfer"}
      Observed Generation:   3
      Reason:                InvalidFilter
      Status:                False
      Type:                  ResolvedRefs
```

{{< call-out "note" >}} If you run into situations where an NGINX directive fails to be applied and the troubleshooting information here isn't sufficient, please create an issue in the [NGINX Gateway Fabric Github repository](https://github.com/nginx/nginx-gateway-fabric). {{< /call-out >}}

## See also

- [API reference]({{< ref "/ngf/reference/api.md" >}}): all configuration fields for the `SnippetsFilter` and `SnippetsPolicy` APIs.
