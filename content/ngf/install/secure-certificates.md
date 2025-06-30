---
title: Add certificates for secure authentication
weight: 100
toc: true
nd-content-type: how-to
nd-product: NGF
nd-docs: DOCS-1851
---

By default, NGINX Gateway Fabric installs self-signed certificates to secure the connection between the NGINX Gateway Fabric control plane and the NGINX data plane pods. These certificates are created by a `cert-generator` job when NGINX Gateway Fabric is first installed.

However, because these certificates are self-signed and will expire after 3 years, we recommend a solution such as [cert-manager](https://cert-manager.io) to create and manage these certificates in a production environment.

This guide will step through how to install and use `cert-manager` to secure this connection.

{{< caution >}}

These steps should be completed before you install NGINX Gateway Fabric.

{{< /caution >}}

---

## Before you begin

To complete this guide, you will need the following prerequisites:

- Administrator access to a Kubernetes cluster.
- [Helm](https://helm.sh) and [kubectl](https://kubernetes.io/docs/tasks/tools/#kubectl) must be installed locally.

## Install cert-manager

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

This also enables Gateway API features for cert-manager, which can be useful for [securing your workload traffic]({{< ref "/ngf/traffic-security/integrate-cert-manager.md" >}}).

## Create the CA issuer

The first step is to create the CA (certificate authority) issuer.

{{< note >}} This example uses a self-signed Issuer, which should not be used in production environments. For production environments, you should use a real [CA issuer](https://cert-manager.io/docs/configuration/ca/). {{< /note >}}

Create the namespace:

```shell
kubectl create namespace nginx-gateway
```

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

## Create server and client certificates

Create the Certificate resources for the NGINX Gateway Fabric control plane (server) and the NGINX agent (client).

The `dnsName` field in the server Certificate represents the name that the NGINX Gateway Fabric control plane service will have once you install it. This name depends on your method of installation.

{{<tabs name="ngf-name">}}

{{%tab name="Helm"%}}

The full service name is of the format: `<helm-release-name>-nginx-gateway-fabric.<namespace>.svc`.

The default Helm release name used in our installation docs is `ngf`, and the default namespace is `nginx-gateway`, so the `dnsName` should be `ngf-nginx-gateway-fabric.nginx-gateway.svc`.

{{% /tab %}}

{{%tab name="Manifests"%}}

The full service name is of the format: `<service-name>.<namespace>.svc`.

By default, the base service name is `nginx-gateway`, and the namespace is `nginx-gateway`, so the `dnsName` should be `nginx-gateway.nginx-gateway.svc`.

{{% /tab %}}

{{</tabs>}}

```yaml
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
  - ngf-nginx-gateway-fabric.nginx-gateway.svc # this value may need to be updated
  issuerRef:
    name: nginx-gateway-issuer
EOF
```

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

Since the TLS Secrets are mounted into each pod that uses them, the NGINX agent (client) Secret is duplicated by the NGINX Gateway Fabric control plane into whichever namespace NGINX is deployed into. All updates to the source Secret are propagated to the duplicate Secrets.

The name of the agent Secret is provided to the NGINX Gateway Fabric control plane via the command-line. `agent-tls` is the default name, but if you wish to use a different name, you can provide it when installing NGINX Gateway Fabric:

{{<tabs name="tls-secret-names">}}

{{%tab name="Helm"%}}

Specify the Secret name using the `certGenerator.agentTLSSecretName` helm value.

{{% /tab %}}

{{%tab name="Manifests"%}}

Specify the Secret name using the `agent-tls-secret` command-line argument.

{{% /tab %}}

{{</tabs>}}

## Confirm the Secrets have been created

You should see the Secrets created in the `nginx-gateway` namespace:

```shell
kubectl -n nginx-gateway get secrets
```

```text
agent-tls          kubernetes.io/tls   3      3s
nginx-gateway-ca   kubernetes.io/tls   3      15s
server-tls         kubernetes.io/tls   3      8s
```

You can now [install NGINX Gateway Fabric]({{< ref "/ngf/install/" >}}).

## Next steps

- [Install NGINX Gateway Fabric with Helm]({{< ref "/ngf/install/helm.md" >}})
- [Install NGINX Gateway Fabric with Manifests]({{< ref "/ngf/install/manifests.md" >}})
- [Install NGINX Gateway Fabric with NGINX Plus]({{< ref "/ngf/install/nginx-plus.md" >}})
