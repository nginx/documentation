---
title: Deploy NGINX App Protect WAF with Manifests
weight: 400
toc: true
type: how-to
product: NAP-WAF
nd-docs: DOCS-1366
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
{{%tab name="Rocky Linux 9"%}}

{{< include "nap-waf/config/v5/build-nginx-image-oss/build-rocky.md" >}}

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
{{%tab name="Rocky Linux 9"%}}

{{< include "nap-waf/config/v5/build-nginx-image-plus/build-rocky.md" >}}

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

An example `nap5-deployment-with-ip-intelligence.yaml` if you are using the IP Intelligence feature:

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
            - name: var-iprep
              mountPath: /var/IpRep
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
        - name: waf-ip-intelligence
          image: private-registry.nginx.com/napwaf-ip-intelligence:<version-tag>
          imagePullPolicy: IfNotPresent
          securityContext:
            allowPrivilegeEscalation: false
          volumeMounts:
            - name: var-iprep
              mountPath: /var/IpRep
      volumes:
        - name: app-protect-bd-config
          emptyDir: {}
        - name: app-protect-config
          emptyDir: {}
         - name: var-iprep
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

{{< include "/nap-waf/nap-k8s-readonly-introduction.md" >}}

---

### Enable `readOnlyRootFilesystem` and configure writable paths

{{< include "/nap-waf/nap-k8s-readonly-context.md" >}}

---

### Update NGINX configuration with writable paths

{{< include "/nap-waf/nap-k8s-readonly-paths.md" >}}

---

### Possible issues

{{< include "/nap-waf/nap-k8s-readonly-issues.md" >}}

---

## Enable mTLS

{{< include "/nap-waf/nap-k8s-mtls-deployment.md" >}}

---

## Use compiled Policy and Logging Profile bundles in NGINX

{{< include "/nap-waf/nap-k8s-use-compiled-bundles.md" >}}

The NGINX configuration can be integrated using a ConfigMap mount.

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
{{%tab name="Rocky Linux 9"%}}

{{< include "nap-waf/config/v5/build-nginx-image-oss/build-rocky.md" >}}

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
{{%tab name="Rocky Linux 9"%}}

{{< include "nap-waf/config/v5/build-nginx-image-plus/build-rocky.md" >}}

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

If you encounter any issues, check the [Troubleshooting Guide]({{< ref "/nap-waf/v5/troubleshooting-guide/troubleshooting#nginx-app-protect-5" >}}).

## Conclusion

This guide provides the foundational steps for deploying NGINX App Protect WAF v5 on Kubernetes. You may need to adjust the deployment to fit your specific requirements.

For more detailed configuration options and advanced deployment strategies, refer to the [NGINX App Protect WAF v5 configuration guide]({{< ref "/nap-waf/v5/configuration-guide/configuration.md" >}}).
