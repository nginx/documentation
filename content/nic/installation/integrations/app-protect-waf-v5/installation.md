---
title: Build NGINX Ingress Controller with F5 WAF for NGINX
weight: 100
toc: true
type: how-to
product: NIC
nd-docs: DOCS-1865
---

This document explains how to build a F5 NGINX Ingress Controller image with F5 WAF for NGINX v5 from source code.

{{<call-out "tip" "Pre-built image alternatives" >}} If you'd rather not build your own NGINX Ingress Controller image, see the [pre-built image options](#pre-built-images) at the end of this guide.{{</call-out>}}

## Before you begin

- To use F5 WAF for NGINX with NGINX Ingress Controller, you must have NGINX Plus.

{{< include "/nic/compatibility-tables/nic-nap.md" >}}

---

## Prepare the environment

Get your system ready for building and pushing the NGINX Ingress Controller image with F5 WAF for NGINX v5.

1. Sign in to your private registry. Replace `<my-docker-registry>` with the path to your own private registry.

    ```shell
    docker login <my-docker-registry>
    ```

1. Pull the WAF Config Manager image:

    ```shell
    docker pull private-registry.nginx.com/nap/waf-config-mgr:<image-tag>
    ```

1. Pull the WAF Enforcer Docker image

    ```shell
    docker pull private-registry.nginx.com/nap/waf-enforcer:<image-tag>
    ```

1. Clone the NGINX Ingress Controller repository:

    ```console
    git clone https://github.com/nginx/kubernetes-ingress.git --branch v{{< nic-version >}}
    cd kubernetes-ingress
    ```

---

## Build the image

Follow these steps to build the NGINX Controller Image with F5 WAF for NGINX v5.

1. Place your NGINX Plus license files (_nginx-repo.crt_ and _nginx-repo.key_) in the project's root folder. To verify they're in place, run:

    ```shell
    ls nginx-repo.*
    ```

   You should see:

    ```shell
    nginx-repo.crt  nginx-repo.key
    ```

2. Build the image. Replace `<makefile target>` with your chosen build option and `<my-docker-registry>` with your private registry's path. Refer to the [Makefile targets](#makefile-targets) table below for the list of build options.

    ```shell
    make <makefile target> PREFIX=<my-docker-registry>/nginx-plus-ingress TARGET=download
    ```

   For example, to build a Debian-based image with NGINX Plus and F5 WAF for NGINX v5, run:

    ```shell
    make debian-image-nap-v5-plus PREFIX=<my-docker-registry>/nginx-plus-ingress TARGET=download
    ```

   **What to expect**: The image is built and tagged with a version number, which is derived from the `VERSION` variable in the [_Makefile_]({{< ref "/nic/installation/build-nginx-ingress-controller.md#makefile-details" >}}). This version number is used for tracking and deployment purposes.

{{< call-out "note" >}} In the event a patch of NGINX Plus is released, make sure to rebuild your image to get the latest version. If your system is caching the Docker layers and not updating the packages, add `DOCKER_BUILD_OPTIONS="--pull --no-cache"` to the make command. {{< /call-out >}}

### Makefile targets {#makefile-targets}

Create Docker image for NGINX Ingress Controller (Alpine with NGINX Plus, F5 WAF for NGINX v5 and FIPS)

| Makefile Target           | Description                                                       | Compatible Systems  |
|---------------------------|-------------------------------------------------------------------|---------------------|
| **alpine-image-nap-v5-plus-fips** | Builds a Alpine-based image with NGINX Plus and the [F5 WAF for NGINX v5](/nginx-app-protect-waf/v5/) module with FIPS. | Alpine  |
| **debian-image-nap-v5-plus** | Builds a Debian-based image with NGINX Plus and the [F5 WAF for NGINX v5](/nginx-app-protect-waf/v5/) module. | Debian  |
| **ubi-image-nap-v5-plus**    | Builds a UBI-based image with NGINX Plus and the [F5 WAF for NGINX v5](/nginx-app-protect-waf/v5/) module. | OpenShift |
| **ubi-image-nap-dos-v5-plus** | Builds a UBI-based image with NGINX Plus, [F5 WAF for NGINX v5](/nginx-app-protect-waf/v5/), and [F5 DoS for NGINX](/nginx-app-protect-dos/). | OpenShift |


