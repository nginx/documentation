---
# We use sentence case and present imperative tone
title: "Kubernetes"
# Weights are assigned in increments of 100: determines sorting order
weight: 100
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
nd-product: F5DOSN
---

This page describes how to install F5 DOS for NGINX using Kubernetes.

It explains the common steps necessary for any Kubernetes-based deployment, then provides details specific to Helm or Manifests.

## Before you begin

To complete this guide, you will need the following pre-requisites:

- A functional Kubernetes cluster
- An active F5 DOS for NGINX subscription (Purchased or trial)
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

From this point, the steps change based on your installation method:

- [Use Helm to install F5 DOS for NGINX](#use-helm-to-install-f5-dos-for-nginx)
- [Use Manifests to install F5 DOS for NGINX](#use-manifests-to-install-f5-dos-for-nginx)

## Use Helm to install F5 DOS for NGINX

You will need to edit the `values.yaml` file for a few changes:

- Update _appprotectdos.image.repository_ and _appprotectdos.image.tag_  with the image name chosen during when [building the Docker image](#build-the-docker-image).

The `<JWT Token>` argument should be the _contents_ of the file, not the file itself. Ensure there are no additional characters such as extra whitespace.

On helm deployment environment variables need to be set for image repository and tag.
`set enviorment variable DOS_IMAGE_REPOSITORY` with your actual nginx-dos image anmae.
`set enviorment variable DOS_IMAGE_TAG` with your actual nginx-dos image tag.

Once you have updated `values.yaml`, you can install F5 WAF for NGINX using `helm install`:

```shell
export DOS_IMAGE_REPOSITORY=<your-nginx-dos-image-name>
export DOS_IMAGE_TAG=<your-nginx-dos-image-tag>

kubectl create namespace <namespace> --dry-run=client -o yaml | kubectl apply -f -
kubectl create secret generic license-token \ 
        --from-file=license.jwt=${PWD}/license.jwt --type=nginx.com/license --namespace <namespace>

# Install DOS Arbitrator
helm repo add nginx-stable https://helm.nginx.com/stable && helm repo update
helm install dos-arbitrator nginx-stable/nginx-appprotect-dos-arbitrator --namespace <namespace>

# Install DOS for NGINX
# release-version example: 4.8.3
helm pull oci://private-registry.nginx.com/nap-dos/nginx-app-protect --version <release-version> --untar
cd nginx-app-protect-dos

helm install nginx-app-protect-dos --namespace <namespace> \
      --set namespace.create=false --set service.type=NodePort \
      --set appProtectDos.image.repository=${DOS_IMAGE_REPOSITORY} \
      --set appProtectDos.image.tag=${DOS_IMAGE_TAG} .
       
kubectl wait --for=condition=available --timeout=300s deployment/app-protect-dos -n <namespace>
```
You can verify the deployment is successful with `kubectl get`, replacing `namespace` accordingly:

```shell
kubectl get pods -n <namespace>
kubectl get svc -n <namespace>
```

{{< call-out "note" >}}

At this stage, you have finished deploying F5 DOS for NGINX and can look at [Post-installation checks](#post-installation-checks).

{{< /call-out >}}

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
