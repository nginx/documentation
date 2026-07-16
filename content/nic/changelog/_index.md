---
title: Changelog
url: /nginx-ingress-controller/changelog
weight: 10200
f5-landing-page: true
f5-content-type: reference
f5-product: NGINX Ingress Controller
f5-docs: DOCS-616
cascade:
  nollms: true
---

This changelog lists all of the information for F5 NGINX Ingress Controller releases in 2026.

For older releases, check the changelogs for previous years: [2025]({{< ref "/nic/changelog/2025.md" >}}), [2024]({{< ref "/nic/changelog/2024.md" >}}), [2023]({{< ref "/nic/changelog/2023.md" >}}), [2022]({{< ref "/nic/changelog/2022.md" >}}), [2021]({{< ref "/nic/changelog/2021.md" >}}), [2020]({{< ref "/nic/changelog/2020.md" >}}), [2019]({{< ref "/nic/changelog/2019.md" >}}).

{{< details summary="NGINX Ingress Controller compatibility matrix" open=false >}}

{{< include "/nic/compatibility-tables/nic-k8s.md" >}}

### Supported F5 WAF for NGINX versions

{{<call-out class="note" title="Note">}}To use F5 WAF for NGINX with NGINX Ingress Controller, you must have NGINX Plus.{{< /call-out >}}

{{< include "/nic/compatibility-tables/nic-nap.md" >}}

{{< /details >}}

## 5.5.4

16 Jul 2026

### {{% icon arrow-up %}} Dependencies

