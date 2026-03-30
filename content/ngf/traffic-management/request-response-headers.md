---
title: Modify HTTP request and response headers
weight: 500
toc: true
nd-content-type: how-to
nd-product: FABRIC
nd-docs: DOCS-1849
---

Learn how to modify the request and response headers of your application using NGINX Gateway Fabric.

## Overview

[HTTP Header Modifiers](https://gateway-api.sigs.k8s.io/guides/http-header-modifier/?h=request#http-header-modifiers) can be used to add, modify or remove headers during the request-response lifecycle. The [RequestHeaderModifier](https://gateway-api.sigs.k8s.io/guides/http-header-modifier/#http-request-header-modifier) is used to alter headers in a request sent by client and [ResponseHeaderModifier](https://gateway-api.sigs.k8s.io/guides/http-header-modifier/#http-response-header-modifier) is used to alter headers in a response to the client.

This guide describes how to configure the headers application to modify the headers in the request. Another version of the headers application is then used to modify response headers when client requests are made. For an introduction to exposing your application, we recommend that you follow the [basic guide]({{< ref "/ngf/traffic-management/basic-routing.md" >}}) first.

## Before you begin

- [Install]({{< ref "/ngf/install/" >}}) NGINX Gateway Fabric.

## HTTP Header Modifiers examples

The following examples use a shared Gateway for both `RequestHeaderModifier` and `ResponseHeaderModifier` filters. Header values can be plain strings or NGINX variable names such as `$remote_addr` or `$request_method`. NGINX variable support requires NGINX Gateway Fabric version 2.6 or above.

### Deploy the Gateway API resources for the Header application

The [Gateway](https://gateway-api.sigs.k8s.io/api-types/gateway/) resource is typically deployed by the [Cluster Operator](https://gateway-api.sigs.k8s.io/concepts/roles-and-personas/#roles-and-personas_1). This Gateway defines a single listener on port 80. Since no hostname is specified, this listener matches on all hostnames. To deploy the Gateway:

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

{{< call-out "note" >}}

In a production environment, you should have a DNS record for the external IP address that is exposed, and it should refer to the hostname that the gateway will forward for.

{{< /call-out >}}

## RequestHeaderModifier example

This examples demonstrates how to configure traffic routing for a simple echo server. A HTTPRoute resource is used to route traffic to the headers application, using the `RequestHeaderModifier` filter to modify headers in the request. You can then verify that the server responds with the modified request headers.

### Deploy the Headers application

Begin by deploying the example application `headers`. It is a simple application that returns the request headers which will be modified later.

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/examples/http-request-header-filter/headers.yaml
```

This will create the headers Service and a Deployment with one Pod. Run the following command to verify the resources were created:

```shell
kubectl get pods,svc
```

```text
pod/headers-545698447b-z52kj   1/1     Running   0          23s

NAME                 TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
service/headers      ClusterIP   10.96.26.161   <none>        80/TCP    23s
```

### Configure the HTTPRoute with RequestHeaderModifier filter

Create a HTTPRoute that exposes the header application outside the cluster using the listener created in the previous section. Use the following command:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: headers
spec:
  parentRefs:
  - name: gateway
    sectionName: http
  hostnames:
  - "echo.example.com"
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /headers
    filters:
    - type: RequestHeaderModifier
      requestHeaderModifier:
        set:
        - name: My-Overwrite-Header
          value: this-is-the-only-value
        - name: X-Client-IP
          value: $remote_addr
        add:
        - name: Accept-Encoding
          value: compress
        - name: My-Cool-header
          value: this-is-an-appended-value
        - name: X-Request-Method
          value: $request_method
        remove:
        - User-Agent
    backendRefs:
    - name: headers
      port: 80
EOF
```

This HTTPRoute has a few important properties:

- The `parentRefs` references the Gateway resource that we created, and specifically defines the `http` listener to attach to, via the `sectionName` field.
- `echo.example.com` is the hostname that is matched for all requests to the backends defined in this HTTPRoute.
- The `match` rule defines that all requests with the path prefix `/headers` are sent to the `headers` Service.
- It has a `RequestHeaderModifier` filter defined for the path prefix `/headers`. This filter:

  1. Sets `My-Overwrite-Header` to `this-is-the-only-value` and `X-Client-IP` to the value of `$remote_addr`.
  1. Appends `compress` to `Accept-Encoding`, `this-is-an-appended-value` to `My-Cool-header`, and the value of `$request_method` to `X-Request-Method`.
  1. Removes `User-Agent` header.

### Send traffic to the Headers application

To access the application, use `curl` to send requests to the `headers` Service, which includes headers within the request.

```shell
curl -s --resolve echo.example.com:$GW_PORT:$GW_IP http://echo.example.com:$GW_PORT/headers -H "My-Cool-Header:my-client-value" -H "My-Overwrite-Header:dont-see-this" -H "X-Request-Method:POST"
```

```text
Headers:
  header 'Accept-Encoding' is 'compress'
  header 'My-cool-header' is 'my-client-value,this-is-an-appended-value'
  header 'X-Request-Method' is 'POST,GET'
  header 'My-Overwrite-Header' is 'this-is-the-only-value'
  header 'X-Client-IP' is '127.0.0.1'
  header 'Host' is 'echo.example.com:8080'
  header 'X-Forwarded-For' is '127.0.0.1'
  header 'X-Real-IP' is '127.0.0.1'
  header 'X-Forwarded-Proto' is 'http'
  header 'X-Forwarded-Host' is 'echo.example.com'
  header 'X-Forwarded-Port' is '80'
  header 'Accept' is '*/*'
```

In the output above, you can see that the headers application modifies the following custom headers:

- `User-Agent` header is absent.
- The header `My-Cool-header` gets appended with the new value `my-client-value`.
- The header `X-Request-Method` is appended with the value `GET`, resolved from the `$request_method` variable.
- The header `X-Client-IP` is set to `127.0.0.1`, the remote address of the client that sent the request resolved from the `$remote_addr` variable.
- The header `My-Overwrite-Header` gets overwritten from `dont-see-this` to `this-is-the-only-value`.
- The header `Accept-encoding` remains unchanged as we did not modify it in the curl request sent.

### Delete the resources

Delete the headers application and HTTPRoute: another instance will be used for the next examples.

```shell
kubectl delete httproutes.gateway.networking.k8s.io headers
```

```shell
kubectl delete -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/examples/http-request-header-filter/headers.yaml
```

## ResponseHeaderModifier example

Begin by configuring an application with custom headers and a simple HTTPRoute. The server response can be observed see its headers. The next step is to modify some of the headers using HTTPRoute filters to modify responses. Finally, verify the server responds with the modified headers.

### Deploy the Headers application

Begin by deploying the example application `headers`. It is a simple application that adds response headers that will be modified later.

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/nginx-gateway-fabric/v{{< version-ngf >}}/examples/http-response-header-filter/headers.yaml
```

This will create the headers Service and a Deployment with one Pod. Run the following command to verify the resources were created:

```shell
kubectl get pods,svc
```

```text
NAME                          READY   STATUS    RESTARTS   AGE
pod/headers-6f854c478-hd2jr   1/1     Running   0          95s

NAME                 TYPE        CLUSTER-IP    EXTERNAL-IP   PORT(S)   AGE
service/headers      ClusterIP   10.96.15.12   <none>        80/TCP    95s
```

### Configure the basic HTTPRoute

Create a HTTPRoute that exposes the header application outside the cluster using the listener created in the previous section. You can do this with the following command:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: headers
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
        value: /headers
    backendRefs:
    - name: headers
      port: 80
EOF
```

This HTTPRoute has a few important properties:

- The `parentRefs` references the Gateway resource that we created, and specifically defines the `http` listener to attach to, via the `sectionName` field.
- `cafe.example.com` is the hostname that is matched for all requests to the backends defined in this HTTPRoute.
- The `match` rule defines that all requests with the path prefix `/headers` are sent to the `headers` Service.

### Send traffic to the Headers application

Use `curl` with the `-i` flag to access the application and include the response headers in the output:

```shell
curl -i --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/headers
```

```text
HTTP/1.1 200 OK
Server: nginx
Date: Mon, 30 Mar 2026 21:24:25 GMT
Content-Type: text/plain
Content-Length: 2
Connection: keep-alive
X-Header-Unmodified: unmodified
X-Header-Add: add-to
X-Header-Set: overwrite
X-Header-Remove: remove
X-Real-IP: 10.244.0.53

ok
```

In the output above, you can see that the headers application adds the following custom headers to the response:

- X-Header-Unmodified: unmodified
- X-Header-Add: add-to
- X-Header-Set: overwrite
- X-Header-Remove: remove
- X-Real-IP: set to the value of `$server_addr`, the IP address of the server that accepted the request.

The next section will modify these headers by adding a ResponseHeaderModifier filter to the headers HTTPRoute.

### Update the HTTPRoute to modify the Response headers

Update the HTTPRoute by adding a `ResponseHeaderModifier` filter:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: headers
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
        value: /headers
    filters:
    - type: ResponseHeaderModifier
      responseHeaderModifier:
        set:
        - name: X-Header-Set
          value: overwritten-value
        - name: X-Real-IP
          value: $remote_addr
        add:
        - name: X-Header-Add
          value: this-is-the-appended-value
        - name: X-Request-ID
          value: $request_id
    backendRefs:
    - name: headers
      port: 80
EOF
```

Notice that this HTTPRoute has a `ResponseHeaderModifier` filter defined for the path prefix `/headers`. This filter:

- Sets the value for the header `X-Header-Set` to `overwritten-value`.
- Overwrites the value for the header `X-Real-IP` to `$remote_addr` variable.
- Adds the value `this-is-the-appended-value` to the header `X-Header-Add`.
- Adds the value `$request_id` to the header `X-Request-ID`.
- Removes `X-Header-Remove` header.

### Send traffic to the modified Headers application

Send a curl request to the modified `headers` application to verify the response headers are modified.

```shell
curl -i --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/headers
```

```text
HTTP/1.1 200 OK
Server: nginx
Date: Mon, 30 Mar 2026 21:26:40 GMT
Content-Type: text/plain
Content-Length: 2
Connection: keep-alive
X-Header-Unmodified: unmodified
X-Header-Add: add-to
X-Header-Add: this-is-the-appended-value
X-Request-ID: dad7ece8fd0d1cb83301be8a361a55b1
X-Header-Set: overwritten-value
X-Real-IP: 127.0.0.1

ok
```

The output confirms the filter was applied. `X-Header-Unmodified` is unchanged because it was not included in the filter. `X-Header-Remove` is absent. `X-Header-Add` appears twice with both the original and appended values. `X-Header-Set` is overwritten to `overwritten-value`. `X-Real-IP` is overwritten with the resolved value of `$remote_addr`, the client's IP address. `X-Request-ID` is added with the resolved value of `$request_id`.

## See also

To learn more about the Gateway API and the resources we created in this guide, check out the following Kubernetes documentation resources:

- [Gateway API Overview](https://gateway-api.sigs.k8s.io/concepts/api-overview/)
- [Deploying a simple Gateway](https://gateway-api.sigs.k8s.io/guides/simple-gateway/)
- [Gateway API HTTP Header Modifier](https://gateway-api.sigs.k8s.io/guides/http-header-modifier/)
