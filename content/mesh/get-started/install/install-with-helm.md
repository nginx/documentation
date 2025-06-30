---
title: Install with Helm
draft: false
toc: true
description: This guide explains how to install F5 NGINX Service Mesh using Helm.
weight: 300
nd-docs: DOCS-680
type:
- how-to
---

## Prerequisites

Before installing F5 NGINX Service Mesh, make sure you've completed the following steps.

- You have Helm version 3.2.0 or newer installed.
- You have a working and [supported]({{< ref "/mesh/about/mesh-tech-specs.md#supported-versions" >}}) Kubernetes or OpenShift cluster.
- You followed the [Kubernetes]( {{< ref "/mesh/get-started/platform-setup/_index.md" >}} ) or [OpenShift]( {{< ref "/mesh/get-started/platform-setup/openshift.md" >}} ) Platform Setup guide to **prepare your cluster** to work with NGINX Service Mesh.
- You have the Kubernetes `kubectl` command-line utility configured on the machine where you want to install NGINX Service Mesh.
- You reviewed the [Configuration Options](#configuration-options).

## Get the Chart

When installing with Helm, you can either add the NGINX Service Mesh Helm repository or download the charts from GitHub.

### Add the Helm Repository

This step is required if you're installing the chart via the helm repository.

```bash
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
```

### Download the Chart from GitHub

This step is required if you're installing the chart using its sources. Additionally, this step is required for upgrading the NGINX Service Mesh Custom Resource Definitions (CRDs).

```bash
git clone https://github.com/nginxinc/nginx-service-mesh
cd nginx-service-mesh/helm-chart
git checkout v2.0.0
```

## Install the Chart

NGINX Service Mesh requires a dedicated namespace for the control plane.
You can create this namespace yourself, or allow Helm to create it for you via the `--create-namespace` flag when installing.
This namespace is dedicated to the NGINX Service Mesh control plane and **should not be used for anything else**.

NGINX Service Mesh will pull multiple required images into your Kubernetes cluster in order to function, some of which are from publicly-accessible third parties. For a full list refer to the [Technical Specifications]({{< ref "/mesh/about/mesh-tech-specs.md#images" >}}). If you are using a private registry, see our [private registry guide]({{< ref "/mesh/guides/private-registry.md" >}}).


If [Persistent Storage]({{< ref "/mesh/get-started/platform-setup/persistent-storage.md" >}}) is not configured in your cluster, disable it in the mesh by adding the `--set mtls.persistentStorage=off` flag to the install commands below.

OpenShift users must add the `--set environment=openshift` flag to the install commands below.

### Install via Repository

To install the chart with the release name `nsm` and namespace `nginx-mesh`, run:

```bash
helm install nsm nginx-stable/nginx-service-mesh --namespace nginx-mesh --create-namespace --wait
```

### Install via Source

To install the chart with the release name `nsm` and namespace `nginx-mesh`, run:

```bash
helm install nsm . --namespace nginx-mesh --create-namespace --wait
```

NGINX Service Mesh control plane Pods may take some time to become Ready once installed.
Some Pods may display error logs during the startup process.
This typically occurs as the Pods attempt to connect to each other.

OpenShift users may see error events related to security contexts while the NGINX Service Mesh control plane is installing.
These should resolve themselves as each component becomes ready.

Ensure all control plane Pods are in a Ready state before deploying your applications.

## Next Steps

Congratulations! At this point NGINX Service Mesh should be successfully installed in your cluster.

### Add the Sidecar to Your Workloads

Now that the control plane is deployed in your cluster, it is time to add the sidecar to your workloads so you can start using the mesh.
Check out the [Sidecar Proxy Injection]({{< ref "/mesh/guides/inject-sidecar-proxy.md" >}}) doc for instructions on how to do that.

### Troubleshooting

If the mesh fails to install, review the [Platform Setup]({{< ref "/mesh/get-started/platform-setup/_index.md" >}}) docs for your platform, the installation steps above, and the [Configuration Options]({{< ref "#configuration-options" >}}) to ensure everything is configured correctly.
A couple frequent problem areas are cluster permissions, security contexts (particularly in OpenShift), and [Persistent Storage]({{< ref "/mesh/get-started/platform-setup/persistent-storage.md" >}}).

If the mesh installation failed or you pressed ctrl-C during deployment, make sure to first [remove the mesh]({{< ref "/mesh/get-started/uninstall/uninstall-with-helm.md" >}}) before attempting to re-install.

If you are unable to resolve the issues, please reach out to the appropriate [support channel]({{< ref "/mesh/support/contact-support.md" >}}).

## Configuration Options

The [values.yaml](https://github.com/nginxinc/nginx-service-mesh/blob/main/helm-chart/values.yaml) file within the `nginx-service-mesh` Helm chart contains the deployment configuration for NGINX Service Mesh.
These configuration fields map directly to the `nginx-meshctl deploy` command-line options mentioned throughout our documentation.
More details about these options can be found in the [Configuration]( {{< ref "/mesh/get-started/install/configuration.md" >}} ) guide.
You can update these fields directly in the `values.yaml` file, or by specifying the `--set` flag when running `helm install`.

The following table lists the configurable parameters of the NGINX Service Mesh chart and their default values.

{{% table %}}
| Parameter | Description | Default |
| --- | --- | --- |
| `registry.server` | Hostname:port (if needed) for registry and path to images. Affects: nginx-mesh-controller, nginx-mesh-cert-reloader, nginx-mesh-init, nginx-mesh-metrics, nginx-mesh-sidecar | docker-registry.nginx.com/nsm |
| `registry.imageTag` | Tag used for pulling images from registry. Affects: nginx-mesh-controller, nginx-mesh-cert-reloader, nginx-mesh-init, nginx-mesh-metrics, nginx-mesh-sidecar | 2.0.0 |
| `registry.key` | Contents of your Google Cloud JSON key file. Can be set via `--set-file registry.key=<your-key-file>.json`. Cannot be used with username/password. | "" |
| `registry.username` | Username for accessing private registry. Cannot be used with key. | "" |
| `registry.password` | Password for accessing private registry. Cannot be used with key. | "" |
| `registry.disablePublicImages` | Do not pull third party images from public repositories. If true, registry.server is used for all images. | false |
| `registry.imagePullPolicy` | Image pull policy. | IfNotPresent |
| `accessControlMode` | Default access control mode for service-to-service communication. | allow |
| `environment` | Environment to deploy the mesh into. Valid values: "kubernetes", "openshift". | kubernetes |
| `enableUDP` | Enable UDP traffic proxying (beta). Linux kernel 4.18 or greater is required. | false |
| `nginxErrorLogLevel` | NGINX error log level. | warn |
| `nginxLogFormat` | NGINX log format. | default |
| `nginxLBMethod` | NGINX load balancing method. | least_time |
| `clientMaxBodySize` | NGINX client max body size. Setting to "0" disables checking of client request body size. | 1m |
| `prometheusAddress` | The address of a Prometheus server deployed in your Kubernetes cluster. Address should be in the format `<service-name>.<namespace>:<service-port>`. | "" |
| `telemetry.samplerRatio` | The percentage of traces that are processed and exported to the telemetry backend. Float between 0 and 1. | 0.01 |
| `telemetry.exporters` | The configuration of exporters to send telemetry data to. | |
| `telemetry.exporters.otlp` | The configuration for an OTLP gRPC exporter. | |
| `telemetry.exporters.otlp.host` | The host of the OpenTelemetry gRPC exporter to connect to. Must be accessible from within the cluster. | |
| `telemetry.exporters.otlp.port` | The port of the OpenTelemetry gRPC exporter to connect to. | 4317 |
| `mtls.mode` | mTLS mode for pod-to-pod communication. | permissive |
| `mtls.caTTL` | The CA/signing key TTL in hours(h). Min value 24h. Max value 999999h. | 720h |
| `mtls.svidTTL` | The trust domain of the NGINX Service Mesh. Max value is 999999. | 1h |
| `mtls.persistentStorage` | Use persistent storage; "on" assumes that a StorageClass exists. | on |
| `mtls.spireServerKeyManager` | Storage logic for Spire Server's private keys. | disk |
| `mtls.caKeyType` | The key type used for the SPIRE Server CA. Valid values: "ec-p256", "ec-p384", "rsa-2048", "rsa-4096". | ec-p256 |
| `mtls.upstreamAuthority` | Upstream authority settings. If left empty, SPIRE is used as the upstream authority. See [values.yaml](https://github.com/nginxinc/nginx-service-mesh/blob/main/helm-chart/values.yaml) for how to configure. | {} |
{{% /table %}}
