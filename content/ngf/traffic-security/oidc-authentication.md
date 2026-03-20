---
title: Configure OpenID Connect authentication
weight: 400
toc: true
nd-content-type: how-to
nd-product: FABRIC
---

This page describes how to configure OpenID Connect authentication in NGINX Gateway Fabric using the `AuthenticationFilter` custom resource definition (CRD).

## Overview

OIDC authentication lets you delegate user login to a trusted Identity Provider (IdP) such as Keycloak, Okta, or Auth0. Once a user signs in through the IdP, that session is recognized across every route protected by the same IdP. They are not prompted to log in again when moving between applications. NGINX Gateway Fabric redirects unauthenticated users to the IdP, receives an authorization code after login, and exchanges that code for identity tokens on the user's behalf. Your backend services receive only requests that have already passed authentication and never handle credentials directly.

When a user requests a protected resource, NGINX Gateway Fabric uses the [Authorization Code Flow](https://openid.net/specs/openid-connect-core-1_0.html#CodeFlowAuth):

1. NGINX redirects the browser to the IdP's authorization endpoint.
2. The user authenticates with the IdP.
3. The IdP redirects the browser back to NGINX with a short-lived authorization code.
4. NGINX exchanges that code for an ID token and access token via a direct, back-channel HTTPS call to the IdP's token endpoint.
5. NGINX validates the ID token, creates a session cookie, and forwards the original request to the backend.
6. Subsequent requests carry the session cookie, so the IdP is not contacted again until the session expires.

TLS is required in two directions. For inbound connections, the callback redirect from the IdP back to NGINX must be served over HTTPS. The `AuthenticationFilter` must be attached to an HTTPRoute that uses an HTTPS listener, and the Gateway listener's `tls.certificateRefs` provides the certificate NGINX presents to the browser. For outbound connections, NGINX connects to the IdP over TLS to exchange the authorization code for tokens. By default, NGINX trusts the system CA bundle. To use a custom CA, specify it in `oidc.caCertificateRefs`. Attaching an OIDC `AuthenticationFilter` to a non-HTTPS route will cause the filter to be rejected.

OIDC configuration references Kubernetes `Opaque` Secrets for sensitive material. The `clientSecretRef` field expects a Secret with the key `client-secret`. Your IdP requires a client ID and secret to identify and authenticate the application contacting its realm. NGINX presents these credentials when exchanging the authorization code for tokens. The `caCertificateRefs` field expects a Secret with the key `ca.crt`, containing PEM-encoded CA certificates that NGINX uses to verify the IdP's TLS certificate on outbound connections. If omitted, NGINX uses the system CA bundle. The `crlSecretRef` field expects a Secret with the key `ca.crl`, containing a PEM-encoded Certificate Revocation List. NGINX checks the IdP's certificate serial number against this list before every outbound connection. This field can be omitted if CRL checking is not required.

You can consolidate multiple keys in a single Secret or use separate Secrets for each. Either approach works as long as each Secret contains the correct key name.

## Note

{{< call-out "important" >}}OIDC authentication requires [NGINX Plus]({{< ref "/ngf/install/nginx-plus.md" >}}) R34 or later and is not supported with open-source NGINX. {{< /call-out >}}

## Before you begin

To follow this guide, you need the following:

- [Install]({{< ref "/ngf/install/" >}}) NGINX Gateway Fabric with NGINX Plus R34 or later.
- Generate certificates for the IdP and NGINX using a local CA so they can communicate over TLS. You can also use a public CA for this.
- [Configure a Keycloak realm](#configure-keycloak) with a client and a test user, or use an existing IdP and skip to [Setup](#setup).


### Generate self-signed certificates

The following steps generate a local Certificate Authority (CA) and sign certificates for both Keycloak and NGINX.

Run the following commands to generate a local Certificate Authority:

```bash
openssl genrsa -out ca.key 4096

openssl req -x509 -new -nodes -key ca.key -sha256 -days 365 \
  -out ca.crt \
  -subj "/CN=LocalCA"
```

Run the following commands to generate a certificate for Keycloak, signed by the CA:

```bash
openssl genrsa -out keycloak.key 4096

openssl req -new -key keycloak.key -out keycloak.csr \
  -subj "/CN=host.docker.internal"

openssl x509 -req -in keycloak.csr \
  -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out keycloak.crt -days 365 \
  -extfile <(printf "subjectAltName=DNS:host.docker.internal,DNS:localhost,IP:127.0.0.1")
```

Run the following commands to generate a certificate for NGINX:

```bash
openssl genrsa -out nginx.key 4096

openssl req -new -key nginx.key -out nginx.csr \
  -subj "/CN=cafe.example.com"

openssl x509 -req -in nginx.csr \
  -CA ca.crt -CAkey ca.key -CAcreateserial \
  -out nginx.crt -days 365 \
  -extfile <(printf "subjectAltName=DNS:cafe.example.com")
```


### Configure Keycloak

If you already have an IdP set up with a realm, a client, and a user, skip to [Setup](#setup).

#### Start Keycloak

Run Keycloak locally using Docker, using the `keycloak.crt` and `keycloak.key` files generated in the previous step. Keycloak must serve HTTPS because NGINX connects to it over TLS for token exchange.

```shell
docker run -p 8443:8443 \
  -e KC_BOOTSTRAP_ADMIN_USERNAME=admin \
  -e KC_BOOTSTRAP_ADMIN_PASSWORD=admin \
  -v $(pwd)/keycloak.crt:/opt/keycloak/conf/server.crt.pem \
  -v $(pwd)/keycloak.key:/opt/keycloak/conf/server.key.pem \
  quay.io/keycloak/keycloak:latest start \
  --https-certificate-file=/opt/keycloak/conf/server.crt.pem \
  --https-certificate-key-file=/opt/keycloak/conf/server.key.pem
```

Once running, open `https://localhost:8443` and log in with username `admin` and password `admin`.

#### Create a realm

A realm is an isolated namespace in Keycloak for users, clients, and configuration. In the top-left dropdown, click Create realm, set the realm name to `nginx-gateway`, and click Create.

The issuer URL for this realm will be `https://<keycloak-host>:8443/realms/nginx-gateway`. You will use this as the `issuer` field in the `AuthenticationFilter`.

#### Create a client

Go to Clients in the left sidebar and click Create client. Set the client ID to `nginx-gateway`, enable Client authentication, and under Valid redirect URIs enter the callback path NGINX will use. If you are not setting a custom `redirectURI` in the filter, enter `https://cafe.example.com/oidc_callback_default_oidc-nginx-gateway`. Click Save, then open the Credentials tab and copy the client secret. You will store this in a Kubernetes Secret in the next step.

#### Create a test user

Go to Users in the left sidebar and click Create new user. Set the username to `testuser` and click Create. Open the Credentials tab, click Set password, enter a password, disable Temporary, and save.

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

OIDC requires an HTTPS listener. The `tls.certificateRefs` entry points to a Secret containing the TLS certificate and key that NGINX presents to browsers on incoming connections. Create a Secret from the `nginx.crt` and `nginx.key` files generated earlier and reference it here.

```shell
kubectl create secret tls nginx-secret --cert=nginx.crt --key=nginx.key
```

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

### Create the Keycloak Secret

This Secret holds two pieces of material the filter needs: the client secret from the `nginx-gateway` realm, and the CA certificate that NGINX uses to verify Keycloak's TLS certificate on outbound connections. Both come from earlier steps. The client secret is the value you copied from the Keycloak Credentials tab, and `ca.crt` is the local CA certificate generated in the [Generate self-signed certificates](#generate-self-signed-certificates) step.

```shell
kubectl create secret generic keycloak-secret \
  --from-literal=client-secret=<client-secret-from-keycloak> \
  --from-file=ca.crt=ca.crt
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
    clientID: nginx-gateway
    issuer: https://host.docker.internal:8443/realms/nginx-gateway
    redirectURI: /custom_callback
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

## Verify OIDC authentication

{{< call-out "note" >}}
Your client must be able to resolve `cafe.example.com` to the Gateway's public IP. The steps below use a browser for OIDC since the flow involves redirects and cookies that curl cannot handle end-to-end.
{{< /call-out >}}

### Accessing the protected `/coffee` route

Open `https://cafe.example.com/coffee` in a browser. Because the route has an `AuthenticationFilter`, NGINX will:

1. Detect there is no valid session cookie.
2. Redirect your browser to the IdP's login page.
3. After you log in, redirect you back to NGINX with an authorization code.
4. Exchange the code for tokens in the background, set a session cookie, and forward you to the `coffee` backend.

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

Use `logout.uri` to define the path a user visits to end their session. NGINX clears the local session and redirects to the IdP's logout endpoint. Use `logout.postLogoutURI` to control where the user lands after logout. A path-only value causes NGINX to return a 200 with "You have been logged out". A full URL redirects the user to an external page. Use `logout.frontChannelLogoutURI` if your IdP uses front-channel logout, where the IdP sends logout requests via an iframe to clear the NGINX session. The IdP must be configured to pass `iss` and `sid` arguments. Set `logout.tokenHint` to `true` if your IdP requires the original ID token to be included in the logout request.

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

By default, NGF registers the OIDC callback at `/oidc_callback_<namespace>_<filtername>`. Use `redirectURI` to set a different path. If you provide a path-only value, NGINX creates a location block to handle the callback. If you provide a full URL, it is treated as an external handler and no location block is created. Register the same value in your IdP as an allowed redirect URI.

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

### Full configuration example

The following example shows all fields populated, using a single Secret that bundles the client secret, CA certificate, and CRL together:

```yaml
kubectl apply -f - <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: oidc-all-in-one
  namespace: default
type: Opaque
stringData:
  client-secret: "<your-client-secret>"
  ca.crt: |
    -----BEGIN CERTIFICATE-----
    <your-CA-certificate>
    -----END CERTIFICATE-----
  ca.crl: |
    -----BEGIN X509 CRL-----
    <your-CRL>
    -----END X509 CRL-----
---
apiVersion: gateway.nginx.org/v1alpha1
kind: AuthenticationFilter
metadata:
  name: oidc-full
  namespace: default
spec:
  type: OIDC
  oidc:
    issuer: "https://keycloak.example.com/realms/my-realm"
    clientID: nginx-gateway
    clientSecretRef:
      name: oidc-all-in-one
    caCertificateRefs:
      - name: oidc-all-in-one
    crlSecretRef:
      name: oidc-all-in-one
    configURL: "https://keycloak.example.com/realms/my-realm/.well-known/openid-configuration"
    redirectURI: /my_callback
    pkce: true
    extraAuthArgs:
      prompt: "login"
      max_age: "3600"
    session:
      cookieName: my-app-session
      timeout: 30m
    logout:
      uri: /logout
      postLogoutURI: /after_logout
      frontChannelLogoutURI: /frontchannel_logout
      tokenHint: true
EOF
```

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

### NGINX logs contain `no resolver defined to resolve`
- NGINX cannot resolve the IdP's hostname. Add a DNS resolver to your `NginxProxy` resource using the cluster DNS address, which is typically the IP of the `kube-dns` service in the `kube-system` namespace.

```yaml
dnsResolver:
  addresses:
  - type: IPAddress
    value: 10.96.0.10
```

## Further reading

- [Example deployment files for OIDC authentication](https://github.com/nginx/nginx-gateway-fabric/tree/main/examples/oidc-authentication)
- [NGINX OIDC module reference](https://nginx.org/en/docs/http/ngx_http_oidc_module.html)
- [How OpenID Connect works](https://openid.net/developers/how-connect-works/)
- [Single Sign-On with OpenID Connect and Identity Providers](https://docs.nginx.com/nginx/admin-guide/security-controls/configuring-oidc)
