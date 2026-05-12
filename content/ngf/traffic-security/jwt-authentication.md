---
title: Configure JSON Web Token (JWT) authentication
weight: 600
toc: true
f5-content-type: how-to
f5-product: FABRIC
f5-description: How to configure JSON Web Token (JWT) authentication in NGINX Gateway Fabric using the `AuthenticationFilter` custom resource definition (CRD).
f5-summary: >
  NGINX Gateway Fabric supports JWT authentication via the AuthenticationFilter CRD, validating JSON Web Tokens in incoming requests using JSON Web Key Sets (JWKS).
  Two JWKS source types are supported: File, where the JWKS is stored in a Kubernetes Secret, and Remote, where NGINX Plus fetches the JWKS from an HTTPS endpoint at runtime.
  JWT authentication requires NGINX Plus and is not supported with open-source NGINX.
---

This guide describes how to configure JSON Web Token (JWT) authentication in NGINX Gateway Fabric using the AuthenticationFilter custom resource definition (CRD).

JWT authentication secures applications and APIs by validating JSON Web Tokens in incoming requests. Only requests with valid JWTs are allowed access.

By following these instructions, you will create two sample application endpoints: one with JWT authentication and one without, so you can see how each behaves.

{{< call-out "note" >}} JWT authentication requires NGINX Plus. {{< /call-out >}}

## Overview

JWT authentication in NGINX Gateway Fabric validates JSON Web Tokens using JSON Web Key Sets (JWKS). The JWKS contains the public keys used to verify JWT signatures. When a request arrives with a JWT in the `Authorization` header, NGINX Plus validates the token against the configured JWKS before forwarding the request to your application.

NGINX Gateway Fabric supports two JWKS source types, set using the `source` field on the `AuthenticationFilter`:

- **File** — JWKS is stored locally in a Kubernetes Secret. Use this when you manage your own keys or want to avoid external dependencies.
- **Remote** — NGINX Plus fetches JWKS from an HTTPS endpoint at runtime. Use this when your identity provider (for example, Keycloak or Auth0) exposes a JWKS URI.

## Before you begin

