---
title: Deploying NGINX App Protect WAF on Kubernetes
weight: 300
toc: true
type: how-to
product: NAP-WAF
docs: DOCS-1366
---

## Prerequisites

- An active F5 NGINX App Protect WAF subscription in [MyF5](https://my.f5.com/) (purchased or trial).
- A functional Kubernetes cluster.
- `kubectl` command-line tool, properly configured.

## Build the NGINX Image

Follow the instructions below to build a Docker image containing the NGINX and the NGINX App Protect module.

### Download Certificates

{{< include "nap-waf/download-certificates.md" >}}

Proceed, by creating a `Dockerfile` using one of the examples provided below.

### Dockerfile Based on the Official NGINX Image

{{< include "nap-waf/build-from-official-nginx-image.md" >}}

### NGINX Open Source Dockerfile

{{<tabs name="nap5_nginx_OSS_dockerfiles">}}
{{%tab name="Alpine Linux"%}}
 
{{< include "nap-waf/config/v5/build-nginx-image-oss/build-alpine.md" >}}

{{%/tab%}}
{{%tab name="Amazon Linux 2"%}}

{{< include "nap-waf/config/v5/build-nginx-image-oss/build-amazon.md" >}}

{{%/tab%}}
{{%tab name="CentOS"%}}

{{< include "nap-waf/config/v5/build-nginx-image-oss/build-centos.md" >}}

{{%/tab%}}
{{%tab name="Debian"%}}

{{< include "nap-waf/config/v5/build-nginx-image-oss/build-debian.md" >}}

{{%/tab%}}
{{%tab name="Oracle Linux 8"%}}

{{< include "nap-waf/config/v5/build-nginx-image-oss/build-oracle.md" >}}

{{%/tab%}}
{{%tab name="RHEL"%}}

{{< include "nap-waf/config/v5/build-nginx-image-oss/build-rhel.md" >}}

{{%/tab%}}
{{%tab name="Ubuntu"%}}

{{< include "nap-waf/config/v5/build-nginx-image-oss/build-ubuntu.md" >}}

{{%/tab%}}
{{</tabs>}}

You are ready to [Build the image](#build-image).

### NGINX Plus Dockerfile

{{<tabs name="nap5_nginx_plus_dockerfiles">}}
{{%tab name="Alpine Linux"%}}
 
{{< include "nap-waf/config/v5/build-nginx-image-plus/build-alpine.md" >}}

{{%/tab%}}
{{%tab name="Amazon Linux 2"%}}

{{< include "nap-waf/config/v5/build-nginx-image-plus/build-amazon.md" >}}

{{%/tab%}}
{{%tab name="CentOS"%}}

{{< include "nap-waf/config/v5/build-nginx-image-plus/build-centos.md" >}}

{{%/tab%}}
{{%tab name="Debian"%}}

{{< include "nap-waf/config/v5/build-nginx-image-plus/build-debian.md" >}}

{{%/tab%}}
{{%tab name="Oracle Linux 8"%}}

{{< include "nap-waf/config/v5/build-nginx-image-plus/build-oracle.md" >}}

{{%/tab%}}
{{%tab name="RHEL"%}}

{{< include "nap-waf/config/v5/build-nginx-image-plus/build-rhel.md" >}}

{{%/tab%}}
{{%tab name="Ubuntu"%}}

{{< include "nap-waf/config/v5/build-nginx-image-plus/build-ubuntu.md" >}}

{{%/tab%}}
{{</tabs>}}

### Build Image

{{< include "nap-waf/build-nginx-image-cmd.md" >}}

Next, push it to your private image repository, ensuring it's accessible to your Kubernetes cluster.

## NGINX Configuration

In your nginx configuration:

1. Load the NGINX App Protect WAF v5 module at the main context:

    ```nginx
    load_module modules/ngx_http_app_protect_module.so;
    ```

2. Configure the Enforcer address at the `http` context:

    ```nginx
    app_protect_enforcer_address 127.0.0.1:50000;
    ```

3. Enable NGINX App Protect WAF on an `http/server/location` context (make sure you only enable NGINX App Protect WAF with `proxy_pass`/`grpc_pass` locations):

    ```nginx
    app_protect_enable on;
    ```

In this guide, the following files are used:

{{<tabs name="nap5_install_conf_files_k8s">}}
{{%tab name="nginx.conf"%}}

`/etc/nginx/nginx.conf`

{{< include "nap-waf/nginx-conf-localhost.md" >}}

{{%/tab%}}
{{%tab name="default.conf"%}}

`/etc/nginx/conf.d/default.conf`

{{< include "nap-waf/default-conf-localhost.md" >}}

{{%/tab%}}
{{</tabs>}}

## WAF Services Configuration

### JWT Token and Docker Config Secret

1. Create a Kubernetes secret:

    ```shell
    kubectl create secret docker-registry regcred --docker-server=private-registry.nginx.com --docker-username=<JWT Token> --docker-password=none
    ```

    It is important that the `--docker-username=<JWT Token>` contains the contents of the token and does not point to the token itself. Ensure that when you copy the contents of the JWT token, there are no additional characters or extra whitespaces. This can invalidate the token and cause 401 errors when trying to authenticate to the registry. Use `none` for password (as the password is not used).

2. Verify Secret:

    ```shell
    kubectl get secret regcred --output=yaml
    ```

3. Use Secret in Deployments:

The Secret is now available for use in manifest deployments.

{{< include "security/jwt-password-note.md" >}}

### Manifest Deployment

In this configuration, two replicas are deployed, with each hosting both NGINX and WAF services together in a single Kubernetes pod.

For simplification in this documentation, we're using a hostPath backed persistent volume claim `nap5-storage.yaml`:

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nap5-bundles-pv
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: "/mnt/nap5_bundles_pv_data"
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nap5-bundles-pvc
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
  volumeName: nap5-bundles-pv
```

An example `nap5-deployment.yaml`:

Replace the `<your-private-registry>/nginx-app-protect-5:<your-tag>` with the actual image tag.

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
          volumeMounts:
            - name: app-protect-bd-config
              mountPath: /opt/app_protect/bd_config
            - name: app-protect-config
              mountPath: /opt/app_protect/config
        - name: waf-enforcer
          image: private-registry.nginx.com/nap/waf-enforcer:<version-tag>
          imagePullPolicy: IfNotPresent
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
        - name: app-protect-bundles
          persistentVolumeClaim:
            claimName: nap5-bundles-pvc
```

Finally, `nap5-service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx
spec:
  selector:
    app: nap5
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: NodePort
```

### Start Deployment

1. Assuming the above manifests are saved in the `/home/user/k8s` directory, you can deploy them by executing the following command:

    ```shell
    kubectl apply -f /home/user/k8s
    ```

    Example output:

    ```shell
    deployment.apps/nap5-deployment created
    service/nginx created
    persistentvolume/nap5-bundles-pv created
    persistentvolumeclaim/nap5-bundles-pvc created
    ```

    This command tells `kubectl` to apply the configuration defined in all the files within the `/home/user/k8s` directory to your Kubernetes cluster.

2. Verify the deployment:

    - Check the status of the deployment using:

        ```bash
        kubectl get deployments
        ```

    - Verify that the pods are running with:

        ```bash
        kubectl get pods
        ```

    - Verify services with:

        ```bash
        kubectl get services
        ```

    - To verify the enforcement functionality, ensure the following request is rejected:

        ```shell
        curl "<node-external-ip>:<node-port>/<script>"
        ```

3. To restart the deployment, use:

    ```shell
    kubectl rollout restart deployment.apps/nap5-deployment
    ```

4. To remove the deployment, use:

    ```shell
    kubectl delete -f /home/user/k8s
    ```

## Configure read only file systems
NGINX App Protect WAF v5 allows you to enable the `readOnlyRootFilesystem` option in your [Kubernetes Configuration](
https://kubernetes.io/docs/tasks/configure-pod-container/security-context/). This option restricts the root filesystem to read-only mode, which improves security by limiting potential write access in case of compromise.

To enable this feature, you will need a Kubernetes cluster that supports read-only root file systems, and you access to the NGINX and NGINX App Protect WAF configurations. 

You may need to identify any extra paths that need to be writable by App Protect during runtime: the following steps assume you are using the defaults path.

---
 
### Enable `readOnlyRootFilesystem` and configure writable paths

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

---

### Update NGINX configuration with writable paths

Once you have created writable paths in your Kubernetes cluster, you should update your NGINX configuration to use these paths.

The following are fields in `nginx.conf` you should update, which correspond to writable volumes configured during the last step:

```nginx
pid        /tmp/nginx.pid;
...
http {
...
    # Temporary directories for kubernetes "readonlyfilesystem"
    client_body_temp_path /tmp/nginx-client-body;
    proxy_temp_path       /tmp/nginx-proxy;    
    fastcgi_temp_path     /tmp/nginx-fastcgi;    
    uwsgi_temp_path       /tmp/nginx-uwsgi;    
    scgi_temp_path        /tmp/nginx-scgi;
...
}
```

A full example might look like the following:

```nginx
user  nginx;
worker_processes  auto;

# NGINX App Protect WAF
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

    # NGINX App Protect WAF
    app_protect_enforcer_address 127.0.0.1:50000;

    include /etc/nginx/conf.d/*.conf;
}
```

--- 
 
### Remediate possible issues

- **Permission denied errors**:
  If you encounter file permission issues, verify that the paths requiring write access are correctly configured as writable volumes in the pod manifest.
- **NGINX App Protect WAF initialization errors**:  
  Check the NGINX and NGINX App Protect Logs to ensure that App Protect can write to necessary files like logs and temporary directories.

For general issues, read the [Troubleshooting]({{< ref "/nap-waf/v5/troubleshooting-guide/troubleshooting.md" >}}) topic.

---

## mTLS Deployment 

To secure traffic between NGINX and App Protect Enforcer using mTLS, follow the steps below:

{{< note >}} Refer to the [Configuration Guide]({{< relref "/nap-waf/v5/configuration-guide/configuration.md#secure-traffic-between-nginx-and-app-protect-enforcer-using-mtls" >}}) to generate certificates and modify the `nginx.conf` for mTLS.
{{< /note >}}

First, create a Kubernetes Secret that contains the certificate and key files:
	
```shell
	kubectl create secret generic enforcer-certificates \
	--from-file=app_protect_server.crt=/path/to/app_protect_server.crt \
	--from-file=app_protect_server.key=/path/to/app_protect_server.key \
	--from-file=app_protect_client_ca.crt=/path/to/app_protect_client_ca.crt
```

Next, update or create the `nap5-deployment.yaml` to mount the Secret as a volume and set the environment variables to point to the mounted files: 

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
	          volumeMounts:
	            - name: app-protect-bd-config
	              mountPath: /opt/app_protect/bd_config
	            - name: app-protect-config
	              mountPath: /opt/app_protect/config
	            - name: certs
	              mountPath: /etc/ssl/certs
	              readOnly: true
	            - name: waf-enforcer
	              image: private-registry.nginx.com/nap/waf-enforcer:<version-tag>
	              imagePullPolicy: IfNotPresent
	              env:
	                - name: ENFORCER_PORT
	                  value: "4431"
	                - name: ENFORCER_SERVER_CERT
	                  value: "/etc/ssl/certs/app_protect_server.crt"
	                - name: ENFORCER_SERVER_KEY
	                  value: "/etc/ssl/certs/app_protect_server.key"
	                - name: ENFORCER_CA_FILE
	                  value: "/etc/ssl/certs/app_protect_client_ca.crt"
	              volumeMounts:
	                - name: app-protect-bd-config
	                  mountPath: /opt/app_protect/bd_config
	                - name: certs
	                  mountPath: /etc/ssl/certs
	                  readOnly: true
	            - name: waf-config-mgr
	              image: private-registry.nginx.com/nap/waf-config-mgr:<version-tag>
	              imagePullPolicy: IfNotPresent
	              securityContext:
	                allowPrivilegeEscalation: false
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
	            - name: app-protect-bundles
	              persistentVolumeClaim:
	                claimName: nap5-bundles-pvc
	            - name: certs
	              secret:
	                secretName: enforcer-certificates
```

## Using Compiled Policy and Logging Profile Bundles in NGINX

In this setup, copy your compiled policy and logging profile bundles to `/mnt/nap5_bundles_pv_data` on a cluster node. Then, in your NGINX configuration, refer to these files from `/etc/app_protect/bundles`.

For example, to apply `custom_policy.tgz` that you've placed in `/mnt/nap5_bundles_pv_data/`, use:

   ```nginx
   app_protect_policy_file "/etc/app_protect/bundles/custom_policy.tgz";
   ```

The NGINX configuration can be integrated using a configmap mount.

## Air-Gap Install: Secure Offline Deployment

### Prerequisites
- Active NGINX App Protect WAF subscription in [MyF5](https://my.f5.com/) (purchased or trial) on the online machine.
- Docker (with Docker Compose) is [installed and running](https://docs.docker.com/engine/install/) on both the online and offline/Air-Gap machine.
- Local registry for the offline/Air-Gap machine
- A functional Kubernetes cluster.
- `kubectl` command-line tool, properly configured.

### Build the NGINX Image

Follow the instructions below to build a Docker image containing the NGINX and the NGINX App Protect module on the machine connected to the internet.

#### Download Certificates

{{< include "nap-waf/download-certificates.md" >}}

Proceed, by creating a `Dockerfile` using one of the examples provided below.

#### Dockerfile Based on the Official NGINX Image

{{< include "nap-waf/build-from-official-nginx-image.md" >}}

#### NGINX Open Source Dockerfile

{{<tabs name="offline_nap5_nginx_OSS_dockerfiles">}}
{{%tab name="Alpine Linux"%}}
 
{{< include "nap-waf/config/v5/build-nginx-image-oss/build-alpine.md" >}}

{{%/tab%}}
{{%tab name="Debian"%}}

{{< include "nap-waf/config/v5/build-nginx-image-oss/build-debian.md" >}}

{{%/tab%}}
{{%tab name="Oracle Linux 8"%}}

{{< include "nap-waf/config/v5/build-nginx-image-oss/build-oracle.md" >}}

{{%/tab%}}
{{%tab name="RHEL"%}}

{{< include "nap-waf/config/v5/build-nginx-image-oss/build-rhel.md" >}}

{{%/tab%}}
{{%tab name="Ubuntu"%}}

{{< include "nap-waf/config/v5/build-nginx-image-oss/build-ubuntu.md" >}}

{{%/tab%}}
{{</tabs>}}

You are ready to [Build the image](#build-image-sub)

#### NGINX Plus Dockerfile

{{<tabs name="offline_nap5_nginx_plus_dockerfiles">}}
{{%tab name="Alpine Linux"%}}
 
{{< include "nap-waf/config/v5/build-nginx-image-plus/build-alpine.md" >}}

{{%/tab%}}
{{%tab name="Debian"%}}

{{< include "nap-waf/config/v5/build-nginx-image-plus/build-debian.md" >}}

{{%/tab%}}
{{%tab name="Oracle Linux 8"%}}

{{< include "nap-waf/config/v5/build-nginx-image-plus/build-oracle.md" >}}

{{%/tab%}}
{{%tab name="RHEL"%}}

{{< include "nap-waf/config/v5/build-nginx-image-plus/build-rhel.md" >}}

{{%/tab%}}
{{%tab name="Ubuntu"%}}

{{< include "nap-waf/config/v5/build-nginx-image-plus/build-ubuntu.md" >}}

{{%/tab%}}
{{</tabs>}}

### Build Image {#build-image-sub}

{{< include "nap-waf/build-nginx-image-cmd.md" >}}

#### Download Waf-Enforcer and Waf-Config-mgr Images
 Pull the `waf-enforcer` and `waf-config-mgr` images. Replace `5.2.0` with the actual release version you are deploying. 

```shell
docker pull private-registry.nginx.com/nap/waf-enforcer:5.2.0
docker pull private-registry.nginx.com/nap/waf-config-mgr:5.2.0
```

#### Saving and Transferring Images
1. Save the NGINX Open Source or NGINX Plus image you built earlier.

    ```shell
    docker save -o nginx-app-protect-5.tar nginx-app-protect-5
    ```

2. Save the `waf-enforcer` docker image

    ```shell
    docker save -o waf-enforcer.tar waf-enforcer:5.2.0
    ```

3. Save the `waf-config-mgr` docker image

    ```shell
    docker save -o waf-config-mgr.tar waf-config-mgr:5.2.0
    ```

4. Transfer the tar files from the online machine to the offline/air-gapped machine.

5. On the offline machine load the docker images

    ```shell
    docker load -i nginx-app-protect-5.tar
    docker load -i waf-enforcer.tar
    docker load -i waf-config-mgr.tar
    ```

#### Local Registry Setup
Set up a local registry for the images on the offline/air-gap machine. 
For the example deployment we will use [Registry](https://www.docker.com/blog/how-to-use-your-own-registry-2/).

1. Set up a local registry on the offline/air-gap machine

2. Add nginx-app-protect-5, waf-enforcer, and waf-config-mgr to the local registry
  
### NGINX Configuration

In your nginx configuration:

1. Load the NGINX App Protect WAF v5 module at the main context:

    ```nginx
    load_module modules/ngx_http_app_protect_module.so;
    ```

2. Configure the Enforcer address at the `http` context:

    ```nginx
    app_protect_enforcer_address waf-enforcer:50000;
    ```

3. Enable NGINX App Protect WAF on an `http/server/location` context (make sure you only enable NGINX App Protect WAF with `proxy_pass`/`grpc_pass` locations):

    ```nginx
    app_protect_enable on;
    ```

In this guide, we have created the following files under `/conf/` directory on the offline machine:

{{<tabs name="offline_nap5_install_conf_files_hostname">}}
{{%tab name="nginx.conf"%}}

`/nginx.conf`

{{< include "nap-waf/nginx-conf-hostname-docker.md" >}}

{{%/tab%}}
{{%tab name="default.conf"%}}

`/default.conf`

{{< include "nap-waf/default-conf-hostname.md" >}}

{{%/tab%}}
{{</tabs>}}

### WAF Services Configuration

#### Manifest Deployment

In this configuration, one replicas are deployed, with each hosting both NGINX and WAF services together in a single Kubernetes pod.

For simplification in this documentation, we're using a hostPath backed persistent volume claim `nap5-storage.yaml`:

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: nap5-bundles-pv
  labels:
    type: local
spec:
  storageClassName: manual
  capacity:
    storage: 2Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  hostPath:
    path: "/mnt/nap5_bundles_pv_data"
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nap5-bundles-pvc
spec:
  storageClassName: manual
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
  volumeName: nap5-bundles-pv
```

An example `nap5-deployment.yaml`:

Replace the `<your-private-registry>/nginx-app-protect-5:<your-tag>` with the actual image tag.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nap5-deployment
spec:
  selector:
    matchLabels:
      app: nap5
  replicas: 1
  template:
    metadata:
      labels:
        app: nap5
    spec:
      containers:
        - name: nginx
          image: localhost:5000/nginx-app-protect-5:latest
          imagePullPolicy: IfNotPresent
          volumeMounts:
            - name: app-protect-bd-config
              mountPath: /opt/app_protect/bd_config
            - name: app-protect-config
              mountPath: /opt/app_protect/config
            - name: nginx-config-volume
              mountPath: /etc/nginx/nginx.conf
              subPath: nginx.conf
            - name: nginx-default-config-volume
              mountPath: /etc/nginx/conf.d/default.conf
              subPath: default.conf
        - name: waf-enforcer
          image: localhost:5000/waf-enforcer:5.2.0
          imagePullPolicy: IfNotPresent
          env:
            - name: ENFORCER_PORT
              value: "50000"
          volumeMounts:
            - name: app-protect-bd-config
              mountPath: /opt/app_protect/bd_config
        - name: waf-config-mgr
          image: localhost:5000/waf-config-mgr:5.2.0
          imagePullPolicy: IfNotPresent
          securityContext:
            allowPrivilegeEscalation: false
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
        - name: app-protect-bundles
          persistentVolumeClaim:
            claimName: nap5-bundles-pvc
        - name: nginx-config-volume
          configMap:
            name: nginx-config
            items:
              - key: nginx.conf
                path: nginx.conf
        - name: nginx-default-config-volume
          configMap:
            name: nginx-config
            items:
              - key: default.conf
                path: default.conf
```

Finally, `nap5-service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx
spec:
  selector:
    app: nap5
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: NodePort
```
In this configuration, a single replica is deployed. It hosts both NGINX and WAF services. These services run together in a single Kubernetes pod.

Add `nginx.conf` and `default.conf` to a config map.

```shell
kubectl create configmap nginx-config \
  --from-file=/nginx.conf \
  --from-file=/default.conf
``` 

#### Start Deployment

1. Assuming the above manifests are saved in the `/home/user/k8s` directory, you can deploy them by executing the following command:

    ```shell
    kubectl apply -f /home/user/k8s
    ```

    Example output:

    ```shell
    deployment.apps/nap5-deployment created
    service/nginx created
    persistentvolume/nap5-bundles-pv created
    persistentvolumeclaim/nap5-bundles-pvc created
    ```

    This command tells `kubectl` to apply the configuration defined in all the files within the `/home/user/k8s` directory to your Kubernetes cluster.

2. Verify the deployment:

    - Check the status of the deployment using:

        ```bash
        kubectl get deployments
        ```

    - Verify that the pods are running with:

        ```bash
        kubectl get pods
        ```

    - Verify services with:

        ```bash
        kubectl get services
        ```

    - To verify the enforcement functionality, ensure the following request is rejected:

        ```shell
        curl "<node-external-ip>:<node-port>/<script>"
        ```

3. To restart the deployment, use:

    ```shell
    kubectl rollout restart deployment.apps/nap5-deployment
    ```

4. To remove the deployment, use:

    ```shell
    kubectl delete -f /home/user/k8s
    ```

### Start Deployment

1. To start the NGINX and WAF services, navigate to the directory that contains the `docker-compose.yml` file and run:

    ```shell
    sudo docker compose up -d
    ```

2. To verify the enforcement functionality, ensure the following request is rejected:

    ```shell
    curl "localhost/<script>"
    ```

3. (Optionally) To reload the NGINX, run:

    ```shell
    sudo docker exec nginx  nginx -s reload
    ```

---

## Troubleshooting

- **Pod Failures**: If a pod fails, check its logs using `kubectl logs [pod_name] -c [container_name]` for error messages. The default names for the containers are:
  - `nginx`.
  - `waf-enforcer`
  - `waf-config-mgr`
- **Connectivity Issues**: Verify the service and deployment configurations, especially port mappings and selectors.
- **Permissions Issues**: By default, the containers `waf-config-mgr` and `waf-enforcer` operate with the user and group IDs set to 101:101. Ensure that the bundle files are accessible to these IDs.

If you encounter any issues, check the [Troubleshooting Guide]({{< relref "/nap-waf/v5/troubleshooting-guide/troubleshooting#nginx-app-protect-5" >}}).

## Conclusion

This guide provides the foundational steps for deploying NGINX App Protect WAF v5 on Kubernetes. You may need to adjust the deployment to fit your specific requirements.

For more detailed configuration options and advanced deployment strategies, refer to the [NGINX App Protect WAF v5 configuration guide]({{< relref "/nap-waf/v5/configuration-guide/configuration.md" >}}).
