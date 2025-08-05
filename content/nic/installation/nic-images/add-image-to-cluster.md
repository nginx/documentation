---
title: Add an NGINX Ingress Controller image to your cluster
toc: true
weight: 150
nd-content-type: how-to
nd-product: NIC
nd-docs: DOCS-1454
---

This document describes how to add an F5 NGINX Plus Ingress Controller image from the F5 Docker registry into your Kubernetes cluster using a JWT token.

## Before you begin

To follow these steps, you will need the following pre-requisite:

- [Create a license Secret]({{< ref "/nic/installation/create-license-secret.md" >}})

You can also get the NGINX Ingress Controller image using the following alternate methods:

- [Download NGINX Ingress Controller from the F5 Registry]({{< ref "/nic/installation/nic-images/registry-download.md" >}})
- [Build NGINX Ingress Controller]({{< ref "/nic/installation/build-nginx-ingress-controller.md" >}}) 
- For NGINX Open Source, you can pull the [nginx/nginx-ingress image](https://hub.docker.com/r/nginx/nginx-ingress/) from DockerHub

## Helm deployments

If you are using Helm for deployment, there are two main methods: using a _chart_ or _source_.

### Add the image from chart

The following command installs NGINX Ingress Controller with a Helm chart, passing required arguments using the `set` parameter.

```shell
helm install my-release -n nginx-ingress oci://ghcr.io/nginx/charts/nginx-ingress --version {{< nic-helm-version >}} --set controller.image.repository=private-registry.nginx.com/nginx-ic/nginx-plus-ingress --set controller.image.tag={{< nic-version >}} --set controller.nginxplus=true --set controller.serviceAccount.imagePullSecretName=regcred
```

You can also use the certificate and key from the MyF5 portal and the Docker registry API to list the available image tags for the repositories, for example:

```shell
curl https://private-registry.nginx.com/v2/nginx-ic/nginx-plus-ingress/tags/list --key <path-to-client.key> --cert <path-to-client.cert>
```
```json
{
"name": "nginx-ic/nginx-plus-ingress",
"tags": [
    "{{< nic-version >}}-alpine",
    "{{< nic-version >}}-alpine-fips",
    "{{< nic-version >}}-ubi",
    "{{< nic-version >}}"
]
}
```

```shell
curl https://private-registry.nginx.com/v2/nginx-ic-nap/nginx-plus-ingress/tags/list --key <path-to-client.key> --cert <path-to-client.cert>
```
```json
{
"name": "nginx-ic-nap/nginx-plus-ingress",
"tags": [
    "{{< nic-version >}}-alpine-fips",
    "{{< nic-version >}}-ubi",
    "{{< nic-version >}}"
]
}
```

```shell
curl https://private-registry.nginx.com/v2/nginx-ic-dos/nginx-plus-ingress/tags/list --key <path-to-client.key> --cert <path-to-client.cert>
```
```json
{
"name": "nginx-ic-dos/nginx-plus-ingress",
"tags": [
    "{{< nic-version >}}-ubi",
    "{{< nic-version >}}"
]
}
```

The `jq` command was used in these examples to make the JSON output easier to read.

### Add the image from source

The [Installation with Helm]({{< ref "/nic/installation/installing-nic/installation-with-helm.md#install-the-helm-chart-from-source" >}}) documentation has a section describing how to use sources: these are the unique steps for Docker secrets using JWT tokens.

1. Clone the NGINX [`kubernetes-ingress` repository](https://github.com/nginx/kubernetes-ingress).
1. Navigate to the `charts/nginx-ingress` folder of your local clone.
1. Open the `values.yaml` file in an editor.

    You must change a few lines NGINX Ingress Controller with NGINX Plus to be deployed.

    1. Change the `nginxplus` argument to `true`.
    1. Change the `repository` argument to the NGINX Ingress Controller image you intend to use.
    1. Add an argument to `imagePullSecretName` or `imagePullSecretsNames` to allow Docker to pull the image from the private registry.

The following code block shows snippets of the parameters you will need to change, and an example of their contents:

```yaml
## Deploys the Ingress Controller for NGINX Plus
nginxplus: true
## Truncated fields
## ...
## ...
image:
## The image repository for the desired NGINX Ingress Controller image
repository: private-registry.nginx.com/nginx-ic/nginx-plus-ingress

## The version tag
tag: {{< nic-version >}}

serviceAccount:
    ## The annotations of the service account of the Ingress Controller pods.
    annotations: {}

## Truncated fields
## ...
## ...

    ## The name of the secret containing docker registry credentials.
    ## Secret must exist in the same namespace as the helm release.
    ## Note that also imagePullSecretsNames can be used here if multiple secrets need to be set.
    imagePullSecretName: regcred
```

With the modified `values.yaml` file, you can now use Helm to install NGINX Ingress Controller, for example:

```shell
helm install nicdev01 -n nginx-ingress --create-namespace -f values.yaml .
```

The above command will install NGINX Ingress Controller in the `nginx-ingress` namespace.

If the namespace does not exist, `--create-namespace` will create it. Using `-f values.yaml` tells Helm to use the `values.yaml` file that you modified earlier with the settings you want to apply for your NGINX Ingress Controller deployment.

## Manifest deployment

The page ["Installation with Manifests"]({{< ref "/nic/installation/installing-nic/installation-with-manifests.md" >}}) explains how to install NGINX Ingress Controller using manifests. The following snippet is an example of a deployment:

```yaml
spec:
  serviceAccountName: nginx-ingress
  imagePullSecrets:
  - name: regcred
  automountServiceAccountToken: true
  securityContext:
    seccompProfile:
      type: RuntimeDefault
  containers:
  - image: private-registry.nginx.com/nginx-ic/nginx-plus-ingress:{{< nic-version >}}
    imagePullPolicy: IfNotPresent
    name: nginx-plus-ingress
```

The `imagePullSecrets` and `containers.image` lines represent the Kubernetes secret, as well as the registry and version of NGINX Ingress Controller we are going to deploy.

## Download an image for local use

If you need to download an image for local use (Such as to push to a different container registry), use this command:

```shell
docker login private-registry.nginx.com --username=<output_of_jwt_token> --password=none
```

Replace the contents of `<output_of_jwt_token>` with the contents of the JWT token itself.
Once you have successfully pulled the image, you can then tag it as needed.

{{< include "/nic/installation/jwt-password-note.md" >}}
