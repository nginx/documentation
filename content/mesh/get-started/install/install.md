---
title: Install with nginx-meshctl
draft: false
toc: true
weight: 200
docs: DOCS-681
type:
- how-to
---

## Overview

This guide contains instructions for downloading and installing F5 NGINX Service Mesh using the `nginx-meshctl` command line tool.

## Prerequisites

Before installing NGINX Service Mesh, make sure you've completed the following steps.

- You have a working and [supported]({{< ref "/mesh/about/mesh-tech-specs.md#supported-versions" >}}) Kubernetes or OpenShift cluster.
- You followed the [Platform Setup]({{< ref "/mesh/get-started/platform-setup/_index.md" >}}) guide to prepare your cluster to work with NGINX Service Mesh.
- You have the Kubernetes `kubectl` command-line utility configured on the machine where you want to install NGINX Service Mesh.

## Install the CLI

The following sections describe how to install the CLI on Linux, macOS, and Windows.

### Download nginx-meshctl

The NGINX Service Mesh command-line tool -- `nginx-meshctl` -- allows you to deploy, remove, and interact with the NGINX Service Mesh control plane.

To install NGINX Service Mesh, you need to download the `nginx-meshctl` binary for your architecture. The latest version of `nginx-meshctl` is available on our [Github releases](https://github.com/nginxinc/nginx-service-mesh/releases/latest) page.

### Install on Linux

1. Download the appropriate binary for your architecture, either `nginx-meshctl_<version>_linux_amd64.tar.gz` or `nginx-meshctl_<version>_linux_arm64.tar.gz`.

1. Unzip the binary.

    ```bash
    tar -xvf nginx-meshctl_<version>_linux_amd64.tar.gz nginx-meshctl
    ```

1. Move the `nginx-meshctl` executable in to your PATH.

    ```bash
    sudo mv nginx-meshctl /usr/local/bin/nginx-meshctl
    ```

1. Ensure the `nginx-meshctl` is executable.

    ```bash
    sudo chmod +x /usr/local/bin/nginx-meshctl
    ```

1. Test the installation.

    ```bash
    nginx-meshctl
    ```

### Install on macOS

1. Download the appropriate binary for your architecture, either `nginx-meshctl_<version>_darwin_arm64.tar.gz` for M1 Macs or `nginx-meshctl_<version>_darwin_amd64.tar.gz` for Intel based Macs.

1. Unzip the binary.

    ```bash
    tar -xvf nginx-meshctl_<version>_darwin_amd64.tar.gz nginx-meshctl
    ```

1. Move the `nginx-meshctl` executable in to your PATH.

    ```bash
    sudo mv nginx-meshctl /usr/local/bin/nginx-meshctl
    ```

1. Ensure the `nginx-meshctl` is executable.

    ```bash
    sudo chmod +x /usr/local/bin/nginx-meshctl
    ```

1. Test the installation.

    ```bash
    nginx-meshctl
    ```

### Install on Windows

1. Download the appropriate binary for your architecture, either `nginx-meshctl_<version>_windows_amd64.zip` or `nginx-meshctl_<version>_windows_arm64.zip`.
1. Extract the binary, `nginx-meshctl.exe`, from the zip file.
1. Add the binary to your PATH.
1. Test the installation.

    ```bash
    nginx-meshctl
    ```

## Install the NGINX Service Mesh Control Plane

NGINX Service Mesh will pull multiple required images into your Kubernetes cluster in order to function, some of which are from publicly-accessible third parties. For a full list refer to the [Technical Specifications]({{< ref "/mesh/about/mesh-tech-specs.md#images" >}}). If you are using a private registry, see our [private registry guide]({{< ref "/mesh/guides/private-registry.md" >}}).

Check out the [Configuration Options]({{< ref "/mesh/get-started/install/configuration.md" >}}) to learn about the deployment options.
You can find the full list of options in the [`nginx-meshctl` Reference]( {{< ref "nginx-meshctl.md" >}} ).

{{< important >}}
`nginx-meshctl` creates the namespace for the NGINX Service Mesh control plane.
This namespace is dedicated to the NGINX Service Mesh control plane and **should not be used for anything else**.
If desired, you can specify any name for the namespace via the `--namespace` argument, but do not create this namespace yourself.
{{< /important >}}

Follow the steps below to install the NGINX Service Mesh control plane.

1. Run the `nginx-meshctl deploy` command using the desired [options]({{< ref "nginx-meshctl.md#deploy" >}}).

   **Examples:**

   Deploy NGINX Service Mesh using all of the default settings for the latest release:

    ```bash
    nginx-meshctl deploy
    ```

    OpenShift users must add the `--environment openshift` flag when deploying:

    ```bash
    nginx-meshctl deploy --environment openshift
    ```

    Disable [Persistent Storage]({{< ref "/mesh/get-started/platform-setup/persistent-storage.md" >}}) if it is not configured in your cluster:

    ```bash
    nginx-meshctl deploy --persistent-storage off
    ```

1. Verify the pods are running. If running in OpenShift, you will see additional `spiffe-csi-driver` Pods.

    ```bash
    $ kubectl get pods -n nginx-mesh
    NAME                                   READY   STATUS    RESTARTS   AGE
    nats-server-84f8b6f669-xszkc           1/1     Running   0          14m
    nginx-mesh-controller-954467945-sc7qh  1/1     Running   0          14m
    nginx-mesh-metrics-57464df46d-qskd2    1/1     Running   0          14m
    spire-agent-92ktv                      1/1     Running   0          15m
    spire-agent-9dbn6                      1/1     Running   0          15m
    spire-agent-z5cq6                      1/1     Running   0          15m
    spire-server-0                         2/2     Running   0          15m
    ```

## Next Steps

Congratulations! At this point NGINX Service Mesh should be successfully installed in your cluster.

### Add the Sidecar to Your Workloads

Now that the control plane is deployed in your cluster, it is time to add the sidecar to your workloads so you can start using the mesh.
Check out the [Sidecar Proxy Injection]({{< ref "/mesh/guides/inject-sidecar-proxy.md" >}}) doc for instructions on how to do that.

### Troubleshooting

If the mesh fails to install, review the [Platform Setup]({{< ref "/mesh/get-started/platform-setup/_index.md" >}}) docs for your platform, the installation steps above, and the [Configuration Options]({{< ref "/mesh/get-started/install/configuration.md" >}}) to ensure everything is configured correctly.
Some frequent problem areas are cluster permissions, security contexts (particularly in OpenShift), and [Persistent Storage]({{< ref "/mesh/get-started/platform-setup/persistent-storage.md" >}}).

If the mesh installation failed or you pressed ctrl-C during deployment, make sure to first [remove the mesh]({{< ref "/mesh/get-started/uninstall/uninstall.md" >}}) before attempting to re-install.

If you are unable to resolve the issues, please reach out to the appropriate [support channel]({{< ref "/mesh/support/contact-support.md" >}}).
