---
title: Configure OpenID Connect authentication
weight: 400
toc: true
nd-content-type: how-to
nd-product: FABRIC
nd-description:  How to configure OpenID Connect authentication in NGINX Gateway Fabric using the `AuthenticationFilter` custom resource definition (CRD).
nd-summary: >
   NGINX Gateway Fabric supports OIDC authentication via the AuthenticationFilter CRD, enabling delegation of user login to identity providers like Keycloak, Okta, or Auth0 using the Authorization Code Flow.
   The filter must be attached to an HTTPS listener and references Kubernetes Secrets for sensitive material including the client secret and optional CA certificate for verifying the IdP's TLS connection.
   Key optional features include session management, logout configuration, PKCE, custom redirect URIs, and Certificate Revocation List support, though the feature requires NGINX Plus and does not work with open-source NGINX.
---

This guide describes how to configure OpenID Connect authentication in NGINX Gateway Fabric using the `AuthenticationFilter` custom resource definition (CRD).

## Overview

OIDC authentication lets you delegate user login to a trusted Identity Provider (IdP) such as Keycloak, Okta, or Auth0. Once a user signs in through the IdP, that session is recognized across every route protected by the same IdP. They are not prompted to log in again when moving between applications. NGINX Gateway Fabric redirects unauthenticated users to the IdP, receives an authorization code after login, and exchanges that code for identity tokens on the user's behalf. Your backend services receive only requests that have already passed authentication and never handle credentials directly.

