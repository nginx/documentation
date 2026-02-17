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


## 5.3.4

17 Feb 2026

### {{% icon bug %}} Fixes
- [9175](https://github.com/nginx/kubernetes-ingress/pull/9175) Replace kind load command in ci tests

### {{% icon arrow-up %}} Dependencies
-  Bump Go dependencies
-  Bump Docker dependencies
- [9181](https://github.com/nginx/kubernetes-ingress/pull/9181) Update pre-commit hook python-jsonschema/check-jsonschema to v0.36.2 (release-5.3)
- [9131](https://github.com/nginx/kubernetes-ingress/pull/9131) Update kubernetes packages to v0.35.1 (release-5.3)
- [9163](https://github.com/nginx/kubernetes-ingress/pull/9163) Update module github.com/gruntwork-io/terratest to v0.56.0 (release-5.3)
- [9162](https://github.com/nginx/kubernetes-ingress/pull/9162) Update module sigs.k8s.io/controller-tools to v0.20.1 (release-5.3)
- [9177](https://github.com/nginx/kubernetes-ingress/pull/9177) Update go to v1.26
- [9161](https://github.com/nginx/kubernetes-ingress/pull/9161) Update kindest/node docker tag to v1.35.1 (release-5.3)
- [9168](https://github.com/nginx/kubernetes-ingress/pull/9168) Update pre-commit hook rhysd/actionlint to v1.7.11 (release-5.3)
- [9164](https://github.com/nginx/kubernetes-ingress/pull/9164) Update dependency dominikh/go-tools to v2026 (release-5.3)
- [9170](https://github.com/nginx/kubernetes-ingress/pull/9170) Update pre-commit hook davidanson/markdownlint-cli2 to v0.21.0 (release-5.3)
- [9130](https://github.com/nginx/kubernetes-ingress/pull/9130) Update k8s.io/utils digest to b8788ab (release-5.3)
- [9136](https://github.com/nginx/kubernetes-ingress/pull/9136) Update golangci/golangci-lint docker tag to v2.9.0 (release-5.3)
- [9133](https://github.com/nginx/kubernetes-ingress/pull/9133) Update quay.io/keycloak/keycloak docker tag to v26.5.3 (release-5.3)
- [9114](https://github.com/nginx/kubernetes-ingress/pull/9114) Update module golang.org/x/tools to v0.42.0 (release-5.3)
- [9143](https://github.com/nginx/kubernetes-ingress/pull/9113, https://github.com/nginx/kubernetes-ingress/pull/9143) Update redhat/ubi8 docker digest to a287489 (release-5.3)
- [9117](https://github.com/nginx/kubernetes-ingress/pull/9117) Loosen f5 waf package versions to allow patch releases
- [9180](https://github.com/nginx/kubernetes-ingress/pull/9098, https://github.com/nginx/kubernetes-ingress/pull/9129, https://github.com/nginx/kubernetes-ingress/pull/9152, https://github.com/nginx/kubernetes-ingress/pull/9180) Update ghcr.io/nginx/dependencies/nginx-ubi:ubi9 docker digest to e06094a (release-5.3)
- [9099](https://github.com/nginx/kubernetes-ingress/pull/9099) Update golang:1.25-alpine docker digest to f6751d8 (release-5.3)
- [9104](https://github.com/nginx/kubernetes-ingress/pull/9104) Update nginx:1.29.5-alpine3.23 docker digest to 1d13701 (release-5.3)
- [9151](https://github.com/nginx/kubernetes-ingress/pull/9097, https://github.com/nginx/kubernetes-ingress/pull/9128, https://github.com/nginx/kubernetes-ingress/pull/9151) Update ghcr.io/nginx/dependencies/nginx-ubi:ubi8 docker digest to 3754cfe (release-5.3)
- [9100](https://github.com/nginx/kubernetes-ingress/pull/9100) Update nginx:1.29.5 docker digest to 341bf0f (release-5.3)
- [9101](https://github.com/nginx/kubernetes-ingress/pull/9101) Update module sigs.k8s.io/structured-merge-diff/v6 to v6.3.2 (release-5.3)
- [9106](https://github.com/nginx/kubernetes-ingress/pull/9106) Update python:3.14-trixie docker digest to abc08a8 (release-5.3)

### {{% icon download %}} Upgrade
- For NGINX, use the 5.3.4 images from our [DockerHub](https://hub.docker.com/r/nginx/nginx-ingress/tags?page=1&ordering=last_updated&name=5.3.4), [GitHub Container](https://github.com/nginx/kubernetes-ingress/pkgs/container/kubernetes-ingress), [Amazon ECR Public Gallery](https://gallery.ecr.aws/nginx/nginx-ingress) or [Quay.io](https://quay.io/repository/nginx/nginx-ingress).
- For NGINX Plus, use the 5.3.4 images from the F5 Container registry or build your own image using the 5.3.4 source code.
- For Helm, use version 2.4.4 of the chart.

### {{% icon life-buoy %}} Supported Platforms
We will provide technical support for NGINX Ingress Controller on any Kubernetes platform that is currently supported by its provider and that passes the Kubernetes conformance tests. This release was fully tested on the following Kubernetes versions: 1.27-1.35.

## 5.3.3

06 Feb 2026

### {{% icon arrow-up %}} Dependencies

- [9049](https://github.com/nginx/kubernetes-ingress/pull/9049), [9074](https://github.com/nginx/kubernetes-ingress/pull/9074), [9050](https://github.com/nginx/kubernetes-ingress/pull/9050), [9047](https://github.com/nginx/kubernetes-ingress/pull/9047), [9035](https://github.com/nginx/kubernetes-ingress/pull/9035), [9031](https://github.com/nginx/kubernetes-ingress/pull/9031), [9071](https://github.com/nginx/kubernetes-ingress/pull/9071), [9036](https://github.com/nginx/kubernetes-ingress/pull/9036), [9034](https://github.com/nginx/kubernetes-ingress/pull/9034), [9006](https://github.com/nginx/kubernetes-ingress/pull/9006), [8997](https://github.com/nginx/kubernetes-ingress/pull/8997), [9030](https://github.com/nginx/kubernetes-ingress/pull/9030), [9048](https://github.com/nginx/kubernetes-ingress/pull/9048), [9068](https://github.com/nginx/kubernetes-ingress/pull/9068), [9007](https://github.com/nginx/kubernetes-ingress/pull/9007), [9069](https://github.com/nginx/kubernetes-ingress/pull/9069), [9008](https://github.com/nginx/kubernetes-ingress/pull/9008) & [9019](https://github.com/nginx/kubernetes-ingress/pull/9019) Bump Docker dependencies
- [9072](https://github.com/nginx/kubernetes-ingress/pull/9072), [9040](https://github.com/nginx/kubernetes-ingress/pull/9040), [9037](https://github.com/nginx/kubernetes-ingress/pull/9037) & [9009](https://github.com/nginx/kubernetes-ingress/pull/9009) Bump Go dependencies
- [9075](https://github.com/nginx/kubernetes-ingress/pull/9075) Update nginx versions 1.29.5 & R36 P2

### {{% icon download %}} Upgrade

- For NGINX, use the 5.3.3 images from our [DockerHub](https://hub.docker.com/r/nginx/nginx-ingress/tags?page=1&ordering=last_updated&name=5.3.3), [GitHub Container](https://github.com/nginx/kubernetes-ingress/pkgs/container/kubernetes-ingress), [Amazon ECR Public Gallery](https://gallery.ecr.aws/nginx/nginx-ingress) or [Quay.io](https://quay.io/repository/nginx/nginx-ingress).
- For NGINX Plus, use the 5.3.3 images from the F5 Container registry or build your own image using the 5.3.3 source code.
- For Helm, use version 2.4.3 of the chart.

### {{% icon life-buoy %}} Supported Platforms

We will provide technical support for NGINX Ingress Controller on any Kubernetes platform that is currently supported by its provider and that passes the Kubernetes conformance tests. This release was fully tested on the following Kubernetes versions: 1.27-1.35.

## 5.3.2

27 Jan 2026

### {{% icon arrow-up %}} Dependencies

- [8895](https://github.com/nginx/kubernetes-ingress/pull/8895), [8894](https://github.com/nginx/kubernetes-ingress/pull/8894), [8886](https://github.com/nginx/kubernetes-ingress/pull/8886), [8769](https://github.com/nginx/kubernetes-ingress/pull/8769), [8864](https://github.com/nginx/kubernetes-ingress/pull/8864), [8954](https://github.com/nginx/kubernetes-ingress/pull/8954), [8855](https://github.com/nginx/kubernetes-ingress/pull/8855), [8752](https://github.com/nginx/kubernetes-ingress/pull/8752), [8804](https://github.com/nginx/kubernetes-ingress/pull/8804), &amp; [8766](https://github.com/nginx/kubernetes-ingress/pull/8766) Bump Go dependencies
- [8955](https://github.com/nginx/kubernetes-ingress/pull/8955), [8833](https://github.com/nginx/kubernetes-ingress/pull/8833), [8885](https://github.com/nginx/kubernetes-ingress/pull/8885), [8967](https://github.com/nginx/kubernetes-ingress/pull/8967), [8824](https://github.com/nginx/kubernetes-ingress/pull/8824), [8845](https://github.com/nginx/kubernetes-ingress/pull/8845), [8906](https://github.com/nginx/kubernetes-ingress/pull/8906), [8754](https://github.com/nginx/kubernetes-ingress/pull/8754), [8753](https://github.com/nginx/kubernetes-ingress/pull/8753), [8765](https://github.com/nginx/kubernetes-ingress/pull/8765), [8893](https://github.com/nginx/kubernetes-ingress/pull/8893), [8911](https://github.com/nginx/kubernetes-ingress/pull/8911), [8778](https://github.com/nginx/kubernetes-ingress/pull/8778), [8843](https://github.com/nginx/kubernetes-ingress/pull/8843), [8927](https://github.com/nginx/kubernetes-ingress/pull/8927), [8983](https://github.com/nginx/kubernetes-ingress/pull/8983), [8786](https://github.com/nginx/kubernetes-ingress/pull/8786), [8822](https://github.com/nginx/kubernetes-ingress/pull/8822), [8926](https://github.com/nginx/kubernetes-ingress/pull/8926), [8982](https://github.com/nginx/kubernetes-ingress/pull/8982), [8768](https://github.com/nginx/kubernetes-ingress/pull/8768), [8924](https://github.com/nginx/kubernetes-ingress/pull/8924), [8980](https://github.com/nginx/kubernetes-ingress/pull/8980), [8798](https://github.com/nginx/kubernetes-ingress/pull/8798), [8863](https://github.com/nginx/kubernetes-ingress/pull/8863), [8884](https://github.com/nginx/kubernetes-ingress/pull/8884), [8799](https://github.com/nginx/kubernetes-ingress/pull/8799), [8806](https://github.com/nginx/kubernetes-ingress/pull/8806), [8873](https://github.com/nginx/kubernetes-ingress/pull/8873), [8943](https://github.com/nginx/kubernetes-ingress/pull/8943), [8793](https://github.com/nginx/kubernetes-ingress/pull/8793), [8853](https://github.com/nginx/kubernetes-ingress/pull/8853), [8784](https://github.com/nginx/kubernetes-ingress/pull/8784), [8851](https://github.com/nginx/kubernetes-ingress/pull/8851), [8905](https://github.com/nginx/kubernetes-ingress/pull/8905), [8931](https://github.com/nginx/kubernetes-ingress/pull/8931), [8964](https://github.com/nginx/kubernetes-ingress/pull/8964), [8785](https://github.com/nginx/kubernetes-ingress/pull/8785), [8791](https://github.com/nginx/kubernetes-ingress/pull/8791), [8852](https://github.com/nginx/kubernetes-ingress/pull/8852), [8767](https://github.com/nginx/kubernetes-ingress/pull/8767), [8779](https://github.com/nginx/kubernetes-ingress/pull/8779), &amp; [8854](https://github.com/nginx/kubernetes-ingress/pull/8854) Bump Docker dependencies
- [8879](https://github.com/nginx/kubernetes-ingress/pull/8879), [8875](https://github.com/nginx/kubernetes-ingress/pull/8875), [8865](https://github.com/nginx/kubernetes-ingress/pull/8865), &amp; [8839](https://github.com/nginx/kubernetes-ingress/pull/8839) Update F5 WAF components

### {{% icon download %}} Upgrade

- For NGINX, use the 5.3.2 images from our [DockerHub](https://hub.docker.com/r/nginx/nginx-ingress/tags?page=1&ordering=last_updated&name=5.3.2), [GitHub Container](https://github.com/nginx/kubernetes-ingress/pkgs/container/kubernetes-ingress), [Amazon ECR Public Gallery](https://gallery.ecr.aws/nginx/nginx-ingress) or [Quay.io](https://quay.io/repository/nginx/nginx-ingress).
- For NGINX Plus, use the 5.3.2 images from the F5 Container registry or build your own image using the 5.3.2 source code.
- For Helm, use version 2.4.2 of the chart.

### {{% icon life-buoy %}} Supported Platforms

We will provide technical support for NGINX Ingress Controller on any Kubernetes platform that is currently supported by its provider and that passes the Kubernetes conformance tests. This release was fully tested on the following Kubernetes versions: 1.27-1.35.
