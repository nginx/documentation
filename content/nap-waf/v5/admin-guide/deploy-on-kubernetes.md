---
authors: []
categories:
- administration guide
date: "2021-04-14T13:32:41+00:00"
description: This guide explains how to deploy NGINX App Protect WAF v5 release in a Kubernetes environment.
docs: DOCS-1366
doctypes:
- task
draft: false
journeys:
- researching
- getting started
- using
- self service
menu:
  docs:
    parent: R 5
    weight: 45
personas:
- devops
- netops
- secops
- support
roles:
- admin
- user
title: Deploying NGINX App Protect WAF on Kubernetes
toc: true
versions:
- "5.0"
weight: 400
---

## Prerequisites

- Active NGINX App Protect WAF subscription in [MyF5](https://my.f5.com/) (purchased or trial).
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

{{< include "nap-waf/build-nginx-image-oss.md" >}}

You are ready to [Build the image](#build-image)

### NGINX Plus Dockerfile

{{< include "nap-waf/build-nginx-image-plus.md" >}}

### Build image

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
          image: private-registry.nginx.com/nap/waf-enforcer:1.0.0
          imagePullPolicy: IfNotPresent
          env:
            - name: ENFORCER_PORT
              value: "50000"
          volumeMounts:
            - name: app-protect-bd-config
              mountPath: /opt/app_protect/bd_config
        - name: waf-config-mgr
          image: private-registry.nginx.com/nap/waf-config-mgr:1.0.0
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
    service/waf-enforcer created
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

## Using Compiled Policy and Logging Profile Bundles in NGINX

In this setup, copy your compiled policy and logging profile bundles to `/mnt/nap5_bundles_pv_data` on a cluster node. Then, in your NGINX configuration, refer to these files from `/etc/app_protect/bundles`.

For example, to apply `custom_policy.tgz` that you've placed in `/mnt/nap5_bundles_pv_data/`, use:

   ```nginx
   app_protect_policy_file "/etc/app_protect/bundles/custom_policy.tgz";
   ```

The NGINX configuration can be integrated using a configmap mount.

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