When a user requests a protected resource, NGINX Gateway Fabric uses the [Authorization Code Flow](https://openid.net/specs/openid-connect-core-1_0.html#CodeFlowAuth):

1. NGINX redirects the browser to the IdP's authorization endpoint.
1. The user authenticates with the IdP.
1. The IdP redirects the browser back to NGINX with a short-lived authorization code.
1. NGINX exchanges that code for an ID token and access token via a direct, back-channel HTTPS call to the IdP's token endpoint.
1. NGINX validates the ID token, creates a session cookie, and forwards the original request to the backend.
1. Subsequent requests carry the session cookie, so the IdP is not contacted again until the session expires.

TLS is required in two directions. For inbound connections, the callback redirect from the IdP back to NGINX must be served over HTTPS. The `AuthenticationFilter` must be attached to an HTTPRoute that uses an HTTPS listener, and the Gateway listener's `tls.certificateRefs` provides the certificate NGINX presents to the browser. This is the same certificate that NGINX would provide to any client. For outbound connections, NGINX connects to the IdP over HTTPS to exchange the authorization code for tokens. By default, NGINX trusts the system CA bundle. To use a custom CA, specify it in `oidc.caCertificateRefs`. Attaching an OIDC `AuthenticationFilter` to a non-HTTPS route will cause the filter to be rejected.

OIDC configuration references Kubernetes `Opaque` Secrets for sensitive material. The `clientSecretRef` field expects a Secret with the key `client-secret`. Your IdP requires a client ID and secret to identify and authenticate the application contacting its realm. NGINX presents these credentials when exchanging the authorization code for tokens. The `caCertificateRefs` field expects a Secret with the key `ca.crt`, containing PEM-encoded CA certificates that NGINX uses to verify the IdP's TLS certificate on outbound connections. If omitted, NGINX uses the system CA bundle. The `crlSecretRef` field expects a Secret with the key `ca.crl`, containing a PEM-encoded Certificate Revocation List. NGINX checks the IdP's certificate serial number against this list before every outbound connection. This field can be omitted if CRL checking is not required.

You can consolidate multiple keys in a single Secret or use separate Secrets for each. Either approach works as long as each Secret contains the correct key name.

{{< call-out "important" >}}OIDC authentication requires [NGINX Plus]({{< ref "/ngf/install/nginx-plus.md" >}}) and is not supported with open-source NGINX. {{< /call-out >}}

## Before you begin

To follow this guide, you need the following:

- [Install]({{< ref "/ngf/install/" >}}) NGINX Gateway Fabric with NGINX Plus.
- [Install cert-manager](https://cert-manager.io/docs/installation/) in your cluster.

### Generate certificates

The following steps use `cert-manager` to issue a local Certificate Authority (CA) and sign certificates for both Keycloak and NGINX. `cert-manager` creates the required Kubernetes Secrets directly so no manual secret creation is needed for TLS.

Create a self-signed `ClusterIssuer` to bootstrap the CA, then issue the CA certificate and create a second `ClusterIssuer` backed by it:

```yaml
kubectl apply -f - <<EOF
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: selfsigned-cluster-issuer
spec:
  selfSigned: {}
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: local-ca
  namespace: cert-manager
spec:
  isCA: true
  commonName: LocalCA
  secretName: local-ca-secret
  issuerRef:
    name: selfsigned-cluster-issuer
    kind: ClusterIssuer
    group: cert-manager.io
---
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: local-ca-issuer
spec:
  ca:
    secretName: local-ca-secret
EOF
```

Create certificates for Keycloak and NGINX. cert-manager will create `keycloak-tls-cert` and `nginx-secret` in the `default` namespace:

```yaml
kubectl apply -f - <<EOF
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: keycloak-cert
  namespace: default
spec:
  secretName: keycloak-tls-cert
  issuerRef:
    name: local-ca-issuer
    kind: ClusterIssuer
  commonName: keycloak.default.svc.cluster.local
  dnsNames:
  - keycloak.default.svc.cluster.local
  - keycloak
  - localhost
  ipAddresses:
  - 127.0.0.1
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: nginx-cert
  namespace: default
spec:
  secretName: nginx-secret
  issuerRef:
    name: local-ca-issuer
    kind: ClusterIssuer
  commonName: cafe.example.com
  dnsNames:
  - cafe.example.com
EOF
```

### Configure Keycloak

If you already have an IdP set up with a realm, a client, and a user, skip to [Setup](#setup).

#### Start Keycloak

Deploy Keycloak to your cluster. Keycloak must serve HTTPS because NGINX connects to it over TLS for token exchange. The `keycloak-tls-cert` Secret was created by cert-manager in the previous step and is mounted into the Keycloak container below.

{{< call-out "note" >}}
The `redirectUris` field must include the exact hostname and port that the NGINX Gateway is exposed on. If you are accessing the Gateway via port-forward or on a non-standard port, include that port explicitly. For example, `https://cafe.example.com:9443/*`. If the URI does not match exactly what NGINX sends, Keycloak will reject the request with an `Invalid parameter: redirect_uri` error.
{{< /call-out >}}

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
          "clientId": "nginx-gateway-coffee",
          "enabled": true,
          "protocol": "openid-connect",
          "publicClient": false,
          "secret": "oidc-coffee-client-secret",
          "directAccessGrantsEnabled": true,
          "standardFlowEnabled": true,
          "redirectUris": ["https://cafe.example.com/*"],
          "webOrigins": ["https://cafe.example.com"]
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

Keycloak is configured with a realm named `nginx-gateway`, a client with ID `nginx-gateway-coffee` and secret `oidc-coffee-client-secret`, and a test user with username `testuser` and password `testpassword`. Update these values to match your environment before applying.

Store the client secret in a shell variable for use in later steps:

```shell
CLIENT_SECRET=oidc-coffee-client-secret
```

Once the pod is running, expose Keycloak with port-forward:

```shell
kubectl port-forward svc/keycloak 8443:8443
```

The browser must be able to resolve the Keycloak hostname to reach the login page during the OIDC flow. Add the following entry to your `/etc/hosts` file:

```text
127.0.0.1  keycloak.default.svc.cluster.local
```

To visit the Keycloak admin console, open `https://keycloak.default.svc.cluster.local:8443` in your browser.

---

## Setup

In this guide, you will deploy two sample applications behind a single HTTPS gateway. The `/coffee` path is protected by OIDC, so users must log in through the identity provider before accessing the **coffee** backend. The `/tea` path does not require authentication, and requests are forwarded directly to the **tea** backend.

### Deploy applications

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
        image: nginxdemos/nginx-hello
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
        image: nginxdemos/nginx-hello
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

Confirm the pods are running with `kubectl get pods`:

```shell
kubectl get pods
```

```text
NAME                      READY   STATUS    RESTARTS   AGE
coffee-654ddf664b-fllj7   1/1     Running   0          15s
tea-75bc9f4b6d-cx2jl      1/1     Running   0          15s
```

### Create a Gateway

OIDC requires an HTTPS listener. The `tls.certificateRefs` entry points to a Secret containing the TLS certificate and key that NGINX presents to clients. The `nginx-secret` Secret was created by cert-manager in the previous step.

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: gateway
spec:
  gatewayClassName: nginx
  listeners:
  - name: https
    port: 443
    protocol: HTTPS
    tls:
      mode: Terminate
      certificateRefs:
      - kind: Secret
        name: nginx-secret
EOF
```

Confirm the Gateway was assigned an IP address:

```shell
kubectl describe gateways.gateway.networking.k8s.io gateway
```

```text
Addresses:
  Type:   IPAddress
  Value:  10.96.20.187
```

Save the IP and port into shell variables:

```shell
GW_IP=XXX.YYY.ZZZ.III
GW_PORT=443
```

### Configure a DNS resolver

NGINX must resolve the IdP's hostname at runtime to fetch the OIDC discovery document and exchange tokens. Without a DNS resolver configured, NGINX cannot start the OIDC flow and will log `no resolver defined to resolve`. Before proceeding, configure a DNS resolver in the `NginxProxy` resource.

Get the IP address of the `kube-dns` service in the `kube-system` namespace:

```shell
kubectl get svc -n kube-system kube-dns
```

```text
NAME       TYPE        CLUSTER-IP   EXTERNAL-IP   PORT(S)         AGE
kube-dns   ClusterIP   10.96.0.10   <none>        53/UDP,53/TCP   10d
```

NGINX Gateway Fabric creates an `NginxProxy` resource during installation. Edit it to add the `dnsResolver` field:

```bash
kubectl edit nginxproxies.gateway.nginx.org -n nginx-gateway ngf-proxy-config
```

```yaml
spec:
  dnsResolver:
    addresses:
    - type: IPAddress
      value: 10.96.0.10
```

### Create the Keycloak Secret

This Secret holds the client secret and the CA certificate NGINX uses to verify Keycloak's TLS certificate on outbound connections. The CA certificate is extracted from the `keycloak-tls-cert` Secret that cert-manager created.

```shell
kubectl create secret generic keycloak-secret \
  --from-literal=client-secret=$CLIENT_SECRET \
  --from-file=ca.crt=<(kubectl get secret keycloak-tls-cert -o jsonpath='{.data.ca\.crt}' | base64 -d)
```

### Create the AuthenticationFilter

The `AuthenticationFilter` defines how NGINX communicates with the IdP. The only required fields are `issuer`, `clientID`, and `clientSecretRef`. Everything else is optional.

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.nginx.org/v1alpha1
kind: AuthenticationFilter
metadata:
  name: oidc-coffee
spec:
  type: OIDC
  oidc:
    clientSecretRef:
      name: keycloak-secret
    clientID: nginx-gateway-coffee
    issuer: https://keycloak.default.svc.cluster.local:8443/realms/nginx-gateway
    caCertificateRefs:
      - name: keycloak-secret
EOF
```

Verify the filter is accepted:

```shell
kubectl describe authenticationfilters.gateway.nginx.org oidc-coffee
```

```text
Status:
  Controllers:
    Conditions:
      Last Transition Time:  2026-03-17T10:00:00Z
      Message:               The AuthenticationFilter is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
Events:                      <none>
```

### Deploy the HTTPRoutes

Create an HTTPRoute with two rules. The `/coffee` rule attaches the `AuthenticationFilter`, whereas `/tea` is publicly accessible with no authentication required.

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: cafe-routes
spec:
  parentRefs:
  - name: gateway
    sectionName: https
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
        name: oidc-coffee
  - matches:
    - path:
        type: Exact
        value: /tea
    backendRefs:
    - name: tea
      port: 80
EOF
```

Verify the route is accepted:

```shell
kubectl describe httproute cafe-routes
```

```text
Status:
  Parents:
    Conditions:
      Last Transition Time:  2026-03-17T10:00:05Z
      Message:               The Route is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
      Last Transition Time:  2026-03-17T10:00:05Z
      Message:               All references are resolved
      Observed Generation:   1
      Reason:                ResolvedRefs
      Status:                True
      Type:                  ResolvedRefs
    Controller Name:         gateway.nginx.org/nginx-gateway-controller
    Parent Ref:
      Group:         gateway.networking.k8s.io
      Kind:          Gateway
      Name:          gateway
      Section Name:  https
Events:              <none>
```

---

## Verify OIDC authentication

For local testing, add the following entry to your `/etc/hosts` file so your browser can resolve `cafe.example.com` to the Gateway's public IP:

```text
<GW_IP>  cafe.example.com
```

The steps below use a browser for OIDC since the flow involves redirects and cookies that curl cannot handle end-to-end.

### Accessing the protected `/coffee` route

Open `https://cafe.example.com:$GW_PORT/coffee` in a browser. Because the route has an `AuthenticationFilter`, NGINX will:

1. Detect there is no valid session cookie.
1. Redirect your browser to the IdP's login page.
1. Log in with username `testuser` and password `testpassword`.
1. After you log in, redirect you back to NGINX with an authorization code.
1. Exchange the code for tokens in the background, set a session cookie, and forward you to the `coffee` backend.

You will see a response from the `coffee` application only after a successful login.

### Accessing the unprotected `/tea` route

Since `/tea` requires no authentication, you can access it directly with curl:

```shell
curl -k --resolve cafe.example.com:$GW_PORT:$GW_IP https://cafe.example.com:$GW_PORT/tea
```

```text
Server address: 10.244.0.10:8080
Server name: tea-75bc9f4b6d-ms2n8
Date: 17/Mar/2026:10:01:00 +0000
URI: /tea
Request ID: c7eb0509303de1c160cb7e7d2ac1d99f
```

The `tea` backend responds immediately with no authentication challenge because no `AuthenticationFilter` is attached to that rule.

## Optional configuration

### Session management

By default, NGINX issues a session cookie named `NGX_OIDC_SESSION` with an 8-hour timeout that resets on each request to a protected resource. Use `session.cookieName` and `session.timeout` to override these values.

```yaml
spec:
  type: OIDC
  oidc:
    session:
      cookieName: my-app-session
      timeout: 30m
```

### Logout

Use `logout.uri` to set the path a user visits to log out. When a request hits that path, NGINX clears the session and redirects to the IdP's logout endpoint. If `logout.postLogoutURI` is not set, NGINX returns a `200 OK` with the body "You have been logged out.". It can be set to a path to redirect the user there after logout. The path must be matched by an existing HTTPRoute rule. Set it to a full URL to redirect the user to an external page.

Use `logout.frontChannelLogoutURI` if your IdP uses front-channel logout, where the IdP sends a logout request to a browser-visible URL to clear the NGINX session. The IdP must send `iss` and `sid` as query parameters. Set `logout.tokenHint` to `true` if your IdP requires the original ID token to be passed in the logout request.

```yaml
spec:
  type: OIDC
  oidc:
    logout:
      uri: /logout
      postLogoutURI: /after_logout
      frontChannelLogoutURI: /frontchannel_logout
      tokenHint: true
```

### PKCE

PKCE (Proof Key for Code Exchange) prevents authorization code interception attacks. NGINX enables it automatically when the IdP requires the `S256` code challenge method. Set `pkce` explicitly if you need to force it on or off.

```yaml
spec:
  type: OIDC
  oidc:
    pkce: true
```

### Extra authentication arguments

Use `extraAuthArgs` to append additional query parameters to the authorization request sent to the IdP. For example, `prompt: "login"` forces the IdP to show the login page on every request, and `max_age` sets the maximum time in seconds since the user last authenticated before re-authentication is required.

```yaml
spec:
  type: OIDC
  oidc:
    extraAuthArgs:
      prompt: "login"
      max_age: "3600"
```

### Custom redirect URI

By default, NGINX Gateway Fabric registers the OIDC callback at `/oidc_callback_<namespace>_<filtername>`. Use `redirectURI` to set a different path. If you provide a path-only value, NGINX creates a location block to handle the callback. If you provide a full URL, it is treated as an external handler and no location block is created. Register the same value in your IdP as an allowed redirect URI.

```yaml
spec:
  type: OIDC
  oidc:
    redirectURI: /my_callback
```

### Custom IdP metadata URL

By default, NGINX fetches IdP metadata from `<issuer>/.well-known/openid-configuration`. Use `configURL` if your IdP exposes metadata at a different path.

```yaml
spec:
  type: OIDC
  oidc:
    configURL: "https://keycloak.example.com/realms/my-realm/.well-known/openid-configuration"
```

### Certificate Revocation List (CRL)

A CRL is a list of certificate serial numbers that a CA has revoked before expiry. When NGINX connects to the IdP over TLS, it checks the IdP's certificate against the CRL and rejects the connection if the certificate has been revoked. You are responsible for keeping the CRL up to date. A stale CRL may not catch recently revoked certificates. The `crlSecretRef` and `caCertificateRefs` fields are separate so you can rotate the CRL independently, though both keys can live in the same Secret.

```yaml
spec:
  type: OIDC
  oidc:
    crlSecretRef:
      name: oidc-crl
```

---

## Troubleshooting

### AuthenticationFilter is not accepted
- Confirm the filter's `type` is `OIDC` and the `oidc` block is present.
- Check that the Secrets referenced by `clientSecretRef`, `caCertificateRefs`, and `crlSecretRef` exist in the same namespace as the filter and contain the expected keys (`client-secret`, `ca.crt`, `ca.crl`).

### HTTPRoute is not accepted or reports `ResolvedRefs=False`
- Verify the `extensionRef` in the HTTPRoute matches the `AuthenticationFilter` name and namespace exactly.
- Confirm the route's `parentRefs` points to an HTTPS listener. OIDC filters are rejected on non-HTTPS listeners.

### Browser is stuck in a redirect loop
- Confirm the `redirectURI` registered in the IdP exactly matches the path NGINX is using (default: `/oidc_callback_<namespace>_<filtername>`).
- Ensure the Gateway's TLS certificate is valid for the hostname the browser is using.

## Further reading

- [Example deployment files for OIDC authentication](https://github.com/nginx/nginx-gateway-fabric/tree/main/examples/oidc-authentication)
- [NGINX OIDC module reference](https://nginx.org/en/docs/http/ngx_http_oidc_module.html)
- [How OpenID Connect works](https://openid.net/developers/how-connect-works/)
- [Single Sign-On with OpenID Connect and Identity Providers](https://docs.nginx.com/nginx/admin-guide/security-controls/configuring-oidc)
