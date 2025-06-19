---
title: Deploy NGINX App Protect WAF with Helm
weight: 300
toc: true
type: how-to
product: NAP-WAF
---

## Overview

This document explains how to install F5 NGINX App Protect WAF with Helm.

---

## Prerequisites

- Kubernetes cluster
- Helm installed
- NGINX Docker image
- NGINX JWT license (if NGINX Plus is used)
- Docker registry credentials for private-registry.nginx.com

## Build the NGINX Image

Follow the instructions below to build a Docker image containing the NGINX and the NGINX App Protect module.

### Download certificates

{{< include "nap-waf/download-certificates.md" >}}

Next, create a `Dockerfile` using one of the examples provided below.

### Official NGINX Dockerfile

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
{{%tab name="Rocky Linux"%}}

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
{{%tab name="RHEL & Rocky"%}}

{{< include "nap-waf/config/v5/build-nginx-image-plus/build-rhel.md" >}}

{{%/tab%}}
{{%tab name="Ubuntu"%}}

{{< include "nap-waf/config/v5/build-nginx-image-plus/build-ubuntu.md" >}}

{{%/tab%}}
{{</tabs>}}

### Build Image

{{< include "nap-waf/build-nginx-image-cmd.md" >}}

Next, push it to your private image repository, ensuring it's accessible to your Kubernetes cluster.

--- 

## Pull the chart

Login to the registry:

```shell
helm registry login --username=<JWT Token> --password=none private-registry.nginx.com
```

Pull the chart:

```shell
helm pull oci://private-registry.nginx.com/nap/nginx-app-protect --version <release-version> --untar
```

Change your working directory to nginx-app-protect:

```shell
cd nginx-app-protect
```

---

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

1.  Verify the Deployment

    Use the following commands to verify the deployment:
    ```
    kubectl get pods -n <namespace>
    kubectl get svc -n <namespace>
    ```
    Replace <namespace> with the namespace specified in the values.yaml.

---

## Use compiled Policy and Logging Profile bundles in NGINX

{{< include "/nap-waf/nap-k8s-use-compiled-bundles.md" >}}

The NGINX configuration is found in the values.yaml file `appprotect.config.nginxConf`.
The bundles path and the host path can be configured in `appprotect.storage`.

## Configuration

This table lists the configurable parameters of the NGINX App Protect chart and their default values.

It should help you quickly understand the referenced configuration settings in the `values.yaml` file.

To use the *mTLS Configuration* options, read the [Secure Traffic Between NGINX and App Protect Enforcer using mTLS]({{< ref "/nap-waf//v5/configuration-guide/configuration.md#secure-traffic-between-nginx-and-app-protect-enforcer-using-mtls" >}}) topic.

