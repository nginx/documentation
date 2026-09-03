---
title: Configure JWT claim validation
weight: 650
toc: true
f5-content-type: how-to
f5-product: NGINX Gateway Fabric
f5-description: How to configure JWT claim validation in NGINX Gateway Fabric using the `AuthenticationFilter` custom resource definition (CRD).
f5-summary: >
  NGINX Gateway Fabric supports JWT claim validation via the AuthenticationFilter CRD, allowing you to enforce authorization rules based on the claims present in a JSON Web Token.
  Claim validation adds an authorization layer on top of JWT authentication, ensuring that only tokens containing specific claim values are granted access.
  JWT claim validation requires NGINX Plus and is not supported with open-source NGINX.
---

This guide describes how to configure JWT claim validation in NGINX Gateway Fabric using the AuthenticationFilter custom resource definition (CRD).

JWT claim validation adds an authorization layer on top of [JWT authentication]({{< ref "/ngf/traffic-security/jwt-authentication.md" >}}) and [OIDC authentication]({{< ref "/ngf/traffic-security/oidc-authentication.md" >}}). While authentication verifies that a token is valid and properly signed, claim validation goes further by inspecting the claims (fields) inside the token payload. This lets you enforce rules such as requiring a specific issuer, audience, or custom claim value before granting access to your application.

By following these instructions, you will configure an AuthenticationFilter with claim validation rules and verify that only tokens containing the expected claims are allowed through.

For demonstration purposes, in this document you will deploy and configure a `type: JWT` AuthenticationFilter using `mode: File`.

{{< call-out class="note" >}} JWT claim validation requires NGINX Plus. {{< /call-out >}}

## Overview

JWT claim validation is configured through the `authorization` field on the AuthenticationFilter spec. It uses a two-level `require` model that controls how rules and claims are evaluated.

**Top-level require**

The top-level `require` field (`authorization.require`) controls how **rules** relate to each other:

- **Any** (default) — A request is authorized if **any one** of the rules are satisfied.
- **All** — A request is authorized only if **every** rule is satisfied.

**Per-rule require**

Each rule has its own `require` field (`rules[].require`) that controls how the **claims within that rule** relate to each other:

- **Any** (default) — The rule is satisfied if **any one** of its claims matches.
- **All** — The rule is satisfied only if **every** claim in the rule matches.

**How the two levels work together**

Consider an AuthenticationFilter with `authorization.require: Any` and two rules, each with `require: All`:

- Rule 0 requires **all** of: `iss=issuer-1` **and** `aud=api`
- Rule 1 requires **all** of: `iss=issuer-2` **and** `aud=admin`

Because the top-level require is `Any`, a request is authorized if the token satisfies **either** rule 0 **or** rule 1. A token that only partially matches both rules would be rejected as it does not fully satisfy either rule.

**Additional fields**

Claim validation also supports the following options:

- **`match`**: Controls how claim values are compared. Set to `Exact` (default) for literal string matching, or `Regex` to allow regular expression patterns in claim values.
- **`proxySetHeader`**: Forwards the value of a matched claim as a request header to the upstream application. For example, setting `proxySetHeader: X-Tenant` on a `tenant` claim sends `X-Tenant: <claim-value>` to the backend.
- **Nested claims**: Use a slash (`/`) separator to reference claims nested within other claims. For example, `realm_access/roles` refers to the `roles` field inside the `realm_access` object.

---

## Before you begin

- [Install]({{< ref "/ngf/install/" >}}) NGINX Gateway Fabric with NGINX Plus.

## Setup

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
coffee-654ddf664b-4fmcq   1/1     Running   0          13s
tea-75bc9f4b6d-8gtjl      1/1     Running   0          13s
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
  Value:  192.0.2.1
