---
title: Configure JSON Web Token (JWT) authentication
weight: 850
toc: true
nd-content-type: how-to
nd-product: FABRIC
---

This page describes how to configure JSON Web Token (JWT) authentication in NGINX Gateway Fabric using the AuthenticationFilter custom resource definition (CRD).

JWT authentication can be used to secure applications and APIs by validating JSON Web Tokens in requests. Only requests with valid JWTs are allowed access.

By following these instructions, you will create two sample application endpoints. One will include JWT authentication and the other will not, allowing you to review how each behaves.

{{< call-out "note" >}} JWT authentication requires NGINX Plus. {{< /call-out >}}

## Overview

JWT authentication in NGINX Gateway Fabric validates JSON Web Tokens using JSON Web Key Sets (JWKS). The JWKS contains the public keys used to verify the JWT signatures. When a request arrives with a JWT in the `Authorization` header, NGINX Plus validates the token against the configured JWKS before forwarding the request to your application.

This guide demonstrates JWT authentication using a local JWKS file stored in a Kubernetes Secret.

## Before you begin

- [Install]({{< ref "/ngf/install/" >}}) NGINX Gateway Fabric with NGINX Plus.

## Setup

In this part of the document, you will set up several resources in your cluster to demonstrate usage of the AuthenticationFilter CRD with JWT authentication.

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

To confirm the application pods are available, run `kubectl get`:

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
kubectl describe gateways.gateway.networking.k8s.io cafe-gateway
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

## Generate JWT and JWKS

For testing purposes, you can generate a JWT and JWKS using online tools or command-line utilities. 

The following example shows how to create a simple JWKS with a single key. In a production environment, you would typically use your identity provider's JWKS endpoint or generate keys using proper cryptographic tools.

Example JWKS (JSON Web Key Set):

```json
{
  "keys": [
    {
      "kty": "RSA",
      "kid": "test-key",
      "use": "sig",
      "n": "0vx7agoebGcQSuuPiLJXZptN9nndrQmbXEps2aiAFbWhM78LhWx4cbbfAAtVT86zwu1RK7aPFFxuhDR1L6tSoc_BJECPebWKRXjBZCiFV4n3oknjhMstn64tZ_2W-5JsGY4Hc5n9yBXArwl93lqt7_RN5w6Cf0h4QyQ5v-65YGjQR0_FDW2QvzqY368QQMicAtaSqzs8KJZgnYb9c7d0zgdAZHzu6qMQvRL5hajrn1n91CbOpbISD08qNLyrdkt-bFTWhAI4vMQFh6WeZu0fM4lFd2NcRwr3XPksINHaQ-G_xBniIqbw0Ls1jF44-csFCur-kEgU8awapJzKnqDKgw",
      "e": "AQAB"
    }
  ]
}
```

{{< call-out "note" >}} This example JWKS is for demonstration purposes only. In production, use properly generated keys from your identity provider or key management system. {{< /call-out >}}

## Create a JWKS secret and AuthenticationFilter

Deploy a secret with your JWKS, and the AuthenticationFilter by running the following YAML with `kubectl apply`:

```yaml
kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: jwt-auth
type: Opaque
stringData:
  auth: |
    {
      "keys": [
        {
          "kty": "RSA",
          "kid": "test-key",
          "use": "sig",
          "n": "0vx7agoebGcQSuuPiLJXZptN9nndrQmbXEps2aiAFbWhM78LhWx4cbbfAAtVT86zwu1RK7aPFFxuhDR1L6tSoc_BJECPebWKRXjBZCiFV4n3oknjhMstn64tZ_2W-5JsGY4Hc5n9yBXArwl93lqt7_RN5w6Cf0h4QyQ5v-65YGjQR0_FDW2QvzqY368QQMicAtaSqzs8KJZgnYb9c7d0zgdAZHzu6qMQvRL5hajrn1n91CbOpbISD08qNLyrdkt-bFTWhAI4vMQFh6WeZu0fM4lFd2NcRwr3XPksINHaQ-G_xBniIqbw0Ls1jF44-csFCur-kEgU8awapJzKnqDKgw",
          "e": "AQAB"
        }
      ]
    }
---
apiVersion: gateway.nginx.org/v1alpha1
kind: AuthenticationFilter
metadata:
  name: jwt-auth
spec:
  type: JWT
  jwt:
    file:
      secretRef:
        name: jwt-auth
    realm: "Restricted jwt-auth"
    keyCache: "1h"
EOF
```

