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


## 5.4.0

20 Mar 2026

### {{% icon rocket %}} Features
- [8656](https://github.com/nginx/kubernetes-ingress/pull/8656) Add nginx.org/ssl-redirect annotation support
- [8711](https://github.com/nginx/kubernetes-ingress/pull/8711) Add nginx.org/http-redirect-code annotation and configmap support
- [8720](https://github.com/nginx/kubernetes-ingress/pull/8720) Add `nginx.org/app-root` annotation support
- [8861](https://github.com/nginx/kubernetes-ingress/pull/8861) Initialise the $service variable early in the server block
- [8168](https://github.com/nginx/kubernetes-ingress/pull/8168) Add custom time format to json and text logging
- [8936](https://github.com/nginx/kubernetes-ingress/pull/8936) Add routeselector labels to virtualserver and virtualserverroutes
- [8972](https://github.com/nginx/kubernetes-ingress/pull/8972) Add `proxy-next-upstream` directives to ingress annotations
- [8555](https://github.com/nginx/kubernetes-ingress/pull/8555) Support loadbalancerclass in helm chart
- [9209](https://github.com/nginx/kubernetes-ingress/pull/9209) Add framework to attach policy cr&#39;s to ingress with annotations
- [9148](https://github.com/nginx/kubernetes-ingress/pull/9148) Add CORS policy to VirtualServer/VirtualServerRoute
- [9280](https://github.com/nginx/kubernetes-ingress/pull/9280) Add AccessControl to ingress via policy
- [9292](https://github.com/nginx/kubernetes-ingress/pull/9292) Add CORS to ingress via policy
- [9260](https://github.com/nginx/kubernetes-ingress/pull/9260) Automate community pr pipeline run
- [9316](https://github.com/nginx/kubernetes-ingress/pull/9316) Enable session persistence for nginx oss config
- [9288](https://github.com/nginx/kubernetes-ingress/pull/9288) Config rollback manager

### {{% icon bug %}} Fixes
- [8689](https://github.com/nginx/kubernetes-ingress/pull/8689) Update stub_status client path
- [8722](https://github.com/nginx/kubernetes-ingress/pull/8722) Update service template for ipfamilies
- [8740](https://github.com/nginx/kubernetes-ingress/pull/8740) Add more validation on rewrite-target
- [8831](https://github.com/nginx/kubernetes-ingress/pull/8831) Implement zone size templates in configmap for oidc templates
- [8869](https://github.com/nginx/kubernetes-ingress/pull/8869) Refactor getvalidtarget to return a list of items
- [8949](https://github.com/nginx/kubernetes-ingress/pull/8949) Fix agent otel metrics failing to start
- [9172](https://github.com/nginx/kubernetes-ingress/pull/9172) Fix load command
- [9140](https://github.com/nginx/kubernetes-ingress/pull/9140) Invalid vs with oidc policy applied at vs spec with trusted cert
- [9213](https://github.com/nginx/kubernetes-ingress/pull/9213) Fix `unexpected ";"` using zone-sync in the configmap while disabling ipv6
- [9315](https://github.com/nginx/kubernetes-ingress/pull/9315) Update openid_connect.js

### {{% icon arrow-up %}} Dependencies
- [9218](https://github.com/nginx/kubernetes-ingress/pull/9218) & [9404](https://github.com/nginx/kubernetes-ingress/pull/9404) Bump Go dependencies
-  Bump Docker dependencies
- [9350](https://github.com/nginx/kubernetes-ingress/pull/9350) Update aws-sdk-go-v2 monorepo (main)
- [9349](https://github.com/nginx/kubernetes-ingress/pull/9349) Update nginx:1.29.6-alpine3.23 docker digest to f46cb72 (main)
- [9345](https://github.com/nginx/kubernetes-ingress/pull/9345) Update docker image digests for nginx and python dependencies
- [9344](https://github.com/nginx/kubernetes-ingress/pull/9344) Update golang.org/x/crypto to v0.49.0 & golang.org/x/tools to v0.42.0
- [9301](https://github.com/nginx/kubernetes-ingress/pull/9301) Update golang:1.26-alpine docker digest to 2389ebf (main)
- [9240](https://github.com/nginx/kubernetes-ingress/pull/9240) Update aws-sdk-go-v2 monorepo (main)
- [9277](https://github.com/nginx/kubernetes-ingress/pull/9223, https://github.com/nginx/kubernetes-ingress/pull/9277) Update pre-commit hook pycqa/isort to v8.0.1 (main)
- [9222](https://github.com/nginx/kubernetes-ingress/pull/9222) Update pre-commit hook pycqa/autoflake to v2.3.3 (main)
- [9176](https://github.com/nginx/kubernetes-ingress/pull/9176) Update go to v1.26
- [9159](https://github.com/nginx/kubernetes-ingress/pull/9159) Update dependency dominikh/go-tools to v2026 (main)
- [9115](https://github.com/nginx/kubernetes-ingress/pull/9115) Loosen f5 waf package versions to allow patch releases
- [9103](https://github.com/nginx/kubernetes-ingress/pull/9103) Update nginx:1.29.5-alpine3.23 docker digest to 1d13701 (main)
- [9243](https://github.com/nginx/kubernetes-ingress/pull/9094, https://github.com/nginx/kubernetes-ingress/pull/9243) Update nginx:1.29.5 docker digest to 0236ee0 (main)
- [9059](https://github.com/nginx/kubernetes-ingress/pull/9059) Update nginx agent to 3.7
- [8877](https://github.com/nginx/kubernetes-ingress/pull/8877) Update c-ares package to 1.19.1-2
- [9002](https://github.com/nginx/kubernetes-ingress/pull/9002) Update alpine:3.22 docker digest to 55ae5d2 (main)
- [9005](https://github.com/nginx/kubernetes-ingress/pull/9005) Update module github.com/golang-jwt/jwt/v5 to v5.3.1 (main)
- [9111](https://github.com/nginx/kubernetes-ingress/pull/8963, https://github.com/nginx/kubernetes-ingress/pull/9111) Update module golang.org/x/crypto to v0.48.0 (main)
- [9303](https://github.com/nginx/kubernetes-ingress/pull/8961, https://github.com/nginx/kubernetes-ingress/pull/9079, https://github.com/nginx/kubernetes-ingress/pull/9303) Update golang docker tag to v1.26.1 (main)
- [8951](https://github.com/nginx/kubernetes-ingress/pull/8951) Update module github.com/aws/aws-sdk-go-v2/service/marketplacemetering to v1.35.6 (main)
- [9294](https://github.com/nginx/kubernetes-ingress/pull/8952, https://github.com/nginx/kubernetes-ingress/pull/9294) Update docker/dockerfile docker tag to v1.22 (main)
- [9095](https://github.com/nginx/kubernetes-ingress/pull/8904, https://github.com/nginx/kubernetes-ingress/pull/9095) Update module sigs.k8s.io/structured-merge-diff/v6 to v6.3.2 (main)
- [9158](https://github.com/nginx/kubernetes-ingress/pull/8883, https://github.com/nginx/kubernetes-ingress/pull/9158) Update module github.com/gruntwork-io/terratest to v0.56.0 (main)
- [9157](https://github.com/nginx/kubernetes-ingress/pull/8764, https://github.com/nginx/kubernetes-ingress/pull/9157) Update module sigs.k8s.io/controller-tools to v0.20.1 (main)
- [8834](https://github.com/nginx/kubernetes-ingress/pull/8834) Bump the pip group across 2 directories with 1 update
- [9298](https://github.com/nginx/kubernetes-ingress/pull/8882, https://github.com/nginx/kubernetes-ingress/pull/8962, https://github.com/nginx/kubernetes-ingress/pull/9124, https://github.com/nginx/kubernetes-ingress/pull/9231, https://github.com/nginx/kubernetes-ingress/pull/9298) Update quay.io/keycloak/keycloak docker tag to v26.5.5 (main)
- [8850](https://github.com/nginx/kubernetes-ingress/pull/8850) Update aws-sdk-go-v2 monorepo (main)
- [8821](https://github.com/nginx/kubernetes-ingress/pull/8821) Update quay.io/keycloak/keycloak docker tag (main)
- [9121](https://github.com/nginx/kubernetes-ingress/pull/8761, https://github.com/nginx/kubernetes-ingress/pull/8840, https://github.com/nginx/kubernetes-ingress/pull/9121) Update k8s.io/utils digest to b8788ab (main)
- [9166](https://github.com/nginx/kubernetes-ingress/pull/8797, https://github.com/nginx/kubernetes-ingress/pull/9166) Update pre-commit hook rhysd/actionlint to v1.7.11 (main)
- [9043](https://github.com/nginx/kubernetes-ingress/pull/8792, https://github.com/nginx/kubernetes-ingress/pull/8795, https://github.com/nginx/kubernetes-ingress/pull/8848, https://github.com/nginx/kubernetes-ingress/pull/8871, https://github.com/nginx/kubernetes-ingress/pull/9043) Update nginx:1.29.4 docker digest to c881927 (main)
- [8881](https://github.com/nginx/kubernetes-ingress/pull/8762, https://github.com/nginx/kubernetes-ingress/pull/8849, https://github.com/nginx/kubernetes-ingress/pull/8881) Update nginx:1.29.4-alpine3.23 docker digest to b0f7830 (main)
- [8748](https://github.com/nginx/kubernetes-ingress/pull/8748) Update ghcr.io/nginx/alpine-fips docker tag to v0.5.0 (main)
- [9142](https://github.com/nginx/kubernetes-ingress/pull/8763, https://github.com/nginx/kubernetes-ingress/pull/8920, https://github.com/nginx/kubernetes-ingress/pull/8974, https://github.com/nginx/kubernetes-ingress/pull/9023, https://github.com/nginx/kubernetes-ingress/pull/9063, https://github.com/nginx/kubernetes-ingress/pull/9110, https://github.com/nginx/kubernetes-ingress/pull/9142) Update redhat/ubi8 docker digest to a287489 (main)
- [9221](https://github.com/nginx/kubernetes-ingress/pull/8747, https://github.com/nginx/kubernetes-ingress/pull/9194, https://github.com/nginx/kubernetes-ingress/pull/9221) Update module github.com/aws/aws-sdk-go-v2/config to v1.32.9 (main)
- [9269](https://github.com/nginx/kubernetes-ingress/pull/8726, https://github.com/nginx/kubernetes-ingress/pull/8975, https://github.com/nginx/kubernetes-ingress/pull/9179, https://github.com/nginx/kubernetes-ingress/pull/9269) Update pre-commit hook python-jsonschema/check-jsonschema to v0.37.0 (main)
- [9365](https://github.com/nginx/kubernetes-ingress/pull/8657, https://github.com/nginx/kubernetes-ingress/pull/8794, https://github.com/nginx/kubernetes-ingress/pull/8870, https://github.com/nginx/kubernetes-ingress/pull/9041, https://github.com/nginx/kubernetes-ingress/pull/9242, https://github.com/nginx/kubernetes-ingress/pull/9365) Update debian:12-slim docker digest to f065376 (main)
- [9169](https://github.com/nginx/kubernetes-ingress/pull/8646, https://github.com/nginx/kubernetes-ingress/pull/9169) Update pre-commit hook davidanson/markdownlint-cli2 to v0.21.0 (main)
- [9305](https://github.com/nginx/kubernetes-ingress/pull/8660, https://github.com/nginx/kubernetes-ingress/pull/9029, https://github.com/nginx/kubernetes-ingress/pull/9284, https://github.com/nginx/kubernetes-ingress/pull/9305) Update opentelemetry-go monorepo to v1.42.0 (main)
- [9112](https://github.com/nginx/kubernetes-ingress/pull/8659, https://github.com/nginx/kubernetes-ingress/pull/8862, https://github.com/nginx/kubernetes-ingress/pull/9112) Update module golang.org/x/tools to v0.42.0 (main)
- [8658](https://github.com/nginx/kubernetes-ingress/pull/8658) Update nginx:1.29.3 docker digest to 2f4e101 (main)
- [9311](https://github.com/nginx/kubernetes-ingress/pull/8661, https://github.com/nginx/kubernetes-ingress/pull/8910, https://github.com/nginx/kubernetes-ingress/pull/9311) Update pre-commit hook psf/black-pre-commit-mirror to v26.3.0 (main)
- [9318](https://github.com/nginx/kubernetes-ingress/pull/8693, https://github.com/nginx/kubernetes-ingress/pull/8780, https://github.com/nginx/kubernetes-ingress/pull/8846, https://github.com/nginx/kubernetes-ingress/pull/8880, https://github.com/nginx/kubernetes-ingress/pull/8901, https://github.com/nginx/kubernetes-ingress/pull/8930, https://github.com/nginx/kubernetes-ingress/pull/8958, https://github.com/nginx/kubernetes-ingress/pull/8994, https://github.com/nginx/kubernetes-ingress/pull/9219, https://github.com/nginx/kubernetes-ingress/pull/9318) Update ghcr.io/nginx/dependencies/nginx-ubi:ubi8 docker digest to e4ac6f7 (main)
- [9193](https://github.com/nginx/kubernetes-ingress/pull/8716, https://github.com/nginx/kubernetes-ingress/pull/8749, https://github.com/nginx/kubernetes-ingress/pull/9156, https://github.com/nginx/kubernetes-ingress/pull/9193) Update kindest/node docker tag to v1.35.1 (main)
- [9039](https://github.com/nginx/kubernetes-ingress/pull/8673, https://github.com/nginx/kubernetes-ingress/pull/9039) Update module github.com/cert-manager/cert-manager to v1.19.3 [security] (main)
- [9323](https://github.com/nginx/kubernetes-ingress/pull/8626, https://github.com/nginx/kubernetes-ingress/pull/8922, https://github.com/nginx/kubernetes-ingress/pull/8977, https://github.com/nginx/kubernetes-ingress/pull/9081, https://github.com/nginx/kubernetes-ingress/pull/9196, https://github.com/nginx/kubernetes-ingress/pull/9323) Update redhat/ubi9-minimal docker tag to v9.7-1764794109 (main)
- [9304](https://github.com/nginx/kubernetes-ingress/pull/8628, https://github.com/nginx/kubernetes-ingress/pull/8832, https://github.com/nginx/kubernetes-ingress/pull/9127, https://github.com/nginx/kubernetes-ingress/pull/9198, https://github.com/nginx/kubernetes-ingress/pull/9304) Update golangci/golangci-lint docker tag to v2.11.3 (main)
- [9026](https://github.com/nginx/kubernetes-ingress/pull/8675, https://github.com/nginx/kubernetes-ingress/pull/9026) Update quay.io/jetstack/cert-manager-cainjector docker tag to v1.19.3 (main)
- [9312](https://github.com/nginx/kubernetes-ingress/pull/8697, https://github.com/nginx/kubernetes-ingress/pull/9312) Update quay.io/skopeo/stable docker tag to v1.22.0 (main)
- [9027](https://github.com/nginx/kubernetes-ingress/pull/8676, https://github.com/nginx/kubernetes-ingress/pull/9027) Update quay.io/jetstack/cert-manager-controller docker tag to v1.19.3 (main)
- [9302](https://github.com/nginx/kubernetes-ingress/pull/8695, https://github.com/nginx/kubernetes-ingress/pull/8842, https://github.com/nginx/kubernetes-ingress/pull/8902, https://github.com/nginx/kubernetes-ingress/pull/9302) Update coredns/coredns docker tag to v1.14.2 (main)
- [9267](https://github.com/nginx/kubernetes-ingress/pull/8696, https://github.com/nginx/kubernetes-ingress/pull/9122, https://github.com/nginx/kubernetes-ingress/pull/9267) Update kubernetes packages to v0.35.2 (main)
- [9028](https://github.com/nginx/kubernetes-ingress/pull/8677, https://github.com/nginx/kubernetes-ingress/pull/9028) Update quay.io/jetstack/cert-manager-webhook docker tag to v1.19.3 (main)
- [9336](https://github.com/nginx/kubernetes-ingress/pull/8694, https://github.com/nginx/kubernetes-ingress/pull/8781, https://github.com/nginx/kubernetes-ingress/pull/8790, https://github.com/nginx/kubernetes-ingress/pull/8847, https://github.com/nginx/kubernetes-ingress/pull/9042, https://github.com/nginx/kubernetes-ingress/pull/9092, https://github.com/nginx/kubernetes-ingress/pull/9120, https://github.com/nginx/kubernetes-ingress/pull/9149, https://github.com/nginx/kubernetes-ingress/pull/9178, https://github.com/nginx/kubernetes-ingress/pull/9220, https://github.com/nginx/kubernetes-ingress/pull/9319, https://github.com/nginx/kubernetes-ingress/pull/9336) Update ghcr.io/nginx/dependencies/nginx-ubi:ubi9 docker digest to 890fce2 (main)
- [9359](https://github.com/nginx/kubernetes-ingress/pull/8624, https://github.com/nginx/kubernetes-ingress/pull/8802, https://github.com/nginx/kubernetes-ingress/pull/9268, https://github.com/nginx/kubernetes-ingress/pull/9359) Update module github.com/gkampitakis/go-snaps to v0.5.21 (main)
- [8691](https://github.com/nginx/kubernetes-ingress/pull/8691) Update nginx agent to 3.6.0
- [8622](https://github.com/nginx/kubernetes-ingress/pull/8622) Update aws-sdk-go-v2 monorepo (main)
- [9322](https://github.com/nginx/kubernetes-ingress/pull/8625, https://github.com/nginx/kubernetes-ingress/pull/8782, https://github.com/nginx/kubernetes-ingress/pull/8819, https://github.com/nginx/kubernetes-ingress/pull/8921, https://github.com/nginx/kubernetes-ingress/pull/8976, https://github.com/nginx/kubernetes-ingress/pull/9195, https://github.com/nginx/kubernetes-ingress/pull/9322) Update redhat/ubi9 docker tag to v9.7-1764794285 (main)
- [9105](https://github.com/nginx/kubernetes-ingress/pull/8621, https://github.com/nginx/kubernetes-ingress/pull/8724, https://github.com/nginx/kubernetes-ingress/pull/8796, https://github.com/nginx/kubernetes-ingress/pull/8805, https://github.com/nginx/kubernetes-ingress/pull/8872, https://github.com/nginx/kubernetes-ingress/pull/8939, https://github.com/nginx/kubernetes-ingress/pull/9044, https://github.com/nginx/kubernetes-ingress/pull/9062, https://github.com/nginx/kubernetes-ingress/pull/9105) Update python:3.14-trixie docker digest to abc08a8 (main)
- [9297](https://github.com/nginx/kubernetes-ingress/pull/8613, https://github.com/nginx/kubernetes-ingress/pull/8891, https://github.com/nginx/kubernetes-ingress/pull/9065, https://github.com/nginx/kubernetes-ingress/pull/9297) Update dependency go to v1.26.1 (main)
- [9093](https://github.com/nginx/kubernetes-ingress/pull/8612, https://github.com/nginx/kubernetes-ingress/pull/8760, https://github.com/nginx/kubernetes-ingress/pull/8890, https://github.com/nginx/kubernetes-ingress/pull/8909, https://github.com/nginx/kubernetes-ingress/pull/9003, https://github.com/nginx/kubernetes-ingress/pull/9061, https://github.com/nginx/kubernetes-ingress/pull/9093) Update golang:1.25-alpine docker digest to e689855 (main)

### {{% icon download %}} Upgrade
- For NGINX, use the 5.4.0 images from our [DockerHub](https://hub.docker.com/r/nginx/nginx-ingress/tags?page=1&ordering=last_updated&name=5.4.0), [GitHub Container](https://github.com/nginx/kubernetes-ingress/pkgs/container/kubernetes-ingress), [Amazon ECR Public Gallery](https://gallery.ecr.aws/nginx/nginx-ingress) or [Quay.io](https://quay.io/repository/nginx/nginx-ingress).
- For NGINX Plus, use the 5.4.0 images from the F5 Container registry or build your own image using the 5.4.0 source code.
- For Helm, use version 2.5.0 of the chart.

### {{% icon life-buoy %}} Supported Platforms
We will provide technical support for NGINX Ingress Controller on any Kubernetes platform that is currently supported by its provider and that passes the Kubernetes conformance tests. This release was fully tested on the following Kubernetes versions: 1.28-1.35.

## 5.3.4

17 Feb 2026

### {{% icon arrow-up %}} Dependencies

- [9177](https://github.com/nginx/kubernetes-ingress/pull/9177) Update go to v1.26
-  [9131](https://github.com/nginx/kubernetes-ingress/pull/9131),[9163](https://github.com/nginx/kubernetes-ingress/pull/9163),[9162](https://github.com/nginx/kubernetes-ingress/pull/9162),[9164](https://github.com/nginx/kubernetes-ingress/pull/9164),[9114](https://github.com/nginx/kubernetes-ingress/pull/9114),[9099](https://github.com/nginx/kubernetes-ingress/pull/9099),[9104](https://github.com/nginx/kubernetes-ingress/pull/9104) & [9101](https://github.com/nginx/kubernetes-ingress/pull/9101) Bump Go dependencies
-  [9161](https://github.com/nginx/kubernetes-ingress/pull/9161),[9130](https://github.com/nginx/kubernetes-ingress/pull/9130),[9136](https://github.com/nginx/kubernetes-ingress/pull/9136),[9133](https://github.com/nginx/kubernetes-ingress/pull/9133),[9143](https://github.com/nginx/kubernetes-ingress/pull/9143), [9113](https://github.com/nginx/kubernetes-ingress/pull/9113),[9100](https://github.com/nginx/kubernetes-ingress/pull/9100), [9098](https://github.com/nginx/kubernetes-ingress/pull/9098), [9129](https://github.com/nginx/kubernetes-ingress/pull/9129), [9152](https://github.com/nginx/kubernetes-ingress/pull/9152), [9180](https://github.com/nginx/kubernetes-ingress/pull/9180),[9097](https://github.com/nginx/kubernetes-ingress/pull/9097), [9128](https://github.com/nginx/kubernetes-ingress/pull/9128) & [9151](https://github.com/nginx/kubernetes-ingress/pull/9151) Bump Docker dependencies

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
