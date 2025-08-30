---
title: SMI Traffic Policies
toc: true
description: Learn about the traffic policies supported by F5 NGINX Service Mesh and
  how to configure them.
weight: 60
nd-docs: DOCS-698
type:
- how-to
---

## Overview

This topic discusses the various traffic policies that are supported by F5 NGINX Service Mesh. We support the SMI spec to allow for a variety of functionality within our mesh, from traffic shaping to access control. NGINX Service Mesh provides additional traffic policies to extend on the SMI spec. This topic provides examples of how you can use the SMI spec and NGINX custom resources with NGINX Service Mesh to apply policies and control your traffic.

Refer to the [SMI GitHub repo](https://github.com/servicemeshinterface/smi-spec) to find out more about the SMI spec and how to configure it.

{{< call-out "note" >}}
Avoid configuring traffic policies such as TrafficSplits, RateLimits, and CircuitBreakers for headless services.
These policies will not work as expected because NGINX Service Mesh has no way to tie each pod IP address to its headless service.
{{< /call-out >}}

## SMI Specification

### Traffic Splitting

<!-- vale off -->

You can use the SMI [TrafficSplit spec](https://github.com/servicemeshinterface/smi-spec/blob/master/apis/traffic-split/v1alpha3/traffic-split.md) to implement Canary, A/B testing, and other traffic routing setups.

<!-- vale on -->

NGINX Service Mesh is also compatible with Flagger and other SMI-compatible projects.

The [Deployments using Traffic Splitting]( {{< ref "/mesh/tutorials/trafficsplit-deployments.md" >}} ) tutorial provides a walkthrough of using traffic splits in a deployment.

{{< call-out "note" >}}
The NGINX Plus Ingress Controller's custom resource [TransportServer](https://docs.nginx.com/nginx-ingress-controller/configuration/transportserver-resource/) has the same Kubernetes short name (`ts`) as the custom resource TrafficSplit.
If you install the NGINX Plus Ingress Controller, use the full names `transportserver(s)` and `trafficsplit(s)` when managing these resources with `kubectl`.
{{< /call-out >}}

#### Traffic Split Matches

The [TrafficSplit spec](https://github.com/servicemeshinterface/smi-spec/blob/master/apis/traffic-split/v1alpha3/traffic-split.md) outlines how you can split traffic based on headers in order to implement A/B testing.
NGINX Service Mesh expands on this concept by allowing you to split traffic based on the path, HTTP methods, and/or headers of a request.
This is achieved by specifying `matches` that associate HTTPRouteGroups with your traffic split policy.

```yaml
apiVersion: split.smi-spec.io/v1alpha3
kind: TrafficSplit
metadata:
  name: target
spec:
  service: target-svc
  backends:
  - service: target-v1
    weight: 0
  - service: target-v2
    weight: 1
  - service: target-v3
    weight: 0
  matches:
  - kind: HTTPRouteGroup
    name: target-route-group
---
 apiVersion: specs.smi-spec.io/v1alpha3
 kind: HTTPRouteGroup
 metadata:
   name: target-route-group
   namespace: default
 spec:
   matches:
   - name: metrics
     pathRegex: "/metrics"
     methods:
     - GET
  - name: test-header
    headers:
      x-test: "^true$"
```

This example associates all matches defined in the `target-route-group` to the `target` TrafficSplit. When a request is sent to the `target-svc`, if it's a GET request to the `/metrics` endpoint or has the `x-test:true` header set, the traffic split is applied and the request is routed to the `target-v2` service.
All other requests will be sent to the root `target-svc`, which will forward the request to one of the target services based on the load-balancing algorithm of the mesh.

{{< call-out "note" >}}
If there are multiple matches defined in a HTTPRouteGroup, or multiple HTTPRouteGroups listed in the TrafficSplit `spec.matches` field, then all the matches across all HTTPRouteGroups will be attached to the TrafficSplit.
Matches are evaluated with the `OR` operation, meaning that a request only needs to satisfy one of the matches in order for the traffic split to be applied.
{{< /call-out >}}

Services named in a TrafficSplit definition should not forward to an overlapping set of Pods. In other words, using the example above, `target-v1` and `target-v2` should have unique selectors to ensure they are forwarding to different sets of Pods. This avoids any unintentional or confusing traffic flow to incorrect destinations.

In another example, the spec above could be changed to set `target-v1` as the root default service, rather than `target-svc`. With this configuration, all traffic that matches the HTTPRouteGroup rules will be sent to `target-v2`, while all unmatched traffic will be sent to `target-v1`.

For more information about HTTPRouteGroups see the SMI [Traffic Specs guide](https://github.com/servicemeshinterface/smi-spec/blob/main/apis/traffic-specs/v1alpha3/traffic-specs.md).

### Access Control

<!-- vale off -->
You can use the SMI [Traffic Access](https://github.com/servicemeshinterface/smi-spec/blob/master/apis/traffic-access/v1alpha2/traffic-access.md) spec to define access to applications throughout your cluster. Keep in mind that you must use this spec in conjunction with SMI [Specs](https://github.com/servicemeshinterface/smi-spec/blob/master/apis/traffic-specs/v1alpha3/traffic-specs.md) to fully define access control in the mesh.
<!-- vale on -->

#### Access Control Rules

The [Traffic Access spec](https://github.com/servicemeshinterface/smi-spec/blob/main/apis/traffic-access/v1alpha2/traffic-access.md) describes how you can define L7 rules for your access control policies with HTTPRouteGroups.

HTTPRouteGroup rules are picked on a `first match` basis. A match is the first rule that satisfies all criteria
(`pathRegex`, `methods`, `headers`, and `port`) for a request. Matches should be defined in order
from most specific to least specific to ensure the `first match` policy picks the best option.

This match policy works on a per TrafficTarget basis. If multiple TrafficTargets reference the same destination
and same sources, rule ordering is not guaranteed. Ensure that a single TrafficTarget contains all appropriate
rules for a destination and source.

The [Services using Access Control]({{< ref "/mesh/tutorials/accesscontrol-walkthrough.md" >}}) tutorial provides a walkthrough of using access control between services.

## NGINX SMI Extensions

### Rate Limiting

API Version: v1alpha2

The [Configure Rate Limiting]({{< ref "/mesh/tutorials/ratelimit-walkthrough.md" >}}) tutorial provides a walkthrough of setting up rate limiting between workloads.

You can configure rate limiting between your workloads in NGINX Service Mesh by creating a RateLimit resource.

```yaml
 apiVersion: specs.smi.nginx.com/v1alpha2
 kind: RateLimit
 metadata:
   name: ratelimit-v1
   namespace: default
 spec:
   destination:
     kind: Service
     name: dest-svc
     namespace: default
   sources:
     - kind: Deployment
       name: source-1
       namespace: default
   name: 10rm
   rate: 10r/m
   burst: 10
   delay: "nodelay"
   rules:
     - kind: HTTPRouteGroup
       name: hrg
       matches:
         - get-only
---
 apiVersion: specs.smi-spec.io/v1alpha3
 kind: HTTPRouteGroup
 metadata:
   name: hrg
   namespace: default
 spec:
   matches:
     - name: get-only
       methods:
         - GET
     - name: v2
       pathRegex: "/configuration-v2"
       headers:
         X-DEMO: "^true$"
       methods:
         - GET
```

In this example, `GET` requests to the destination service from `source-1` will be rate limited at the rate of 10r/m.
The burst of 10 and a delay of `nodelay` means that 10 excess requests over the rate will be forwarded to the destination service immediately.
Requests from sources other than `source-1`, or requests from `source-1` that are _not_ `GET` requests, will not be rate limited.

> You can download the schema for the RateLimit CRD here: {{< icon "download" >}} [`rate-limit-schema.yaml`](https://github.com/nginxinc/nginx-service-mesh/blob/main/helm-chart/crds/ratelimit.yaml)

The rate limit spec contains the following fields:

- `destination`: The destination resource for the rate limit (required).

  Must provide a `name`, `kind`, and `namespace` in order to bind to the specified resource. Supported kinds: `Pod`, `Deployment`, `DaemonSet`, `StatefulSet`, and `Service`.
- `sources`: The source resources that the rate limit is applied to (optional).

  Rate limits only affect the traffic from services that are in the sources list. Services not included in this
  list are able to pass unlimited traffic to their destination(s).
  If no sources are provided then the rate limit applies to all resources making requests to the destination.

  {{< call-out "note" >}} The sources do not have to be in the same namespace as the destination; cross-namespaces rate limiting is supported. {{< /call-out >}}

- `name`: The name of the rate limit (required).
- `rate`: The rate to restrict traffic to (required). Example: "1r/s", "30r/m"

  Each Pod in the destination accepts the total rate defined in a rate limit policy. If a policy has
  a rate of 100 r/m, and the destination consists of 3 Pods, each Pod accepts 100 r/m.

  If a single rate limit policy contains multiple sources, the rate divides evenly amongst them. For
  example, a policy defined with

  ```yaml
  destination:
    name: destService
  sources:
  - name: source1
  - name: source2
  rate: 100 r/m
  ```

  would result in `destService` accepting 50 requests per minute from `source1`, and 50 requests per minute
  from `source2`, for a total rate of 100 requests per minute. If two separate policies are defined for the
  same destination, then the rate is not divided amongst the sources.

  {{< call-out "important" >}}
  If you are creating multiple rate limit policies for the same destination, the source lists for each rate limit must be distinct.
  You cannot reference the same source and destination across multiple rate limits.
  {{< /call-out >}}

- `burst`: The number of requests to allow beyond a given rate (optional).

   Refer to the [NGINX Documentation](http://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req) for more information on burst.

- `delay`: The number of requests after which to delay requests (optional).

   Refer to the [NGINX Documentation](http://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req) for more information on delay.

- `rules`: A list of routing rules (optional).

  RateLimit `rules` allow you to configure rate limiting based on the path, HTTP methods, and/or headers of a request.
  The `rules` field is a list of [HTTPRouteGroups](https://github.com/servicemeshinterface/smi-spec/blob/main/apis/traffic-specs/v1alpha3/traffic-specs.md) with an optional `matches` field.
  The `matches` field allows you to specify one or more matches from a particular HTTPRouteGroup. If the `matches` field is omitted, then all matches from the HTTPRouteGroup are attached to the RateLimit.

  {{< call-out "important" >}}HTTPRouteGroups must be in the same namespace as the RateLimit.{{< /call-out >}}

  {{< call-out "note" >}}
  If there are multiple matches defined in an HTTPRouteGroup, or multiple HTTPRouteGroups listed in the RateLimit `spec.rules` field, then all the matches across all HTTPRouteGroups will be attached to the RateLimit.
  Matches are evaluated with the OR operation, meaning that a request only needs to satisfy one of the matches in order for the rate limit to be applied.
  {{< /call-out >}}

Documentation for the v1alpha1 RateLimit can be found [here]({{< ref "v1alpha1-ratelimit.md" >}}).

#### Default rate limit policies

If you would like to enforce one rate limit policy for all requests made to a destination, you can omit the `sources` field from your rate limit spec.

```yaml
 apiVersion: specs.smi.nginx.com/v1alpha2
 kind: RateLimit
 metadata:
   name: dest-svc-default
   namespace: default
 spec:
   destination:
     kind: Service
     name: dest-svc
     namespace: default
   name: 10rs
   rate: 10r/s
```

The above configuration will restrict all traffic sent to `dest-svc` to 10 requests per second.

You can also create additional rate limit policies for `dest-svc` with `sources` defined, and the default policy will only apply if the source of the traffic is not listed in another policy.
For example, if you have a source that sends bursts of requests to `dest-svc`, you might create the following rate limit:

```yaml
 apiVersion: specs.smi.nginx.com/v1alpha2
 kind: RateLimit
 metadata:
   name: dest-svc-bursty
   namespace: default
 spec:
   destination:
     kind: Service
     name: dest-svc
     namespace: default
   sources:
     kind: Deployment
     name: bursty-src
     namespace: default
   name: 10rs
   rate: 10r/s
   burst: 10
```

The `dest-svc-bursty` rate limit will allow a burst of 10 requests to get through to the `dest-svc` only if the requests are from `bursty-src`. All other requests will be limited according to the `dest-svc-default` rate limit policy.

#### Rate limit conflicts

Multiple rate limit policies are allowed for the same destination, but the source lists for each rate limit must be distinct. You cannot reference the same source and destination across multiple rate limits.
The NGINX Service Mesh control plane's [admission webhook](https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/#what-are-admission-webhooks) will reject rate limits that reference the same source and destination as an existing rate limit.
However, the admission webhook can only compare the resource definitions (`Kind`, `Namespace`, and `Name`)  of the destination and sources in order to determine if there's a conflict with an existing rate limit.
For example, consider the following rate limits:

```yaml
apiVersion: specs.smi.nginx.com/v1alpha2
kind: RateLimit
metadata:
 name: limit-1
 namespace: default
spec:
  destination:
    kind: Service
    name: dest-svc
    namespace: default
  sources:
  - kind: Service
    name: src-1
    namespace: default
```

```yaml
apiVersion: specs.smi.nginx.com/v1alpha2
kind: RateLimit
metadata:
  name: limit-2
  namespace: default
spec:
  destination:
    kind: Deployment
    name: dest-svc
    namespace: default
  sources:
    - kind: Service
      name: src-1
      namespace: default
```

Let's say that we create `limit-1` first and `limit-2` second. The admission webhook will allow both limits to be created, because even though the sources are the same, the destinations are different.
If the control plane later determines that the IP addresses between the two destinations are the same, `limit-2` will not be configured and the control plane will emit an `UpsertRateLimitFailed` event on the rate limit object.

To check for misconfiguration events, you can describe the rate limit:

```bash
kubectl describe ratelimit <rate limit name>
```

### Circuit Breaking

API Version: v1alpha1

You can enable circuit breaking by creating a CircuitBreaker resource.
A circuit breaker requires a destination and an associated spec. The destination takes a `name`, `kind`, and `namespace` in order to bind to a selected resource.

{{< call-out "note" >}}
Currently, only `kind: Service` is supported.
{{< /call-out >}}

The circuit breaker spec has three custom fields:

- `errors`: The number of errors before the circuit trips.
- `timeoutSeconds`: The window for errors to occur within before tripping the circuit. Also the amount of time
to wait before closing the circuit.
- `fallback`: The name and port of a Kubernetes Service to re-route traffic to after the circuit has been tripped.

   Example:

   ```yaml
   fallback:
      name: "my-namespace/fallback-svc"
      port: 8080
   ```

   If no namespace or port is specified, default values are `default` and `80`, respectively.

{{< call-out "important" >}}
The destination and fallback services must be in the same namespace. The fallback service must be [injected with the sidecar proxy]( {{< ref "/mesh/guides/inject-sidecar-proxy.md" >}} ).
{{< /call-out >}}

{{< call-out "important" >}}
If Circuit Breakers are configured, the load balancing algorithm `random` cannot be used. Combining Circuit Breakers with `random` load balancing will cause sidecars to exit with an error. Data flow will be affected.

To avoid this issue, use a different load balancing algorithm. See the [Configuration]({{< ref "/mesh/get-started/install/configuration.md" >}}) guide.
{{< /call-out >}}

{{< call-out "important" >}}
If a Traffic Split is applied to the same service that a Circuit Breaker is defined for, the Circuit Breaker may no longer function as intended. This is because the Traffic Split changes the destination service to a backend service, not the original root destination for which the Circuit Breaker is defined. Therefore, Circuit Breakers must be defined for each backend service individually.
{{< /call-out >}}

> You can download our Circuit Breaker example here: {{< link "/examples/circuit-breaker/circuit-breaker.yaml" "circuit-breaker.yaml" >}} and the Circuit Breaker schema here: [`circuit-breaker-schema.yaml`](https://github.com/nginxinc/nginx-service-mesh/blob/main/helm-chart/crds/circuitbreaker.yaml)

Refer to the [NGINX Documentation](https://nginx.org/en/docs/http/ngx_http_upstream_module.html#server) for more information about the `max_fails`, `fail_timeout`, and `backup` parameters, which are used for circuit breaking.