### Understanding the configuration

- **Secret type**: The secret must be of type `Opaque` with a key named `auth` containing the JWKS data in JSON format.
- **realm**: (Optional) The realm parameter sets the authentication realm displayed in the WWW-Authenticate header when authentication fails.
- **keyCache**: (Optional) Specifies how long NGINX Plus caches the JWKS keys in memory. Valid values include time units like `10s`, `1m`, `1h`. This reduces the need to re-read the secret file for each request. If not specified, keys are cached indefinitely until NGINX is reloaded.

Verify the AuthenticationFilter is _Accepted_ and has no errors using `kubectl describe`:

```shell
kubectl describe authenticationfilters.gateway.nginx.org jwt-auth | grep "Status:" -A10
```

```text
Status:
  Controllers:
    Conditions:
      Last Transition Time:  2026-03-10T10:09:18Z
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
          name: jwt-auth
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
      Last Transition Time:  2026-03-10T15:18:55Z
      Message:               The Route is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
      Last Transition Time:  2026-03-10T15:18:55Z
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

## Verify JWT authentication

{{< call-out "note" >}}

Your clients should be able to resolve the domain name "cafe.example.com" to the public IP of the NGINX Service. 

This guide simulates it using curl's `--resolve` option. 

{{< /call-out >}}

### Generate a test JWT

To test the authentication, you need a JWT signed with the private key corresponding to the public key in your JWKS. For testing purposes, you can use [jwt.io](https://jwt.io) or other JWT generation tools.

For this guide, assume you have generated a JWT and stored it in a variable:

```shell
JWT_TOKEN="eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6InRlc3Qta2V5In0.eyJzdWIiOiJ1c2VyMTIzIiwibmFtZSI6IlRlc3QgVXNlciIsImlhdCI6MTUxNjIzOTAyMiwiZXhwIjo5OTk5OTk5OTk5fQ.example_signature"
```

### Test authentication scenarios

Accessing `/coffee` with a valid JWT:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee -H "Authorization: Bearer $JWT_TOKEN"
```

Response:

```text
Server address: 10.244.0.7:8080
Server name: coffee-654ddf664b-nhhvr
Date: 10/Mar/2026:15:20:15 +0000
URI: /coffee
Request ID: 13a925b2514b62c45ea4a79800248d5c
```

Accessing `/coffee` without a JWT:

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

Accessing `/coffee` with an invalid JWT:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee -H "Authorization: Bearer invalid.jwt.token"
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

Because tea has no AuthenticationFilter attached, responses are processed normally:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/tea
```

Response:

```text
Server address: 10.244.0.10:8080
Server name: tea-75bc9f4b6d-ms2n8
Date: 10/Mar/2026:15:36:26 +0000
URI: /tea
Request ID: c7eb0509303de1c160cb7e7d2ac1d99f
```

## Troubleshooting

- Ensure NGINX Gateway Fabric is deployed with NGINX Plus as JWT authentication is not supported in the open source version.
- Ensure the HTTPRoute is Accepted and references the correct AuthenticationFilter name and group.
- Confirm the secret key is named `auth` and contains valid JWKS JSON.
- Ensure the secret referenced by the AuthenticationFilter is in the same namespace.
- Verify that your JWT includes the `kid` (key ID) claim that matches one of the keys in your JWKS.
- Check that the JWT is not expired by verifying the `exp` claim.
- Ensure the JWT signature algorithm (typically RS256) matches the key type in your JWKS.

## Further reading

- [AuthenticationFilter API reference]({{< ref "/ngf/reference/api.md#gateway.nginx.org/v1alpha1.AuthenticationFilter" >}})
- [NGINX JWT Authentication Module](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html)
- [JWT.io - JWT debugger and generator](https://jwt.io)
- [RFC 7519 - JSON Web Token (JWT)](https://datatracker.ietf.org/doc/html/rfc7519)
- [RFC 7517 - JSON Web Key (JWK)](https://datatracker.ietf.org/doc/html/rfc7517)
