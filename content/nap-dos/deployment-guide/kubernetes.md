---
# We use sentence case and present imperative tone
title: "Kubernetes"
# Weights are assigned in increments of 100: determines sorting order
weight: 200
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: how-to
nd-product: WAF
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

## Build the Docker image

Your folder should contain the following files:

- _nginx-repo.crt_
- _nginx-repo.key_
- _Dockerfile_

To build an image, use the following command, replacing `<your-image-name>` as appropriate:

```shell
sudo docker build --no-cache --platform linux/amd64 \
  --secret id=nginx-crt,src=nginx-repo.crt \
  --secret id=nginx-key,src=nginx-repo.key \
  --secret id=license-jwt,src=license.jwt \
  -t <your-image-name> .
```

Once you have built the image, push it to your private image repository, which should be accessible to your Kubernetes cluster.

From this point, the steps change based on your installation method:

- [Use Manifests to install F5 WAF for NGINX](#use-manifests-to-install-f5-waf-for-nginx)

## Use Manifests to install F5 WAF for NGINX

### Update configuration files

{{< include "waf/install-update-configuration.md" >}}

### Create a Secret

Before you can start the Manifest deployment, you need a Kubernetes secret for the Docker registry.

You can create the secret using `kubectl create`:

```shell
kubectl create secret docker-registry regcred --docker-server=private-registry.nginx.com --docker-username=<JWT Token> --docker-password=none
```

The `<JWT Token>` argument should be the _contents_ of the file, not the file itself. Ensure there are no additional characters such as extra whitespace.

### Create Manifest files

The default configuration provided creates two replicas, each hosting NGINX and WAF services together in a single Kubernetes pod.

Create all of these files in a single folder (Such as `/manifests`).

In each file, replace `<your-private-registry>/waf:<your-tag>` with your actual image tag.

{{< tabs name="manifest-files" >}}

{{% tab name="waf-storage.yaml" %}}

{{< call-out "note" >}}

This configuration uses a _hostPath_ backed persistent volume claim.

{{< /call-out >}}

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
          image: <your-private-registry>/waf:<your-tag>
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

{{% /tab %}}

{{% tab name="waf-deployment.yaml" %}}

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dos-deployment
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
          image: <your-private-registry>/waf:<your-tag>
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

{{% /tab %}}

{{% tab name="dos-service.yaml" %}}

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

{{% /tab %}}

{{< /tabs >}}

### Start the Manifest deployment

From the folder containing the YAML files from the previous step (Suggested as `/manifests`), deploy F5 DOS for NGINX using `kubectl`:

```shell
kubectl apply -f manifests/
```

It will apply all the configuration defined in the files to your Kubernetes cluster.

You can then check the status of the deployment with `kubectl get`:

```shell
kubectl -n dos get deployments
kubectl -n dos get pods
kubectl -n dos get services
```

You should see output similar to the following:

```text
...

```

{{< call-out "note" >}}

At this stage, you have finished deploying F5 WAF for NGINX and can look at [Post-installation checks](#post-installation-checks).

{{< /call-out >}}

## Post-installation checks


## Next steps
