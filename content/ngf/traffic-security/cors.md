---
title: Configure Cross-Origin Request Sharing (CORS)
weight: 900
toc: true
nd-content-type: how-to
nd-product: FABRIC
---


This page describes how to configure the HTTPCORSFilter in NGINX Gateway Fabric to handle Cross-Origin Resource Sharing (CORS) for your applications.

CORS is a security feature that allows or denies web applications running at one domain to make requests for resources from a different domain. The HTTPCORSFilter in Gateway API provides a standard way to configure CORS policies.

## Before you begin

- [Install]({{< ref "/ngf/install/" >}}) NGINX Gateway Fabric.

## Deploy sample application

To deploy the `coffee` application, run the following YAML with `kubectl apply`:

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
EOF
```

To confirm the application pods are availble, run `kubectl get`:

```shell
kubectl get pods
```

```text
NAME                      READY   STATUS    RESTARTS   AGE
coffee-654ddf664b-fzzrf   1/1     Running   0          5s
```

### Create a Gateway

To create your Gateway resource and provision the NGINX pod, run the following YAML with `kubectl apply`:

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


Confirm the Gateway was assigned an IP address and reports a `Programmed=True` status with `kubectl describe`:

```shell
kubectl describe gateways.gateway.networking.k8s.io gateway | grep "Addresses:" -A2
```

```text
Addresses:
  Type:   IPAddress
  Value:  10.96.20.187
```

Save the public IP address and port(s) of the Gateway into shell variables:

```text
GW_IP=XXX.YYY.ZZZ.III
GW_PORT=<port number>
```

## Deploy a HTTPRoute with the HTTPCORSFilter

In this example, the filter is applied to the `/coffee` path: run the following YAML with `kubectl apply`

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: coffee-cors
spec:
  parentRefs:
  - name: gateway
  hostnames:
  - "cafe.example.com"
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /coffee
    filters:
    - type: CORS
      cors:
        allowOrigins:
        - "https://foobar*.com"
        - "https://example.com"
        allowMethods:
        - GET
        - POST
        allowHeaders:
        - "Keep-Alive"
        - "Content-Type"
        - "User-Agent"
        - "Authorization"
        exposeHeaders:
        - "Content-Security-Policy"
        allowCredentials: true
        maxAge: 10
    backendRefs:
    - name: coffee
      port: 80
```

Verify the HTTPRoute is _Accepted_ and there are no errors with `kubectl describe`:

```shell
kubectl describe httproute coffee-cors | grep "Status:" -A10
```

```text
Status:
  Parents:
    Conditions:
      Last Transition Time:  2026-02-18T10:25:36Z
      Message:               The Route is accepted
      Observed Generation:   3
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
      Last Transition Time:  2026-02-18T10:25:36Z
      Message:               All references are resolved
      Observed Generation:   3
      Reason:                ResolvedRefs
      Status:                True
      Type:                  ResolvedRefs
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
    Parent Ref:
      Group:         gateway.networking.k8s.io
      Kind:          Gateway
      Name:          gateway
      Namespace:     default
      Section Name:  http
Events:              <none>
```

## Verify CORS pre-flight check

{{< call-out "note" >}}

Your clients should be able to resolve the domain name "cafe.example.com" to the public IP of the NGINX Service. 

This guide simulates it using curl's `--resolve` option. 

{{< /call-out >}}

Send a preflight request using curl:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee -H "Origin: https://example.com" -X OPTIONS  -v
```

Response:

```text
> OPTIONS /coffee HTTP/1.1
> Host: cafe.example.com:8080
> User-Agent: curl/8.7.1
> Accept: */*
> Origin: https://example.com
> 
* Request completely sent off
< HTTP/1.1 200 OK
< Server: nginx
< Date: Wed, 18 Feb 2026 11:49:23 GMT
< Content-Type: application/octet-stream
< Content-Length: 0
< Connection: keep-alive
< Access-Control-Allow-Origin: https://example.com
< Access-Control-Allow-Methods: GET, POST
< Access-Control-Allow-Headers: Keep-Alive, Content-Type, User-Agent, Authorization
< Access-Control-Expose-Headers: Content-Security-Policy
< Access-Control-Allow-Credentials: true
< Access-Control-Max-Age: 10
< 
* Connection #0 to host cafe.example.com left intact
```

## Further reading

- [Example deployment files for HTTPCORSFilter](https://github.com/nginx/nginx-gateway-fabric/tree/main/examples/cors-filter)
- [Gateway API Specification](https://gateway-api.sigs.k8s.io/reference/spec/#httpcorsfilter)