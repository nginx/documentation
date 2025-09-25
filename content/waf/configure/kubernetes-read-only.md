---
# We use sentence case and present imperative tone
title: "Add a read-only filesystem for Kubernetes  "
# Weights are assigned in increments of 100: determines sorting order
weight: 700
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

This page describes how to add a read-only filesystem when deploying F5 WAF for NGINX when using Kubernetes.

It restricts the root filesystem to read-only mode, improving security by limiting potential write access in case of compromise.

## Before you begin

To complete this guide, you will need the following prerequisites:

- A Kubernetes cluster that supports read-only root file systems
- The cluster must have access to the NGINX and F5 WAF configuration files

You may need to identify any extra paths that need to be writable by F5 WAF for NGINX during runtime: this document assumes you are using the default paths.

## Enable readOnlyRootFilesystem and configure writable paths 

The first step is to add the `readOnlyRootFilesystem` value (as true) to your Kubernetes pod security context as follows:

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

In the following example, `/tmp` and `/var/log/nginx` are writable directories, essential for NGINX and F5 WAF operations.

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

A full example could look like the following:

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

## Update NGINX configuration with writable paths

Once you have created writable paths in your Kubernetes cluster, you should update your NGINX configuration to use these paths.

The following are fields in _nginx.conf_ you should update, which correspond to writable volumes configured during the last step:

```nginx
user  nginx;
worker_processes  auto;

# F5 WAF for NGINX
load_module modules/ngx_http_app_protect_module.so;

error_log  /var/log/nginx/error.log debug;
pid        /tmp/nginx.pid; 

events {
    worker_connections  1024;
}

http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log;

    # Temporary directories for kubernetes "readonlyfilesystem"
    client_body_temp_path /tmp/nginx-client-body;
    proxy_temp_path       /tmp/nginx-proxy;
    fastcgi_temp_path     /tmp/nginx-fastcgi;
    uwsgi_temp_path       /tmp/nginx-uwsgi;
    scgi_temp_path        /tmp/nginx-scgi;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    # F5 WAF for NGINX
    app_protect_enforcer_address 127.0.0.1:50000;

    include /etc/nginx/conf.d/*.conf;
}
```