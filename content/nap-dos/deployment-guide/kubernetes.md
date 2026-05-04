---
title: Kubernetes
description: "Install F5 DoS for NGINX on Kubernetes using manifests to deploy DoS protection as a sidecar container alongside NGINX Plus."
keywords: "F5 DoS for NGINX, Kubernetes, install, container, Docker, manifest"
weight: 100
toc: true
nd-content-type: how-to
nd-product: F5DOSN
nd-summary: >
  Install F5 DoS for NGINX on Kubernetes using manifests and have a working deployment that protects your applications against behavioral DoS attacks.
  F5 DoS for NGINX runs as a sidecar container alongside NGINX Plus, using real-time traffic analysis to detect and block denial-of-service attacks.
  This guide covers the standard Kubernetes deployment; for L4 accelerated mitigation with eBPF, see the separate guide.
---

This guide explains how to install F5 DoS for NGINX on Kubernetes. It covers the common steps for any Kubernetes-based deployment, then provides the manifest-based installation steps.

## Before you begin

Before you start, make sure you have:

- A functional Kubernetes cluster
- An active F5 DoS for NGINX subscription (purchased or trial)
- [Docker](https://docs.docker.com/get-started/get-docker/)

To review supported operating systems, read the [Releases]({{< ref "/nap-dos/releases" >}}) topic.

## Download your subscription credentials 

{{< include "licensing-and-reporting/download-jwt-crt-from-myf5.md" >}}

## Create a Dockerfile

In the same folder as your credential files, create a _Dockerfile_ based on your desired operating system image using an example from the following sections.

### Alpine Linux

{{< tabs name="alpine-instructions" >}}

{{% tab name="NGINX Plus" %}}

{{< include "/dos/dockerfiles/alpine-plus-dos.md" >}}

{{% /tab %}}

{{< /tabs >}}

### Amazon Linux

{{< tabs name="amazon-instructions" >}}

{{% tab name="NGINX Plus" %}}

{{< include "/dos/dockerfiles/amazon-plus-dos.md" >}}

{{% /tab %}}

{{< /tabs >}}

### Debian

{{< tabs name="debian-instructions" >}}

{{% tab name="NGINX Plus" %}}

{{< include "/dos/dockerfiles/debian-plus-dos.md" >}}

{{% /tab %}}

{{< /tabs >}}

### RHEL 8

{{< tabs name="rhel8-instructions" >}}

{{% tab name="NGINX Plus" %}}

{{< include "/dos/dockerfiles/rhel8-plus-dos.md" >}}

{{% /tab %}}

{{< /tabs >}}

### RHEL 9

{{< tabs name="rhel9-instructions" >}}

{{% tab name="NGINX Plus" %}}

{{< include "/dos/dockerfiles/rhel9-plus-dos.md" >}}

{{% /tab %}}

{{< /tabs >}}

### RHEL 10

{{< tabs name="rhel10-instructions" >}}

{{% tab name="NGINX Plus" %}}

{{< include "/dos/dockerfiles/rhel10-plus-dos.md" >}}

{{% /tab %}}

{{< /tabs >}}

### Rocky Linux 9

{{< tabs name="rocky-instructions" >}}

{{% tab name="NGINX Plus" %}}

{{< include "/dos/dockerfiles/rocky9-plus-dos.md" >}}

{{% /tab %}}

{{< /tabs >}}

### Ubuntu

{{< tabs name="ubuntu-instructions" >}}

{{% tab name="NGINX Plus" %}}

{{< include "/dos/dockerfiles/ubuntu-plus-dos.md" >}}

{{% /tab %}}

{{< /tabs >}}

## Create DOS entrypoint.sh
Docker startup script which spins up all App Protect DoS processes, must have executable permissions

{{< include "/dos/dos-entrypoint.md" >}}

## Build the Docker image

Your folder should contain the following files:

- _nginx-repo.crt_
- _nginx-repo.key_
- _entrypoint.sh_
- _nginx.conf_
- _Dockerfile_

To build an image, use the following command, replacing `<your-nginx-dos-image-name>` as appropriate:

```shell
sudo docker build --no-cache --platform linux/amd64 \
  --secret id=nginx-crt,src=nginx-repo.crt \
  --secret id=nginx-key,src=nginx-repo.key \
  -t <your-nginx-dos-image-name> .
```

Once you have built the image, push it to your private image repository, which should be accessible to your Kubernetes cluster.

## Use Manifests to install F5 DOS for NGINX

The `<JWT Token>` argument should be the _contents_ of the file, not the file itself. Ensure there are no additional characters such as extra whitespace.

### Create Manifest files

The default configuration provided creates two replicas, each hosting NGINX and DOS services together in a single Kubernetes pod.

Create all of these files in a single folder (Such as `/manifests`).

On manifest deployment environment variables need to be set for image repository and tag.
`set enviorment variable DOS_IMAGE_REPOSITORY` with your actual nginx-dos image anmae.
`set enviorment variable DOS_IMAGE_TAG` with your actual nginx-dos image tag.

{{< tabs name="manifest-files" >}}

{{% tab name=dos-namespace.yaml %}}

{{< include "dos/k8s_manifest/dos-namespace.md" >}}

{{% /tab %}}

{{% tab name=dos-nginx-conf-configmap.yaml %}}

{{< include "dos/k8s_manifest/dos-nginx-conf-configmap.md" >}}

{{% /tab %}}

{{% tab name=dos-log-default-configmap.yaml %}}

{{< include "dos/k8s_manifest/dos-log-default-configmap.md" >}}

{{% /tab %}}

{{% tab name=dos-deployment.yaml %}}

{{< include "dos/k8s_manifest/dos-deployment.md" >}}

{{% /tab %}}

{{% tab name=dos-service.yaml %}}

{{< include "dos/k8s_manifest/dos-service.md" >}}

{{% /tab %}}

{{< /tabs >}}

### Start the Manifest deployment

From the folder containing the YAML files from the previous step (Suggested as `/manifests`), deploy F5 DOS for NGINX using `kubectl`:

```shell
export DOS_IMAGE_REPOSITORY=<your-nginx-dos-image-name>
export DOS_IMAGE_TAG=<your-nginx-dos-image-tag>
kubectl apply -f manifests/dos-namespace.yaml
kubectl create secret generic license-token --from-file=license.jwt=license.jwt --type=nginx.com/license --namespace app-protect-dos
kubectl apply -f dos-manifest/dos-log-default-configmap.yaml
kubectl apply -f dos-manifest/dos-nginx-conf-configmap.yaml
kubectl apply -f manifests/dos-deployment.yaml
kubectl apply -f manifests/dos-service.yaml
```

It will apply all the configuration defined in the files to your Kubernetes cluster.

You can then check the status of the deployment with `kubectl get`:

```shell
kubectl --namespace app-protect-dos get deployments
kubectl --namespace app-protect-dos get pods
kubectl --namespace app-protect-dos get services
```

You should see output similar to the following:

```text
~$ kubectl --namespace app-protect-dos get deployments
NAME              READY   UP-TO-DATE   AVAILABLE   AGE
app-protect-dos   1/1     1            1           1m

~$ kubectl --namespace app-protect-dos get pods
NAME                               READY   STATUS    RESTARTS   AGE
app-protect-dos-586fb94947-8sjnc   1/1     Running   0          1m

~$ kubectl --namespace app-protect-dos get services
NAME                TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
nap-dos             LoadBalancer   10.43.83.225    <pending>     80:30307/TCP   1m
```
## Post-Installation Checks
At this stage, you have finished deploying F5 DOS for NGINX.
You csn login to app-protect-dos pod like following command
```text
kubectl exec -it app-protect-dos-586fb94947-8sjnc -n app-protect-dos -c nginx-app-protect-dos -- bash
```
and can look at .
{{< include "dos/install-post-checks.md" >}}

## F5 DoS for NGINX Arbitrator

{{< include "/dos/dos-arbitrator.md" >}}

## Next steps
