---
title: Configure external authentication
weight: 600
toc: true
nd-content-type: how-to
nd-product: FABRIC
nd-description: How to configure external authentication in NGINX Gateway Fabric using the `ExternalAuth` filter on HTTPRoute.
nd-summary: >
  NGINX Gateway Fabric supports external authentication via the `ExternalAuth` filter on an HTTPRoute.
  Before proxying a request to the backend, NGINX performs an authorization subrequest to an external service.
  A 2xx response allows the request through, and any other status rejects it.
  This feature uses the NGINX [ngx_http_auth_request_module](https://nginx.org/en/docs/http/ngx_http_auth_request_module.html).
---

This guide describes how to configure external authentication in NGINX Gateway Fabric using the `ExternalAuth` filter on an HTTPRoute.

External authentication delegates the authorization decision for each request to an external service. NGINX issues a subrequest to that service before proxying the original request, and forwards the request only if the service responds with a 2xx status.

By following these instructions, you will create two sample applications. The `coffee` endpoint is protected by an `ExternalAuth` filter, and the `tea` endpoint is exposed without any external authentication filter, so you can compare the behavior of each.

## Overview

The `ExternalAuth` filter is declared in the `filters` list of an HTTPRoute rule. When NGINX processes a request that matches the rule, it first sends a subrequest to the backend referenced by the filter. Based on the status returned by that backend, NGINX either forwards the original request to the route's `backendRefs` or returns the error status to the client.

Each route rule supports only one `ExternalAuth` filter. If your authentication flow requires multiple checks, consolidate them into a single authentication service that performs all the necessary validations.

The filter translates to NGINX's [ngx_http_auth_request_module](https://nginx.org/en/docs/http/ngx_http_auth_request_module.html) directives:

- [`auth_request`](https://nginx.org/en/docs/http/ngx_http_auth_request_module.html#auth_request) — sends a subrequest to the specified URI and grants or denies access based on the response status.
- [`auth_request_set`](https://nginx.org/en/docs/http/ngx_http_auth_request_module.html#auth_request_set) — captures a value from the authentication response and stores it in a variable for use in the main request.

## Note on Gateway API Experimental Features

{{< call-out "important" >}} ExternalAuth is a Gateway API resource from the experimental release channel. {{< /call-out >}}

{{< include "/ngf/installation/install-gateway-api-experimental-features.md" >}}

## Before you begin

- [Install]({{< ref "/ngf/install/" >}}) NGINX Gateway Fabric with experimental features enabled.

## Deploy sample applications

Run the following `kubectl apply` command to create the `coffee` and `tea` deployments and services:

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

To confirm the application pods are running, run `kubectl get`:

```shell
kubectl get pods
```

```text
NAME                      READY   STATUS    RESTARTS   AGE
coffee-654ddf664b-fllj7   1/1     Running   0          21s
tea-75bc9f4b6d-cx2jl      1/1     Running   0          21s
```

## Create a Gateway

Run the following `kubectl apply` command to create a Gateway:

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

Confirm the Gateway was assigned an IP address and reports a `Programmed=True` status with `kubectl describe`:

```shell
kubectl describe gateways.gateway.networking.k8s.io gateway
```

```text
Addresses:
  Type:   IPAddress
  Value:  10.96.20.187
```

Save the public IP address and port of the Gateway into shell variables:

```shell
GW_IP=XXX.YYY.ZZZ.III
GW_PORT=<port number>
```

## Deploy the external authentication server

This sample authentication service is an NGINX deployment that checks the `X-Api-Key` request header. If the header value is `my-custom-secret`, the server responds with `200 OK`; otherwise it responds with `401 Unauthorized`.

```yaml
kubectl apply -f - <<'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: ext-auth-config
data:
  default.conf: |
    server {
        listen 8080;

        location / {
            if ($http_x_api_key != "my-custom-secret") {
                return 401 "unauthorized";
            }
            return 200 "ok";
        }
    }
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ext-auth-server
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ext-auth-server
  template:
    metadata:
      labels:
        app: ext-auth-server
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 8080
        volumeMounts:
        - name: config
          mountPath: /etc/nginx/conf.d
      volumes:
      - name: config
        configMap:
          name: ext-auth-config
---
apiVersion: v1
kind: Service
metadata:
  name: ext-auth-server
spec:
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
    name: http
  selector:
    app: ext-auth-server
EOF
```

## Configure routing with the ExternalAuth filter

Run the following `kubectl apply` command to create an HTTPRoute for `coffee` and `tea` applications. The `coffee` route uses an `ExternalAuth` filter to require authentication, while the `tea` route is exposed without one:

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
    - type: ExternalAuth
      externalAuth:
        protocol: HTTP
        backendRef:
          name: ext-auth-server
          port: 80
        http:
          path: /
          allowedHeaders:
          - X-Api-Key
        forwardBody:
          maxSize: 1024
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

`backendRef` and `http.path` identify the authentication service and the URI that receives the subrequest. `http.allowedHeaders` lists the client headers that are forwarded to the authentication service. `forwardBody.maxSize` sets the largest request body the gateway will accept and forward; anything larger is rejected with `413 Request Entity Too Large`.

{{< call-out "note" >}}
By default, no headers from the authentication server response are copied onto the proxied request. To forward headers such as a user ID or role from the authentication server to the backend, list them explicitly in `allowedResponseHeaders`.
{{< /call-out >}}

Verify both HTTPRoutes are accepted with `kubectl describe`:

```shell
kubectl describe httproute coffee | grep "Status:" -A10
```

```text
Status:
  Parents:
    Conditions:
      Last Transition Time:  2026-04-16T15:18:55Z
      Message:               The Route is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
      Last Transition Time:  2026-04-16T15:18:55Z
      Message:               All references are resolved
      Observed Generation:   1
      Reason:                ResolvedRefs
      Status:                True
      Type:                  ResolvedRefs
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
```

## Verify external authentication

{{< call-out "note" >}}

Your clients should be able to resolve "cafe.example.com" to the public IP of the NGINX Service.

This guide simulates that using curl's `--resolve` option.

{{< /call-out >}}

Access `/coffee` without an API key:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee
```

```text
<html>
<head><title>401 Authorization Required</title></head>
<body>
<center><h1>401 Authorization Required</h1></center>
<hr><center>nginx</center>
</body>
</html>
```

Access `/coffee` with a valid API key:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee -H "X-Api-Key: my-custom-secret"
```

```text
Server address: 10.244.0.151:8080
Server name: coffee-654ddf664b-l9ml5
Date: 16/Apr/2026:20:14:28 +0000
URI: /coffee
Request ID: 217931bc5fe27254d1821cec91e1f2d8
```

The `X-Api-Key` header is listed in `allowedHeaders`, so it reaches the authentication server, which responds `200 OK`. NGINX then proxies the request to the `coffee` backend.

Access `/tea`, which has no `ExternalAuth` filter and responds normally:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/tea
```

```text
Server address: 10.244.0.149:8080
Server name: tea-75bc9f4b6d-q5wg5
Date: 16/Apr/2026:20:14:41 +0000
URI: /tea
Request ID: d27f6ef4edc2f1e09bb455824ac67a07
```

### Exceed the body size limit

Because `forwardBody.maxSize: 1024` is applied as `client_max_body_size` on the `/coffee` location, any client request with a body larger than 1024 bytes is rejected with `413 Request Entity Too Large` before the authorization subrequest runs. Send a 1100-byte body to demonstrate this:

```shell
BODY=$(head -c 1100 /dev/zero | tr '\0' 'x')
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee -X POST -H "X-Api-Key: my-custom-secret" -d "$BODY"
```

```text
<html>
<head><title>413 Request Entity Too Large</title></head>
<body>
<center><h1>413 Request Entity Too Large</h1></center>
<hr><center>nginx</center>
</body>
</html>
```

`client_max_body_size` can also be set on a route through a [ClientSettingsPolicy]({{< ref "/ngf/traffic-management/client-settings.md" >}}) via its `body.maxSize` field. If a ClientSettingsPolicy with `body.maxSize` is attached to the same HTTPRoute as an `ExternalAuth` filter that sets `forwardBody.maxSize`, the HTTPRoute is marked invalid with reason `InvalidFilter`.

## Troubleshooting

- If the HTTPRoute is not accepted, run `kubectl describe httproute coffee` and check the `Status` conditions for validation errors.
- If every request returns `401`, confirm that the authentication server is reachable from the NGINX pod and that the `backendRef` name, namespace, and port are correct.
- If a required request header is not reaching the authentication server, confirm it is listed in `http.allowedHeaders`.
- If a response header from the authentication server is not reaching the backend, confirm it is listed in `http.allowedResponseHeaders`.
- If a request is rejected with `413 Request Entity Too Large`, raise `forwardBody.maxSize` to accommodate the client body.
- If the HTTPRoute reports `ResolvedRefs: False` with an `InvalidFilter` reason mentioning `body.maxSize`, remove either the `ExternalAuth` filter's `forwardBody.maxSize` or the ClientSettingsPolicy's `body.maxSize` as they both cannot be set on the same route.

## Further reading

- [NGINX HTTP auth request module](https://nginx.org/en/docs/http/ngx_http_auth_request_module.html)
- [Gateway API HTTPExternalAuthFilter specification](https://gateway-api.sigs.k8s.io/reference/spec/#httpexternalauthfilter)