- [10471](https://github.com/nginx/kubernetes-ingress/pull/10471) Update F5 WAF for NGINX to 5.13.4
- [10440](https://github.com/nginx/kubernetes-ingress/pull/10440) Bump Go dependencies
- [10426](https://github.com/nginx/kubernetes-ingress/pull/10426), [10450](https://github.com/nginx/kubernetes-ingress/pull/10450), [10449](https://github.com/nginx/kubernetes-ingress/pull/10449), [10451](https://github.com/nginx/kubernetes-ingress/pull/10451) & [10448](https://github.com/nginx/kubernetes-ingress/pull/10448) Bump Docker dependencies

### {{% icon download %}} Update

- For NGINX, use the 5.5.4 images from [DockerHub](https://hub.docker.com/r/nginx/nginx-ingress/tags?page=1&ordering=last_updated&name=5.5.4), [GitHub Container](https://github.com/nginx/kubernetes-ingress/pkgs/container/kubernetes-ingress), [Amazon ECR Public Gallery](https://gallery.ecr.aws/nginx/nginx-ingress) or [Quay.io](https://quay.io/repository/nginx/nginx-ingress).
- For NGINX Plus, use the 5.5.4 images from the F5 Container registry or build your own image from the 5.5.4 source code.
- For Helm, use version 2.6.4 of the chart.

### {{% icon life-buoy %}} Supported platforms

We provide technical support for NGINX Ingress Controller on any Kubernetes platform that is currently supported by its provider and that passes the Kubernetes conformance tests. This release was fully tested on the following Kubernetes versions: 1.29 - 1.36.

## 5.5.3

15 Jul 2026

### {{% icon arrow-up %}} Dependencies

- Bump NGINX Plus to 37.0.3.1
- [10467](https://github.com/nginx/kubernetes-ingress/pull/10467) Bump NGINX OSS to 1.31.3

### {{% icon download %}} Update

- For NGINX, use the 5.5.3 images from [DockerHub](https://hub.docker.com/r/nginx/nginx-ingress/tags?page=1&ordering=last_updated&name=5.5.3), [GitHub Container](https://github.com/nginx/kubernetes-ingress/pkgs/container/kubernetes-ingress), [Amazon ECR Public Gallery](https://gallery.ecr.aws/nginx/nginx-ingress) or [Quay.io](https://quay.io/repository/nginx/nginx-ingress).
- For NGINX Plus, use the 5.5.3 images from the F5 Container registry or build your own image from the 5.5.3 source code.
- For Helm, use version 2.6.3 of the chart.

### {{% icon life-buoy %}} Supported platforms

We provide technical support for NGINX Ingress Controller on any Kubernetes platform that is currently supported by its provider and that passes the Kubernetes conformance tests. This release was fully tested on the following Kubernetes versions: 1.29 - 1.36.

## 5.5.2

15 Jul 2026

### {{% icon bug %}} Fixes

- [10323](https://github.com/nginx/kubernetes-ingress/pull/10323) Fix external auth attachment to multiple ingresses

### {{% icon arrow-up %}} Dependencies

- [10221](https://github.com/nginx/kubernetes-ingress/pull/10221), [10237](https://github.com/nginx/kubernetes-ingress/pull/10237), [10292](https://github.com/nginx/kubernetes-ingress/pull/10292), [10305](https://github.com/nginx/kubernetes-ingress/pull/10305), [10291](https://github.com/nginx/kubernetes-ingress/pull/10291), [10313](https://github.com/nginx/kubernetes-ingress/pull/10313), [10331](https://github.com/nginx/kubernetes-ingress/pull/10331), [10344](https://github.com/nginx/kubernetes-ingress/pull/10344), [10364](https://github.com/nginx/kubernetes-ingress/pull/10364), [10389](https://github.com/nginx/kubernetes-ingress/pull/10389), [10379](https://github.com/nginx/kubernetes-ingress/pull/10379), [10381](https://github.com/nginx/kubernetes-ingress/pull/10381), [10403](https://github.com/nginx/kubernetes-ingress/pull/10403), [10363](https://github.com/nginx/kubernetes-ingress/pull/10363), [10428](https://github.com/nginx/kubernetes-ingress/pull/10428) & [10414](https://github.com/nginx/kubernetes-ingress/pull/10414) Bump Go dependencies
- [10276](https://github.com/nginx/kubernetes-ingress/pull/10276), [10245](https://github.com/nginx/kubernetes-ingress/pull/10245), [10223](https://github.com/nginx/kubernetes-ingress/pull/10223), [10343](https://github.com/nginx/kubernetes-ingress/pull/10343), [10257](https://github.com/nginx/kubernetes-ingress/pull/10257), [10278](https://github.com/nginx/kubernetes-ingress/pull/10278), [10329](https://github.com/nginx/kubernetes-ingress/pull/10329), [10273](https://github.com/nginx/kubernetes-ingress/pull/10273), [10303](https://github.com/nginx/kubernetes-ingress/pull/10303), [10304](https://github.com/nginx/kubernetes-ingress/pull/10304), [10330](https://github.com/nginx/kubernetes-ingress/pull/10330), [10380](https://github.com/nginx/kubernetes-ingress/pull/10380) & [10427](https://github.com/nginx/kubernetes-ingress/pull/10427) Bump Docker dependencies

### {{% icon download %}} Upgrade

- For NGINX, use the 5.5.2 images from our [DockerHub](https://hub.docker.com/r/nginx/nginx-ingress/tags?page=1&ordering=last_updated&name=5.5.2), [GitHub Container](https://github.com/nginx/kubernetes-ingress/pkgs/container/kubernetes-ingress), [Amazon ECR Public Gallery](https://gallery.ecr.aws/nginx/nginx-ingress) or [Quay.io](https://quay.io/repository/nginx/nginx-ingress).
- For NGINX Plus, use the 5.5.2 images from the F5 Container registry or build your own image using the 5.5.2 source code.
- For Helm, use version 2.6.2 of the chart.

### {{% icon life-buoy %}} Supported platforms

We provide technical support for NGINX Ingress Controller on any Kubernetes platform that is currently supported by its provider and that passes the Kubernetes conformance tests. This release was fully tested on the following Kubernetes versions: 1.29 - 1.36.

## 5.5.1

18 Jun 2026

### {{% icon bug %}} Fixes

- [10161](https://github.com/nginx/kubernetes-ingress/pull/10161) Update oidc njs code

### {{% icon arrow-up %}} Dependencies

- Update NGINX Plus to 37.0.2.1
- [10217](https://github.com/nginx/kubernetes-ingress/pull/10217) Update NGINX OSS to 1.31.2
- [10208](https://github.com/nginx/kubernetes-ingress/pull/10208), [10063](https://github.com/nginx/kubernetes-ingress/pull/10063), [10197](https://github.com/nginx/kubernetes-ingress/pull/10197), [10114](https://github.com/nginx/kubernetes-ingress/pull/10114), [10134](https://github.com/nginx/kubernetes-ingress/pull/10134), [10168](https://github.com/nginx/kubernetes-ingress/pull/10168), [10157](https://github.com/nginx/kubernetes-ingress/pull/10157), [10143](https://github.com/nginx/kubernetes-ingress/pull/10143) & [10182](https://github.com/nginx/kubernetes-ingress/pull/10182) Bump Go dependencies
- [10102](https://github.com/nginx/kubernetes-ingress/pull/10102), [10094](https://github.com/nginx/kubernetes-ingress/pull/10094), [10145](https://github.com/nginx/kubernetes-ingress/pull/10145), [10180](https://github.com/nginx/kubernetes-ingress/pull/10180), [10166](https://github.com/nginx/kubernetes-ingress/pull/10166), [10142](https://github.com/nginx/kubernetes-ingress/pull/10142), [10212](https://github.com/nginx/kubernetes-ingress/pull/10212), [10195](https://github.com/nginx/kubernetes-ingress/pull/10195), [10196](https://github.com/nginx/kubernetes-ingress/pull/10196) & [10207](https://github.com/nginx/kubernetes-ingress/pull/10207) Bump Docker dependencies
- [10097](https://github.com/nginx/kubernetes-ingress/pull/10097) Update kindest/node to v1.36.1

### {{% icon download %}} Upgrade

- For NGINX, use the 5.5.1 images from our [DockerHub](https://hub.docker.com/r/nginx/nginx-ingress/tags?page=1&ordering=last_updated&name=5.5.1), [GitHub Container](https://github.com/nginx/kubernetes-ingress/pkgs/container/kubernetes-ingress), [Amazon ECR Public Gallery](https://gallery.ecr.aws/nginx/nginx-ingress) or [Quay.io](https://quay.io/repository/nginx/nginx-ingress).
- For NGINX Plus, use the 5.5.1 images from the F5 Container registry or build your own image using the 5.5.1 source code.
- For Helm, use version 2.6.1 of the chart.

### {{% icon life-buoy %}} Supported platforms

We will provide technical support for NGINX Ingress Controller on any Kubernetes platform that is currently supported by its provider and that passes the Kubernetes conformance tests. This release was fully tested on the following Kubernetes versions: 1.29-1.36.

## 5.5.0

29 May 2026

Release 5.5.0 focuses on key enhancements for security, performance, flexibility, and migration from `ingress-nginx` to F5 NGINX Ingress Controller.

This release adds new capabilities and additional security features, expands support for Kubernetes `Ingress` resources, and introduces more annotations to make migrations from `ingress-nginx` easier, including support for External Authentication.

Major highlights include:

  * External Authentication support: External Authentiation is now supported for both `Ingress` and `VirtualServer` resources. Based on analysis of the `ingress-nginx` project, ExternalAuth is one of the most common `ingress-nginx` use cases and has been a frequent request from users migrating to F5 NGINX Ingress Controller.
  * WAF IP Intelligence support: WAF IP Intelligence can now automatically block or limit access from IP addresses with poor reputations, using real-time threat intelligence for categories such as botnets, Windows exploits, and web attacks.
  * mTLS support for `Ingress`: Mutual TLS for ingress and egress traffic is now supported on the `Ingress` resource.
  * Additional annotation support: This release adds support for more annotations, including `add-header`, `add_header_inherit`, `proxy-redirect-from`, and `proxy-redirect-to`.
  * Improved startup performance at scale: NIC startup time has been significantly improved for environments with hundreds or thousands of configured resources. In a large-scale test environment with 100 regular Ingresses, 250 master Ingresses, 1,000 minion Ingresses, and 100 VirtualServers, startup time went from minutes to seconds.
  * Expanded `VirtualServerRoute` path matching: `VirtualServerRoute` now supports multiple regular expression paths, making routing configurations more flexible.
  * WAF `Policy` support for `Ingress`: F5 WAF `Policy` resources no longer requires VirtualServer and can now be associated directly with `Ingress` resources, enabling customers to use advanced WAF capabilities while continuing to use standard Kubernetes `Ingress`.
  * Optional `Host` support: `Host` field in Ingress is now optional through an opt-in approach. This enables IP-based routing for environments that do not use DNS, such as test environments and labs, while preserving host-based routing as the standard Kubernetes routing model.

### {{% icon rocket %}} Features

- [9450](https://github.com/nginx/kubernetes-ingress/pull/9450) Add waf policy support to ingress object
- [9635](https://github.com/nginx/kubernetes-ingress/pull/9635) Add egress mtls policy to ingress object
- [9521](https://github.com/nginx/kubernetes-ingress/pull/9521) Add external auth policy to ingress
- [9519](https://github.com/nginx/kubernetes-ingress/pull/9519) Add external auth policy to vs/vsr
- [9711](https://github.com/nginx/kubernetes-ingress/pull/9711) Improve pod startup times
- [9671](https://github.com/nginx/kubernetes-ingress/pull/9671) Add support for multiple regex paths in a single vsr
- [9743](https://github.com/nginx/kubernetes-ingress/pull/9743) Add support for add_header in configmap and ingress
- [9628](https://github.com/nginx/kubernetes-ingress/pull/9628) Attach ingressmtls policy to ingress
- [9547](https://github.com/nginx/kubernetes-ingress/pull/9547) Support add_header_inherit directive
- [9622](https://github.com/nginx/kubernetes-ingress/pull/9622) Support waf ip intelligence
- [9728](https://github.com/nginx/kubernetes-ingress/pull/9728) Support empty host ingress
- [9862](https://github.com/nginx/kubernetes-ingress/pull/9862) Add support for proxy_redirect in ingress
- [9740](https://github.com/nginx/kubernetes-ingress/pull/9740) Add nginx agent 3.x waf support
- [9778](https://github.com/nginx/kubernetes-ingress/pull/9778) Add path normalisation

### {{% icon bug %}} Fixes

- [9332](https://github.com/nginx/kubernetes-ingress/pull/9332) Fix authentication issue in external pr workflow
- [9406](https://github.com/nginx/kubernetes-ingress/pull/9406) Fix external pr branch creation
- [9452](https://github.com/nginx/kubernetes-ingress/pull/9452) Missing policies on ingress will return 500
- [9486](https://github.com/nginx/kubernetes-ingress/pull/9486) Fix dereference panic
- [9613](https://github.com/nginx/kubernetes-ingress/pull/9613) Fix oidc policy leaking into non-referenced locations
- [9791](https://github.com/nginx/kubernetes-ingress/pull/9791) Implement policy support checks for ingress resources
- [9877](https://github.com/nginx/kubernetes-ingress/pull/9877) Improve transportserver and nginx.org/limit-req-key annotation
- [9955](https://github.com/nginx/kubernetes-ingress/pull/9955) Fix overly restrictive validation in cors policy fields

### {{% icon arrow-up %}} Dependencies

- [9403](https://github.com/nginx/kubernetes-ingress/pull/9403), [9446](https://github.com/nginx/kubernetes-ingress/pull/9446), [9445](https://github.com/nginx/kubernetes-ingress/pull/9445), [9466](https://github.com/nginx/kubernetes-ingress/pull/9466), [9840](https://github.com/nginx/kubernetes-ingress/pull/9840), [9476](https://github.com/nginx/kubernetes-ingress/pull/9476), [9530](https://github.com/nginx/kubernetes-ingress/pull/9530), [9569](https://github.com/nginx/kubernetes-ingress/pull/9569), [9660](https://github.com/nginx/kubernetes-ingress/pull/9660), [9661](https://github.com/nginx/kubernetes-ingress/pull/9661), [9669](https://github.com/nginx/kubernetes-ingress/pull/9669), [9697](https://github.com/nginx/kubernetes-ingress/pull/9697), [9726](https://github.com/nginx/kubernetes-ingress/pull/9726), [9754](https://github.com/nginx/kubernetes-ingress/pull/9754), [9776](https://github.com/nginx/kubernetes-ingress/pull/9776), [9777](https://github.com/nginx/kubernetes-ingress/pull/9777), [9990](https://github.com/nginx/kubernetes-ingress/pull/9990), [9491](https://github.com/nginx/kubernetes-ingress/pull/9491), [9807](https://github.com/nginx/kubernetes-ingress/pull/9807), [9830](https://github.com/nginx/kubernetes-ingress/pull/9830), [9703](https://github.com/nginx/kubernetes-ingress/pull/9703), [9966](https://github.com/nginx/kubernetes-ingress/pull/9966), [9983](https://github.com/nginx/kubernetes-ingress/pull/9983), [10004](https://github.com/nginx/kubernetes-ingress/pull/10004), [10051](https://github.com/nginx/kubernetes-ingress/pull/10051) & [9987](https://github.com/nginx/kubernetes-ingress/pull/9987) Bump Go dependencies

- [9378](https://github.com/nginx/kubernetes-ingress/pull/9378), [9430](https://github.com/nginx/kubernetes-ingress/pull/9430), [9444](https://github.com/nginx/kubernetes-ingress/pull/9444), [9608](https://github.com/nginx/kubernetes-ingress/pull/9608), [9607](https://github.com/nginx/kubernetes-ingress/pull/9607), [9606](https://github.com/nginx/kubernetes-ingress/pull/9606), [9964](https://github.com/nginx/kubernetes-ingress/pull/9964), [9881](https://github.com/nginx/kubernetes-ingress/pull/9881), [10012](https://github.com/nginx/kubernetes-ingress/pull/10012), [9474](https://github.com/nginx/kubernetes-ingress/pull/9474), [9558](https://github.com/nginx/kubernetes-ingress/pull/9558), [9567](https://github.com/nginx/kubernetes-ingress/pull/9567), [9568](https://github.com/nginx/kubernetes-ingress/pull/9568), [9643](https://github.com/nginx/kubernetes-ingress/pull/9643), [9577](https://github.com/nginx/kubernetes-ingress/pull/9577), [9637](https://github.com/nginx/kubernetes-ingress/pull/9637), [9642](https://github.com/nginx/kubernetes-ingress/pull/9642), [9663](https://github.com/nginx/kubernetes-ingress/pull/9663), [9659](https://github.com/nginx/kubernetes-ingress/pull/9659), [9658](https://github.com/nginx/kubernetes-ingress/pull/9658), [9680](https://github.com/nginx/kubernetes-ingress/pull/9680), [9802](https://github.com/nginx/kubernetes-ingress/pull/9802), [9685](https://github.com/nginx/kubernetes-ingress/pull/9685), [9683](https://github.com/nginx/kubernetes-ingress/pull/9683), [9701](https://github.com/nginx/kubernetes-ingress/pull/9701), [9699](https://github.com/nginx/kubernetes-ingress/pull/9699), [9736](https://github.com/nginx/kubernetes-ingress/pull/9736), [9772](https://github.com/nginx/kubernetes-ingress/pull/9772), [9793](https://github.com/nginx/kubernetes-ingress/pull/9793), [9849](https://github.com/nginx/kubernetes-ingress/pull/9849), [9880](https://github.com/nginx/kubernetes-ingress/pull/9880), [9829](https://github.com/nginx/kubernetes-ingress/pull/9829), [9896](https://github.com/nginx/kubernetes-ingress/pull/9896), [9910](https://github.com/nginx/kubernetes-ingress/pull/9910), [9911](https://github.com/nginx/kubernetes-ingress/pull/9911), [9982](https://github.com/nginx/kubernetes-ingress/pull/9982), [10011](https://github.com/nginx/kubernetes-ingress/pull/10011), [10009](https://github.com/nginx/kubernetes-ingress/pull/10009), [10010](https://github.com/nginx/kubernetes-ingress/pull/10010), [9940](https://github.com/nginx/kubernetes-ingress/pull/9940), [10048](https://github.com/nginx/kubernetes-ingress/pull/10048) & [10047](https://github.com/nginx/kubernetes-ingress/pull/10047) Bump Docker dependencies

- [9526](https://github.com/nginx/kubernetes-ingress/pull/9526) Update dependency more-itertools to v11 (main)

### {{% icon download %}} Upgrade

- For NGINX, use the 5.5.0 images from our [DockerHub](https://hub.docker.com/r/nginx/nginx-ingress/tags?page=1&ordering=last_updated&name=5.5.0), [GitHub Container](https://github.com/nginx/kubernetes-ingress/pkgs/container/kubernetes-ingress), [Amazon ECR Public Gallery](https://gallery.ecr.aws/nginx/nginx-ingress) or [Quay.io](https://quay.io/repository/nginx/nginx-ingress).
- For NGINX Plus, use the 5.5.0 images from the F5 Container registry or build your own image using the 5.5.0 source code.
- For Helm, use version 2.6.0 of the chart.

### {{% icon life-buoy %}} Supported platforms

We will provide technical support for NGINX Ingress Controller on any Kubernetes platform that is currently supported by its provider and that passes the Kubernetes conformance tests. This release was fully tested on the following Kubernetes versions: 1.29 - 1.36.

## 5.4.3

22 May 2026

### {{% icon bug %}} Fixes

- [9878](https://github.com/nginx/kubernetes-ingress/pull/9878) Improve transportserver and nginx.org/limit-req-key annotation - release 5.4

### {{% icon arrow-up %}} Dependencies

- [9870](https://github.com/nginx/kubernetes-ingress/pull/9870), [998x](https://github.com/nginx/kubernetes-ingress/pull/998x) Update NGINX OSS to 1.31.1, NGINX Plus to R37.0.1.1, WAF to 5.13.1 & NGINX Agent to latest version
- [9851](https://github.com/nginx/kubernetes-ingress/pull/9851) Update Go version to 1.26.3
- [9841](https://github.com/nginx/kubernetes-ingress/pull/9841), [9833](https://github.com/nginx/kubernetes-ingress/pull/9833), [9818](https://github.com/nginx/kubernetes-ingress/pull/9818), [9831](https://github.com/nginx/kubernetes-ingress/pull/9831), [9813](https://github.com/nginx/kubernetes-ingress/pull/9813) & [9974](https://github.com/nginx/kubernetes-ingress/pull/9974) Bump Go dependencies
- [9926](https://github.com/nginx/kubernetes-ingress/pull/9926), [9924](https://github.com/nginx/kubernetes-ingress/pull/9924), [9814](https://github.com/nginx/kubernetes-ingress/pull/9814), [9948](https://github.com/nginx/kubernetes-ingress/pull/9948), [9868](https://github.com/nginx/kubernetes-ingress/pull/9868), [9898](https://github.com/nginx/kubernetes-ingress/pull/9898), [9832](https://github.com/nginx/kubernetes-ingress/pull/9832), [9870](https://github.com/nginx/kubernetes-ingress/pull/9870), [9884](https://github.com/nginx/kubernetes-ingress/pull/9884) & [9947](https://github.com/nginx/kubernetes-ingress/pull/9947) Bump Docker dependencies

### {{% icon download %}} Upgrade

- For NGINX, use the 5.4.3 images from our [DockerHub](https://hub.docker.com/r/nginx/nginx-ingress/tags?page=1&ordering=last_updated&name=5.4.3), [GitHub Container](https://github.com/nginx/kubernetes-ingress/pkgs/container/kubernetes-ingress), [Amazon ECR Public Gallery](https://gallery.ecr.aws/nginx/nginx-ingress) or [Quay.io](https://quay.io/repository/nginx/nginx-ingress).
- For NGINX Plus, use the 5.4.3 images from the F5 Container registry or build your own image using the 5.4.3 source code.
- For Helm, use version 2.5.3 of the chart.

### {{% icon life-buoy %}} Supported platforms

We will provide technical support for NGINX Ingress Controller on any Kubernetes platform that is currently supported by its provider and that passes the Kubernetes conformance tests. This release was fully tested on the following Kubernetes versions: 1.28 - 1.35.

## 5.4.2

07 May 2026

### {{% icon bug %}} Fixes

- [9510](https://github.com/nginx/kubernetes-ingress/pull/9510) Warn user when policy on ingress needs custom resources enabling
- [9620](https://github.com/nginx/kubernetes-ingress/pull/9620) Fix oidc policy leaking into non-referenced locations
- [9792](https://github.com/nginx/kubernetes-ingress/pull/9792) Implement policy support checks for Ingress resources

### {{% icon arrow-up %}} Dependencies

- [9480](https://github.com/nginx/kubernetes-ingress/pull/9480), [9541](https://github.com/nginx/kubernetes-ingress/pull/9541), [9596](https://github.com/nginx/kubernetes-ingress/pull/9596), [9595](https://github.com/nginx/kubernetes-ingress/pull/9595), [9538](https://github.com/nginx/kubernetes-ingress/pull/9538), [9670](https://github.com/nginx/kubernetes-ingress/pull/9670), [9755](https://github.com/nginx/kubernetes-ingress/pull/9755), [9666](https://github.com/nginx/kubernetes-ingress/pull/9666), [9786](https://github.com/nginx/kubernetes-ingress/pull/9786) & [9688](https://github.com/nginx/kubernetes-ingress/pull/9688) Bump Go dependencies
- [9493](https://github.com/nginx/kubernetes-ingress/pull/9493), [9492](https://github.com/nginx/kubernetes-ingress/pull/9492), [9494](https://github.com/nginx/kubernetes-ingress/pull/9494), [9764](https://github.com/nginx/kubernetes-ingress/pull/9764), [9784](https://github.com/nginx/kubernetes-ingress/pull/9784), [9515](https://github.com/nginx/kubernetes-ingress/pull/9515), [9566](https://github.com/nginx/kubernetes-ingress/pull/9566), [9651](https://github.com/nginx/kubernetes-ingress/pull/9651), [9648](https://github.com/nginx/kubernetes-ingress/pull/9648), [9664](https://github.com/nginx/kubernetes-ingress/pull/9664), [9604](https://github.com/nginx/kubernetes-ingress/pull/9604), [9731](https://github.com/nginx/kubernetes-ingress/pull/9731), [9668](https://github.com/nginx/kubernetes-ingress/pull/9668), [9705](https://github.com/nginx/kubernetes-ingress/pull/9705), [9704](https://github.com/nginx/kubernetes-ingress/pull/9704), [9707](https://github.com/nginx/kubernetes-ingress/pull/9707), [9763](https://github.com/nginx/kubernetes-ingress/pull/9763), [9774](https://github.com/nginx/kubernetes-ingress/pull/9774), [9737](https://github.com/nginx/kubernetes-ingress/pull/9737), [9687](https://github.com/nginx/kubernetes-ingress/pull/9687) & [9665](https://github.com/nginx/kubernetes-ingress/pull/9665) Bump Docker dependencies
- [9583](https://github.com/nginx/kubernetes-ingress/pull/9583) Update go to v1.26.2, nginx to 1.29.8, waf to 5.12.1

### {{% icon download %}} Upgrade

- For NGINX, use the 5.4.2 images from our [DockerHub](https://hub.docker.com/r/nginx/nginx-ingress/tags?page=1&ordering=last_updated&name=5.4.2), [GitHub Container](https://github.com/nginx/kubernetes-ingress/pkgs/container/kubernetes-ingress), [Amazon ECR Public Gallery](https://gallery.ecr.aws/nginx/nginx-ingress) or [Quay.io](https://quay.io/repository/nginx/nginx-ingress).
- For NGINX Plus, use the 5.4.2 images from the F5 Container registry or build your own image using the 5.4.2 source code.
- For Helm, use version 2.5.2 of the chart.

### {{% icon life-buoy %}} Supported platforms

We will provide technical support for NGINX Ingress Controller on any Kubernetes platform that is currently supported by its provider and that passes the Kubernetes conformance tests. This release was fully tested on the following Kubernetes versions: 1.28-1.35.

## 5.4.1

26 Mar 2026

### {{% icon bug %}} Fixes

- [9463](https://github.com/nginx/kubernetes-ingress/pull/9463) Missing policies on ingress will return 500

### {{% icon arrow-up %}} Dependencies

- [9456](https://github.com/nginx/kubernetes-ingress/pull/9456) Update NGINX OSS to 1.29.7, NGINX Plus to R36 P3 & WAF to 5.12
- [9438](https://github.com/nginx/kubernetes-ingress/pull/9438) Update NGINX Agent to 3.8
- [9441](https://github.com/nginx/kubernetes-ingress/pull/9441) Bump Go dependencies
- [9397](https://github.com/nginx/kubernetes-ingress/pull/9397), [9442](https://github.com/nginx/kubernetes-ingress/pull/9442), [9467](https://github.com/nginx/kubernetes-ingress/pull/9467) & [9395](https://github.com/nginx/kubernetes-ingress/pull/9395) Bump Docker dependencies

### {{% icon download %}} Upgrade

- For NGINX, use the 5.4.1 images from our [DockerHub](https://hub.docker.com/r/nginx/nginx-ingress/tags?page=1&ordering=last_updated&name=5.4.1), [GitHub Container](https://github.com/nginx/kubernetes-ingress/pkgs/container/kubernetes-ingress), [Amazon ECR Public Gallery](https://gallery.ecr.aws/nginx/nginx-ingress) or [Quay.io](https://quay.io/repository/nginx/nginx-ingress).
- For NGINX Plus, use the 5.4.1 images from the F5 Container registry or build your own image using the 5.4.1 source code.
- For Helm, use version 2.5.1 of the chart.

### {{% icon life-buoy %}} Supported Platforms

We will provide technical support for NGINX Ingress Controller on any Kubernetes platform that is currently supported by its provider and that passes the Kubernetes conformance tests. This release was fully tested on the following Kubernetes versions: 1.28-1.35.

## 5.4.0

20 Mar 2026

Release 5.4.0 focuses on making migrations from `ingress-nginx` easier by providing key features users need most when transitioning to NGINX Ingress Controller:

- CORS support: A new `Policy` introduces CORS configuration that works seamlessly with both `Ingress` and `VirtualServer` resources, giving users a flexible, native way to manage cross-origin policies.
- Expanded `Annotation` support: This release adds compatibility with a broader set of `ingress-nginx` annotations, reducing the friction of migrating existing workloads without requiring immediate resource rewrites.
- Access control for `Ingress` resources: Access control policies are now compatible with `kind: Ingress`, bringing parity with `VirtualServer` and allowing teams to enforce consistent access policies across resource types during migration.
- Configuration resilience and validation: Improved configuration validation and resilience mechanisms help catch misconfigurations early and ensure more stable reloads, reducing downtime risk.

- Label-based `VirtualServerRoute` selection: `VirtualServers` can now select `VirtualServerRoutes` using label selectors instead of explicit references, enabling more dynamic and scalable routing configurations without tight coupling between resources

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
- [9316](https://github.com/nginx/kubernetes-ingress/pull/9316) Enable session persistence for nginx oss config
- [9288](https://github.com/nginx/kubernetes-ingress/pull/9288) Config rollback manager
- [8831](https://github.com/nginx/kubernetes-ingress/pull/8831) Implement zone size templates in configmap for oidc templates

### {{% icon bug %}} Fixes

- [8689](https://github.com/nginx/kubernetes-ingress/pull/8689) Update stub_status client path
- [8722](https://github.com/nginx/kubernetes-ingress/pull/8722) Update service template for ipfamilies
- [8740](https://github.com/nginx/kubernetes-ingress/pull/8740) Add more validation on rewrite-target
- [8869](https://github.com/nginx/kubernetes-ingress/pull/8869) Refactor getvalidtarget to return a list of items
- [8949](https://github.com/nginx/kubernetes-ingress/pull/8949) Ensure NGINX metric show up in NGINX One console
- [9140](https://github.com/nginx/kubernetes-ingress/pull/9140) Invalid vs with oidc policy applied at vs spec with trusted cert
- [9213](https://github.com/nginx/kubernetes-ingress/pull/9213) Remove `unexpected ";"` using zone-sync in the configmap while disabling ipv6

### {{% icon arrow-up %}} Dependencies

- [9059](https://github.com/nginx/kubernetes-ingress/pull/9059) Update nginx agent to 3.7
- [9176](https://github.com/nginx/kubernetes-ingress/pull/9176) Update go to v1.26
- [9218](https://github.com/nginx/kubernetes-ingress/pull/9218), [9404](https://github.com/nginx/kubernetes-ingress/pull/9404), [9344](https://github.com/nginx/kubernetes-ingress/pull/9344), [9240](https://github.com/nginx/kubernetes-ingress/pull/9240), [9350](https://github.com/nginx/kubernetes-ingress/pull/9350), [9159](https://github.com/nginx/kubernetes-ingress/pull/9159), [9005](https://github.com/nginx/kubernetes-ingress/pull/9005), [8963](https://github.com/nginx/kubernetes-ingress/pull/8963), [9111](https://github.com/nginx/kubernetes-ingress/pull/9111), [8951](https://github.com/nginx/kubernetes-ingress/pull/8951), [9095](https://github.com/nginx/kubernetes-ingress/pull/9095), [9158](https://github.com/nginx/kubernetes-ingress/pull/9158), [9157](https://github.com/nginx/kubernetes-ingress/pull/9157), [8850](https://github.com/nginx/kubernetes-ingress/pull/8850), [9121](https://github.com/nginx/kubernetes-ingress/pull/9121), [9221](https://github.com/nginx/kubernetes-ingress/pull/9221), [9305](https://github.com/nginx/kubernetes-ingress/pull/9305), [9112](https://github.com/nginx/kubernetes-ingress/pull/9112), [9039](https://github.com/nginx/kubernetes-ingress/pull/9039), [9267](https://github.com/nginx/kubernetes-ingress/pull/9267), [9359](https://github.com/nginx/kubernetes-ingress/pull/9359) & [8622](https://github.com/nginx/kubernetes-ingress/pull/8622) Bump Go dependencies
- [9322](https://github.com/nginx/kubernetes-ingress/pull/9322), [9349](https://github.com/nginx/kubernetes-ingress/pull/9349), [9345](https://github.com/nginx/kubernetes-ingress/pull/9345), [9301](https://github.com/nginx/kubernetes-ingress/pull/9301), [9303](https://github.com/nginx/kubernetes-ingress/pull/9303), [9294](https://github.com/nginx/kubernetes-ingress/pull/9294), [9243](https://github.com/nginx/kubernetes-ingress/pull/9243), [9115](https://github.com/nginx/kubernetes-ingress/pull/9115), [9103](https://github.com/nginx/kubernetes-ingress/pull/9103), [8877](https://github.com/nginx/kubernetes-ingress/pull/8877), [9002](https://github.com/nginx/kubernetes-ingress/pull/9002), [9298](https://github.com/nginx/kubernetes-ingress/pull/9298), [8821](https://github.com/nginx/kubernetes-ingress/pull/8821), [9043](https://github.com/nginx/kubernetes-ingress/pull/9043), [8881](https://github.com/nginx/kubernetes-ingress/pull/8881), [8748](https://github.com/nginx/kubernetes-ingress/pull/8748), [9142](https://github.com/nginx/kubernetes-ingress/pull/9142), [9365](https://github.com/nginx/kubernetes-ingress/pull/9365), [8658](https://github.com/nginx/kubernetes-ingress/pull/8658), [9318](https://github.com/nginx/kubernetes-ingress/pull/9318), [9193](https://github.com/nginx/kubernetes-ingress/pull/9193), [9323](https://github.com/nginx/kubernetes-ingress/pull/9323), [9304](https://github.com/nginx/kubernetes-ingress/pull/9304), [9026](https://github.com/nginx/kubernetes-ingress/pull/9026), [9312](https://github.com/nginx/kubernetes-ingress/pull/9312), [9027](https://github.com/nginx/kubernetes-ingress/pull/9027), [9302](https://github.com/nginx/kubernetes-ingress/pull/9302), [9028](https://github.com/nginx/kubernetes-ingress/pull/9028), [9336](https://github.com/nginx/kubernetes-ingress/pull/9336), [9105](https://github.com/nginx/kubernetes-ingress/pull/9105), [9297](https://github.com/nginx/kubernetes-ingress/pull/9297) & [9093](https://github.com/nginx/kubernetes-ingress/pull/9093) Bump Docker dependencies

### {{% icon download %}} Upgrade

- For NGINX, use the 5.4.0 images from our [DockerHub](https://hub.docker.com/r/nginx/nginx-ingress/tags?page=1&ordering=last_updated&name=5.4.0), [GitHub Container](https://github.com/nginx/kubernetes-ingress/pkgs/container/kubernetes-ingress), [Amazon ECR Public Gallery](https://gallery.ecr.aws/nginx/nginx-ingress) or [Quay.io](https://quay.io/repository/nginx/nginx-ingress).
- For NGINX Plus, use the 5.4.0 images from the F5 Container registry or build your own image using the 5.4.0 source code.
- For Helm, use version 2.5.0 of the chart.

### {{% icon life-buoy %}} Supported platforms

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

### {{% icon life-buoy %}} Supported platforms

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

### {{% icon life-buoy %}} Supported platforms

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

### {{% icon life-buoy %}} Supported platforms

We will provide technical support for NGINX Ingress Controller on any Kubernetes platform that is currently supported by its provider and that passes the Kubernetes conformance tests. This release was fully tested on the following Kubernetes versions: 1.27-1.35.
