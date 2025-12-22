---
---

```dos-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: nap-dos
  namespace: app-protect-dos
spec:
  type: LoadBalancer
  externalTrafficPolicy: Local
  ports:
    - port: 80
      targetPort: 80
      protocol: TCP
  selector:
    app: app-protect-dos
```