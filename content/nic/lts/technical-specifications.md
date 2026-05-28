---
title: Technical specifications
toc: true
weight: 200
f5-content-type: reference
f5-product: INGRESS
---

This page describes technical specifications for F5 NGINX Ingress Controller LTS, such as its version compatibility with Kubernetes and other NGINX software.

## Supported NGINX Ingress Controller LTS versions

NGINX Ingress Controller LTS is a feature-frozen release supported for 36 months from the date of release. Security patches and critical bug fixes are delivered as patch revisions throughout the support period.

We test NGINX Ingress Controller LTS on a range of Kubernetes platforms for each release, and list them in the [Changelog]({{< ref "/nic/lts/changelog" >}}).

We provide technical support for NGINX Ingress Controller LTS on any Kubernetes platform that is currently supported by its provider, and that passes the [Kubernetes conformance tests](https://www.cncf.io/certification/software-conformance/).

We provide technical support for F5 customers using NGINX Ingress Controller LTS for 36 months from the date of release.

{{< include "/nic/compatibility-tables/nic-k8s.md" >}}

## Supported Docker images

We provide the following Docker images, which include NGINX Plus bundled with the Ingress Controller binary.

### Images with NGINX Plus

NGINX Plus images include NGINX Plus R37.0.1.1.

#### F5 Container registry

NGINX Plus images are available through the F5 Container registry `private-registry.nginx.com`, explained in the [Download NGINX Ingress Controller LTS from the F5 Registry]({{< ref "/nic/lts/install/images/registry-download.md" >}}) and [Add an NGINX Ingress Controller LTS image to your cluster]({{< ref "/nic/lts/install/images/add-image-to-cluster.md" >}}) topics.

The LTS image is a single artifact supporting AMD64 and ARM64 architectures. The base operating system is an implementation detail and is not exposed as part of the LTS release identity.

{{< table >}}

| Name | <div style="width:200px">Additional modules</div> | F5 Container Registry Image | Architectures |
| ---| --- | --- | --- |
| NGINX Plus LTS image | NJS (NGINX JavaScript)<br>OpenTelemetry | `nginx-ic/nginx-plus-ingress:2026-lts-r1` | arm64<br>amd64 |
| NGINX Plus LTS image with F5 WAF for NGINX v5 | F5 WAF for NGINX v5<br>NJS (NGINX JavaScript)<br>OpenTelemetry | `nginx-ic-nap-v5/nginx-plus-ingress:2026-lts-r1` | amd64 |
| NGINX Plus LTS image with F5 DoS for NGINX | F5 DoS for NGINX<br>NJS (NGINX JavaScript)<br>OpenTelemetry | `nginx-ic-dos/nginx-plus-ingress:2026-lts-r1` | amd64 |
| NGINX Plus LTS image with F5 WAF for NGINX v5 and DoS | F5 WAF for NGINX v5 and DoS<br>NJS (NGINX JavaScript)<br>OpenTelemetry | `nginx-ic-nap-dos/nginx-plus-ingress:2026-lts-r1` | amd64 |

{{< /table >}}

#### LTS image bill of materials

| Component | Version |
|---|---|
| LTS image tag | `2026-lts-r1` |
| NGINX Plus | R37.0.1.1 |
| NGINX Agent | v3 |
| End of Technical Support | 36 months from release date |

### Custom images

{{< call-out "note" >}} Custom images are not covered by the LTS support lifecycle. F5 technical support applies only to the official LTS images listed above. {{< /call-out >}}

You can customize an existing Dockerfile or use it as a reference to create a new one, which is necessary when:

- Choosing a different base image.
- Installing additional NGINX modules.

## Supported Helm versions

NGINX Ingress Controller LTS can be [installed]({{< ref "/nic/lts/install/helm/" >}}) using Helm 3.0 or later.

## Supported F5 WAF for NGINX versions

{{< call-out "warning" >}}F5 WAF for NGINX package based installation (previously NGINX App Protect WAF v4) is not supported when `readOnlyRootFilesystem` is enabled.{{< /call-out >}}

{{< include "/nic/compatibility-tables/nic-nap.md" >}}
