---
---

```appprotect-dos-arb.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: appprotect-dos-arb
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
        resources:
          requests:
            cpu: "200m"
            memory: "500Mi"
          limits:
            cpu:  "900m"
            memory: "800Mi"
        ports:
        - containerPort: 3000
```