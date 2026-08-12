---
f5-product: F5 DOS for NGINX
f5-files:
- content/nap-dos/deployment-guide/kubernetes.md
---

```dos-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: nap-dos
  namespace: app-protect-dos
spec:
  ports:
    - name: app 
      port: 80
      protocol: TCP
  selector:
    app: app-protect-dos
  type: NodePort 
```