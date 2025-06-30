---
title: v1alpha1 RateLimit Documentation
nd-docs: DOCS-701
description: v1alpha1 RateLimit documentation.
---

## RateLimit

API Version: v1alpha1

```yaml
apiVersion: specs.smi.nginx.com/v1alpha1
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
```

In this example, requests to the destination service from `source-1` will be rate limited at the rate of 10r/m.
The burst of 10 and a delay of `nodelay` means that 10 excess requests over the rate will be forwarded to the destination service immediately.
Requests from sources other than `source-1`  will not be rate limited.


The rate limit spec contains the following fields:

- `destination`: The destination resource for the rate limit (required).

  Must provide a `name`, `kind`, and `namespace` in order to bind to the specified resource. Supported kinds: `Pod`, `Deployment`, `DaemonSet`, `StatefulSet`, and `Service`.

- `sources`: The source resources that the rate limit is applied to (optional).

  Rate limits only affect the traffic from services that are in the sources list. Services not included in this
  list are able to pass unlimited traffic to their destination(s).
  If no sources are provided then the rate limit applies to all resources making requests to the destination.

  {{<note>}} The sources do not have to be in the same namespace as the destination; cross-namespaces rate limiting is supported. {{</note>}}

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

  {{<important>}}
  If you are creating multiple rate limit policies for the same destination, the source lists for each rate limit must be distinct.
  You cannot reference the same source and destination across multiple rate limits.
  {{</important>}}

- `burst`: The number of requests to allow beyond a given rate (optional).

  Refer to the [NGINX Documentation](http://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req) for more information on burst.

- `delay`: The number of requests after which to delay requests (optional).

  Refer to the [NGINX Documentation](http://nginx.org/en/docs/http/ngx_http_limit_req_module.html#limit_req) for more information on delay.
