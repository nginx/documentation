---
title: Configure TLS routing with TLSRoute
weight: 600
toc: true
f5-content-type: how-to
f5-product: FABRIC
f5-docs: DOCS-1850
f5-summary: >
   NGINX Gateway Fabric supports two TLS modes for TLSRoute: passthrough and terminate.
   In passthrough mode, the Gateway forwards encrypted traffic to the backend using SNI-based (Server Name Indication) routing, and the backend terminates TLS with its own certificate.
   In terminate mode, the Gateway holds the certificate and terminates TLS, then forwards plain TCP traffic to the backend.
---

Learn how to configure TLS routing with [TLSRoute](https://gateway-api.sigs.k8s.io/reference/spec/#tlsroute) using NGINX Gateway Fabric.

## Overview

TLSRoute supports two TLS modes:

- **Passthrough**: The Gateway reads the SNI and forwards encrypted TCP traffic to the backend. The backend holds and terminates TLS with its own certificate. Use this mode when the backend needs its own certificate, or when you can't expose the private key to the gateway.
- **Terminate**: The Gateway holds the certificate, terminates TLS, and forwards plain TCP to the backend. Use this mode when the backend shouldn't handle TLS, or when it serves a non-HTTP TCP protocol.

{{< call-out "note" >}}You can add an HTTPS listener on the same port that terminates TLS connections, as long as the hostname doesn't overlap with the TLS listener hostname.{{< /call-out >}}

## Before you begin

- [Install]({{< ref "/ngf/install/" >}}) NGINX Gateway Fabric.

Set up cert-manager and a local CA for both examples:

{{< include "ngf/deploy-cert-manager.md" >}}

{{< include "ngf/cert-manager-local-ca.md" >}}

## TLS passthrough

### Set up

Create a `Certificate` for `app.example.com`. cert-manager creates the `app-tls-secret` Secret, which contains `tls.crt`, `tls.key`, and `ca.crt` and is mounted by the `secure-app` Pod:

```yaml
kubectl apply -f - <<EOF
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: app-cert
  namespace: default
spec:
  secretName: app-tls-secret
  issuerRef:
    name: local-ca-issuer
    kind: ClusterIssuer
  commonName: app.example.com
  dnsNames:
  - app.example.com
EOF
```

Create the `secure-app` application by copying and pasting the following block into your terminal:

```yaml
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: secure-app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: secure-app
  template:
    metadata:
      labels:
        app: secure-app
    spec:
      containers:
        - name: secure-app
          image: nginxdemos/nginx-hello:plain-text
          ports:
            - containerPort: 8443
          volumeMounts:
            - name: secret
              mountPath: /etc/nginx/ssl
              readOnly: true
            - name: config-volume
              mountPath: /etc/nginx/conf.d
      volumes:
        - name: secret
          secret:
            secretName: app-tls-secret
        - name: config-volume
          configMap:
            name: secure-config
---
apiVersion: v1
kind: Service
metadata:
  name: secure-app
spec:
  ports:
    - port: 8443
      targetPort: 8443
      protocol: TCP
      name: https
  selector:
    app: secure-app
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: secure-config
data:
  app.conf: |-
    server {
      listen 8443 ssl;
      listen [::]:8443 ssl;

      server_name app.example.com;

      ssl_certificate /etc/nginx/ssl/tls.crt;
      ssl_certificate_key /etc/nginx/ssl/tls.key;

      default_type text/plain;

      location / {
        return 200 "hello from pod \$hostname\n";
      }
    }
EOF
```

This will create the **secure-app** Service and a Deployment. The secure app is configured to serve HTTPS traffic on port 8443 for the host `app.example.com`, using the cert-manager-issued TLS certificate from `app-tls-secret`. The app responds to a client's HTTPS requests with a simple text response "hello from pod $POD_HOSTNAME".

Run the following command to verify the resources were created:

```shell
kubectl get pods,svc
```

The output should include the **secure-app** pod and the **secure-app** Service:

```text
NAME                              READY   STATUS      RESTARTS   AGE
pod/secure-app-575785644-kzqf6    1/1     Running     0          12s

NAME                  TYPE        CLUSTER-IP        EXTERNAL-IP   PORT(S)    AGE
service/secure-app    ClusterIP   192.168.194.152   <none>        8443/TCP   12s
```

Create a Gateway with a TLS listener in passthrough mode. Copy and paste this into your terminal:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: gateway
  namespace: default
spec:
  gatewayClassName: nginx
  listeners:
  - name: tls
    port: 443
    protocol: TLS
    hostname: "*.example.com"
    allowedRoutes:
      namespaces:
        from: All
      kinds:
        - kind: TLSRoute
    tls:
      mode: Passthrough
EOF
```

This Gateway configures NGINX Gateway Fabric to accept TLS connections on port 443 and forward them to the backend without decryption. The routing uses the SNI, which lets clients specify a server name during the TLS handshake.

After creating the Gateway resource, NGINX Gateway Fabric provisions an NGINX Pod and Service to route traffic. Verify the Gateway is created:

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
GW_TLS_PORT=<port number>
```

{{< call-out "note" >}}

In a production environment, you should have a DNS record for the external IP address that is exposed, and it should refer to the hostname that the Gateway will forward for.

{{< /call-out >}}

Create a TLSRoute that attaches to the Gateway and routes requests to `app.example.com` to the `secure-app` Service:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: TLSRoute
metadata:
  name: tls-secure-app-route
  namespace: default
spec:
  parentRefs:
  - name: gateway
    namespace: default
  hostnames:
  - "app.example.com"
  rules:
  - backendRefs:
    - name: secure-app
      port: 8443
EOF
```

{{< call-out "note" >}}To route to a Service in a Namespace different from the TLSRoute Namespace, create a [ReferenceGrant](https://gateway-api.sigs.k8s.io/reference/spec/#referencegrant) to permit the cross-namespace reference. {{< /call-out >}}

### Send traffic

Using the external IP address and port for the NGINX Service, send traffic to the `secure-app` application.

{{< call-out "note" >}}If you have a DNS record allocated for `app.example.com`, you can send the request directly to that hostname, without needing to resolve.{{< /call-out >}}

Send a request to the `secure-app` Service on the TLS port with the `--insecure` flag. The flag is required because `secure-app` uses a certificate signed by a local self-signed CA that curl does not trust.

```shell
curl --resolve app.example.com:$GW_TLS_PORT:$GW_IP https://app.example.com:$GW_TLS_PORT --insecure -v
```

```text
Added app.example.com:8443:127.0.0.1 to DNS cache
* Hostname app.example.com was found in DNS cache
*   Trying 127.0.0.1:8443...
* Connected to app.example.com (127.0.0.1) port 8443
* ALPN: curl offers h2,http/1.1
Handling connection for 8443
* (304) (OUT), TLS handshake, Client hello (1):
* (304) (IN), TLS handshake, Server hello (2):
* (304) (IN), TLS handshake, Unknown (8):
* (304) (IN), TLS handshake, Certificate (11):
* (304) (IN), TLS handshake, CERT verify (15):
* (304) (IN), TLS handshake, Finished (20):
* (304) (OUT), TLS handshake, Finished (20):
* SSL connection using TLSv1.3 / AEAD-CHACHA20-POLY1305-SHA256 / [blank] / UNDEF
* ALPN: server accepted http/1.1
* Server certificate:
*  subject: CN=app.example.com
*  start date: May  6 21:23:51 2026 GMT
*  expire date: Aug  4 21:23:51 2026 GMT
*  issuer: CN=LocalCA
*  SSL certificate verify result: unable to get local issuer certificate (20), continuing anyway.
* using HTTP/1.x
> GET / HTTP/1.1
> Host: app.example.com:8443
> User-Agent: curl/8.7.1
> Accept: */*
>
* Request completely sent off
< HTTP/1.1 200 OK
< Server: nginx/1.29.1
< Date: Wed, 06 May 2026 21:25:18 GMT
< Content-Type: text/plain
< Content-Length: 42
< Connection: keep-alive
<
hello from pod secure-app-59bbd475b-phgsv
```

Note that the server certificate used to terminate the TLS connection has the subject common name of `app.example.com`. This is the server certificate that the `secure-app` is configured with and shows that the TLS connection was terminated by the `secure-app`, not NGINX Gateway Fabric.

## TLS terminate

In terminate mode, NGINX Gateway Fabric holds the TLS certificate, terminates the TLS connection, and forwards plain TCP traffic to the backend. The backend doesn't need a certificate or TLS configuration.

Use TLS terminate mode when:

- Your backend serves a non-HTTP TCP protocol, such as a database or custom binary protocol.
- You want to centralize certificate management at the gateway rather than on each backend.

{{< call-out "note" >}}If your backend serves HTTP traffic and you need HTTP-level routing — such as path matching or header manipulation — use an HTTPS listener with an HTTPRoute instead. See [Configure HTTPS termination]({{< ref "/ngf/traffic-management/https-termination.md" >}}).{{< /call-out >}}

### Set up

Create a `Certificate` for `app.example.com`. cert-manager creates the `gateway-tls-secret` Secret, which the Gateway uses to terminate TLS:

```yaml
kubectl apply -f - <<EOF
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: gateway-cert
  namespace: default
spec:
  secretName: gateway-tls-secret
  issuerRef:
    name: local-ca-issuer
    kind: ClusterIssuer
  commonName: app.example.com
  dnsNames:
  - app.example.com
EOF
```

Create the `app` application. Because the Gateway terminates TLS, the backend doesn't need a certificate:

```yaml
kubectl apply -f - <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: app
  template:
    metadata:
      labels:
        app: app
    spec:
      containers:
        - name: app
          image: nginxdemos/nginx-hello:plain-text
          ports:
            - containerPort: 8080
---
apiVersion: v1
kind: Service
metadata:
  name: app
spec:
  ports:
    - port: 80
      targetPort: 8080
      protocol: TCP
      name: http
  selector:
    app: app
EOF
```

Run the following command to verify the resources were created:

```shell
kubectl get pods,svc
```

The output should include the **app** pod and the **app** Service:

```text
NAME                       READY   STATUS    RESTARTS   AGE
pod/app-6c8d9c4b5f-xr7tq   1/1     Running   0          10s

NAME          TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)   AGE
service/app   ClusterIP   192.168.194.87   <none>        80/TCP    10s
```

Create a Gateway with a TLS listener in terminate mode. Copy and paste this into your terminal:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: gateway
  namespace: default
spec:
  gatewayClassName: nginx
  listeners:
  - name: tls
    port: 443
    protocol: TLS
    hostname: "*.example.com"
    allowedRoutes:
      namespaces:
        from: All
      kinds:
        - kind: TLSRoute
    tls:
      mode: Terminate
      certificateRefs:
      - name: gateway-tls-secret
        namespace: default
EOF
```

NGINX Gateway Fabric terminates TLS using the certificate from `gateway-tls-secret` and forwards plain TCP traffic to the backend.

After creating the Gateway resource, NGINX Gateway Fabric provisions an NGINX Pod and Service to route traffic. Verify the Gateway is created:

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

Save the public IP address and port of the Gateway into shell variables:

```text
GW_IP=XXX.YYY.ZZZ.III
GW_TLS_PORT=<port number>
```

{{< call-out "note" >}}

In a production environment, you should have a DNS record for the external IP address that is exposed, and it should refer to the hostname that the Gateway will forward for.

{{< /call-out >}}

Create a TLSRoute that attaches to the Gateway and routes requests to `app.example.com` to the `app` Service:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: TLSRoute
metadata:
  name: tls-app-route
  namespace: default
spec:
  parentRefs:
  - name: gateway
    namespace: default
  hostnames:
  - "app.example.com"
  rules:
  - backendRefs:
    - name: app
      port: 80
EOF
```

{{< call-out "note" >}}To route to a Service in a Namespace different from the TLSRoute Namespace, create a [ReferenceGrant](https://gateway-api.sigs.k8s.io/reference/spec/#referencegrant) to permit the cross-namespace reference.{{< /call-out >}}

### Send traffic

Using the external IP address and port for the NGINX Service, send traffic to the `app` application.

{{< call-out "note" >}}If you have a DNS record allocated for `app.example.com`, you can send the request directly to that hostname, without needing to resolve.{{< /call-out >}}

Send a request to the `app` Service on the TLS port with the `--insecure` flag. The flag is required because the Gateway uses a certificate signed by a local self-signed CA that curl doesn't trust.

```shell
curl --resolve app.example.com:$GW_TLS_PORT:$GW_IP https://app.example.com:$GW_TLS_PORT --insecure
```

```text
Server address: 10.244.0.9:8080
Server name: app-6f65b8c59b-9lk8j
Date: 14/May/2026:17:06:41 +0000
URI: /
Request ID: dca1e1d0f48b11f50e15007056242349
```

The server certificate subject is `app.example.com`, which matches the certificate in `gateway-tls-secret`. This confirms that NGINX Gateway Fabric terminated the TLS connection, not the backend.

## See also

To learn more about TLS routing using the Gateway API, see the following resources:

- [Gateway API TLS routing](https://gateway-api.sigs.k8s.io/guides/tls-routing/)
- [Configure HTTPS termination]({{< ref "/ngf/traffic-management/https-termination.md" >}})
