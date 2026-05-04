---
f5-product: FABRIC
f5-files:
- content/ngf/traffic-security/oidc-authenication.md
- content/ngf/traffic-security/jwt-authenication.md
---

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