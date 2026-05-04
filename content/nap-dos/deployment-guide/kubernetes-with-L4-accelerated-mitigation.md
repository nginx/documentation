---
title: Kubernetes with L4 accelerated mitigation
description: "Install F5 DoS for NGINX on Kubernetes with L4 accelerated mitigation using eBPF to offload DoS blocking to the Linux kernel."
keywords: "F5 DoS for NGINX, Kubernetes, L4, eBPF, accelerated mitigation, install, Linux kernel"
weight: 110
toc: true
nd-content-type: how-to
nd-product: F5DOSN
nd-summary: >
  Install F5 DoS for NGINX on Kubernetes with L4 accelerated mitigation using manifests, ending with a deployment that offloads DoS blocking to the Linux kernel.
  The eBPF Manager sidecar intercepts Layer 4 DoS traffic in the kernel, reducing CPU load on the NGINX container compared to a standard deployment.
  This deployment requires elevated container privileges; familiarity with Kubernetes security practices is assumed.
---

This guide explains how to install F5 DoS for NGINX on Kubernetes with L4 accelerated mitigation. By enabling the [`app_protect_dos_accelerated_mitigation`]({{< ref "/nap-dos/directives-and-policy/learn-about-directives-and-policy.md#accelerated-mitigation-directive-app_protect_dos_accelerated_mitigation" >}}) directive and running the DoS eBPF (Extended Berkeley Packet Filter) Manager as a sidecar container alongside the NGINX container, you can offload Layer 4 DoS mitigation to eBPF programs in the Linux kernel. This improves mitigation performance and reduces CPU usage on the NGINX container.

Deployments with L4 accelerated mitigation require the NGINX and DoS containers to run with elevated privileges and additional Linux capabilities. This guide assumes you have a good understanding of Kubernetes security best practices and have secured your cluster accordingly.

