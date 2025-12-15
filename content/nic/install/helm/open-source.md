---
title: Use Helm to Install NGINX Ingress Controller with NGINX Open Source
linkTitle: NGINX Open Source
toc: true
weight: 100
nd-content-type: how-to
nd-product: INGRESS
---

This page describes how to use Helm to install F5 NGINX Ingress Controller with NGINX Open Source. 

It explains the requirements for NGINX Ingress Controller, how to obtain and install the Helm chart, and what custom resource definitions (CRDs) are installed during the process.

By following these instructions, you will finish with a functional NGINX Ingress Controller instance for your Kubernetes cluster.

## Before you begin

- A [supported Kubernetes version]({{< ref "/nic/technical-specifications.md#supported-kubernetes-versions" >}})
- A functional Kubernetes cluster
- [Helm 3.19+.](https://helm.sh/docs/intro/install)

Throughout this page, you will see placeholder values indicated with angular brackets, such as **\<my-release\>**. Replace them accordingly for your installation.

{{< call-out "warning" >}}

The `edge` version **is not intended for production use**. It is intended for testing and development purposes only.

{{< /call-out >}}

If you'd like to test the latest changes in NGINX Ingress Controller before a new release, you can install the `edge` version, which is built from the `main` branch of the [NGINX Ingress Controller repository](https://github.com/nginx/kubernetes-ingress).

You can install the `edge` version by specifying the `--version` flag with the value `0.0.0-edge`:

```shell
helm install <my-release> oci://ghcr.io/nginx/charts/nginx-ingress --version 0.0.0-edge
```

## Install the Helm chart

You have two options for installing the Helm chart: directly from the OCI registry, or using the source.

### OCI Registry

To install NGINX Ingress Controller using the OCI registry, run this command with your release name:

```shell
helm install <my-release> oci://ghcr.io/nginx/charts/nginx-ingress --version {{< nic-helm-version >}}
```

{{< details summary="Example output" >}}

```text
Pulled: ghcr.io/nginx/charts/nginx-ingress:{{< nic-helm-version >}}
Digest: sha256:bb452d593c31b6be39f459f9604882e170227429821bac01e7ddd7da16d91ba1
NAME: h4-oss
LAST DEPLOYED: Fri Nov 28 11:53:57 2025
NAMESPACE: default
STATUS: deployed
REVISION: 1
DESCRIPTION: Install complete
TEST SUITE: None
NOTES:
NGINX Ingress Controller {{< nic-version >}} has been installed.

For release notes for this version please see: https://docs.nginx.com/nginx-ingress-controller/releases/

Installation and upgrade instructions: https://docs.nginx.com/nginx-ingress-controller/installation/installing-nic/installation-with-helm/
```

{{< /details >}}

### From source

To install NGINX Ingress Controller from source, first pull the chart by running this command:

```shell
helm pull oci://ghcr.io/nginx/charts/nginx-ingress --untar --version {{< nic-helm-version >}}
```

{{< details summary="Example output" >}}

```text
Pulled: ghcr.io/nginx/charts/nginx-ingress:{{< nic-helm-version >}}
Digest: sha256:bb452d593c31b6be39f459f9604882e170227429821bac01e7ddd7da16d91ba1
```

{{< /details >}}

Then use the `cd` command to change your working directory to _nginx-ingress_:

```shell
cd nginx-ingress
```

Finally, install the chart with your release name with `helm install`:

```shell
helm install <my-release> . 
```

{{< details summary="Example output" >}}

```text
NAME: h4-oss-source
LAST DEPLOYED: Fri Nov 28 12:06:07 2025
NAMESPACE: default
STATUS: deployed
REVISION: 1
DESCRIPTION: Install complete
TEST SUITE: None
NOTES:
NGINX Ingress Controller {{< nic-version >}} has been installed.

For release notes for this version please see: https://docs.nginx.com/nginx-ingress-controller/releases/

Installation and upgrade instructions: https://docs.nginx.com/nginx-ingress-controller/installation/installing-nic/installation-with-helm/
```

{{< /details >}}

## Verify the deployment

To verify that NGINX Ingress Controller has been installed correctly, you can review `ingressclasses` with `kubectl get`:

```shell
kubectl get ingressclasses
```

{{< details summary="Example output" >}}

```text
NAME    CONTROLLER                     PARAMETERS   AGE
nginx   nginx.org/ingress-controller   <none>       10m
```

{{< /details >}}

## Custom Resource Definitions

When installing the chart, Helm will install the required CRDs. Without them, NGINX Ingress Controller pods will not become _Ready_.

If you do not use the custom resources that require those CRDs, add the parameter `--skip-crds` in your `helm install` command.

The following chart parameters should be set to `false`:

- `controller.enableCustomResources`
- `controller.appprotect.enable`
- `controller.appprotectdos.enable`

## Next steps

- [NGINX Ingress Controller Helm chart parameters]({{< ref "/nic/install/helm/parameters.md" >}})
- [Security recommendations]({{< ref "/nic/configuration/security.md" >}})
- [Basic configuration]({{< ref "/nic/configuration/ingress-resources/basic-configuration.md" >}})
- [Extensibility with NGINX Plus]({{< ref "/nic/overview/nginx-plus.md" >}})