---
title: Configure basic authentication
weight: 800
toc: true
nd-content-type: how-to
nd-product: FABRIC
---

This guide introduces how to configure basic authentication for your applications using the AuthenticationFilter CRD.

## Overview

Authentication is crucial for modern application security and allows you to be confident that only trusted and authorized users are accessing your applications, or API backends.
Through this document, you'll learn how to protect your application endpoints with NGINX Gateway Fabric using the AuthenticationFilter CRD.
In this guide we will create two sample applications, `tea` and `coffee`, where we will enable basic authentication on the `/coffee` endpoint. The `/tea` endpoint will not have any authentication. This is to help demonstrate how the application behaves both with and without authentication.
The `/coffee` endpoint will use the `ExtensionRef` filter to reference and `AuthenticationFilter` CRD which is configured for Basic Authentication.

## Before you begin

- Install NGINX Gateway Fabric (OSS or Plus), with [Helm]({{< ref "/ngf/install/helm.md" >}}) or [Manifest]({{< ref "/ngf/install/manifests.md" >}})
- Ensure the Gateway API CRDs are installed on your cluster.
- Ensure the latest NGINX Gateway Fabric CRDs are installed on your cluster.

## Setup

### Deploy demo applications

To deploy both the `coffee` and `tea` applications, copy the blow yaml into your terminal:

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

Confirm that the pods are running

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

To create your gateway resource, and provision the NGINX pod, copy the below yaml into your terminal:

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

After creating the Gateway resource, NGINX Gateway Fabric will provision an NGINX Pod and Service fronting it to route traffic. Verify the gateway is created:

```shell
kubectl get gateways.gateway.networking.k8s.io cafe-gateway
```

```text
NAME           CLASS   ADDRESS         PROGRAMMED   AGE
cafe-gateway   nginx   10.96.187.113   True         10m
```

Save the public IP address and port of the NGINX Service into shell variables:

```text
GW_IP=XXX.YYY.ZZZ.III
GW_PORT=<port number>
```

### Create a Basic Authentication secret and AuthenticationFilter

Deploy secret with user credentials, and the AuthenticationFilter.

{{< call-out "important" >}} Ensure the secret deployed is of type `nginx.org/htpasswd` and the key is `auth` {{< /call-out >}}

```yaml
kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: basic-auth
type: nginx.org/htpasswd
data:
  # Base64 of output from: htpasswd -bn user1 password1
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

(Optional) The secret can also be created using kubectl command:

```shell
kubectl create secret generic basic-auth --type='nginx.org/htpasswd' --from-literal=auth="$(htpasswd -bn user1 password1)"
```

Verify the AuthenticationFilter is Accepted, and there are no errors:

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

### Deploy HTTPRoute referencing an AuthenticationFilter

Deploy an HTTPRoute which references the AuthenticationFilter. This uses the `ExtensionRef` filter type. In this example, we set this filter to the `/coffee` path:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: cafe-routes
spec:
  parentRefs:
  - name: cafe-gateway
  rules:
  - matches:
    # Coffee configured with Basic Auth
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
    # Tea with no authentication configured
    - path:
        type: PathPrefix
        value: /tea
    backendRefs:
    - name: tea
      port: 80
EOF
```

Verify the HTTPRoute is Accepted, and there are no errors:

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

Before verifying the traffic of the application, we'll first make sure the NGINX config is correct.

First, get the name of the NGINX Pod. The name of this pod should start with `cafe-gateway`

```shell
kubectl get pods | grep "cafe-gateway" -B1
```

```text
NAME                                  READY   STATUS    RESTARTS   AGE
cafe-gateway-nginx-5d9855f458-chggl   1/1     Running   0          55s
```

Run this command to check the configuration of the NGINX upstreams and loactions:

```shell
kubectl exec -it cafe-gateway-nginx-5d9855f458-chggl  -- cat /etc/nginx/conf.d/http.conf | grep "/coffee" -A5
```

From this output, we can see the `/coffee` route has sets the `auth_basic` directive, which enabled basic authentication in NGINX.
```nginx
location = /coffee { 
  auth_basic "Restricted basic-auth";
  auth_basic_user_file /etc/nginx/secrets/default_basic-auth;
}
```

Accessing `/coffee` without credentials:

```shell
curl -i -H "Host: cafe.example.com" http://$GW_IP:$GW_PORT/coffee
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
curl -i -u user1:wrong -H "Host: cafe.example.com http://$GW_IP:$GW_PORT/coffee"
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

Accessing `/coffee` with valid credentials:

```shell
curl -i -u user1:password1 -H "Host: cafe.example.com http://$GW_IP:$GW_PORT/coffee"
```

Response:

```text
Server address: 10.244.0.7:8080
Server name: coffee-654ddf664b-nhhvr
Date: 06/Jan/2026:15:20:15 +0000
URI: /coffee
Request ID: 13a925b2514b62c45ea4a79800248d5c
```

Accessing `/tea`

Since tea has no AuthenticationFilter attached, responses are processed normally:

```shell
curl -i -H "Host: cafe.example.com" http://$GW_IP:$GW_PORT/coffee
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