F5 DoS for NGINX requires the service to run with [`externalTrafficPolicy`](https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#preserving-the-client-source-ip) set to `Local` to preserve the client source IP address for accurate DoS mitigation:

```yaml
spec:
  externalTrafficPolicy: Local
```

It covers the common steps for any Kubernetes-based deployment, then provides the manifest-based installation steps.

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

{{< tabs name="alpine-instructions-ebpf" >}}

{{% tab name="EBPF Manager" %}}

{{< include "/dos/dockerfiles/alpine-ebpf-manager.md" >}}

{{% /tab %}}

{{< /tabs >}}

### Amazon Linux

{{< tabs name="amazon-instructions" >}}

{{% tab name="NGINX Plus" %}}

{{< include "/dos/dockerfiles/amazon-plus-dos.md" >}}

{{% /tab %}}

{{< /tabs >}}

{{< tabs name="amazon-instructions-ebpf" >}}

{{% tab name="EBPF Manager" %}}

{{< include "/dos/dockerfiles/amazon-ebpf-manager.md" >}}

{{% /tab %}}

{{< /tabs >}}

### Debian

{{< tabs name="debian-instructions" >}}

{{% tab name="NGINX Plus" %}}

{{< include "/dos/dockerfiles/debian-plus-dos.md" >}}

{{% /tab %}}

{{< /tabs >}}

{{< tabs name="debian-instructions-ebpf" >}}

{{% tab name="EBPF Manager" %}}

{{< include "/dos/dockerfiles/debian-ebpf-manager.md" >}}

{{% /tab %}}

{{< /tabs >}}

### RHEL 8

{{< tabs name="rhel8-instructions" >}}

{{% tab name="NGINX Plus" %}}

{{< include "/dos/dockerfiles/rhel8-plus-dos.md" >}}

{{% /tab %}}

{{< /tabs >}}

{{< tabs name="rhel8-instructions-ebpf" >}}

{{% tab name="EBPF Manager" %}}

{{< include "/dos/dockerfiles/rhel8-ebpf-manager.md" >}}

{{% /tab %}}

{{< /tabs >}}

### RHEL 9

{{< tabs name="rhel9-instructions" >}}

{{% tab name="NGINX Plus" %}}

{{< include "/dos/dockerfiles/rhel9-plus-dos.md" >}}

{{% /tab %}}

{{< /tabs >}}

{{< tabs name="rhel9-instructions-ebpf" >}}

{{% tab name="EBPF Manager" %}}

{{< include "/dos/dockerfiles/rhel9-ebpf-manager.md" >}}

{{% /tab %}}

{{< /tabs >}}

### RHEL 10

{{< tabs name="rhel10-instructions" >}}

{{% tab name="NGINX Plus" %}}

{{< include "/dos/dockerfiles/rhel10-plus-dos.md" >}}

{{% /tab %}}

{{< /tabs >}}

{{< tabs name="rhel10-instructions-ebpf" >}}

{{% tab name="EBPF Manager" %}}

{{< include "/dos/dockerfiles/rhel10-ebpf-manager.md" >}}

{{% /tab %}}

{{< /tabs >}}

### Rocky Linux 9

{{< tabs name="rocky-instructions" >}}

{{% tab name="NGINX Plus" %}}

{{< include "/dos/dockerfiles/rocky9-plus-dos.md" >}}

{{% /tab %}}

{{< /tabs >}}

{{< tabs name="rocky9-instructions-ebpf" >}}

{{% tab name="EBPF Manager" %}}

{{< include "/dos/dockerfiles/rocky9-ebpf-manager.md" >}}

{{% /tab %}}

{{< /tabs >}}

### Ubuntu

{{< tabs name="ubuntu-instructions" >}}

{{% tab name="NGINX Plus" %}}

{{< include "/dos/dockerfiles/ubuntu-plus-dos.md" >}}

{{% /tab %}}

{{< /tabs >}}

{{< tabs name="ubuntu-instructions-ebpf" >}}

{{% tab name="EBPF Manager" %}}

{{< include "/dos/dockerfiles/ubuntu-ebpf-manager.md" >}}

{{% /tab %}}

{{< /tabs >}}

## Create DOS entrypoint.sh
Docker startup script which spins up all App Protect DoS processes, must have executable permissions

{{< include "/dos/dos-entrypoint.md" >}}

## Build the DOS Docker image

Your folder should contain the following files:

- _nginx-repo.crt_
- _nginx-repo.key_
- _license.jwt_
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

## Build the EBPF Manager Docker image

Your folder should contain the following files:

- _nginx-repo.crt_
- _nginx-repo.key_
- _Dockerfile_

To build an image, use the following command, replacing `<your-ebpf-manager-image-name>` as appropriate:

```shell
sudo docker build --no-cache --platform linux/amd64 \
  --secret id=nginx-crt,src=nginx-repo.crt \
  --secret id=nginx-key,src=nginx-repo.key \
  -t <your-ebpf-manager-image-name> .
```

Once you have built the DOS and EBPF images, push them to your private image repository, which should be accessible to your Kubernetes cluster.

## Use Manifests to install F5 DOS for NGINX

### Create Manifest files

The default configuration provided creates two replicas, each hosting NGINX and DOS services together in a single Kubernetes pod.

Create all of these files in a single folder (Such as `/manifests`).

On manifest deployment environment variables need to be set for image repository and tag.
 `set enviorment variable DOS_IMAGE_REPOSITORY` with your actual nginx-dos image anmae.
 `set enviorment variable DOS_IMAGE_TAG` with your actual nginx-dos image tag.
 `set enviorment variable EBPF_IMAGE_REPOSITORY` with your actual ebpf-manager image name.
 `set enviorment variable EBPF_IMAGE_TAG` with your actual ebpf-manager image tag.

{{< tabs name="manifest-files" >}}

{{% tab name=dos-namespace.yaml %}}

{{< include "dos/k8s_with_ebpf_manifest/dos-namespace.md" >}}

{{% /tab %}}


{{% tab name=dos-nginx-conf-configmap.yaml %}}

{{< include "dos/k8s_with_ebpf_manifest/dos-nginx-conf-configmap.md" >}}

{{% /tab %}}

{{% tab name=dos-log-default-configmap.yaml %}}

{{< include "dos/k8s_with_ebpf_manifest/dos-log-default-configmap.md" >}}

{{% /tab %}}

{{% tab name=dos-deployment.yaml %}}

{{< include "dos/k8s_with_ebpf_manifest/dos-deployment.md" >}}

{{% /tab %}}

{{% tab name=dos-service.yaml %}}

{{< include "dos/k8s_with_ebpf_manifest/dos-service.md" >}}

{{% /tab %}}

{{< /tabs >}}

### Start the Manifest deployment

From the folder containing the YAML files from the previous step (Suggested as `/manifests`), deploy F5 DOS for NGINX using `kubectl`:

```shell
export DOS_IMAGE_REPOSITORY=<your-nginx-dos-image-name>
export DOS_IMAGE_TAG=<your-nginx-dos-image-tag>
export EBPF_IMAGE_REPOSITORY=<your-ebpf-manager-image-name>
export EBPF_IMAGE_TAG=<your-ebpf-manager-image-tag>
kubectl apply -f manifests/dos-namespace.yaml
kubectl apply -f manifests/dos-nginx-conf-configmap.yaml
kubectl apply -f manifests/dos-log-default-configmap.yaml
kubectl apply -f manifests/dos-deployment.yaml
kubectl apply -f manifests/dos-service.yaml
```

It will apply all the configuration defined in the files to your Kubernetes cluster.

You can then check the status of the deployment with `kubectl get`:

```shell
kubectl -n app-protect-dos get deployments
kubectl -n app-protect-dos get pods
kubectl -n app-protect-dos get services
```

You should see output similar to the following:

```text
~$ kubectl -n app-protect-dos get deployments
NAME              READY   UP-TO-DATE   AVAILABLE   AGE
app-protect-dos   1/1     1            1           33s

~$ kubectl -n app-protect-dos get pods
NAME                               READY   STATUS    RESTARTS   AGE
app-protect-dos-7f9798654c-7ncbl   2/2     Running   0          68s

$ kubectl -n app-protect-dos get pods -o jsonpath='{range .items[*]}Pod: {.metadata.name} -> Containers: {.spec.containers[*].name}{"\n"}{end}'
Pod: app-protect-dos-7f9798654c-7ncbl -> Containers: dos-ebpf-manager nginx-app-protect-dos

~$ kubectl -n app-protect-dos get services
NAME                TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
nap-dos             LoadBalancer   10.43.212.232   <pending>     80:32586/TCP   93s
```
## Post-Installation Checks
At this stage, you have finished deploying F5 DOS for NGINX with EBPF L4 accelerated mitigation enabled
You can login to dos-ebpf-manager container like following command
```text
kubectl exec -it app-protect-dos-586fb94947-8sjnc -n app-protect-dos -c nginx-app-protect-dos -- bash
kubectl exec -it app-protect-dos-586fb94947-8sjnc -n app-protect-dos -c dos-ebpf-manager -- bash
```
and can look at .
{{< include "dos/install-post-checks.md" >}}

## F5 DoS for NGINX Arbitrator

{{< include "/dos/dos-arbitrator.md" >}}

## Next steps
