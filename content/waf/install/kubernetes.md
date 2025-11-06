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

This page describes how to install F5 WAF for NGINX using Kubernetes.

It explains the common steps necessary for any Kubernetes-based deployment, then provides details specific to Helm or Manifests.

## Before you begin

To complete this guide, you will need the following pre-requisites:

- A functional Kubernetes cluster
- An active F5 WAF for NGINX subscription (Purchased or trial)
- [Docker](https://docs.docker.com/get-started/get-docker/)

You will need [Helm](https://helm.sh/docs/intro/install/) installed for a Helm-based deployment.

You should read the [IP intelligence]({{< ref "/waf/policies/ip-intelligence.md" >}}) and [Secure traffic using mTLS]({{< ref "/waf/configure/secure-mtls.md" >}}) topics for additional set-up configuration if you want to use them immediately.

There is another optional topic to [Add a read-only filesystem for Kubernetes]({{< ref "/waf/configure/kubernetes-read-only.md" >}})

To review supported operating systems, read the [Technical specifications]({{< ref "/waf/fundamentals/technical-specifications.md" >}}) topic.

## Download your subscription credentials 

{{< include "licensing-and-reporting/download-certificates-from-myf5.md" >}}

## Create a Dockerfile

In the same folder as your credential files, create a _Dockerfile_ based on your desired operating system image using an example from the following sections.

Alternatively, you may want make your own image based on a Dockerfile using the official NGINX image:

{{< details summary="Dockerfile based on official image" >}}

This example uses NGINX Open Source as a base: it requires NGINX to be installed as a package from the official repository, instead of being compiled from source.

{{< include "/waf/dockerfiles/official-oss.md" >}}

{{< /details >}}

{{< call-out "note" >}}

If you are not using using `custom_log_format.json` or the IP intelligence feature,  you should remove any references to them from your Dockerfile.

{{< /call-out >}}

### Alpine Linux

{{< tabs name="alpine-instructions" >}}

{{% tab name="NGINX Open Source" %}}

{{< include "/waf/dockerfiles/alpine-oss.md" >}}

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

{{< include "/waf/dockerfiles/alpine-plus.md" >}}

{{% /tab %}}

{{< /tabs >}}

### Amazon Linux

{{< tabs name="amazon-instructions" >}}

{{% tab name="NGINX Open Source" %}}

{{< include "/waf/dockerfiles/amazon-oss.md" >}}

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

{{< include "/waf/dockerfiles/amazon-plus.md" >}}

{{% /tab %}}

{{< /tabs >}}

### Debian

{{< tabs name="debian-instructions" >}}

{{% tab name="NGINX Open Source" %}}

{{< include "/waf/dockerfiles/debian-oss.md" >}}

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

{{< include "/waf/dockerfiles/debian-oss.md" >}}

{{% /tab %}}

{{< /tabs >}}

### Oracle Linux

{{< tabs name="oracle-instructions" >}}

{{% tab name="NGINX Open Source" %}}

{{< include "/waf/dockerfiles/oracle-oss.md" >}}

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

{{< include "/waf/dockerfiles/oracle-plus.md" >}}

{{% /tab %}}

{{< /tabs >}}

### RHEL 8

{{< tabs name="rhel8-instructions" >}}

{{% tab name="NGINX Open Source" %}}

{{< include "/waf/dockerfiles/rhel8-oss.md" >}}

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

{{< include "/waf/dockerfiles/rhel8-plus.md" >}}

{{% /tab %}}

{{< /tabs >}}

### RHEL 9

{{< tabs name="rhel9-instructions" >}}

{{% tab name="NGINX Open Source" %}}

{{< include "/waf/dockerfiles/rhel9-oss.md" >}}

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

{{< include "/waf/dockerfiles/rhel9-plus.md" >}}

{{% /tab %}}

{{< /tabs >}}

### Rocky Linux 9

{{< tabs name="rocky-instructions" >}}

{{% tab name="NGINX Open Source" %}}

{{< include "/waf/dockerfiles/rocky9-oss.md" >}}

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

{{< include "/waf/dockerfiles/rocky9-plus.md" >}}

{{% /tab %}}

{{< /tabs >}}

### Ubuntu

{{< tabs name="ubuntu-instructions" >}}

{{% tab name="NGINX Open Source" %}}

{{< include "/waf/dockerfiles/ubuntu-oss.md" >}}

{{% /tab %}}

{{% tab name="NGINX Plus" %}}

{{< include "/waf/dockerfiles/ubuntu-plus.md" >}}

{{% /tab %}}

{{< /tabs >}}

## Build the Docker image

Your folder should contain the following files:

- _nginx-repo.cert_
- _nginx-repo.key_
- _Dockerfile_

To build an image, use the following command, replacing `<your-image-name>` as appropriate:

```shell
sudo docker build --no-cache --platform linux/amd64 \
  --secret id=nginx-crt,src=nginx-repo.crt \
  --secret id=nginx-key,src=nginx-repo.key \
  -t <your-image-name> .
```

Once you have built the image, push it to your private image repository, which should be accessible to your Kubernetes cluster.

From this point, the steps change based on your installation method:

- [Use Helm to install F5 WAF for NGINX](#use-helm-to-install-f5-waf-for-nginx)
- [Use Manifests to install F5 WAF for NGINX](#use-manifests-to-install-f5-waf-for-nginx)

## Use Helm to install F5 WAF for NGINX

### Download your JSON web token

{{< include "licensing-and-reporting/download-jwt-from-myf5.md" >}}

### Get the Helm chart

To get the Helm chart, first configure Docker for the F5 Container Registry.

{{< include "waf/install-services-registry.md" >}}

Then use `helm pull` to get the chart, replacing `<release-version>`:

```shell
helm pull oci://private-registry.nginx.com/nap/nginx-app-protect --version <release-version> --untar
```

Change the working directory afterwards:

```shell
cd nginx-app-protect
```

### Deploy the Helm chart

You will need to edit the `values.yaml` file for a few changes:

- Update _appprotect.nginx.image.repository_ and _appprotect.nginx.image.tag_  with the image name chosen during when [building the Docker image](#build-the-docker-image).
- Update _appprotect.config.nginxJWT_ with your JSON web token
- Update _dockerConfigJson_ to contain the base64 encoded Docker registration credentials

You can encode your credentials with the following command:

```shell
echo '{
    "auths": {
        "private-registry.nginx.com": {
            "username": "<JWT Token>",
            "password": "none"
        }
    }
}' | base64 -w 0```
```

Alternatively, you can use `kubectl` to create a secret:

```shell
kubectl create secret docker-registry regcred -n <namespace> \
    --docker-server=private-registry.nginx.com \
    --docker-username=<JWT Token> \
    --docker-password=none
```

The `<JWT Token>` argument should be the _contents_ of the file, not the file itself. Ensure there are no additional characters such as extra whitespace.

Once you have updated `values.yaml`, you can install F5 WAF for NGINX using `helm install`:

```shell
helm install <release-name> .
```

You can verify the deployment is successful with `kubectl get`, replacing `namespace` accordingly:

```shell
kubectl get pods -n <namespace>
kubectl get svc -n <namespace>
```

{{< call-out "note" >}}

At this stage, you have finished deploying F5 WAF for NGINX and can look at [Post-installation checks](#post-installation-checks).

{{< /call-out >}}

### Helm Chart parameters

This table lists the configurable parameters of the F5 WAF for NGINX Helm chart and their default values.

To understand the _mTLS Configuration_ options, view the [Secure traffic using mTLS]({{< ref "/waf/configure/secure-mtls.md" >}}) topic.

{{< table >}}

| **Topic** | **Parameter** | **Description** | **Default value** |
|-------------|---------|-----------------|-------------------|
| **Namespace** | _namespace_ | The target Kubernetes namespace where the Helm chart will be deployed. | N/A |
| **F5 WAF for NGINX Configuration** | _appprotect.replicas_ | The number of replicas for the F5 WAF for NGINX deployment. | 1 |
| | _appprotect.readOnlyRootFilesystem_ | Specifies if the root filesystem is read-only. | false |
| | _appprotect.annotations_ | Custom annotations for the deployment. | {} |
| **NGINX Configuration** | _appprotect.nginx.image.repository_ | Docker image repository for NGINX. | \<your-private-registry>/nginx-app-protect-5 |
| | _appprotect.nginx.image.tag_ | Docker image tag for NGINX. | latest |
| | _appprotect.nginx.imagePullPolicy_ | Image pull policy. | IfNotPresent |
| | _appprotect.nginx.resources_ | The resources of the NGINX container. | requests: cpu=10m,memory=16Mi |
| **WAF Config Manager** | _appprotect.wafConfigMgr.image.repository_ | Docker image repository for the WAF Configuration Manager. | private-registry.nginx.com/nap/waf-config-mgr |
| | _appprotect.wafConfigMgr.image.tag_ | Docker image tag for the WAF Configuration Manager. | {{< version-waf-config-mgr >}} |
| | _appprotect.wafConfigMgr.imagePullPolicy_ | Image pull policy. | IfNotPresent |
| | _appprotect.wafConfigMgr.resources_ | The resources of the WAF Config Manager container. | requests: cpu=10m,memory=16Mi |
| **WAF Enforcer** | _appprotect.wafEnforcer.image.repository_ | Docker image repository for the WAF Enforcer. | private-registry.nginx.com/nap/waf-enforcer |
| | _appprotect.wafEnforcer.image.tag_ | Docker image tag for the WAF Enforcer. | {{< version-waf-enforcer >}} |
| | _appprotect.wafEnforcer.imagePullPolicy_ | Image pull policy. | IfNotPresent |
| | _appprotect.wafEnforcer.env.enforcerPort_ | Port for the WAF Enforcer. | 50000 |
| | _appprotect.wafEnforcer.resources_ | The resources of the WAF Enforcer container. | requests: cpu=20m,memory=256Mi |
| **WAF IP Intelligence** | _appprotect.wafIpIntelligence.enable | Enable or disable the use of the IP intelligence container | false |
| | _appprotect.wafIpIntelligence.image.repository_ | Docker image repository for the WAF IP Intelligence. | private-registry.nginx.com/nap/waf-ip-intelligence |
| | _appprotect.wafIpIntelligence.image.tag_ | Docker image tag for the WAF Enforcer. | {{< version-waf-ip-intelligence >}} |
| | _appprotect.wafIpIntelligence.imagePullPolicy_ | Image pull policy. | IfNotPresent |
| | _appprotect.wafIpIntelligence.resources_ | The resources of the WAF Enforcer container. | requests: cpu=10m,memory=256Mi |
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

{{< /table >}}

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

{{% tab name="waf-service.yaml" %}}

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

From the folder containing the YAML files from the previous step (Suggested as `/manifests`), deploy F5 WAF for NGINX using `kubectl`:

```shell
kubectl apply -f manifests/
```

It will apply all the configuration defined in the files to your Kubernetes cluster.

You can then check the status of the deployment with `kubectl get`:

```shell
kubectl get deployments
kubectl get pods
kubectl get services
```

You should see output similar to the following:

```text
deployment.apps/nap5-deployment created
service/nginx created
persistentvolume/nap5-bundles-pv created
persistentvolumeclaim/nap5-bundles-pvc created
```

{{< call-out "note" >}}

At this stage, you have finished deploying F5 WAF for NGINX and can look at [Post-installation checks](#post-installation-checks).

{{< /call-out >}}

## Post-installation checks

{{< include "waf/install-post-checks.md" >}}

Or from an external host:

```shell
curl "<node-external-ip>:<node-port>/<script>"
```

## Next steps

{{< include "waf/install-next-steps.md" >}}
