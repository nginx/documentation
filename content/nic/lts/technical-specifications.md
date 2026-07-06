---
title: Technical specifications
toc: true
weight: 200
f5-content-type: reference
f5-product: NGINX Ingress Controller
---

This page describes technical specifications for F5 NGINX Ingress Controller LTS, such as its version compatibility with Kubernetes and other NGINX software.

## Supported NGINX Ingress Controller LTS versions

NGINX Ingress Controller LTS is a feature-frozen release supported for 36 months from the date of release. Security patches and stability bug fixes are delivered as patch revisions throughout the support period.

We test NGINX Ingress Controller LTS on a range of Kubernetes platforms for each release, and list them in the [Changelog]({{< ref "/nic/lts/changelog" >}}).

We provide technical support for NGINX Ingress Controller LTS on any Kubernetes platform that is currently supported by its provider, and that passes the [Kubernetes conformance tests](https://www.cncf.io/certification/software-conformance/).

We provide technical support for F5 customers using NGINX Ingress Controller LTS for 36 months from the date of release.

{{< include "/nic/compatibility-tables/nic-lts-k8s.md" >}}

## Supported Docker images

We provide the following Docker images, which include NGINX Plus bundled with the Ingress Controller binary.

### Images with NGINX Plus for LTS 2026 

NGINX Ingress Controller LTS image include NGINX Plus LTS R37.0

{{< table >}}

| Name | Base image | <div style="width:200px">Additional modules</div> | F5 Container Registry Image | Architectures | Based on CR |
| ---| ---| --- | --- | --- | --- |
|Debian-based image | ``debian:13-slim`` | NJS (NGINX JavaScript)<br>OpenTelemetry<br>Agent (NGINX Agent 3) | ``private-registry.nginx.com/nginx-ic/lts/nginx-plus-ingress:{{< nic-lts-version >}} `` | arm64<br>amd64 | 5.4.3 |

{{< /table >}}
