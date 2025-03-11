---
title: Deploying NGINX App Protect WAF with Helm
weight: 300
toc: true
type: how-to
product: NAP-WAF
---

## Overview

This document explains how to install NGINX App Protect using Helm.

## Prerequisites
* Kubernetes cluster
* Helm installed
* NGINX Docker Image
* NGINX JWT License (if NGINX Plus is used)
* Docker registry credentials for private-registry.nginx.com

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

## Pull the Chart
1. Login to the registry
    ```
    helm registry login private-registry.nginx.com
    ```

1. Pull the chart
    ```
    helm pull oci://private-registry.nginx.com/nap/nginx-app-protect --version <release-version> --untar
    ```

1. Change your working directory to nginx-app-protect
    ```
    cd nginx-app-protect
    ```

## Deployment
1.  Set NGINX Docker Image and Tag

    Update the appprotect.nginx.image.repository and appprotect.nginx.image.tag in values.yaml with your built NGINX image.

1.  Set NGINX JWT License

    Update the appprotect.config.nginxJWT in values.yaml with your JWT License Token.

1.  Set Docker Registry Credentials

    In values.yaml, update the dockerConfigJson to contain the base64 encoded Docker registration credentials
    ```
    echo '{
        "auths": {
            "private-registry.nginx.com": {
                "username": "<JWT Token>",
                "password": "none"
            }
        }
    }' | base64 -w 0
    ```
    OR create the secret using the following command:
    ```
    kubectl create secret docker-registry regcred -n <namespace> \
        --docker-server=private-registry.nginx.com \
        --docker-username=<JWT Token> \
        --docker-password=none
    ```

1.  Deploy the Helm Chart

    Use the following command to deploy the Helm chart:
    ```
    helm install <release-name> .
    ```
    Replace `<release-name>` with your desired release name.

3.  Verify the Deployment

    Use the following commands to verify the deployment:
    ```
    kubectl get pods -n <namespace>
    kubectl get svc -n <namespace>
    ```
    Replace <namespace> with the namespace specified in the values.yaml.

## Upgrade the Chart

To upgrade the release `<release-name>`:
```
helm upgrade <release-name> .
```

## Uninstall the Chart

To uninstall/delete the release `<release-name>`:

```
helm uninstall <release-name>
```

## Configuration
The following tables lists the configurable parameters of the NGINX App Protect chart and their default values.

