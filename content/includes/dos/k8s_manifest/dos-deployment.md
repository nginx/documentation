---
---

```dos-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app-protect-dos
  namespace: app-protect-dos
  labels:
    app: app-protect-dos
spec:
  replicas: 1
  revisionHistoryLimit: 10
  selector:
    matchLabels:
      app: app-protect-dos
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 2
      maxUnavailable: 1
  template:
    metadata:
      labels:
        app: app-protect-dos
    spec:
      containers:
        - name: nginx-app-protect-dos
          image: <your-private-registry>/<your-nginx-app-protect-dos-image-name>:<your-tag>
          imagePullPolicy: Always

          command: ["/bin/bash", "-c"]
          args:
            - |
              /root/entrypoint.sh

          resources:
            requests:
              cpu: "200m"
              memory: "500Mi"
            limits:
              cpu: "900m"
              memory: "800Mi"

          ports:
            - containerPort: 80
              name: web
            - containerPort: 8090
              name: probe
            - containerPort: 8091
              name: probe500

          livenessProbe:
            httpGet:
              path: /app_protect_dos_liveness
              port: 8090
            initialDelaySeconds: 5
            periodSeconds: 10

          readinessProbe:
            httpGet:
              path: /app_protect_dos_readiness
              port: 8090
            initialDelaySeconds: 5
            periodSeconds: 10    

          volumeMounts:
            - name: shared-dir
              mountPath: /shared/
            - name: conf
              mountPath: /etc/nginx/nginx.conf
              subPath: nginx.conf
            - name: log-default
              mountPath: /etc/app_protect_dos/log-default.json
              subPath: log-default.json
        
      volumes:
        - name: shared-dir
          persistentVolumeClaim:
            claimName: pvc-app-protect-dos-shared
        - name: conf
          configMap:
            name: dos-nginx-conf
            items:
              - key: nginx.conf
                path: nginx.conf
        - name: log-default
          configMap:
            name: dos-log-default
            defaultMode: 0644
            items:
              - key: log-default.json
                path: log-default.json

```