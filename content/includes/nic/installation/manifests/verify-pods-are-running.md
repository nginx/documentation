---
f5-docs: DOCS-1466
f5-product: INGRESS
f5-files:
- content/nic/install/manifests.md
- content/nic/integrations/app-protect-dos/installation.md
- content/nic/integrations/app-protect-waf-v5/installation.md
- content/nic/integrations/app-protect-waf/installation.md
---

To confirm the NGINX Ingress Controller pods are operational, run:

```shell
kubectl get pods --namespace=nginx-ingress
```
