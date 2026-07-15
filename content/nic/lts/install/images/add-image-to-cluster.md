---
title: Add an NGINX Ingress Controller LTS image to your cluster
toc: true
weight: 150
f5-content-type: how-to
f5-product: NGINX Ingress Controller
---

This document describes how to add an F5 NGINX Plus Ingress Controller image from the F5 Docker registry into your Kubernetes cluster using a JWT token.

## Before you begin

To follow these steps, you will need the following pre-requisite:

- [Create a license Secret]({{< ref "/nic/lts/install/license-secret.md" >}})

You can also get the NGINX Ingress Controller LTS image using the following alternate methods:

- [Download NGINX Ingress Controller LTS from the F5 Registry]({{< ref "/nic/lts/install/images/registry-download.md" >}})

## Helm deployments

If you are using Helm for deployment, there are two main methods: using a _chart_ or _source_.

### Add the image from chart

The following command installs NGINX Ingress Controller LTS with a Helm chart, passing required arguments using the `set` parameter.

```shell
helm install my-release -n nginx-ingress oci://ghcr.io/nginx/charts/nginx-ingress-lts --version {{< nic-lts-helm-version >}} --set controller.image.repository=private-registry.nginx.com/nginx-ic/lts/nginx-plus-ingress --set controller.image.tag={{< nic-lts-version >}} --set controller.nginxplus=true --set controller.serviceAccount.imagePullSecretName=regcred
```

You can also use the certificate and key from the MyF5 portal and the Docker registry API to list the available image tags for the repositories, for example:

```shell
curl https://private-registry.nginx.com/v2/nginx-ic/lts/nginx-plus-ingress/tags/list --key <path-to-client.key> --cert <path-to-client.cert>
```

```json
{
"name": "nginx-ic/lts/nginx-plus-ingress",
"tags": [
    "2026-lts-r3"
]
}
```

The `jq` command was used in these examples to make the JSON output easier to read.

### Add the image from source

The [Installation with Helm]({{< ref "/nic/lts/install/helm/#install-the-helm-chart-from-source" >}}) documentation has a section describing how to use sources: these are the unique steps for Docker secrets using JWT tokens.

1. Clone the NGINX [`kubernetes-ingress` repository](https://github.com/nginx/kubernetes-ingress).
1. Navigate to the `charts/nginx-ingress` folder of your local clone.
1. Open the `values.yaml` file in an editor.

    You must change a few lines NGINX Ingress Controller LTS with NGINX Plus to be deployed.

    1. Change the `nginxplus` argument to `true`.
    1. Change the `repository` argument to the NGINX Ingress Controller LTS image you intend to use.
    1. Add an argument to `imagePullSecretName` or `imagePullSecretsNames` to allow Docker to pull the image from the private registry.

The following code block shows snippets of the parameters you will need to change, and an example of their contents:

```yaml
## Deploys the Ingress Controller for NGINX Plus
nginxplus: true
## Truncated fields
## ...
## ...
image:
## The image repository for the desired NGINX Ingress Controller LTS image
repository: private-registry.nginx.com/nginx-ic/lts/nginx-plus-ingress

## The version tag
tag: {{< nic-lts-version >}} 

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

With the modified `values.yaml` file, you can now use Helm to install NGINX Ingress Controller LTS, for example:

```shell
helm install nicdev01 -n nginx-ingress --create-namespace -f values.yaml .
```

The above command will install NGINX Ingress Controller LTS in the `nginx-ingress` namespace.

If the namespace does not exist, `--create-namespace` will create it. Using `-f values.yaml` tells Helm to use the `values.yaml` file that you modified earlier with the settings you want to apply for your NGINX Ingress Controller LTS deployment.

## Manifest deployment

The page ["Installation with Manifests"]({{< ref "/nic/lts/install/manifests.md" >}}) explains how to install NGINX Ingress Controller LTS using manifests. The following snippet is an example of a deployment:

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
  - image: private-registry.nginx.com/nginx-ic/lts/nginx-plus-ingress:2026-lts-r3
    imagePullPolicy: IfNotPresent
    name: nginx-plus-ingress
```

The `imagePullSecrets` and `containers.image` lines represent the Kubernetes secret, as well as the registry and version of NGINX Ingress Controller LTS we are going to deploy.

## Download an image for local use

If you need to download an image for local use (Such as to push to a different container registry), use this command:

```shell
docker login private-registry.nginx.com --username=<output_of_jwt_token> --password=none
```

Replace the contents of `<output_of_jwt_token>` with the contents of the JWT token itself.
Once you have successfully pulled the image, you can then tag it as needed.

{{< include "/nic/installation/jwt-password-note.md" >}}