```

Save the public IP address and port of the Gateway into shell variables:

```shell
GW_IP=XXX.YYY.ZZZ.III
GW_PORT=<port number>
```

### Generate a JWKS and create a Secret

For testing purposes, the following example shows a simple JWKS with a single RSA key. In production, use properly generated keys from your identity provider or key management system.

Save the JWKS to a file called `auth` and create a Secret:

```shell
cat <<EOF > auth
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
EOF
kubectl create secret generic jwks-secret --from-file=auth
```

{{< call-out class="note" >}} This example JWKS is for demonstration only. In production, use keys from your identity provider or key management system. {{< /call-out >}}

---

## Configure JWT claim validation

This example creates an AuthenticationFilter with two rules that enforce different issuer and audience combinations. The top-level `require` is set to `Any`, and each rule's `require` is set to `All`.

This means a request is authorized if its JWT satisfies **all** claims in rule 0 **or** all claims in rule 1.

### Create the AuthenticationFilter

Deploy the AuthenticationFilter with claim validation rules by running the following YAML with `kubectl apply`:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: AuthenticationFilter
metadata:
  name: jwt-claims
spec:
  type: JWT
  jwt:
    source: File
    file:
      secretRef:
        name: jwks-secret
    realm: "nginx-gateway"
    keyCache: "1h"
    authorization:
      require: Any # Top-level require
      rules:
      - require: All # Require for rules[0]
        claims:
        - name: "iss"
          values:
          - "https://issuer-1.example.com"
        - name: "aud"
          values:
          - "api"
      - require: All # Require for rules[1]
        claims:
        - name: "iss"
          values:
          - "https://issuer-2.example.com"
        - name: "aud"
          values:
          - "admin"
EOF
```

Verify the AuthenticationFilter is accepted with `kubectl describe`:

```shell
kubectl describe authenticationfilters.gateway.nginx.org jwt-claims | grep "Status:" -A10
```

```text
Status:
  Controllers:
    Conditions:
      Last Transition Time:  2026-09-03T10:26:58Z
      Message:               The AuthenticationFilter is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
Events:                      <none>
```

### Understanding the configuration

- **`authorization.require: Any`** — The request passes if **any** rule is satisfied.
- **Rule 0** (`require: All`) — The JWT must contain **both** `iss` equal to `https://issuer-1.example.com` **and** `aud` equal to `api`.
- **Rule 1** (`require: All`) — The JWT must contain **both** `iss` equal to `https://issuer-2.example.com` **and** `aud` equal to `admin`.

The following table summarizes which tokens are authorized:

| Token claims | Rule 0 | Rule 1 | Result |
|---|---|---|---|
| `iss=issuer-1`, `aud=api` | ✅ All matched | ❌ | ✅ Authorized |
| `iss=issuer-2`, `aud=admin` | ❌ | ✅ All matched | ✅ Authorized |
| `iss=issuer-1`, `aud=admin` | ❌ Partial | ❌ Partial | ❌ Rejected |
| `iss=issuer-2`, `aud=api` | ❌ Partial | ❌ Partial | ❌ Rejected |

### Deploy an HTTPRoute referencing the AuthenticationFilter

Deploy an HTTPRoute that applies the AuthenticationFilter to the `/coffee` path. The `/tea` path has no authentication and responds normally. Run the following YAML with `kubectl apply`:

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
        name: jwt-claims
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
      Last Transition Time:  2026-09-03T10:28:15Z
      Message:               The Route is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
      Last Transition Time:  2026-09-03T10:28:15Z
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

### Verify JWT claim validation

{{< call-out class="note" >}}

Your clients should be able to resolve "cafe.example.com" to the public IP of the NGINX Service.

This guide simulates that using curl's `--resolve` option.

{{< /call-out >}}

