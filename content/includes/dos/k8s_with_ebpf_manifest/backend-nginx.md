---
---

```backend-nginx.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backend-nginx
  namespace: app-protect-dos
  labels:
    app: backend-nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: backend-nginx
  template:
    metadata:
      labels:
        app: backend-nginx
    spec:
      containers:
        - name: nginx
          image: nginx:stable
          ports:
            - containerPort: 8080
          command: ["/bin/sh", "-c"]
          args:
            - |
              # Change default port from 80 to 8080
              sed -i 's/listen       80;/listen 8080;/g' /etc/nginx/conf.d/default.conf
              nginx -g "daemon off;"
---
apiVersion: v1
kind: Service
metadata:
  name: svc-backend-nginx
  namespace: app-protect-dos
  labels:
    app: backend-nginx
spec:
  type: ClusterIP
  selector:
    app: backend-nginx
  ports:
    - name: http
      port: 8080
      targetPort: 8080
      protocol: TCP
```