---
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