To test claim validation, you need JWTs signed with the private key corresponding to the public key in your JWKS. You can use [jwt.io](https://jwt.io) or other JWT tools to generate tokens with different claim payloads. Store each token in a shell variable.

**Token matching rule 0** (`iss=https://issuer-1.example.com`, `aud=api`):

```shell
JWT_RULE0="<your-signed-jwt-rule-0>"
```

**Token matching rule 1** (`iss=https://issuer-2.example.com`, `aud=admin`):

```shell
JWT_RULE1="<your-signed-jwt-rule-1>"
```

**Token matching neither rule** (`iss=https://issuer-1.example.com`, `aud=admin`):

```shell
JWT_NEITHER="<your-signed-jwt-matching-neither>"
```

Access `/coffee` with a token matching rule 0

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee -H "Authorization: Bearer $JWT_RULE0"
```

```text
Server address: 10.244.0.7:8080
Server name: coffee-654ddf664b-nhhvr
Date: 10/Mar/2026:15:20:15 +0000
URI: /coffee
Request ID: 13a925b2514b62c45ea4a79800248d5c
```

The request succeeds as the token satisfies all claims in rule 0.

Access `/coffee` with a token matching rule 1

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee -H "Authorization: Bearer $JWT_RULE1"
```

```text
Server address: 10.244.0.7:8080
Server name: coffee-654ddf664b-nhhvr
Date: 02/Sep/2026:15:21:30 +0000
URI: /coffee
Request ID: 7b2e4a1c9f0d3e5a8c6b4d2f1a0e9c8b
```

The request succeeds as the token satisfies all claims in rule 1.

Access `/coffee` with a token matching neither rule

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/coffee -H "Authorization: Bearer $JWT_NEITHER"
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

The request is rejected. Although the token has valid claims, it only partially matches each rule (`iss` from rule 0 and `aud` from rule 1). Since each rule requires **all** claims to match and the token does not fully satisfy either rule, authorization fails.

Access `/coffee` without a token

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

Without a JWT, the request fails authentication before claim validation is evaluated.

Access `/tea` without authentication

```shell
curl --resolve cafe.example.com:$GW_PORT:$GW_IP http://cafe.example.com:$GW_PORT/tea
```

```text
Server address: 10.244.0.10:8080
Server name: tea-75bc9f4b6d-ms2n8
Date: 03/Sep/2026:15:36:26 +0000
URI: /tea
Request ID: c7eb0509303de1c160cb7e7d2ac1d99f
```

The `/tea` path has no AuthenticationFilter attached and responds normally.

---

## Troubleshooting

- Ensure NGINX Gateway Fabric is deployed with NGINX Plus. JWT claim validation is not supported in the open source version.
- Ensure the AuthenticationFilter is accepted by checking its status with `kubectl describe`.
- Ensure the HTTPRoute references the correct AuthenticationFilter name and group.
- Confirm the Secret key is named `auth` and contains valid JWKS JSON. The Secret must be in the same namespace as the AuthenticationFilter.
- Verify your JWT includes the `kid` (key ID) claim that matches one of the keys in your JWKS.
- Check that the JWT is not expired by verifying the `exp` claim.
- Ensure the JWT signature algorithm (typically RS256) matches the key type in your JWKS.
- If claim validation rejects a token you expect to pass, decode the token at [jwt.io](https://jwt.io) and verify that the claim names and values exactly match what is configured in the AuthenticationFilter.

## Further reading

- [AuthenticationFilter API reference]({{< ref "/ngf/reference/api.md#gateway.nginx.org/v1alpha1.AuthenticationFilter" >}})
- [Configure JWT authentication]({{< ref "/ngf/traffic-security/jwt-authentication.md" >}})
- [Configure OIDC authentication]({{< ref "/ngf/traffic-security/oidc-authentication.md" >}})
- [NGINX JWT Authentication Module](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html)
- [NGINX auth_jwt_require directive](https://nginx.org/en/docs/http/ngx_http_auth_jwt_module.html#auth_jwt_require)
- [RFC 7519 - JSON Web Token (JWT)](https://datatracker.ietf.org/doc/html/rfc7519)