{{< bootstrap-table "table table-striped table-bordered" >}}
| **Section** | **Key** | **Description** | **Default Value** |
|-------------|---------|-----------------|-------------------|
| **Namespace** | _namespace_ | The target Kubernetes namespace where the Helm chart will be deployed. | N/A |
| **App Protect Configuration** | _appprotect.replicas_ | The number of replicas of the Nginx App Protect deployment. | 1 |
| | _appprotect.readOnlyRootFilesystem_ | Specifies if the root filesystem is read-only. | false |
| | _appprotect.annotations_ | Custom annotations for the deployment. | {} |
| **NGINX Configuration** | _appprotect.nginx.image.repository_ | Docker image repository for NGINX. | \<your-private-registry>/nginx-app-protect-5 |
| | _appprotect.nginx.image.tag_ | Docker image tag for NGINX. | latest |
| | _appprotect.nginx.imagePullPolicy_ | Image pull policy. | IfNotPresent |
| | _appprotect.nginx.resources_ | The resources of the NGINX container. | requests: cpu=10m,memory=16Mi |
| **WAF Config Manager** | _appprotect.wafConfigMgr.image.repository_ | Docker image repository for the WAF Configuration Manager. | private-registry.nginx.com/nap/waf-config-mgr |
| | _appprotect.wafConfigMgr.image.tag_ | Docker image tag for the WAF Configuration Manager. | 5.6.0 |
| | _appprotect.wafConfigMgr.imagePullPolicy_ | Image pull policy. | IfNotPresent |
| | _appprotect.wafConfigMgr.resources_ | The resources of the WAF Config Manager container. | requests: cpu=10m,memory=16Mi |
| **WAF Enforcer** | _appprotect.wafEnforcer.image.repository_ | Docker image repository for the WAF Enforcer. | private-registry.nginx.com/nap/waf-enforcer |
| | _appprotect.wafEnforcer.image.tag_ | Docker image tag for the WAF Enforcer. | 5.6.0 |
| | _appprotect.wafEnforcer.imagePullPolicy_ | Image pull policy. | IfNotPresent |
| | _appprotect.wafEnforcer.env.enforcerPort_ | Port for the WAF Enforcer. | 50000 |
| | _appprotect.wafEnforcer.resources_ | The resources of the WAF Enforcer container. | requests: cpu=20m,memory=256Mi |
| **Config** | _appprotect.config.name_ | The name of the ConfigMap used by the NGINX container. | nginx-config |
| | _appprotect.config.annotations_ | The annotations of the ConfigMap. | {} |
| | _appprotect.config.nginxJWT_ | JWT license for NGINX. | "" |
| | _appprotect.config.nginxConf_ | NGINX configuration file content. | See _values.yaml_ |
| | _appprotect.config.nginxDefault_ | Default server block configuration for NGINX. | {} |
| | _appprotect.config.entries_ | Extra entries of the ConfigMap for customizing NGINX configuration. | {} |
| **mTLS Configuration** | _appprotect.mTLS.serverCert_ | The base64-encoded TLS certificate for the App Protect Enforcer (server). | "" |
| | _appprotect.mTLS.serverKey_ | The base64-encoded TLS key for the App Protect Enforcer (server). | "" |
| | _appprotect.mTLS.serverCACert_ | The base64-encoded TLS CA certificate for the App Protect Enforcer (server). | "" |
| | _appprotect.mTLS.clientCert_ | The base64-encoded TLS certificate for the NGINX (client). | "" |
| | _appprotect.mTLS.clientKey_ | The base64-encoded TLS key for the NGINX (client). | "" |
| | _appprotect.mTLS.clientCACert_ | The base64-encoded TLS CA certificate for the NGINX (client). | "" |
| **Extra Volumes** | _appprotect.volumes_ | The extra volumes of the NGINX container. | [] |
| **Extra Volume Mounts** | _appprotect.volumeMounts_ | The extra volume mounts of the NGINX container. | [] |
| **Service** | _appprotect.service.nginx.ports.port_ | Service port. | 80 |
| | _appprotect.service.nginx.ports.protocol_ | Protocol used. | TCP |
| | _appprotect.service.nginx.ports.targetPort_ | Target port inside the container. | 80 |
| | _appprotect.service.nginx.type_ | Service type. | NodePort |
| **Storage Configuration** | _appprotect.storage.bundlesPath.name_ | Bundles volume name used by WAF Config Manager container for storing policy bundles  | app-protect-bundles |
| | _appprotect.storage.bundlesPath.mountPath_ | Bundles mount path used by WAF Config Manager container, which is the path to the app_protect_policy_file in nginx.conf. | /etc/app_protect/bundles |
| | _appprotect.storage.pv.hostPath_ | Host path for persistent volume. | /mnt/nap5_bundles_pv_data |
| | _appprotect.storage.pvc.bundlesPvc.storageClass_ | Storage class for PVC. | manual |
| | _appprotect.storage.pvc.bundlesPvc.storageRequest_ | Storage request size. | 2Gi |
| **Docker Configuration** | _dockerConfigJson_ | A base64-encoded string representing the Docker registry credentials in JSON format. | N/A |
{{< /bootstrap-table >}}

---

## Upgrade the chart

To upgrade the release `<release-name>`:
```
helm upgrade <release-name> .
```

## Uninstall the chart

To uninstall/delete the release `<release-name>`:

```shell
helm uninstall <release-name>
```