- [Install]({{< ref "/ngf/install/" >}}) NGINX Gateway Fabric with NGINX Plus.
- [Install cert-manager](https://cert-manager.io/docs/installation/) in your cluster.

## Common setup

The following steps are required for both file-based and remote JWT authentication.

### Deploy sample applications

To deploy the `coffee` and `tea` applications, run the following YAML with `kubectl apply`:

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

Save the public IP address and port of the Gateway into shell variables:

```shell
GW_IP=XXX.YYY.ZZZ.III
GW_PORT=<port number>
```

---

## File-based JWT authentication

Use file-based JWT authentication when your JWKS is stored in a Kubernetes Secret. NGINX Plus loads the key material directly from the Secret at startup and after each reload.

### Generate a JWKS

For testing purposes, the following example shows a simple JWKS with a single RSA key. In production, use properly generated keys from your identity provider or key management system.

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

{{< call-out "note" >}} This example JWKS is for demonstration only. In production, use keys from your identity provider or key management system. {{< /call-out >}}

### Create a JWKS Secret and AuthenticationFilter

Deploy a Secret containing your JWKS and the AuthenticationFilter by running these `kubectl` commands:

```
kubectl create secret generic jwks-secret --from-file=auth=jwks.json
```

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: AuthenticationFilter
metadata:
  name: jwt-auth-file
spec:
  type: JWT
  jwt:
    source: File
    file:
      secretRef:
        name: jwks-secret
    realm: "nginx-gateway"
    keyCache: "1h"
EOF
```

#### Understanding the configuration

- **source**: Set to `File` to use a local JWKS Secret.
- **file.secretRef.name**: The name of the `Opaque` Secret containing the JWKS. The Secret must have a key named `auth` with valid JWKS JSON as its value.
- **realm**: (Optional) Sets the authentication realm shown in the `WWW-Authenticate` header when authentication fails.
- **keyCache**: (Optional) Controls how long NGINX Plus caches the JWKS keys in memory. Supported values use standard time units such as 10s, 1m, or 1h. Caching avoids reloading the JWKS from the Secret for every request, improving performance. If not specified, the keys remain cached indefinitely and are only refreshed when NGINX is reloaded.

Verify the AuthenticationFilter is accepted with `kubectl describe`:

```shell
kubectl describe authenticationfilters.gateway.nginx.org jwt-auth-file | grep "Status:" -A10
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

### Deploy an HTTPRoute referencing the AuthenticationFilter

Deploy an HTTPRoute that references the AuthenticationFilter using the `ExtensionRef` filter type. In this example, the filter is applied to the `/coffee` path only. Run the following YAML with `kubectl apply`:

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
          name: jwt-auth-file
  - matches:
      - path:
          type: PathPrefix
          value: /tea
    backendRefs:
      - name: tea
        port: 80
EOF
```

Verify the HTTPRoute is accepted with `kubectl describe`:

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

### Verify file-based JWT authentication

{{< call-out "note" >}}

Your clients should be able to resolve "cafe.example.com" to the public IP of the NGINX Service.

This guide simulates that using curl's `--resolve` option.

{{< /call-out >}}

To test the authentication, you need a JWT signed with the private key that corresponds to the public key in your JWKS. You can use [jwt.io](https://jwt.io) or other JWT tools to generate one. Store it in a shell variable:

```shell
JWT_TOKEN="<your-signed-jwt>"
```

Access `/coffee` with a valid JWT:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee -H "Authorization: Bearer $JWT_TOKEN"
```

```text
Server address: 10.244.0.7:8080
Server name: coffee-654ddf664b-nhhvr
Date: 10/Mar/2026:15:20:15 +0000
URI: /coffee
Request ID: 13a925b2514b62c45ea4a79800248d5c
```

Access `/coffee` without a JWT:

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

Access `/coffee` with an invalid JWT:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee -H "Authorization: Bearer invalid.jwt.token"
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

Access `/tea`, which has no AuthenticationFilter and responds normally:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/tea
```

```text
Server address: 10.244.0.10:8080
Server name: tea-75bc9f4b6d-ms2n8
Date: 10/Mar/2026:15:36:26 +0000
URI: /tea
Request ID: c7eb0509303de1c160cb7e7d2ac1d99f
```

---

## Remote JWT authentication

Use remote JWT authentication when your identity provider (IdP) exposes a JWKS endpoint. NGINX Plus fetches the JWKS from the URI at runtime using an internal subrequest, so keys are always up to date without requiring a Secret or NGINX reload.

### Generate certificates

{{< include "/ngf/keycloak-certs.md" >}}

### Configure Keycloak

If you already have an IdP set up with a realm, a client, and a user, skip to [Create an AuthenticationFilter with a remote source](#create-an-authenticationfilter-with-a-remote-source).

#### Start Keycloak

Deploy Keycloak to your cluster. The `keycloak-tls-cert` Secret was created by cert-manager in the previous step and is mounted into the Keycloak container below.

```yaml
kubectl apply -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: keycloak-realm-config
data:
  nginx-gateway-realm.json: |
    {
      "realm": "nginx-gateway",
      "enabled": true,
      "sslRequired": "external",
      "roles": {
        "realm": [
          {
            "name": "user",
            "composite": false
          }
        ]
      },
      "clients": [
        {
          "clientId": "cafe-app",
          "enabled": true,
          "publicClient": true,
          "directAccessGrantsEnabled": true,
          "standardFlowEnabled": true
        }
      ],
      "users": [
        {
          "username": "testuser",
          "enabled": true,
          "emailVerified": true,
          "email": "testuser@example.com",
          "firstName": "Test",
          "lastName": "User",
          "credentials": [
            {
              "type": "password",
              "value": "testpassword",
              "temporary": false
            }
          ],
          "realmRoles": ["user"]
        }
      ]
    }
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: keycloak
  labels:
    app: keycloak
spec:
  replicas: 1
  selector:
    matchLabels:
      app: keycloak
  template:
    metadata:
      labels:
        app: keycloak
    spec:
      containers:
      - name: keycloak
        image: quay.io/keycloak/keycloak:26.5
        args:
        - "start-dev"
        - "--https-certificate-file=/etc/keycloak-certs/tls.crt"
        - "--https-certificate-key-file=/etc/keycloak-certs/tls.key"
        - "--import-realm"
        env:
        - name: KC_BOOTSTRAP_ADMIN_USERNAME
          value: "admin"
        - name: KC_BOOTSTRAP_ADMIN_PASSWORD
          value: "admin"
        - name: KC_HTTP_ENABLED
          value: "true"
        - name: KC_HTTPS_ENABLED
          value: "true"
        - name: KC_PROXY_HEADERS
          value: "xforwarded"
        ports:
        - name: http
          containerPort: 8080
        - name: https
          containerPort: 8443
        volumeMounts:
        - name: keycloak-certs
          mountPath: /etc/keycloak-certs
          readOnly: true
        - name: realm-config
          mountPath: /opt/keycloak/data/import
          readOnly: true
        readinessProbe:
          httpGet:
            path: /realms/master
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
      volumes:
      - name: keycloak-certs
        secret:
          secretName: keycloak-tls-cert
      - name: realm-config
        configMap:
          name: keycloak-realm-config
---
apiVersion: v1
kind: Service
metadata:
  name: keycloak
spec:
  selector:
    app: keycloak
  ports:
    - name: http
      port: 8080
      targetPort: 8080
    - name: https
      port: 8443
      targetPort: 8443
EOF
```

This creates a Keycloak deployment and service. 

### Create an AuthenticationFilter with a remote source

Deploy an AuthenticationFilter with `source: Remote` and the URI of your IdP's JWKS endpoint by running the following YAML with `kubectl apply`:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: AuthenticationFilter
metadata:
  name: jwt-auth-remote
spec:
  type: JWT
  jwt:
    source: Remote
    remote:
      uri: https://keycloak.default.svc.cluster.local:8443/realms/nginx-gateway/protocol/openid-connect/certs
      caCertificateRefs:
        - name: keycloak-secret
    realm: "nginx-gateway"
    keyCache: "1h"
EOF
```

#### Understanding the configuration

- **source**: Set to `Remote` to fetch JWKS from a remote endpoint.
- **remote.uri**: The URL of the JWKS endpoint.
- **remote.caCertificateRefs**: (Optional) A list of Secrets containing trusted CA certificates in PEM format, used to verify the server certificate of the JWKS endpoint. Only one Secret can be referenced at a time. If not specified, the system CA bundle is used.
- **realm**: (Optional) Sets the authentication realm shown in the `WWW-Authenticate` header when authentication fails.
- **keyCache**: (Optional) Controls how long NGINX Plus caches the JWKS keys in memory. Supported values use standard time units such as 10s, 1m, or 1h. Caching avoids reloading the JWKS from the Secret for every request, improving performance. If not specified, the keys remain cached indefinitely and are only refreshed when NGINX is reloaded.

{{< call-out "note" >}} The CA Secret must be in the same namespace as the AuthenticationFilter. {{< /call-out >}}

Verify the AuthenticationFilter is accepted with `kubectl describe`:

```shell
kubectl describe authenticationfilters.gateway.nginx.org jwt-auth-remote | grep "Status:" -A10
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

### Deploy an HTTPRoute referencing the remote AuthenticationFilter

Deploy an HTTPRoute that applies the remote AuthenticationFilter to `/coffee`. Run the following YAML with `kubectl apply`:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: cafe-remote-routes
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
          name: jwt-auth-remote
  - matches:
      - path:
          type: PathPrefix
          value: /tea
    backendRefs:
      - name: tea
        port: 80
EOF
```


Verify the HTTPRoute is accepted with `kubectl describe`:

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

### Obtain a JWT

Expose Keycloak with port-forward:

```shell
kubectl port-forward svc/keycloak 8443:8443
```

Set your `JWT_TOKEN` environment variable by calling the `tokens` endpoint in keycloak:

```shell
export JWT_TOKEN=$(curl -s -k -X POST https://localhost:8443/realms/nginx-gateway/protocol/openid-connect/token \
     -H "Content-Type: application/x-www-form-urlencoded" \
     -d "username=testuser" \
     -d "password=testpassword" \
     -d "grant_type=password" \
     -d "client_id=cafe-app" | jq -r '.access_token')
```

### Verify remote JWT authentication

{{< call-out "note" >}}

Your clients should be able to resolve "cafe.example.com" to the public IP of the NGINX Service.

This guide simulates that using curl's `--resolve` option.

{{< /call-out >}}

Access `/coffee` with a valid JWT:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee -H "Authorization: Bearer $JWT_TOKEN"
```

```text
Server address: 10.244.0.7:8080
Server name: coffee-654ddf664b-nhhvr
Date: 10/Mar/2026:15:20:15 +0000
URI: /coffee
Request ID: 13a925b2514b62c45ea4a79800248d5c
```

Access `/coffee` without a JWT:

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

Access `/tea`, which has no AuthenticationFilter and responds normally:

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/tea
```

```text
Server address: 10.244.0.10:8080
Server name: tea-75bc9f4b6d-ms2n8
Date: 10/Mar/2026:15:36:26 +0000
URI: /tea
Request ID: c7eb0509303de1c160cb7e7d2ac1d99f
```

---

## Troubleshooting

- Ensure NGINX Gateway Fabric is deployed with NGINX Plus. JWT authentication is not supported in the open source version.
- Ensure the HTTPRoute is accepted and references the correct AuthenticationFilter name and group.
- For file-based JWT: confirm the Secret key is named `auth` and contains valid JWKS JSON. The Secret must be in the same namespace as the AuthenticationFilter.
- For remote JWT: confirm the `uri` uses the `https://` scheme and the endpoint is reachable from the NGINX Plus pod.
- For remote JWT with a custom CA: confirm the Secret key is named `ca.crt` and contains a valid PEM certificate. The Secret must be in the same namespace as the AuthenticationFilter.
- Verify your JWT includes the `kid` (key ID) claim that matches one of the keys in your JWKS.
- Check that the JWT is not expired by verifying the `exp` claim.
- Ensure the JWT signature algorithm (typically RS256) matches the key type in your JWKS.

## Further reading

- [AuthenticationFilter API reference]({{< ref "/ngf/reference/api.md#gateway.nginx.org/v1alpha1.AuthenticationFilter" >}})
- [NGINX JWT Authentication Module](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html)
- [JWT.io - JWT debugger and generator](https://jwt.io)
- [RFC 7519 - JSON Web Token (JWT)](https://datatracker.ietf.org/doc/html/rfc7519)
- [RFC 7517 - JSON Web Key (JWK)](https://datatracker.ietf.org/doc/html/rfc7517)
