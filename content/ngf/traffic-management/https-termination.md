---
title: Configure HTTPS termination
weight: 300
toc: true
f5-content-type: how-to
f5-product: FABRIC
f5-docs: DOCS-1421
f5-summary: >
   NGINX Gateway Fabric terminates HTTPS at the Gateway using a TLS certificate stored in a Kubernetes Secret that the HTTPS listener references through `certificateRefs`.
   cert-manager issues the certificate from a local self-signed CA and populates the Secret automatically, with a ReferenceGrant allowing the Gateway to read the Secret from a separate namespace.
   An HTTPRoute redirect filter on the HTTP listener sends plaintext requests to the HTTPS listener, so all client traffic is encrypted end-to-end.
---

Learn how to terminate HTTPS traffic using NGINX Gateway Fabric.

## Overview

In this guide, we will show how to configure HTTPS termination for your application, using an [HTTPRoute](https://gateway-api.sigs.k8s.io/api-types/httproute/) redirect filter, secret, and [ReferenceGrant](https://gateway-api.sigs.k8s.io/api-types/referencegrant/).

---

## Before you begin

- [Install]({{< ref "/ngf/install/" >}}) NGINX Gateway Fabric.

## Set up

Create the **coffee** application in Kubernetes by copying and pasting the following block into your terminal:

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

This will create the **coffee** service and a deployment. Run the following command to verify the resources were created:

```shell
kubectl get pods,svc
```

Your output should include the **coffee** pod and the **coffee** service:

```text
NAME                          READY   STATUS      RESTARTS   AGE
pod/coffee-6b8b6d6486-7fc78   1/1     Running   0          40s


NAME                 TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
service/coffee       ClusterIP   10.96.189.37   <none>        80/TCP    40s
```

## Configure HTTPS termination and routing

For HTTPS, we need a certificate and key stored in a Secret. This Secret will live in a separate namespace, so we will need a ReferenceGrant in order to access it. We use cert-manager to issue the certificate from a local self-signed CA, which creates the `cafe-secret` Secret automatically.

To create the **certificate** namespace, copy and paste the following into your terminal:

```yaml
kubectl apply -f - <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: certificate
EOF
```

{{< include "ngf/deploy-cert-manager.md" >}}

{{< include "ngf/cert-manager-local-ca.md" >}}

Create a `Certificate` for `cafe.example.com` in the `certificate` namespace. cert-manager will create the `cafe-secret` Secret containing `tls.crt`, `tls.key`, and `ca.crt`:

```yaml
kubectl apply -f - <<EOF
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: cafe-cert
  namespace: certificate
spec:
  secretName: cafe-secret
  issuerRef:
    name: local-ca-issuer
    kind: ClusterIssuer
  commonName: cafe.example.com
  dnsNames:
  - cafe.example.com
EOF
```

To create the **access-to-cafe-secret** referencegrant, copy and paste the following into your terminal:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: ReferenceGrant
metadata:
  name: access-to-cafe-secret
  namespace: certificate
spec:
  to:
  - group: ""
    kind: Secret
    name: cafe-secret # if you omit this name, then Gateways in default namespace can access all Secrets in the certificate namespace
  from:
  - group: gateway.networking.k8s.io
    kind: Gateway
    namespace: default
EOF
```

To create the **cafe** gateway, copy and paste the following into your terminal:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  name: cafe
spec:
  gatewayClassName: nginx
  listeners:
  - name: http
    port: 80
    protocol: HTTP
  - name: https
    port: 443
    protocol: HTTPS
    tls:
      mode: Terminate
      certificateRefs:
      - kind: Secret
        name: cafe-secret
        namespace: certificate
      options:
        nginx.org/ssl-protocols: "TLSv1.2 TLSv1.3"
        nginx.org/ssl-ciphers: "ECDHE-RSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:HIGH:!aNULL:!MD5"
        nginx.org/ssl-prefer-server-ciphers: "on"
EOF
```

This gateway configures:

- `http` listener for HTTP traffic
- `https` listener for HTTPS traffic. It terminates TLS connections using the `cafe-secret` we created. The SSL protocol and ciphers are also configured using the TLS options.

After creating the Gateway resource, NGINX Gateway Fabric will provision an NGINX Pod and Service fronting it to route traffic. Verify the gateway is created:

```shell
kubectl describe gateways.gateway.networking.k8s.io cafe
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

- Save the public IP address and port(s) of the Gateway into shell variables:

  ```text
   GW_IP=XXX.YYY.ZZZ.III
   GW_HTTP_PORT=<http port number>
   GW_HTTPS_PORT=<https port number>
  ```

{{< call-out "note" >}}

In a production environment, you should have a DNS record for the external IP address that is exposed, and it should refer to the hostname that the gateway will forward for.

{{< /call-out >}}

To create the httproute resources, copy and paste the following into your terminal:

```yaml
kubectl apply -f - <<EOF
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: cafe-tls-redirect
spec:
  parentRefs:
  - name: cafe
    sectionName: http
  hostnames:
  - "cafe.example.com"
  rules:
  - filters:
    - type: RequestRedirect
      requestRedirect:
        scheme: https
        port: 443
---
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: coffee
spec:
  parentRefs:
  - name: cafe
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
EOF
```

The first route issues a `requestRedirect` from the `http` listener on port 80 to `https` on port 443. The second route binds the `coffee` route to the `https` listener.

## Send traffic

Using the external IP address and ports for the NGINX Service, we can send traffic to our coffee application.

{{< call-out "note" >}}If you have a DNS record allocated for `cafe.example.com`, you can send the request directly to that hostname, without needing to resolve.{{< /call-out >}}

To test that NGINX sends an HTTPS redirect, we will send requests to the `coffee` service on the HTTP port. We
will use curl's `--include` option to print the response headers (we are interested in the `Location` header).

```shell
curl --resolve cafe.example.com:$GW_HTTP_PORT:$GW_IP http://cafe.example.com:$GW_HTTP_PORT/coffee --include
```

```text
HTTP/1.1 302 Moved Temporarily
...
Location: https://cafe.example.com/coffee
...
```

Now we will access the application over HTTPS. Since our certificate is signed by a local self-signed CA that curl does not trust, we will use curl's `--insecure` option to turn off certificate verification.

```shell
curl --resolve cafe.example.com:$GW_HTTPS_PORT:$GW_IP https://cafe.example.com:$GW_HTTPS_PORT/coffee --insecure
```

```text
Server address: 10.244.0.6:80
Server name: coffee-6b8b6d6486-7fc78
```

{{< include "ngf/sni-https.md" >}}

## See also

To set up a production-ready integration with cert-manager for HTTPS traffic, see the [Secure traffic using Let's Encrypt]({{< ref "/ngf/traffic-security/integrate-cert-manager.md" >}}) guide.

To learn more about redirects using the Gateway API, see the following resource:

- [Gateway API Redirects](https://gateway-api.sigs.k8s.io/guides/http-redirect-rewrite/)
