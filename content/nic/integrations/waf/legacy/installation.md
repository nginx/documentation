---
title: Build NGINX Ingress Controller for the legacy F5 WAF for NGINX integration
linkTitle: "Build the image"
description: Build an NGINX Ingress Controller image with the legacy F5 WAF for NGINX integration, then deploy it with manifests.
weight: 100
toc: true
f5-content-type: how-to
f5-product: F5 NGINX Ingress Controller
aliases:
  - /nginx-ingress-controller/integrations/app-protect-waf/installation/
---

**Applies to:** Legacy F5 WAF for NGINX integration, CRD-based (in-pod compilation) and bundle-based (local bundles)

This document explains how to build an F5 NGINX Ingress Controller image with the legacy F5 WAF for NGINX integration from source code. The legacy F5 WAF for NGINX integration was formerly called F5 WAF for NGINX v4. To check which integration you run, see [Choose an F5 WAF for NGINX deployment]({{< ref "/nic/integrations/waf/choose-deployment.md#check-which-integration-you-run" >}}).

{{< call-out class="tip" title="Pre-built image alternatives" >}} 
If you'd rather not build your own NGINX Ingress Controller image, see the [pre-built image options](#pre-built-images) at the end of this guide.
{{< /call-out >}}

## Before you start

- To use F5 WAF for NGINX with NGINX Ingress Controller, you must have NGINX Plus.
- The legacy F5 WAF for NGINX integration is not supported when `readOnlyRootFilesystem` is enabled.

## Prepare the environment

Get your system ready for building and pushing the NGINX Ingress Controller image with F5 WAF for NGINX.

1. Sign in to your private registry. Replace `<MY_DOCKER_REGISTRY>` with the path to your own private registry.

    ```shell
    docker login <MY_DOCKER_REGISTRY>
    ```

1. Clone the NGINX Ingress Controller repository:

    ```shell
    git clone https://github.com/nginx/kubernetes-ingress.git --branch v{{< nic-version >}}
    cd kubernetes-ingress
    ```

## Build the image

Follow these steps to build the NGINX Ingress Controller image with the legacy F5 WAF for NGINX integration.

1. Place your NGINX Plus license files (_nginx-repo.crt_ and _nginx-repo.key_) in the project's root folder. To verify they're in place, run:

    ```shell
    ls nginx-repo.*
    ```

    You should see:

    ```shell
    nginx-repo.crt  nginx-repo.key
    ```

2. Build the image. Replace `<MAKEFILE_TARGET>` with your chosen build option and `<MY_DOCKER_REGISTRY>` with your private registry's path. Refer to the [Makefile targets](#makefile-targets) table below for the list of build options.

    ```shell
    make <MAKEFILE_TARGET> PREFIX=<MY_DOCKER_REGISTRY>/nginx-plus-ingress TARGET=download
    ```

    For example, to build a Debian-based image with NGINX Plus and F5 DoS for NGINX, run:

    ```shell
    make debian-image-dos-plus PREFIX=<MY_DOCKER_REGISTRY>/nginx-plus-ingress TARGET=download
    ```

     **What to expect**: The image is built and tagged with a version number, which is derived from the `VERSION` variable in the [_Makefile_]({{< ref "/nic/install/build.md#makefile-details" >}}). This version number is used for tracking and deployment purposes.

{{< call-out class="note" >}} In the event a patch of NGINX Plus is released, make sure to rebuild your image to get the latest version. If your system is caching the Docker layers and not updating the packages, add `DOCKER_BUILD_OPTIONS="--pull --no-cache"` to the make command. {{< /call-out >}}

### Makefile targets {#makefile-targets}

| Makefile Target           | Description                                                       | Compatible Systems  |
|---------------------------|-------------------------------------------------------------------|---------------------|
| **debian-image-nap-plus** | Builds a Debian-based image with NGINX Plus and the [F5 WAF for NGINX](/nginx-app-protect-waf/) module, for the legacy integration. | Debian  |
| **debian-image-nap-dos-plus** | Builds a Debian-based image with NGINX Plus, [F5 WAF for NGINX](/nginx-app-protect-waf/), and [F5 DoS for NGINX](/nginx-app-protect-dos/), for the legacy integration. | Debian  |
| **ubi-image-nap-plus**    | Builds a UBI-based image with NGINX Plus and the [F5 WAF for NGINX](/nginx-app-protect-waf/) module, for the legacy integration. | OpenShift |
| **ubi-image-nap-dos-plus** | Builds a UBI-based image with NGINX Plus, [F5 WAF for NGINX](/nginx-app-protect-waf/), and [F5 DoS for NGINX](/nginx-app-protect-dos/), for the legacy integration. | OpenShift |

Targets that include `nap-v5` build images for the current integration, not the legacy one. For those targets, see [Build NGINX Ingress Controller for the current F5 WAF for NGINX integration]({{< ref "/nic/integrations/waf/current/installation.md#makefile-targets" >}}).

{{< call-out class="note" >}} For the complete list of _Makefile_ targets and customizable variables, see the [Build NGINX Ingress Controller]({{< ref "/nic/install/build.md#makefile-details" >}}) topic. {{< /call-out>}}

## Push the image to your private registry

Once you've successfully built the NGINX Ingress Controller image with F5 WAF for NGINX, the next step is to upload it to your private Docker registry. This makes the image available for deployment to your Kubernetes cluster.

To upload the image, run the following command. If you're using a custom tag, add `TAG=your-tag` to the end of the command. Replace `<MY_DOCKER_REGISTRY>` with your private registry's path.

```shell
make push PREFIX=<MY_DOCKER_REGISTRY>/nginx-plus-ingress
```

## Set up role-based access control (RBAC) {#set-up-rbac}

