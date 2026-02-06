---
title: Technical specifications
toc: true
weight: 200
nd-content-type: reference
nd-product: INGRESS
nd-docs: DOCS-617
---

This page describes technical specifications for F5 NGINX Ingress Controller, such as its version compatibility with Kubernetes and other NGINX software.

## Supported NGINX Ingress Controller versions

We recommend using the latest release of NGINX Ingress Controller, and provides software updates for the most recent release. 

We test NGINX Ingress Controller on a range of Kubernetes platforms for each release, and list them in the [Changelog]({{< ref "/nic/changelog" >}}).

We provide technical support for NGINX Ingress Controller on any Kubernetes platform that is currently supported by its provider, and that passes the [Kubernetes conformance tests](https://www.cncf.io/certification/software-conformance/).

We provide technical support for F5 customers who are using the most recent version of NGINX Ingress Controller, and any version released within two years of the current release.

{{< include "/nic/compatibility-tables/nic-k8s.md" >}}

## Supported Docker images

We provide the following Docker images, which include NGINX or NGINX Plus bundled with the Ingress Controller binary.

### Images with NGINX

_All images include NGINX 1.29.5._

|<div style="width:200px">Name</div> | <div style="width:100px">Base image</div> | DockerHub image | Architectures |
| ---| --- | --- | --- |
|Alpine-based image | ``nginx:1.29.5-alpine``,<br>based on on ``alpine:3.23`` | ``nginx/nginx-ingress:{{< nic-version >}}-alpine`` | arm64<br>amd64 |
|Debian-based image | ``nginx:1.29.5``,<br>based on on ``debian:13-slim`` | ``nginx/nginx-ingress:{{< nic-version >}}`` | arm64<br>amd64 |
|Ubi-based image | ``redhat/ubi9-minimal`` | ``nginx/nginx-ingress:{{< nic-version >}}-ubi`` | arm64<br>amd64 |

### Images with NGINX Plus

NGINX Plus images include NGINX Plus R36.

#### F5 Container registry

NGINX Plus images are available through the F5 Container registry `private-registry.nginx.com`, explained in the [Download NGINX Ingress Controller from the F5 Registry]({{< ref "/nic/install/images/registry-download.md" >}}) and [Add an NGINX Ingress Controller image to your cluster]({{< ref "/nic/install/images/add-image-to-cluster.md" >}}) topics.

{{< table >}}

| Name | Base image | <div style="width:200px">Additional modules</div> | F5 Container Registry Image | Architectures |
| ---| ---| --- | --- | --- |
|Alpine-based image | ``alpine:3.22`` | NJS (NGINX JavaScript)<br>OpenTelemetry  | `nginx-ic/nginx-plus-ingress:{{< nic-version >}}-alpine` | arm64<br>amd64 |
|Alpine-based image with FIPS inside | ``alpine:3.22`` | NJS (NGINX JavaScript)<br>OpenTelemetry<br>FIPS module and OpenSSL configuration | `nginx-ic/nginx-plus-ingress:{{< nic-version >}}-alpine-fips` | arm64<br>amd64 |
|Alpine-based image with F5 WAF for NGINX & FIPS inside | ``alpine:3.22`` | F5 WAF for NGINX<br>NJS (NGINX JavaScript)<br>OpenTelemetry<br>FIPS module and OpenSSL configuration | `nginx-ic-nap/nginx-plus-ingress:{{< nic-version >}}-alpine-fips` | amd64 |
|Alpine-based image with F5 WAF for NGINX v5 & FIPS inside | ``alpine:3.22`` | F5 WAF for NGINX v5<br>NJS (NGINX JavaScript)<br>OpenTelemetry<br>FIPS module and OpenSSL configuration | `nginx-ic-nap-v5/nginx-plus-ingress:{{< nic-version >}}-alpine-fips` | amd64 |
|Debian-based image | ``debian:12-slim`` | NJS (NGINX JavaScript)<br>OpenTelemetry | `nginx-ic/nginx-plus-ingress:{{< nic-version >}}` | arm64<br>amd64 |
|Debian-based image with F5 WAF for NGINX | ``debian:12-slim`` | F5 WAF for NGINX<br>NJS (NGINX JavaScript)<br>OpenTelemetry | `nginx-ic-nap/nginx-plus-ingress:{{< nic-version >}}` | amd64 |
|Debian-based image with F5 WAF for NGINX v5 | ``debian:12-slim`` | F5 WAF for NGINX v5<br>NJS (NGINX JavaScript)<br>OpenTelemetry | `nginx-ic-nap-v5/nginx-plus-ingress:{{< nic-version >}}` | amd64 |
|Debian-based image with F5 DoS for NGINX | ``debian:12-slim`` | F5 DoS for NGINX<br>NJS (NGINX JavaScript)<br>OpenTelemetry | `nginx-ic-dos/nginx-plus-ingress:{{< nic-version >}}` | amd64 |
|Debian-based image with F5 WAF for NGINX and DoS | ``debian:12-slim`` | F5 WAF for NGINX and DoS<br>NJS (NGINX JavaScript)<br>OpenTelemetry | `nginx-ic-nap-dos/nginx-plus-ingress:{{< nic-version >}}` | amd64 |
|Ubi-based image | ``redhat/ubi9-minimal`` | NJS (NGINX JavaScript)<br>OpenTelemetry | `nginx-ic/nginx-plus-ingress:{{< nic-version >}}-ubi` | arm64<br>amd64 |
|Ubi-based image with F5 WAF for NGINX | ``redhat/ubi9`` | F5 WAF for NGINX<br>NJS (NGINX JavaScript)<br>OpenTelemetry | `nginx-ic-nap/nginx-plus-ingress:{{< nic-version >}}-ubi` | amd64 |
|Ubi-based image with F5 WAF for NGINX v5 | ``redhat/ubi9`` | F5 WAF for NGINX v5<br>NJS (NGINX JavaScript)<br>OpenTelemetry | `nginx-ic-nap-v5/nginx-plus-ingress:{{< nic-version >}}-ubi` | amd64 |
|Ubi-based image with F5 DoS for NGINX | ``redhat/ubi8`` | F5 DoS for NGINX<br>NJS (NGINX JavaScript)<br>OpenTelemetry | `nginx-ic-dos/nginx-plus-ingress:{{< nic-version >}}-ubi` | amd64 |
|Ubi-based image with F5 WAF for NGINX and DoS | ``redhat/ubi8`` | F5 WAF for NGINX and DoS<br>NJS (NGINX JavaScript)<br>OpenTelemetry | `nginx-ic-nap-dos/nginx-plus-ingress:{{< nic-version >}}-ubi` | amd64 |

{{< /table >}}

### Custom images

You can customize an existing Dockerfile or use it as a reference to create a new one, which is necessary when:

- Choosing a different base image.
- Installing additional NGINX modules.

## Supported Helm versions

NGINX Ingress Controller can be [installed]({{< ref "/nic/install/helm.md" >}}) using Helm 3.0 or later.

## Supported F5 WAF for NGINX versions

{{< call-out "warning" >}}F5 WAF for NGINX package based installation (previously NGINX App Protect WAF v4) is not supported when `readOnlyRootFilesystem` is enabled.{{< /call-out >}}

{{< include "/nic/compatibility-tables/nic-nap.md" >}}