{{< call-out "note" >}} For the complete list of _Makefile_ targets and customizable variables, see the [Build NGINX Ingress Controller]({{< ref "/nic/installation/build-nginx-ingress-controller.md#makefile-details" >}}) guide. {{< /call-out>}}

If you intend to use [external references](/nginx-app-protect-waf/v5/configuration-guide/configuration/#external-references) in F5 WAF for NGINX policies, you may want to provide a custom CA certificate to authenticate with the hosting server.

To do so, place the `*.crt` file in the build folder and uncomment the lines following this comment:
`#Uncomment the lines below if you want to install a custom CA certificate`

{{< call-out "warning" >}} External references are deprecated in NGINX Ingress Controller and will not be supported in future releases. {{< /call-out >}}

---

## Push the images to your private registry

Once you've successfully pulled the WAF v5 manager and enforcer images and built the NGINX Ingress Controller image with F5 WAF for NGINX v5, the next step is to upload them to your private Docker registry. This makes the image available for deployment to your Kubernetes cluster.

To upload the image, run the following command. If you're using a custom tag, add `TAG=your-tag` to the end of the command. Replace `<my-docker-registry>` with your private registry's path.

```shell
make push PREFIX=<my-docker-registry>/nginx-plus-ingress
```

To upload the WAF config manager and enforcer images run the following commands:

```shell
docker push <my-docker-registry>/waf-config-mgr:<your-tag>
```

```shell
docker push <my-docker-registry>/waf-enforcer:<your-tag>
```

---

{{< include "/nic/installation/create-custom-resources.md" >}}


## Deploy NGINX Ingress Controller {#deploy-ingress-controller}

{{< important >}} NGINX Ingress Controller with the AppProtect WAF v5 module works only with policy bundles. You need to modify the Deployment, DaemonSet, or StatefulSet file to include volumes, volume mounts and two WAF 5 docker images: `waf-config-mgr` and `waf-enforcer`.

NGINX Ingress Controller **requires** the volume mount path to be `/etc/app_protect/bundles`. {{< /call-out >}}

{{<tabs name="deploy-nic">}}

{{%tab name="With Helm"%}}

Below are examples of a `PersistentVolume` and `PersistentVolumeClaim` that you can reference in your Helm values:

```yaml
...
volumes:
- name: <volume_name>
persistentVolumeClaim:
    claimName: <claim_name>
...
```

Add volume mounts to the `containers` section:

```yaml
...
volumeMounts:
- name: <volume_mount_name>
    mountPath: /etc/app_protect/bundles
...
```

### Enabling WAF v5

Start by setting `controller.appprotect.enable` to `true` in your Helm values. This will the standard F5 WAF for NGINX features.
Afterwords, set `controller.approtect.v5` to `true`.
This ensures that both the `waf-enforcer` and `waf-config-mgr` containers are deployed alongside the NGINX Ingress Controller containers.
These two additional containers are required when using F5 WAF for NGINX v5.

Your Helm values should look something like this:

```yaml
controller:
  ...
  ## Support for F5 WAF for NGINX
  appprotect:
    ## Enable the F5 WAF for NGINX module in the Ingress Controller.
    enable: true
    ## Enables F5 WAF for NGINX v5.
    v5: true
```


### Configuring volumes

Whether you have created a new `PersistentVolume` and `PersistentVolumeClaim`, or you are referencing an existing `PersistentVolumeClaim`, update the `app-protect-bundles` volume to reference your `PersistentVolumeClaim`.

Example helm values:

```yaml
...
controller:
  ...
  appprotect:
  ...
   volumes:
   - name: app-protect-bundles
     persistentVolumeClaim:
        claimName: <my_claim_name>
...
```

{{< call-out "note" >}}
By default, `emptyDir` mounts are used.
Bundles that are added to these kind of volume mounts will **NOT** persist across pod restarts.

Example default volumes:
```yaml
...
controller:
  ...
  appprotect:
  ...
   volumes:
   - name: app-protect-bundles
     emptyDir: {}
...
```
{{< /call-out >}}

### Configuring `readOnlyRootFilesystem`

Create required volumes:

```yaml
volumes:
  - name: nginx-etc
    emptyDir: {}
  - name: nginx-cache # do not set this value in statefulset if volumeclaimtemplate is set
    emptyDir: {}      # do not set this value in statefulset if volumeclaimtemplate is set
  - name: nginx-lib
    emptyDir: {}
  - name: nginx-log
    emptyDir: {}
  - name: app-protect-bd-config
    emptyDir: {}
  - name: app-protect-config
    emptyDir: {}
  - name: app-protect-bundles
    emptyDir: {}
```

Set `controller.securityContext.readOnlyRootFilesystem` to `true`.

Example Helm values:

```yaml
controller:
  ...
  securityContext:
    readOnlyRootFilesystem: true
  ...
```

Set `controller.appprotect.enforcer.securityContext.readOnlyRootFilesystem` to `true`.

Example Helm values:

```yaml
controller:
  ...
  appprotect:
    ...
    enforcer:
      securityContext:
        readOnlyRootFilesystem: true
  ...
```

Set `controller.appprotect.configManager.securityContext.readOnlyRootFilesystem` to `true`.

Example Helm values:

```yaml
controller:
  ...
  appprotect:
    ...
    configManager:
      securityContext:
        readOnlyRootFilesystem: true
  ...
```

{{%/tab%}}

{{%tab name="With Manifest"%}}

You have two options for deploying NGINX Ingress Controller:

- **Deployment**. Choose this method for the flexibility to dynamically change the number of NGINX Ingress Controller replicas.
- **DaemonSet**. Choose this method if you want NGINX Ingress Controller to run on all nodes or a subset of nodes.
- **StatefulSet**. Choose this method when you need stable, persistent storage and ordered deployment/scaling for your NGINX Ingress Controller pods.

---

### Set up role-based access control (RBAC) {#set-up-rbac}

{{<call-out "important" "Admin access required" >}}To complete these steps you need admin access to your cluster. Refer to to your Kubernetes platform's documentation to set up admin access. For Google Kubernetes Engine (GKE), you can refer to their [Role-Based Access Control guide](https://cloud.google.com/kubernetes-engine/docs/how-to/role-based-access-control).{{</call-out>}}

1. Create a namespace and a service account:

    ```shell
    kubectl apply -f deployments/common/ns-and-sa.yaml
    ```

2. Create a cluster role and binding for the service account:

    ```shell
    kubectl apply -f deployments/rbac/rbac.yaml
    ```

---

### Volumes and VolumeMounts

Add a `volumes` section to deployment template spec:

```yaml
...
volumes:
- name: <volume_name>
persistentVolumeClaim:
    claimName: <claim_name>
...
```

Add volume mounts to the `containers` section:

```yaml
...
volumeMounts:
- name: <volume_mount_name>
    mountPath: /etc/app_protect/bundles
...
```

### WAF Config Manager and WAF Enforcer

Add `waf-config-mgr` image to the `containers` section:

```yaml
...
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
...
```

Add `waf-enforcer` image to the `containers` section:

```yaml
...
- name: waf-enforcer
  image: private-registry.nginx.com/nap/waf-enforcer:<version-tag>
  imagePullPolicy: IfNotPresent
  env:
    - name: ENFORCER_PORT
      value: "50000"
    - name: ENFORCER_CONFIG_TIMEOUT
      value: "0"
  volumeMounts:
    - name: app-protect-bd-config
      mountPath: /opt/app_protect/bd_config
...
```

### Update NIC container in deployment, daemonset, or statefulset

Add `volumeMounts` as below:

```yaml
...
- image: <my_docker_registry>:<version_tag>
  imagePullPolicy: IfNotPresent
  name: nginx-plus-ingress
  volumeMounts:
    - name: app-protect-bd-config
      mountPath: /opt/app_protect/bd_config
    - name: app-protect-config
      mountPath: /opt/app_protect/config
    - name: app-protect-bundles
      mountPath: /etc/app_protect/bundles
...
```

### Configure `readOnlyRootFilesystem`

Add `readOnlyRootFilesystem` to the NIC container and set valut to `true` as below:

```yaml
...
- image: <my_docker_registry>:<version_tag>
  imagePullPolicy: IfNotPresent
  name: nginx-plus-ingress
  ...
  securityContext:
    allowPrivilegeEscalation: false
      capabilities:
        add:
        - NET_BIND_SERVICE
        drop:
        - ALL
      readOnlyRootFilesystem: true
      runAsNonRoot: true
      runAsUser: 101
    readOnlyRootFilesystem: true
  ...
  volumeMounts:
    - mountPath: /etc/nginx
      name: nginx-etc
    - mountPath: /var/cache/nginx
      name: nginx-cache
    - mountPath: /var/lib/nginx
      name: nginx-lib
    - mountPath: /var/log/nginx
      name: nginx-log
    - mountPath: /opt/app_protect/bd_config
      name: app-protect-bd-config
    - mountPath: /opt/app_protect/config
      name: app-protect-config
    - mountPath: /etc/app_protect/bundles
      name: app-protect-bundles
...
```

Add `readOnlyRootFilesystem` to the `waf-config-mgr` container and set value to `true` as below:

```yaml
...
- name: waf-config-mgr
  image: private-registry.nginx.com/nap/waf-config-mgr:<version-tag>
  imagePullPolicy: IfNotPresent
  ...
  securityContext:
    readOnlyRootFilesystem: true
    ...
...
```

Add `readOnlyRootFilesystem` to the `waf-enforcer` container and set value to `true` as below:

```yaml
...
- name: waf-enforcer
  image: private-registry.nginx.com/nap/waf-enforcer:<version-tag>
  imagePullPolicy: IfNotPresent
  ...
  securityContext:
    readOnlyRootFilesystem: true
    ...
...
```

{{< call-out "note" >}}
**StatefulSet Volume Configuration**: When using StatefulSet deployments, the `nginx-cache` volume is automatically provided via `volumeClaimTemplates` for persistent storage. F5 WAF for NGINX v5 volumes (like app-protect-config, app-protect-bundles) are still configured as regular volumes in the `volumes` section. Use `emptyDir` for temporary data or PersistentVolumeClaims if you need persistence for App Protect configurations across pod restarts.
{{< /call-out >}}

### Using a Deployment

{{< include "/nic/installation/manifests/deployment.md" >}}

### Using a DaemonSet

{{< include "/nic/installation/manifests/daemonset.md" >}}

### Using a StatefulSet

{{< include "/nic/installation/manifests/statefulset.md" >}}

---

### Enable F5 WAF for NGINX module

To enable the F5 DoS for NGINX Module:

- Add the `enable-app-protect` [command-line argument]({{< ref "/nic/configuration/global-configuration/command-line-arguments.md#cmdoption-enable-app-protect" >}}) to your Deployment, DaemonSet, or StatefulSet file.

{{%/tab%}}

{{</tabs>}}

---

## Confirm NGINX Ingress Controller is running

{{< include "/nic/installation/manifests/verify-pods-are-running.md" >}}

For more information, see the [Configuration guide]({{< ref "/nic/installation/integrations/app-protect-waf-v5/configuration.md" >}}) and the NGINX Ingress Controller with App Protect version 5 example resources on GitHub [for VirtualServer resources](https://github.com/nginx/kubernetes-ingress/tree/v{{< nic-version >}}/examples/custom-resources/app-protect-waf-v5).

---

## Alternatives to building your own image {#pre-built-images}

If you prefer not to build your own NGINX Ingress Controller image, you can use pre-built images. Here are your options:

- Download the image using your NGINX Ingress Controller subscription certificate and key. View the [Download NGINX Ingress Controller from the F5 Registry]({{< ref "/nic/installation/nic-images/registry-download.md" >}}) topic.
- The [Add an NGINX Ingress Controller image to your cluster]({{< ref "/nic/installation/nic-images/add-image-to-cluster.md" >}}) topic describes how to use your subscription JWT token to get the image.
