---
f5-docs: DOCS-50
f5-product: F5 DoS for NGINX
f5-files:
- content/nap-dos/deployment-guide/kubernetes.md
---

```dos-log-default-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: dos-log-default
  namespace: app-protect-dos
data:
 log-default.json: |
    {
      "filter": {
        "traffic-mitigation-stats": "all",
        "bad-actors": "all",
        "attack-signatures": "all"
      }
    }
```