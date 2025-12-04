---
---

```svc-appprotect-dos-arb.yaml
apiVersion: v1
kind: Service
metadata:
  name: svc-appprotect-dos
  namespace: appprotect-dos-wp-diff
  labels:
    app: appprotect-dos
spec:
  ports:
    - name: app
      port: 80
      protocol: TCP
      nodePort: 80
  selector:
    app: appprotect-dos
  type: NodePort```