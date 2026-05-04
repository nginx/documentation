---
---

```svc-appprotect-dos-arb.yaml
apiVersion: v1
kind: Service
metadata:
   name: svc-appprotect-dos-arb
   namespace: app-protect-dos
spec:
  selector:
     app: appprotect-dos-arb
  ports:
   - name: arb
     port: 3000
     protocol: TCP
     targetPort: 3000
  clusterIP: None
```