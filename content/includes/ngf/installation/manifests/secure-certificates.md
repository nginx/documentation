---
---

{{< call-out "note" >}} These steps use a self-signed issuer, which should not be used in production environments. For production environments, you should use a real [CA issuer](https://cert-manager.io/docs/configuration/ca/). {{< /call-out >}}

First, create a CA (certificate authority) issuer:

```yaml
kubectl apply -f - <<EOF
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: selfsigned-issuer
  namespace: nginx-gateway
spec:
  selfSigned: {}
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: nginx-gateway-ca
  namespace: nginx-gateway
spec:
  isCA: true
  commonName: nginx-gateway
  secretName: nginx-gateway-ca
  privateKey:
    algorithm: RSA
    size: 2048
  issuerRef:
    name: selfsigned-issuer
    kind: Issuer
    group: cert-manager.io
---
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: nginx-gateway-issuer
  namespace: nginx-gateway
spec:
  ca:
    secretName: nginx-gateway-ca
EOF
```

{{< details summary="Example output" >}}

```text
issuer.cert-manager.io/selfsigned-issuer created
Warning: spec.privateKey.rotationPolicy: In cert-manager >= v1.18.0, the default value changed from `Never` to `Always`.
certificate.cert-manager.io/nginx-gateway-ca created
issuer.cert-manager.io/nginx-gateway-issuer created
```

{{< /details >}}

You will then need to create a server certificate for the NGINX Gateway Fabric control plane (server):

{{< call-out "note" >}}

The default service name is _nginx-gateway_, and the namespace is _nginx-gateway_, so the `dnsNames` value should be `nginx-gateway.nginx-gateway.svc`.

This value becomes the name of the NGINX Gateway Fabric control plane service.

{{< /call-out >}}

```yaml {hl_lines=[13]}
kubectl apply -f - <<EOF
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: nginx-gateway
  namespace: nginx-gateway
spec:
  secretName: server-tls
  usages:
  - digital signature
  - key encipherment
  dnsNames:
  - ngf-nginx-gateway-fabric.nginx-gateway.svc
  issuerRef:
    name: nginx-gateway-issuer
EOF
```

Since the TLS Secrets are mounted into each pod that uses them, the NGINX agent (client) Secret is duplicated by the NGINX Gateway Fabric control plane into whichever namespace NGINX is deployed into.

All updates to the source Secret are propagated to the duplicate Secrets. 

Add the certificate for the NGINX agent (client):

```yaml
kubectl apply -f - <<EOF
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: nginx
  namespace: nginx-gateway
spec:
  secretName: agent-tls
  usages:
  - "digital signature"
  - "key encipherment"
  dnsNames:
  - "*.cluster.local"
  issuerRef:
    name: nginx-gateway-issuer
EOF
```

`agent-tls` is the default name: if you use a different name, provide it when installing NGINX Gateway Fabric with the `agent-tls-secret` argument.

You should see the Secrets created in the `nginx-gateway` namespace:

```shell
kubectl -n nginx-gateway get secrets
```

{{< details summary="Example output" >}}

```text
agent-tls          kubernetes.io/tls   3      3s
nginx-gateway-ca   kubernetes.io/tls   3      15s
server-tls         kubernetes.io/tls   3      8s
```

{{< /details >}}