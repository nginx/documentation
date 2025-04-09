The first step is to add the `readOnlyRootFilesystem` value (as *true*) to your Kubernetes pod security context as follows:

```yaml
containers:
    - name: nginx
      ...
      securityContext:
          readOnlyRootFilesystem: true
    - name: waf-enforcer
      ...
      securityContext:
          readOnlyRootFilesystem: true
    - name: waf-config-mgr
      ...
      securityContext:
          readOnlyRootFilesystem: true
```

With a read-only root file system, you will likely still require write access for certain directories, such as logs and temporary files. You can add these directories by mounting them as writable volumes in your Kubernetes deployment. 

In this example, `/tmp` and `/var/log/nginx` are writable directories, essential for NGINX and App Protect operations.

```yaml
containers:
    - name: nginx
      ...
      volumeMounts:
           - name: app-protect-bd-config
             mountPath: /opt/app_protect/bd_config
           - name: app-protect-config
             mountPath: /opt/app_protect/config
           - name: tmp-volume
             mountPath: /tmp
           - name: nginx-log
             mountPath: /var/log/nginx
           - name: app-protect-bundles
             mountPath: /etc/app_protect/bundles
...

volumes:
        - name: app-protect-bd-config
          emptyDir: {}
        - name: app-protect-config
          emptyDir: {}
        - name: nginx-log
          emptyDir: {}
        - name: tmp-volume
          emptyDir: {}
        - name: app-protect-bundles
          persistentVolumeClaim:
            claimName: nap5-bundles-pvc 
```

A full example might look like the following:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nap5-deployment
spec:
  selector:
    matchLabels:
      app: nap5
  replicas: 2
  template:
    metadata:
      labels:
        app: nap5
    spec:
      imagePullSecrets:
        - name: regcred
      containers:
        - name: nginx
          image: <your-private-registry>/nginx-app-protect-5:<your-tag>
          imagePullPolicy: IfNotPresent
          securityContext:
            readOnlyRootFilesystem: true
          volumeMounts:
            - name: app-protect-bd-config
              mountPath: /opt/app_protect/bd_config
            - name: app-protect-config
              mountPath: /opt/app_protect/config
            - name: tmp-volume
              mountPath: /tmp
            - name: nginx-log
              mountPath: /var/log/nginx
            - name: app-protect-bundles
              mountPath: /etc/app_protect/bundles
        - name: waf-enforcer
          image: private-registry.nginx.com/nap/waf-enforcer:<version-tag>
          imagePullPolicy: IfNotPresent
          securityContext:
            readOnlyRootFilesystem: true
          env:
            - name: ENFORCER_PORT
              value: "50000"
          volumeMounts:
            - name: app-protect-bd-config
              mountPath: /opt/app_protect/bd_config
        - name: waf-config-mgr
          image: private-registry.nginx.com/nap/waf-config-mgr:<version-tag>
          imagePullPolicy: IfNotPresent
          securityContext:
            allowPrivilegeEscalation: false
            readOnlyRootFilesystem: true
            capabilities:
              drop:
                - all
          volumeMounts:
            - name: app-protect-bd-config
              mountPath: /opt/app_protect/bd_config
            - name: app-protect-config
              mountPath: /opt/app_protect/config
            - name: app-protect-bundles
              mountPath: /etc/app_protect/bundles
      volumes:
        - name: app-protect-bd-config
          emptyDir: {}
        - name: app-protect-config
          emptyDir: {}
        - name: nginx-log
          emptyDir: {}
        - name: tmp-volume
          emptyDir: {}
        - name: app-protect-bundles
          persistentVolumeClaim:
            claimName: nap5-bundles-pvc 
```