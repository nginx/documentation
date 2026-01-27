---
title: Changelog
url: /nginx-ingress-controller/changelog
weight: 10200
nd-landing-page: true
nd-content-type: reference
nd-product: INGRESS
nd-docs: DOCS-616
---

This changelog lists all of the information for F5 NGINX Ingress Controller releases in 2026.

For older releases, check the changelogs for previous years: [2025]({{< ref "/nic/changelog/2025.md" >}}), [2024]({{< ref "/nic/changelog/2024.md" >}}), [2023]({{< ref "/nic/changelog/2023.md" >}}), [2022]({{< ref "/nic/changelog/2022.md" >}}), [2021]({{< ref "/nic/changelog/2021.md" >}}), [2020]({{< ref "/nic/changelog/2020.md" >}}), [2019]({{< ref "/nic/changelog/2019.md" >}}).

{{< details summary="NGINX Ingress Controller compatibility matrix" open=false >}}

{{< include "/nic/compatibility-tables/nic-k8s.md" >}}

### Supported F5 WAF for NGINX versions

{{<call-out "note" "Note">}}To use F5 WAF for NGINX with NGINX Ingress Controller, you must have NGINX Plus.{{< /call-out >}}

{{< include "/nic/compatibility-tables/nic-nap.md" >}}

{{< /details >}}


## 5.3.2

27 Jan 2026