{{< include "/nic/rbac/set-up-rbac.md" >}}

## Create common resources {#create-common-resources}

{{< include "/nic/installation/create-common-resources.md" >}}

## Create core custom resources {#create-custom-resources}

{{< include "/nic/installation/create-custom-resources.md" >}}

## Create F5 WAF for NGINX custom resources

{{< call-out class="note" >}} These custom resources are for in-pod compilation. If you use only local policy bundles, you can skip this section. Instead, create a [Persistent Volume and Persistent Volume Claim](https://kubernetes.io/docs/concepts/storage/persistent-volumes/) in your Kubernetes cluster for the bundle folder. {{< /call-out >}}

{{<tabs name="install-waf-crds">}}

{{%tab name="Install CRDs from single YAML"%}}

This single YAML file creates CRDs for the following resources:

- `APPolicy`
- `APLogConf`
- `APUserSig`

```shell
kubectl apply -f https://raw.githubusercontent.com/nginx/kubernetes-ingress/v{{< nic-version >}}/deploy/crds-nap-waf.yaml
```

{{%/tab%}}

{{%tab name="Install CRDs after cloning the repo"%}}

{{< call-out class="note" >}} If you are installing the CRDs this way, ensure you have first cloned the repository. {{< /call-out >}}

These YAML files create CRDs for the following resources:

- `APPolicy`
- `APLogConf`
- `APUserSig`

```shell
kubectl apply -f config/crd/bases/appprotect.f5.com_appolicies.yaml
kubectl apply -f config/crd/bases/appprotect.f5.com_aplogconfs.yaml
kubectl apply -f config/crd/bases/appprotect.f5.com_apusersigs.yaml
```

{{%/tab%}}

{{</tabs>}}

## Deploy NGINX Ingress Controller {#deploy-ingress-controller}

{{< include "/nic/installation/deploy-controller.md" >}}

{{< call-out class="note" >}} If you use local policy bundles, you need to change the Deployment, DaemonSet, or StatefulSet file to include volumes and volume mounts.

NGINX Ingress Controller **requires** the volume mount path to be `/etc/nginx/waf/bundles`, the bundle folder for the legacy F5 WAF for NGINX integration. The current integration uses `/etc/app_protect/bundles` instead. {{< /call-out >}}

Add a `volumes` section to deployment template spec:

```yaml
...
volumes:
- name: <VOLUME_NAME>
persistentVolumeClaim:
    claimName: <CLAIM_NAME>
...
```

Replace `<VOLUME_NAME>` with the name of the volume and `<CLAIM_NAME>` with the name of the PersistentVolumeClaim.

Add volume mounts to the `containers` section:

```yaml
...
volumeMounts:
- name: <VOLUME_MOUNT_NAME>
    mountPath: /etc/nginx/waf/bundles
...
```

Replace `<VOLUME_MOUNT_NAME>` with the name of the volume mount.

{{< call-out class="note" >}}
**StatefulSet Volume Configuration**: When using StatefulSet deployments, the `nginx-cache` volume is automatically provided via `volumeClaimTemplates` for persistent storage. Configure the bundle volume as a regular volume in the `volumes` section. Use `emptyDir` for temporary data or PersistentVolumeClaims if you need bundles to persist across pod restarts.
{{< /call-out >}}

### Using a Deployment

{{< include "/nic/installation/manifests/deployment.md" >}}

### Using a DaemonSet

{{< include "/nic/installation/manifests/daemonset.md" >}}

### Using a StatefulSet

{{< include "/nic/installation/manifests/statefulset.md" >}}

## Enable F5 WAF for NGINX module (requires NGINX Plus)

To enable the F5 WAF for NGINX Module:

- Add the `--enable-app-protect` [command-line argument]({{< ref "/nic/configuration/global-configuration/command-line-arguments.md#cmdoption-enable-app-protect" >}}) to your Deployment, DaemonSet, or StatefulSet file.

Additional WAF modules can be enabled by adding the appropriate command-line arguments:

- To enable F5 DoS for NGINX, add the `--enable-app-protect-dos` [command-line argument]({{< ref "/nic/configuration/global-configuration/command-line-arguments.md#cmdoption-enable-app-protect-dos" >}}).
- To enable F5 WAF IP Intelligence, add the `--enable-app-protect-ip-intelligence` [command-line argument]({{< ref "/nic/configuration/global-configuration/command-line-arguments.md#cmdoption-enable-app-protect-ip-intelligence" >}}).

## Confirm NGINX Ingress Controller is running

{{< include "/nic/installation/manifests/verify-pods-are-running.md" >}}

For more information, see [Configure the legacy F5 WAF for NGINX integration]({{< ref "/nic/integrations/waf/legacy/configuration.md" >}}) and the NGINX Ingress Controller with the legacy F5 WAF for NGINX integration example resources on GitHub [for VirtualServer resources](https://github.com/nginx/kubernetes-ingress/tree/v{{< nic-version >}}/examples/custom-resources/app-protect-waf) and [for Ingress resources](https://github.com/nginx/kubernetes-ingress/tree/v{{< nic-version >}}/examples/ingress-resources/app-protect-waf).

## Alternatives to building your own image {#pre-built-images}

If you prefer not to build your own NGINX Ingress Controller image, you can use pre-built images. Here are your options:

- Download the image using your NGINX Ingress Controller subscription certificate and key. View the [Download NGINX Ingress Controller from the F5 Registry]({{< ref "/nic/install/images/registry-download.md" >}}) topic.
- The [Add an NGINX Ingress Controller image to your cluster]({{< ref "/nic/install/images/add-image-to-cluster.md" >}}) topic describes how to use your subscription JWT token to get the image.