| **Section** | **Key** | **Description** | **Default Value** |
|-------------|---------|-----------------|-------------------|
| **Namespace** | `namespace` | The target Kubernetes namespace where the Helm chart will be deployed. | N/A |
| **App Protect Configuration** | `appprotect.replicas` | The number of replicas of the Nginx App Protect deployment. | 1 |
| | `appprotect.readOnlyRootFilesystem` | Specifies if the root filesystem is read-only. | false |
| | `appprotect.annotations` | Custom annotations for the deployment. | {} |
| **NGINX Configuration** | `appprotect.nginx.image.repository` | Docker image repository for NGINX. | \<your-private-registry>/nginx-app-protect-5 |
| | `appprotect.nginx.image.tag` | Docker image tag for NGINX. | latest |
| | `appprotect.nginx.imagePullPolicy` | Image pull policy. | IfNotPresent |
| | `appprotect.nginx.resources` | The resources of the NGINX container. | requests: cpu=10m,memory=16Mi |
| **WAF Config Manager** | `appprotect.wafConfigMgr.image.repository` | Docker image repository for the WAF Configuration Manager. | private-registry.nginx.com/nap/waf-config-mgr |
| | `appprotect.wafConfigMgr.image.tag` | Docker image tag for the WAF Configuration Manager. | 5.6.0 |
| | `appprotect.wafConfigMgr.imagePullPolicy` | Image pull policy. | IfNotPresent |
| | `appprotect.wafConfigMgr.resources` | The resources of the WAF Config Manager container. | requests: cpu=10m,memory=16Mi |
| **WAF Enforcer** | `appprotect.wafEnforcer.image.repository` | Docker image repository for the WAF Enforcer. | private-registry.nginx.com/nap/waf-enforcer |
| | `appprotect.wafEnforcer.image.tag` | Docker image tag for the WAF Enforcer. | 5.6.0 |
| | `appprotect.wafEnforcer.imagePullPolicy` | Image pull policy. | IfNotPresent |
| | `appprotect.wafEnforcer.env.enforcerPort` | Port for the WAF Enforcer. | 50000 |
| | `appprotect.wafEnforcer.resources` | The resources of the WAF Enforcer container. | requests: cpu=20m,memory=256Mi |
| **Config** | `appprotect.config.name` | The name of the ConfigMap used by the NGINX container. | nginx-config |
| | `appprotect.config.annotations` | The annotations of the ConfigMap. | {} |
| | `appprotect.config.nginxJWT` | JWT license for NGINX. | "" |
| | `appprotect.config.nginxConf` | NGINX configuration file content. | See `values.yaml` |
| | `appprotect.config.nginxDefault` | Default server block configuration for NGINX. | {} |
| | `appprotect.config.entries` | Extra entries of the ConfigMap for customizing NGINX configuration. | {} |
| **mTLS Configuration** | `appprotect.mTLS.serverCert` | The base64-encoded TLS certificate for the App Protect Enforcer (server). | "" |
| | `appprotect.mTLS.serverKey` | The base64-encoded TLS key for the App Protect Enforcer (server). | "" |
| | `appprotect.mTLS.serverCACert` | The base64-encoded TLS CA certificate for the App Protect Enforcer (server). | "" |
| | `appprotect.mTLS.clientCert` | The base64-encoded TLS certificate for the NGINX (client). | "" |
| | `appprotect.mTLS.clientKey` | The base64-encoded TLS key for the NGINX (client). | "" |
| | `appprotect.mTLS.clientCACert` | The base64-encoded TLS CA certificate for the NGINX (client). | "" |
| **Extra Volumes** | `appprotect.volumes` | The extra volumes of the NGINX container. | [] |
| **Extra Volume Mounts** | `appprotect.volumeMounts` | The extra volume mounts of the NGINX container. | [] |
| **Service** | `appprotect.service.nginx.ports.port` | Service port. | 80 |
| | `appprotect.service.nginx.ports.protocol` | Protocol used. | TCP |
| | `appprotect.service.nginx.ports.targetPort` | Target port inside the container. | 80 |
| | `appprotect.service.nginx.type` | Service type. | NodePort |
| **Storage Configuration** | `appprotect.storage.bundlesPath.name` | Bundles volume name used by WAF Config Manager container for storing policy bundles  | app-protect-bundles |
| | `appprotect.storage.bundlesPath.mountPath` | Bundles mount path used by WAF Config Manager container, which is the path to the app_protect_policy_file in nginx.conf. | /etc/app_protect/bundles |
| | `appprotect.storage.pv.hostPath` | Host path for persistent volume. | /mnt/nap5_bundles_pv_data |
| | `appprotect.storage.pvc.bundlesPvc.storageClass` | Storage class for PVC. | manual |
| | `appprotect.storage.pvc.bundlesPvc.storageRequest` | Storage request size. | 2Gi |
| **Docker Configuration** | `dockerConfigJson` | A base64-encoded string representing the Docker registry credentials in JSON format. | N/A |

This table should help you quickly understand and reference the configuration settings in the `values.yaml` file.

## Using Compiled Policy and Logging Profile Bundles in NGINX

In this setup, copy your compiled policy and logging profile bundles to `/mnt/nap5_bundles_pv_data` on a cluster node. Make sure that input files are accessible to UID 101. Then, in your NGINX configuration, refer to these files from `/etc/app_protect/bundles`.

For example, to apply `custom_policy.tgz` that you've placed in `/mnt/nap5_bundles_pv_data/`, use:

   ```nginx
   app_protect_policy_file "/etc/app_protect/bundles/custom_policy.tgz";
   ```

The NGINX configuration is found in the values.yaml file `appprotect.config.nginxConf`.
The bundles path and the host path can be configured in `appprotect.storage`.
