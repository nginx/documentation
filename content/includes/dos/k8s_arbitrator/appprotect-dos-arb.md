---
---

```appprotect-dos-arb.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-protect-dos-arb
  namespace: app-protect-dos
spec:
  replicas: 1
  selector:
    matchLabels:
      app: appprotect-dos-arb
  template:
    metadata:
      labels:
        app: appprotect-dos-arb
    spec:
      containers:
        - name: arb-svc
          image: docker-registry.nginx.com/nap-dos/app_protect_dos_arb:latest
          ports:
            - containerPort: 3000
```