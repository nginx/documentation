---
title: Technical specifications
toc: true
weight: 200
doctype: reference
product: NIC
nd-docs: DOCS-617
---

This page describes technical specifications for F5 NGINX Ingress Controller, such as its version compatibility with Kubernetes and other NGINX software.

## Supported NGINX Ingress Controller versions

We recommend using the latest release of NGINX Ingress Controller. We provide software updates for the most recent release. We provide technical support for F5 customers who are using the most recent version of NGINX Ingress Controller, and any version released within two years of the current release.
We test NGINX Ingress Controller on a range of Kubernetes platforms for each release, and list them in the [release notes]({{< ref "/nic/releases.md" >}}). We provide technical support for NGINX Ingress Controller on any Kubernetes platform that is currently supported by its provider, and that passes the [Kubernetes conformance tests](https://www.cncf.io/certification/software-conformance/).

{{< table >}}
| NIC version | Kubernetes versions tested  | NIC Helm Chart version | NIC Operator version | NGINX / NGINX Plus version | End of Technical Support |
| --- | --- | --- | --- | --- | --- |
| {{< nic-version >}} | 1.25 - 1.33 | {{< nic-helm-version >}} | {{< nic-operator-version >}} | 1.29.1 / R35 | - |
| 5.0.0 | 1.25 - 1.32 | 2.1.0 | 3.1.0 | 1.27.4 / R34 | Apr 16, 2027 |
| 4.0.1 | 1.25 - 1.32 | 2.0.1 | 3.0.1 | 1.27.4 / R33 P2 | Feb 7, 2027 |
| 3.7.2 | 1.25 - 1.31 | 1.4.2 | 2.4.2 | 1.27.2 / R32 P1 | Nov 25, 2026 |
| 3.6.2 | 1.25 - 1.31 | 1.3.2 | 2.3.2 | 1.27.1 / R32 P1 | Aug 19, 2026 |
| 3.5.2 | 1.23 - 1.30 | 1.2.2 | 2.2.2 | 1.27.0 / R32 | May 31, 2026 |
| 3.4.3 | 1.23 - 1.29 | 1.1.3 | 2.1.2 | 1.25.4 / R31 P1 | Feb 19, 2026 |
| 3.3.2 | 1.22 - 1.28 | 1.0.2 | 2.0.2 | 1.25.3 / R30 | Nov 1, 2025 |
| 3.2.1 | 1.22 - 1.27 | 0.18.1 | 1.5.1 | 1.25.2 / R30 | Aug 18, 2025 |
{{< /table >}}

## Supported Docker images

We provide the following Docker images, which include NGINX or NGINX Plus bundled with the Ingress Controller binary.

### Images with NGINX

{{< call-out "important" >}}
From release `v5.1.0` onwards, NGINX Ingress Controller will no longer provide binaries for the `armv7`, `s390x` & `ppc64le` architectures.
{{< /call-out >}}

_All images include NGINX 1.29.1._

|<div style="width:200px">Name</div> | <div style="width:100px">Base image</div> | DockerHub image | Architectures |
| ---| --- | --- | --- |
|Alpine-based image | ``nginx:1.29.1-alpine``,<br>based on on ``alpine:3.22`` | ``nginx/nginx-ingress:{{< nic-version >}}-alpine`` | arm64<br>amd64 |
|Debian-based image | ``nginx:1.29.1``,<br>based on on ``debian:12-slim`` | ``nginx/nginx-ingress:{{< nic-version >}}`` | arm64<br>amd64 |
|Ubi-based image | ``redhat/ubi9-minimal`` | ``nginx/nginx-ingress:{{< nic-version >}}-ubi`` | arm64<br>amd64 |

---

### Images with NGINX Plus

_NGINX Plus images include NGINX Plus R35_

---

#### **F5 Container registry**

NGINX Plus images are available through the F5 Container registry `private-registry.nginx.com`, explained in the [Download NGINX Ingress Controller from the F5 Registry]({{< ref "/nic/installation/nic-images/registry-download.md" >}}) and [Add an NGINX Ingress Controller image to your cluster]({{< ref "/nic/installation/nic-images/add-image-to-cluster.md" >}}) topics.

{{< table >}}
|<div style="width:200px">Name</div> | <div style="width:100px">Base image</div> | <div style="width:200px">Additional modules</div> | F5 Container Registry Image | Architectures |
| ---| ---| --- | --- | --- |
|Alpine-based image | ``alpine:3.22`` | NJS (NGINX JavaScript)<br>OpenTelemetry  | `nginx-ic/nginx-plus-ingress:{{< nic-version >}}-alpine` | arm64<br>amd64 |
|Alpine-based image with FIPS inside | ``alpine:3.22`` | NJS (NGINX JavaScript)<br>OpenTelemetry<br>FIPS module and OpenSSL configuration | `nginx-ic/nginx-plus-ingress:{{< nic-version >}}-alpine-fips` | arm64<br>amd64 |
|Alpine-based image with NGINX App Protect WAF & FIPS inside | ``alpine:3.19`` | NGINX App Protect WAF<br>NJS (NGINX JavaScript)<br>OpenTelemetry<br>FIPS module and OpenSSL configuration | `nginx-ic-nap/nginx-plus-ingress:{{< nic-version >}}-alpine-fips` | amd64 |
|Alpine-based image with NGINX App Protect WAF v5 & FIPS inside | ``alpine:3.19`` | NGINX App Protect WAF v5<br>NJS (NGINX JavaScript)<br>OpenTelemetry<br>FIPS module and OpenSSL configuration | `nginx-ic-nap-v5/nginx-plus-ingress:{{< nic-version >}}-alpine-fips` | amd64 |
|Debian-based image | ``debian:12-slim`` | NJS (NGINX JavaScript)<br>OpenTelemetry | `nginx-ic/nginx-plus-ingress:{{< nic-version >}}` | arm64<br>amd64 |
|Debian-based image with NGINX App Protect WAF | ``debian:12-slim`` | NGINX App Protect WAF<br>NJS (NGINX JavaScript)<br>OpenTelemetry | `nginx-ic-nap/nginx-plus-ingress:{{< nic-version >}}` | amd64 |
|Debian-based image with NGINX App Protect WAF v5 | ``debian:12-slim`` | NGINX App Protect WAF v5<br>NJS (NGINX JavaScript)<br>OpenTelemetry | `nginx-ic-nap-v5/nginx-plus-ingress:{{< nic-version >}}` | amd64 |
|Debian-based image with NGINX App Protect DoS | ``debian:12-slim`` | NGINX App Protect DoS<br>NJS (NGINX JavaScript)<br>OpenTelemetry | `nginx-ic-dos/nginx-plus-ingress:{{< nic-version >}}` | amd64 |
|Debian-based image with NGINX App Protect WAF and DoS | ``debian:12-slim`` | NGINX App Protect WAF and DoS<br>NJS (NGINX JavaScript)<br>OpenTelemetry | `nginx-ic-nap-dos/nginx-plus-ingress:{{< nic-version >}}` | amd64 |
|Ubi-based image | ``redhat/ubi9-minimal`` | NJS (NGINX JavaScript)<br>OpenTelemetry | `nginx-ic/nginx-plus-ingress:{{< nic-version >}}-ubi` | arm64<br>amd64 |
|Ubi-based image with NGINX App Protect WAF | ``redhat/ubi9`` | NGINX App Protect WAF<br>NJS (NGINX JavaScript)<br>OpenTelemetry | `nginx-ic-nap/nginx-plus-ingress:{{< nic-version >}}-ubi` | amd64 |
|Ubi-based image with NGINX App Protect WAF v5 | ``redhat/ubi9`` | NGINX App Protect WAF v5<br>NJS (NGINX JavaScript)<br>OpenTelemetry | `nginx-ic-nap-v5/nginx-plus-ingress:{{< nic-version >}}-ubi` | amd64 |
|Ubi-based image with NGINX App Protect DoS | ``redhat/ubi8`` | NGINX App Protect DoS<br>NJS (NGINX JavaScript)<br>OpenTelemetry | `nginx-ic-dos/nginx-plus-ingress:{{< nic-version >}}-ubi` | amd64 |
|Ubi-based image with NGINX App Protect WAF and DoS | ``redhat/ubi8`` | NGINX App Protect WAF and DoS<br>NJS (NGINX JavaScript)<br>OpenTelemetry | `nginx-ic-nap-dos/nginx-plus-ingress:{{< nic-version >}}-ubi` | amd64 |
{{< /table >}}

### Custom images

You can customize an existing Dockerfile or use it as a reference to create a new one, which is necessary when:

- Choosing a different base image.
- Installing additional NGINX modules.

## Supported Helm versions

NGINX Ingress Controller can be [installed]({{< ref "/nic/installation/installing-nic/installation-with-helm.md" >}}) using Helm 3.0 or later.
