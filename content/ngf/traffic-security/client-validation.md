---
title: Configure client request validation
weight: 100
toc: true
f5-content-type: how-to
f5-product: FABRIC
f5-docs: DOCS-000
f5-summary: >
    NGINX Gateway Fabric now supports configuration of client request validation through Frontend TLS.
    When configured, client requests to a specific HTTPS listener will be validated against a referenced CA cert for that listener.
    Frontend TLS provides a required default validation configuration, which will be applied to all HTTPS listeners for the Gateway.
    This default configuration can be overwritten for a specific port using the perPort configuration.
f5-keywords: ngf, nginx-gateway-fabric, kubernetes, cert-manager, tls, mtls, secure
---

Learn how to configure client request validation at the Gateway using Frontend TLS configuration in NGINX Gateway Fabric.

## Overview

In this guide, we will configure client to Gateway validation (mTLS) using the Gateway's Frontend TLS settings. This example shows how to validate client certificates at the Gateway, to ensure that communication between the client and the Gateway is secure, and that only authorized requests are processed and sent to the backend.

With Frontend TLS, the Gateway validates incoming client certificates against one or more CA certificates. You can configure validation at two levels:

- **Default**: Applies frontend validation to all HTTPS listeners on the Gateway.
- **Per-port**: Overrides the default frontend validation for specific listener ports.

Both **Default** and **Per-port** can be configured with one of two validation modes:

- **AllowValidOnly** (default): When set, a valid client certificate must be presented. Connections without a valid certificate are rejected.
- **AllowInsecureFallback**: When set, all connections with either a valid or invalid certificate are allowed, as well as no certificate.

CA certificates can be stored in either a `Secret` or a `ConfigMap`, and must contain the `ca.crt` key.

The following diagram shows how the mTLS handshake takes place between the client, and NGINX Gateway Fabric:

```mermaid
sequenceDiagram
    participant client as Client
    participant gw as NGINX Gateway Fabric
    participant app as backend application

    client->>gw: Send request and present cert for validation
    gw->>client: Present certificate from Secret: cafe-secret
    client->>client: Validate Gateway's certificate
    gw->>gw: Validate client certificate with CA Secret
    gw->>app: Request to backend
    app-->>gw: Response
    gw-->>client: Response
```

## Before you begin

Before starting, you will need:

- Administrator access to a Kubernetes cluster.
- [Helm](https://helm.sh/) and [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl) must be installed locally.
- [NGINX Gateway Fabric deployed]({{< ref "/ngf/install/" >}}) in the Kubernetes cluster.

## Install cert-manager

Frontend TLS requires CA certificates for client certificate validation. In this example, we will use [cert-manager](https://cert-manager.io/) to issue these certificates.

Add the Helm repository:

```shell
helm repo add jetstack https://charts.jetstack.io
helm repo update
```

Install cert-manager:

```shell
helm install \
  cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --set config.apiVersion="controller.config.cert-manager.io/v1alpha1" \
  --set config.kind="ControllerConfiguration" \
  --set config.enableGatewayAPI=true \
  --set crds.enabled=true
```

## Create CA certificates and issuers

Create a CA issuer to generate our certificates.

{{< call-out "warning" >}} This example uses a `selfSigned` Issuer, which should not be used in production environments. For production environments, use a real [CA issuer](https://cert-manager.io/docs/configuration/ca/). {{< /call-out >}}

Next, we create the following resources:
1. A self-signed issuer.
2. A CA certificate named `default-validation-ca-secret` for our **default** frontend TLS validation.
3. A CA certificate named `per-port-validation-ca-secret` for our **perPort** frontend TLS validation.
4. A CA certificate named `cafe-secret`. This will be referenced by the HTTPS listeners on the Gateway, and will be presented to the client during the TLS handshake.


{{< call-out "warning" >}} For the Gateway's certificate, replace `cafe.example.com` with the correct hostname for your environment {{< /call-out >}}

```yaml
kubectl apply -f - <<EOF
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: selfsigned-issuer
spec:
  selfSigned: {}
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: ca-certificate-default
spec:
  isCA: true
  commonName: LocalCA
  secretName: default-validation-ca-secret
  issuerRef:
    name: selfsigned-issuer
    kind: Issuer
    group: cert-manager.io
---
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: default-validation-issuer
spec:
  ca:
    secretName: default-validation-ca-secret # CA cert for default validation
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: ca-certificate-per-port
spec:
  isCA: true
  commonName: LocalCA
  secretName: per-port-validation-ca-secret
  issuerRef:
    name: selfsigned-issuer
    kind: Issuer
    group: cert-manager.io
---
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: per-port-validation-issuer
spec:
  ca:
    secretName: per-port-validation-ca-secret # CA cert for perPort validation
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: gateway-certificate
spec:
  commonName: cafe.example.com # Change to appropriate hostname for your environment
  secretName: cafe-secret # Gateway HTTPS Listener cert
  dnsNames:
  - cafe.example.com # Change to appropriate hostname for your environment
  issuerRef:
    name: selfsigned-issuer
    kind: Issuer
    group: cert-manager.io
EOF
```

## Deploy example applications

Create the coffee and tea applications that will serve as backends.
Copy and paste the following block into your terminal:

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

Verify the pods are running:

```shell
kubectl get pods
```

```text
NAME                       READY   STATUS    RESTARTS   AGE
coffee-6b8b6d6486-7fc78    1/1     Running   0          9s
tea-6fb46d899f-qlmz9       1/1     Running   0          9s
```


## Configure the Gateway with Frontend TLS

Create a Gateway resource with HTTPS listeners and Frontend TLS client certificate validation configured. This example shows:

- An HTTPS listener on port `443` with per-port client validation set to `AllowValidOnly`.
- An HTTPS listener on port `8443` with default client validation set to `AllowValidOnly` (default when omitted).

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
        name: cafe-secret
  - name: https-2
    port: 8443
    protocol: HTTPS
    tls:
      mode: Terminate
      certificateRefs:
      - kind: Secret
        name: cafe-secret
  tls:
    frontend:
      default: # Default applies to all other HTTPS listeners
        validation:
          caCertificateRefs:
          - kind: Secret
            group: ""
            name: default-validation-ca-secret
            namespace: default
      perPort:
      - port: 443 # perPort overrides default for this port
        tls:
          validation:
            caCertificateRefs:
            - group: ""
              kind: Secret
              name: per-port-validation-ca-secret
              namespace: default
            mode: AllowValidOnly
EOF
```

Key details:
- The `tls.frontend.default.validation` section defines the default client certificate validation. This applies to all HTTPS listeners unless overridden by a `perPort` configuration. This also references the Secret, `default-validation-ca-secret`, which we issued earlier.
- The `tls.frontend.perPort` section allows overriding the default validation for a specific listener port. In this example, port `443` is configured with `AllowValidOnly` mode, ensuring only valid client certificates are accepted. This also references the Secret, `per-port-validation-ca-secret`, which we issued earlier.
- The `caCertificateRefs` field references the CA certificate used to validate client certificates. This can be either a `Secret` or a `ConfigMap` with a `ca.crt` key.
- If `mode` is omitted, `AllowValidOnly` is applied by default.

Confirm the Gateway was created and is programmed:

```shell
kubectl describe gateways.gateway.networking.k8s.io gateway
```

You should see the Gateway status is `Accepted` and `Programmed`:

```text
Status:
  Addresses:
    Type:   IPAddress
    Value:  10.96.36.219
  Conditions:
    Type:   Accepted
    Status: True
    Type:   Programmed
    Status: True
```

You should also see that both Listeners on the Gateway are also `Accepted` and `Programmed`:

```text
  Listeners:
    Attached Routes:  0
    Conditions:
      Last Transition Time:  2026-05-05T07:38:57Z
      Message:               The Listener is programmed
      Observed Generation:   1
      Reason:                Programmed
      Status:                True
      Type:                  Programmed
      Last Transition Time:  2026-05-05T07:38:57Z
      Message:               The Listener is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
      Last Transition Time:  2026-05-05T07:38:57Z
      Message:               All references are resolved
      Observed Generation:   1
      Reason:                ResolvedRefs
      Status:                True
      Type:                  ResolvedRefs
      Last Transition Time:  2026-05-05T07:38:57Z
      Message:               No conflicts
      Observed Generation:   1
      Reason:                NoConflicts
      Status:                False
      Type:                  Conflicted
    Name:                    https
```

Save the public IP address and ports of the Gateway into shell variables.
In this example, we will want the port values for both frontend validation modes

```text
GW_IP=XXX.YYY.ZZZ.III
GW_DEFAULT=<port number>
GW_PER_PORT=<port number>
```

## Create HTTPRoutes

Copy the yaml below into your terminal to create HTTPRoutes to route traffic to the backend applications:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: tea
spec:
  parentRefs:
  - name: gateway
    sectionName: https # Uses port 443
  hostnames:
  - "cafe.example.com"
  rules:
  - matches:
    - path:
        type: PathPrefix
        value: /tea
    backendRefs:
    - name: tea
      port: 80
---
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: coffee
spec:
  parentRefs:
  - name: gateway
    sectionName: https-2 # Uses port 8443
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
EOF
```

Verify the HTTPRoute was created

```shell
kubectl describe httproutes | grep -i status -A 10
```

```text
Status:
  Parents:
    Conditions:
      Last Transition Time:  2026-05-06T06:57:53Z
      Message:               The Route is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
      Last Transition Time:  2026-05-06T06:57:53Z
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
      Namespace:     default
      Section Name:  https-2
Events:              <none>

--
Status:
  Parents:
    Conditions:
      Last Transition Time:  2026-05-06T06:57:53Z
      Message:               The Route is accepted
      Observed Generation:   1
      Reason:                Accepted
      Status:                True
      Type:                  Accepted
      Last Transition Time:  2026-05-06T06:57:53Z
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
      Namespace:     default
      Section Name:  https
Events:              <none>
```

## Setup configuration test

In order to send requests to the Gateway, we must provide a valid certificate and key that has been signed by a valid Certificate Authority (CA).

For this example, copy the block below into your terminal, to create two Certificate resources.
These will generate two `Secrets` with TLS certs and keys signed by the CAs we created earlier in this example.

{{< call-out "warning" >}} Replace `cafe.example.com` with the correct hostname for your environment {{< /call-out >}}

```yaml
kubectl apply -f - <<EOF
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: nginx-cert-default
spec:
  secretName: nginx-secret-default
  issuerRef:
    name: default-validation-issuer
    kind: Issuer
  commonName: cafe.example.com # Change to appropriate hostname for your environment
  dnsNames:
  - cafe.example.com # Change to appropriate hostname for your environment
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: nginx-cert-per-port
spec:
  secretName: nginx-secret-per-port
  issuerRef:
    name: per-port-validation-issuer
    kind: Issuer
  commonName: cafe.example.com # Change to appropriate hostname for your environment
  dnsNames:
  - cafe.example.com # Change to appropriate hostname for your environment
EOF
```

### Send a request with a valid client certificate

Use the following `curl` command to send a request to `/coffee` with the cert and key created earlier.
This request uses the cert and key signed by the CA used in the **default** frontend validation.
In this example, the request should pass.

```shell
curl --resolve cafe.example.com:$GW_DEFAULT:$GW_IP \
  https://cafe.example.com:$GW_DEFAULT/coffee \
  --cert <(kubectl get secret nginx-secret-default -o jsonpath='{.data.tls\.crt}' | base64 -d) \
  --key <(kubectl get secret nginx-secret-default -o jsonpath='{.data.tls\.key}' | base64 -d) \
  -k
```

```text
Server address: 10.244.0.11:8080
Server name: coffee-654ddf664b-pg7mg
Date: 01/May/2026:11:23:51 +0000
URI: /coffee
Request ID: 040e7899523c1a52194176b5808db9e4
```

The request succeeds because a valid client certificate signed by the trusted CA was presented.

Let's now also send a request to `/tea` with the same cert and key used in the `/coffee` request. Since `tea` is referencing the listener named `https`, the CA in `per-port-validation-ca-secret` will be used to verify the cert and key provided in the request. Since the cert and key were signed by the CA in `default-validation-ca-secret`, the request should fail.

```shell
curl --resolve cafe.example.com:$GW_PER_PORT:$GW_IP \
  https://cafe.example.com:$GW_PER_PORT/tea \
  --cert <(kubectl get secret nginx-secret-default -o jsonpath='{.data.tls\.crt}' | base64 -d) \
  --key <(kubectl get secret nginx-secret-default -o jsonpath='{.data.tls\.key}' | base64 -d) \
  -k
```

```text
curl: (92) HTTP/2 stream 1 was not closed cleanly: PROTOCOL_ERROR (err 1)
```

Lastly, let's send a request to `/tea` with the cert and key signed by the CA in `per-port-validation-ca-secret`:

```shell
curl --resolve cafe.example.com:$GW_PER_PORT:$GW_IP \
  https://cafe.example.com:$GW_PER_PORT/tea \
  --cert <(kubectl get secret nginx-secret-per-port -o jsonpath='{.data.tls\.crt}' | base64 -d) \
  --key <(kubectl get secret nginx-secret-per-port -o jsonpath='{.data.tls\.key}' | base64 -d) \
  -k
```

```text
Server address: 10.244.0.12:8080
Server name: tea-75bc9f4b6d-cjz47
Date: 05/May/2026:08:08:51 +0000
URI: /tea
Request ID: c326f89b0541b6109cf2a9306c45d0cd
```

## See also

- [Gateway API TLS configuration](https://gateway-api.sigs.k8s.io/guides/tls/)
- [HTTPS Termination](https://docs.nginx.com/nginx-gateway-fabric/traffic-management/https-termination/)
- [Secure traffic using Let's Encrypt and cert-manager](https://docs.nginx.com/nginx-gateway-fabric/traffic-security/integrate-cert-manager/)
- [Securing backend traffic using mutual TLS](https://docs.nginx.com/nginx-gateway-fabric/traffic-security/secure-backend/)
