---
f5-docs: DOCS-88
f5-product: F5 NGINX Gateway Fabric
f5-files:
- content/ngf/external-loadbalancers/BIG-IP/multicluster.md
- content/ngf/how-to/gateway-api-inference-extension.md
- content/ngf/traffic-management/https-termination.md
- content/ngf/traffic-management/tlsroute.md
- content/ngf/traffic-security/secure-backend.md
---

Create a self-signed `ClusterIssuer`, a CA `Certificate`, and a CA-backed `ClusterIssuer`. cert-manager uses the resulting `local-ca-issuer` to sign certificates in any namespace:

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
