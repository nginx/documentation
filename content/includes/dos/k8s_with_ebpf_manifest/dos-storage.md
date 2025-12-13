---
---

```dos-storage.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-app-protect-dos-shared
  namespace: app-protect-dos
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```