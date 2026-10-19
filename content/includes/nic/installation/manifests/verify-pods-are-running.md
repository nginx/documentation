---
f5-docs: DOCS-188
f5-product: F5 NGINX Ingress Controller
f5-files:
- content/nic/install/manifests.md
- content/nic/integrations/app-protect-dos/installation.md
- content/nic/integrations/app-protect-waf-v5/installation.md
- content/nic/integrations/app-protect-waf/installation.md
- content/nic/lts/install/manifests.md
---

To confirm the NGINX Ingress Controller pods are operational, run:

```shell
kubectl get pods --namespace=nginx-ingress
```
