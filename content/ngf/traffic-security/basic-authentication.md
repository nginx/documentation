---
title: Configure basic authentication
weight: 800
toc: true
nd-content-type: how-to
nd-product: FABRIC
---


This page describes how to configure basic authentication in NGINX Gateway Fabric using the AuthenticationFilter custom resource definition (CRD).

Authentication can be used to secure applications and APIs, ensuring only trusted and authorized users have access.

By following these instructions, you will create two sample application endpoints. One will include basic authentication and the other will not, allowing you to review how each behaves.

## Before you begin

- [Install]({{< ref "/ngf/install/" >}}) NGINX Gateway Fabric.

## Setup

In this part of the document, we will set up several resources in your cluster to demonstrate usage of the AuthenticationFilter CRD.

## Deploy sample applications

To deploy the `coffee` and `tea` applications, run the following YAML with `kubectl apply`:

```yaml
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: coffee
spec:
  replicas: 2
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
  replicas: 2
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

To confirm the application pods are availble, run `kubectl get`:

```shell
kubectl get pods
```

```text
NAME                      READY   STATUS    RESTARTS   AGE
coffee-654ddf664b-fllj7   1/1     Running   0          21s
coffee-654ddf664b-lpgq9   1/1     Running   0          21s
tea-75bc9f4b6d-cx2jl      1/1     Running   0          21s
tea-75bc9f4b6d-s99jz      1/1     Running   0          21s
```

### Create a Gateway

To create your Gateway resource and provision the NGINX pod, run the following YAML with `kubectl apply`:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: cafe-gateway
spec:
  gatewayClassName: nginx
  listeners:
  - name: http
    port: 80
    protocol: HTTP
    hostname: "cafe.example.com"
EOF
```

Confirm the Gateway was assigned an IP address and reports a `Programmed=True` status with `kubectl describe`:

```shell
kubectl describe gateways.gateway.networking.k8s.io cafe-gateway | grep "Addresses:" -A2
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

## Create a user credentials secret and AuthenticationFilter

Deploy a secret with user credentials, and the AuthenticationFilter by running the following YAML with `kubectl apply`:

{{< call-out "important" >}} Ensure the secret deployed is of type `nginx.org/htpasswd` and the key is `auth` {{< /call-out >}}

```yaml
kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: basic-auth
type: nginx.org/htpasswd
data:
  # Base64 of "htpasswd -bn user1 password1"
  auth: dXNlcjE6JGFwcjEkWEFKeU5yekgkY0Rjdy9YMVBCZTFmTjltQVBweXpxMA==
---
apiVersion: gateway.nginx.org/v1alpha1
kind: AuthenticationFilter
metadata:
  name: basic-auth
spec:
  type: Basic
  basic:
    secretRef:
      name: basic-auth
    realm: "Restricted basic-auth"
EOF
```

Verify the AuthenticationFilter is _Accepted_ and has no errors using `kubectl describe`:

```shell
kubectl describe authenticationfilters.gateway.nginx.org | grep "Status:" -A10
```

```text
Status:
  Controllers:
    Conditions:
      Last Transition Time:  2026-01-08T10:09:18Z
      Message:               The AuthenticationFilter is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
Events:                      <none>
```

## Deploy a HTTPRoute referencing the AuthenticationFilter

Deploy a HTTPRoute resource which references the AuthenticationFilter using the `ExtensionRef` filter type. 

In this example, the filter is applied to the `/coffee` path: run the following YAML with `kubectl apply`

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: cafe-routes
spec:
  parentRefs:
  - name: cafe-gateway
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
    filters:
      - type: ExtensionRef
        extensionRef:
          group: gateway.nginx.org
          kind: AuthenticationFilter
          name: basic-auth
  - matches:
      - path:
          type: PathPrefix
          value: /tea
    backendRefs:
      - name: tea
        port: 80
EOF
```

Verify the HTTPRoute is _Accepted_ and there are no errors with `kubectl describe`:

```shell
kubectl describe httproute cafe-routes | grep "Status:" -A10
```

```text
Status:
  Parents:
    Conditions:
      Last Transition Time:  2026-01-06T15:18:55Z
      Message:               The Route is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
      Last Transition Time:  2026-01-06T15:18:55Z
      Message:               All references are resolved
      Observed Generation:   1
      Reason:                ResolvedRefs
      Status:                True
      Type:                  ResolvedRefs
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
    Parent Ref:
      Group:         gateway.networking.k8s.io
      Kind:          Gateway
      Name:          cafe-gateway
      Namespace:     default
      Section Name:  http
Events:              <none>
```

## Verify Basic Authentication

{{< call-out "note" >}}

Your clients should be able to resolve the domain name "cafe.example.com" to the public IP of the NGINX Service. 

This guide simulates it using curl's `--resolve` option. 

{{< /call-out >}}

Accessing `/coffee` with valid credentials:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee -u user1:password1
```

Response:

```text
Server address: 10.244.0.7:8080
Server name: coffee-654ddf664b-nhhvr
Date: 06/Jan/2026:15:20:15 +0000
URI: /coffee
Request ID: 13a925b2514b62c45ea4a79800248d5c
```

Accessing `/coffee` without credentials:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee
```

Response:

```text
<html>
<head><title>401 Authorization Required</title></head>
<body>
<center><h1>401 Authorization Required</h1></center>
<hr><center>nginx</center>
</body>
</html>
```

Accessing `/coffee` with incorrect credentials:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee  -u user1:wrong 
```

Response:

```text
<html>
<head><title>401 Authorization Required</title></head>
<body>
<center><h1>401 Authorization Required</h1></center>
<hr><center>nginx</center>
</body>
</html>
```

Accessing `/tea`

Since tea has no AuthenticationFilter attached, responses are processed normally:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/tea
```

Response:

```text
Server address: 10.244.0.10:8080
Server name: tea-75bc9f4b6d-ms2n8
Date: 06/Jan/2026:15:36:26 +0000
URI: /tea
Request ID: c7eb0509303de1c160cb7e7d2ac1d99f
```


## Troubleshooting

- Ensure the HTTPRoute is Accepted and references the correct AuthenticationFilter name and group.
- Confirm the secret key is named `auth` and is of type `nginx.org/htpasswd`.
- Ensure the secret referenced by the AuthenticationFilter is in the same namespace.

## Further reading

- [Example deployment files for AuthenticationFilter](https://github.com/nginx/nginx-gateway-fabric/tree/main/examples/basic-authentication)
- [NGINX HTTP Basic Auth Module](https://nginx.org/en/docs/http/ngx_http_auth_basic_module.html)