### {{% icon arrow-up %}} Dependencies
-  Bump Go dependencies
-  Bump Docker dependencies
- [8981](https://github.com/nginx/kubernetes-ingress/pull/8981) Update pre-commit hook python-jsonschema/check-jsonschema to v0.36.1 (release-5.3)
- [8954](https://github.com/nginx/kubernetes-ingress/pull/8954) Update module github.com/aws/aws-sdk-go-v2/service/marketplacemetering to v1.35.6 (release-5.3)
- [8955](https://github.com/nginx/kubernetes-ingress/pull/8955) Update docker/dockerfile docker tag to v1.21 (release-5.3)
- [8983](https://github.com/nginx/kubernetes-ingress/pull/8927, https://github.com/nginx/kubernetes-ingress/pull/8983) Update redhat/ubi9-minimal docker tag to v9.7-1768783948 (release-5.3)
- [8912](https://github.com/nginx/kubernetes-ingress/pull/8912) Update pre-commit hook psf/black-pre-commit-mirror to v26 (release-5.3)
- [8895](https://github.com/nginx/kubernetes-ingress/pull/8895) Update module sigs.k8s.io/structured-merge-diff/v6 to v6.3.1 (release-5.3)
- [8894](https://github.com/nginx/kubernetes-ingress/pull/8894) Update dependency go to v1.25.6 (release-5.3)
- [8886](https://github.com/nginx/kubernetes-ingress/pull/8886) Update module github.com/gruntwork-io/terratest to v0.55.0 (release-5.3)
- [8769](https://github.com/nginx/kubernetes-ingress/pull/8769) Update module sigs.k8s.io/controller-tools to v0.20.0 (release-5.3)
- [8833](https://github.com/nginx/kubernetes-ingress/pull/8833) Update golangci/golangci-lint docker tag to v2.8.0 (release-5.3)
- [8967](https://github.com/nginx/kubernetes-ingress/pull/8885, https://github.com/nginx/kubernetes-ingress/pull/8967) Update quay.io/keycloak/keycloak docker tag to v26.5.2 (release-5.3)
- [8879](https://github.com/nginx/kubernetes-ingress/pull/8879) Update nap to 511 on release branch
- [8875](https://github.com/nginx/kubernetes-ingress/pull/8875) Update waf to 5.11.0 on release 5.3
- [8855](https://github.com/nginx/kubernetes-ingress/pull/8855) Update aws-sdk-go-v2 monorepo (release-5.3)
- [8864](https://github.com/nginx/kubernetes-ingress/pull/8864) Update module golang.org/x/tools to v0.41.0 (release-5.3)
- [8865](https://github.com/nginx/kubernetes-ingress/pull/8865) Update app-protect-attack-signatures to 2026 versions
- [8906](https://github.com/nginx/kubernetes-ingress/pull/8845, https://github.com/nginx/kubernetes-ingress/pull/8906) Update coredns/coredns docker tag to v1.14.1 (release-5.3)
- [8839](https://github.com/nginx/kubernetes-ingress/pull/8839) Update app protect threat campaign version
- [8824](https://github.com/nginx/kubernetes-ingress/pull/8824) Update quay.io/keycloak/keycloak docker tag (release-5.3)
- [8804](https://github.com/nginx/kubernetes-ingress/pull/8804) Update module github.com/gkampitakis/go-snaps to v0.5.19 (release-5.3)
- [8884](https://github.com/nginx/kubernetes-ingress/pull/8798, https://github.com/nginx/kubernetes-ingress/pull/8863, https://github.com/nginx/kubernetes-ingress/pull/8884) Update debian:12-slim docker digest to 94c4d59 (release-5.3)
- [8943](https://github.com/nginx/kubernetes-ingress/pull/8799, https://github.com/nginx/kubernetes-ingress/pull/8806, https://github.com/nginx/kubernetes-ingress/pull/8873, https://github.com/nginx/kubernetes-ingress/pull/8943) Update python:3.14-trixie docker digest to d9ce54c (release-5.3)
- [8800](https://github.com/nginx/kubernetes-ingress/pull/8800) Update pre-commit hook rhysd/actionlint to v1.7.10 (release-5.3)
- [8853](https://github.com/nginx/kubernetes-ingress/pull/8793, https://github.com/nginx/kubernetes-ingress/pull/8853) Update nginx:1.29.4 docker digest to c881927 (release-5.3)
- [8964](https://github.com/nginx/kubernetes-ingress/pull/8784, https://github.com/nginx/kubernetes-ingress/pull/8851, https://github.com/nginx/kubernetes-ingress/pull/8905, https://github.com/nginx/kubernetes-ingress/pull/8931, https://github.com/nginx/kubernetes-ingress/pull/8964) Update ghcr.io/nginx/dependencies/nginx-ubi:ubi8 docker digest to 998262b (release-5.3)
- [8754](https://github.com/nginx/kubernetes-ingress/pull/8754) Update kindest/node docker tag to v1.35.0 (release-5.3)
- [8982](https://github.com/nginx/kubernetes-ingress/pull/8786, https://github.com/nginx/kubernetes-ingress/pull/8822, https://github.com/nginx/kubernetes-ingress/pull/8926, https://github.com/nginx/kubernetes-ingress/pull/8982) Update redhat/ubi9 docker tag to v9.7-1766364927 (release-5.3)
- [8852](https://github.com/nginx/kubernetes-ingress/pull/8785, https://github.com/nginx/kubernetes-ingress/pull/8791, https://github.com/nginx/kubernetes-ingress/pull/8852) Update ghcr.io/nginx/dependencies/nginx-ubi:ubi9 docker digest to 8352fd3 (release-5.3)
- [8753](https://github.com/nginx/kubernetes-ingress/pull/8753) Update ghcr.io/nginx/alpine-fips docker tag to v0.5.0 (release-5.3)
- [8911](https://github.com/nginx/kubernetes-ingress/pull/8765, https://github.com/nginx/kubernetes-ingress/pull/8893, https://github.com/nginx/kubernetes-ingress/pull/8911) Update golang:1.25-alpine docker digest to e689855 (release-5.3)
- [8843](https://github.com/nginx/kubernetes-ingress/pull/8766, https://github.com/nginx/kubernetes-ingress/pull/8778, https://github.com/nginx/kubernetes-ingress/pull/8843) Update k8s.io/utils digest to 914a6e7 (release-5.3)
- [8980](https://github.com/nginx/kubernetes-ingress/pull/8768, https://github.com/nginx/kubernetes-ingress/pull/8924, https://github.com/nginx/kubernetes-ingress/pull/8980) Update redhat/ubi8 docker digest to a7e3d45 (release-5.3)
- [8854](https://github.com/nginx/kubernetes-ingress/pull/8767, https://github.com/nginx/kubernetes-ingress/pull/8779, https://github.com/nginx/kubernetes-ingress/pull/8854) Update nginx:1.29.4-alpine3.23 docker digest to 8491795 (release-5.3)
- [8752](https://github.com/nginx/kubernetes-ingress/pull/8752) Update module github.com/aws/aws-sdk-go-v2/config to v1.32.6 (release-5.3)

### {{% icon download %}} Upgrade
- For NGINX, use the 5.3.2 images from our [DockerHub](https://hub.docker.com/r/nginx/nginx-ingress/tags?page=1&ordering=last_updated&name=5.3.2), [GitHub Container](https://github.com/nginx/kubernetes-ingress/pkgs/container/kubernetes-ingress), [Amazon ECR Public Gallery](https://gallery.ecr.aws/nginx/nginx-ingress) or [Quay.io](https://quay.io/repository/nginx/nginx-ingress).
- For NGINX Plus, use the 5.3.2 images from the F5 Container registry or build your own image using the 5.3.2 source code.
- For Helm, use version 2.4.2 of the chart.

### {{% icon life-buoy %}} Supported Platforms
We will provide technical support for NGINX Ingress Controller on any Kubernetes platform that is currently supported by its provider and that passes the Kubernetes conformance tests. This release was fully tested on the following Kubernetes versions: 1.27-1.35.
