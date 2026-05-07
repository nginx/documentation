---
nd-product: F5DOSN
nd-files:
- content/nap-dos/deployment-guide/kubernetes-with-L4-accelerated-mitigation.md
---

```dos-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: nap-dos
  namespace: app-protect-dos
spec:
  externalTrafficPolicy: Local
  ports:
    - name: app
      port: 80
      protocol: TCP
  selector:
    app: app-protect-dos
  type: LoadBalancer
```