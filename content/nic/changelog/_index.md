---
title: Changelog
url: /nginx-ingress-controller/changelog
weight: 10200
nd-landing-page: true
nd-content-type: reference
nd-product: INGRESS
nd-docs: DOCS-616
---

This changelog lists all of the information for F5 NGINX Ingress Controller releases in 2025.

For older releases, check the changelogs for previous years: [2024]({{< ref "/nic/changelog/2024.md" >}}), [2023]({{< ref "/nic/changelog/2023.md" >}}), [2022]({{< ref "/nic/changelog/2022.md" >}}), [2021]({{< ref "/nic/changelog/2021.md" >}}), [2020]({{< ref "/nic/changelog/2020.md" >}}), [2019]({{< ref "/nic/changelog/2019.md" >}}).

{{< details summary="NGINX Ingress Controller compatibility matrix" open=false >}}

{{< include "/nic/compatibility-tables/nic-k8s.md" >}}

### Supported F5 WAF for NGINX versions

{{<call-out "note" "Note">}}To use F5 WAF for NGINX with NGINX Ingress Controller, you must have NGINX Plus.{{< /call-out >}}

{{< include "/nic/compatibility-tables/nic-nap.md" >}}

{{< /details >}}

## 5.3.0

09 Dec 2025

### {{% icon rocket %}} Features

- [8292](https://github.com/nginx/kubernetes-ingress/pull/8292) Add sslverify for jwksuri
- [8447](https://github.com/nginx/kubernetes-ingress/pull/8447) Add support for ssl ciphers related annotations
- [8340](https://github.com/nginx/kubernetes-ingress/pull/8340) Implement oidc front channel logout nginx directives
- [8495](https://github.com/nginx/kubernetes-ingress/pull/8495) Add oidc timeout customization to configmap
- [8453](https://github.com/nginx/kubernetes-ingress/pull/8453) Support namespaced upstream service reference in virtualserver
- [8508](https://github.com/nginx/kubernetes-ingress/pull/8508) Add rewrite-target annotation
- [8548](https://github.com/nginx/kubernetes-ingress/pull/8548) Add `client-body-buffer-size` directive to ingress annotations & configmap
- [8557](https://github.com/nginx/kubernetes-ingress/pull/8557) Add client-body-buffer-size directive to virtualserver
- [8556](https://github.com/nginx/kubernetes-ingress/pull/8556) Add oidc policy idp tls validation
- [8533](https://github.com/nginx/kubernetes-ingress/pull/8533) Extend cache policy for more configurable parameters

### {{% icon bug %}} Fixes

- [8299](https://github.com/nginx/kubernetes-ingress/pull/8299) Remove type field for objects with schema ref
- [8455](https://github.com/nginx/kubernetes-ingress/pull/8455) Cleanup stale socket files on startup

### {{% icon arrow-up %}} Dependencies

- [8553](https://github.com/nginx/kubernetes-ingress/pull/8553) Bump Go dependencies
- [8244](https://github.com/nginx/kubernetes-ingress/pull/8244), [8279](https://github.com/nginx/kubernetes-ingress/pull/8279), [8284](https://github.com/nginx/kubernetes-ingress/pull/8284), [8595](https://github.com/nginx/kubernetes-ingress/pull/8595), [8584](https://github.com/nginx/kubernetes-ingress/pull/8584), [8315](https://github.com/nginx/kubernetes-ingress/pull/8315), [8324](https://github.com/nginx/kubernetes-ingress/pull/8324), [8334](https://github.com/nginx/kubernetes-ingress/pull/8334), [8466](https://github.com/nginx/kubernetes-ingress/pull/8466), [8384](https://github.com/nginx/kubernetes-ingress/pull/8384), [8502](https://github.com/nginx/kubernetes-ingress/pull/8502), [8406](https://github.com/nginx/kubernetes-ingress/pull/8406), [8588](https://github.com/nginx/kubernetes-ingress/pull/8588), [8589](https://github.com/nginx/kubernetes-ingress/pull/8589), [8598](https://github.com/nginx/kubernetes-ingress/pull/8598), [8575](https://github.com/nginx/kubernetes-ingress/pull/8575), [8542](https://github.com/nginx/kubernetes-ingress/pull/8542), [8543](https://github.com/nginx/kubernetes-ingress/pull/8543), [8599](https://github.com/nginx/kubernetes-ingress/pull/8599), [8551](https://github.com/nginx/kubernetes-ingress/pull/8551), [8484](https://github.com/nginx/kubernetes-ingress/pull/8484), [8475](https://github.com/nginx/kubernetes-ingress/pull/8475), [8497](https://github.com/nginx/kubernetes-ingress/pull/8497), [8498](https://github.com/nginx/kubernetes-ingress/pull/8498), [8499](https://github.com/nginx/kubernetes-ingress/pull/8499), [8596](https://github.com/nginx/kubernetes-ingress/pull/8596), [8511](https://github.com/nginx/kubernetes-ingress/pull/8511) & [8581](https://github.com/nginx/kubernetes-ingress/pull/8581) Bump Docker dependencies
- [8616](https://github.com/nginx/kubernetes-ingress/pull/8616) Update dependency go to v1.25.5 (main)
- [8611](https://github.com/nginx/kubernetes-ingress/pull/8611) Bump waf version to 5.10.0
- [8494](https://github.com/nginx/kubernetes-ingress/pull/8494) Update nginx to 1.29.3, nginx agent to 3.5
- [8600](https://github.com/nginx/kubernetes-ingress/pull/8600) Update nginx plus waf pkg and alpine base version

### {{% icon download %}} Upgrade

- For NGINX, use the 5.3.0 images from our [DockerHub](https://hub.docker.com/r/nginx/nginx-ingress/tags?page=1&ordering=last_updated&name=5.3.0), [GitHub Container](https://github.com/nginx/kubernetes-ingress/pkgs/container/kubernetes-ingress), [Amazon ECR Public Gallery](https://gallery.ecr.aws/nginx/nginx-ingress) or [Quay.io](https://quay.io/repository/nginx/nginx-ingress).
- For NGINX Plus, use the 5.3.0 images from the F5 Container registry or build your own image using the 5.3.0 source code.
- For Helm, use version 2.4.0 of the chart.
- For users making use of a custom `oidc.conf` by following this [guide]({{< ref "/nic/tutorials/oidc-custom-configuration.md" >}}), in this release this behaviour has changed from a static file (`oidc.conf`) to a dynamic template (`oidc.tmpl`).  The [guide]({{< ref "/nic/tutorials/oidc-custom-configuration.md" >}}) has been updated to reflect the recent changes.  If you still require a custom OIDC configuration, you should copy all the modifications you have made prior to 5.3.0 to the `oidc.tmpl` in the `ConfigMap`.

### {{% icon life-buoy %}} Supported Platforms

We will provide technical support for NGINX Ingress Controller on any Kubernetes platform that is currently supported by its provider and that passes the Kubernetes conformance tests. This release was fully tested on the following Kubernetes versions: 1.27-1.34.

## 5.2.1

10 Oct 2025

### <i class="fa-solid fa-bug-slash"></i> Fixes

- [8302](https://github.com/nginx/kubernetes-ingress/pull/8302) Remove type field for objects with schema ref

### <i class="fa-solid fa-upload"></i> Dependencies

- [8321](https://github.com/nginx/kubernetes-ingress/pull/8321), [8330](https://github.com/nginx/kubernetes-ingress/pull/8330), [8352](https://github.com/nginx/kubernetes-ingress/pull/8352) & [8358](https://github.com/nginx/kubernetes-ingress/pull/8358) Bump Go dependencies
- [8280](https://github.com/nginx/kubernetes-ingress/pull/8280), [8291](https://github.com/nginx/kubernetes-ingress/pull/8291), [8331](https://github.com/nginx/kubernetes-ingress/pull/8331) & [8320](https://github.com/nginx/kubernetes-ingress/pull/8320) Bump Docker dependencies
- [8348](https://github.com/nginx/kubernetes-ingress/pull/8348) Update F5 WAF for NGINX 5.9.0
- [8273](https://github.com/nginx/kubernetes-ingress/pull/8273) Update dependencies

### <i class="fa-solid fa-download"></i> Upgrade

- For NGINX, use the 5.2.1 images from our [DockerHub](https://hub.docker.com/r/nginx/nginx-ingress/tags?page=1&ordering=last_updated&name=5.2.1), [GitHub Container](https://github.com/nginx/kubernetes-ingress/pkgs/container/kubernetes-ingress), [Amazon ECR Public Gallery](https://gallery.ecr.aws/nginx/nginx-ingress) or [Quay.io](https://quay.io/repository/nginx/nginx-ingress).
- For NGINX Plus, use the 5.2.1 images from the F5 Container registry or build your own image using the 5.2.1 source code.
- For Helm, use version 2.3.1 of the chart.

### <i class="fa-solid fa-life-ring"></i> Supported Platforms

We will provide technical support for NGINX Ingress Controller on any Kubernetes platform that is currently supported by its provider and that passes the Kubernetes conformance tests. This release was fully tested on the following Kubernetes versions: 1.27-1.34.

## 5.2.0

15 Sept 2025

This NGINX Ingress Controller release focuses on enhancing performance, simplifying configurations, and improving security to better support modern application needs. The highlights of this release are as follows:

- NGINX Content Cache using policies: This new feature introduces policy configurations that enable proxy caching.
- Support for Kubernetes `StatefulSet` Objects: Added support for Kubernetes `StatefulSet` objects, which can also be used to provide persistent storage for cached content.
- Auto-Adjusting incompatible proxy buffer directive values: A new `-enable-directive-autoadjust` parameter has been added. When enabled, this feature automatically resolves common proxy buffer configuration dependencies that could cause issues during NGINX reloads.
- Server Name Indication (SNI) support in JWT Policies: Users can now configure sniName and sniEnabled for scenarios where the remote server requires SNI to present the correct certificate

### <i class="fa-solid fa-rocket"></i> Features

- [8005](https://github.com/nginx/kubernetes-ingress/pull/8005) Add nginx content cache as NIC cache policy
- [8159](https://github.com/nginx/kubernetes-ingress/pull/8159) Statefulset support
- [8133](https://github.com/nginx/kubernetes-ingress/pull/8133) Add support for automatic adjustment of buffer related directives
- [8011](https://github.com/nginx/kubernetes-ingress/pull/8011) Allow startupprobe to be configured via helm 
- [7993](https://github.com/nginx/kubernetes-ingress/pull/7993) Add sni to NIC jwt policy
- [8093](https://github.com/nginx/kubernetes-ingress/pull/8093) Add viol_bot_client and viol_geolocation violations support
- [8229](https://github.com/nginx/kubernetes-ingress/pull/8229) Add N+ license expiry to prometheus metrics
- [8142](https://github.com/nginx/kubernetes-ingress/pull/8142) Add globalconfigurationcustomname parameter
- [8195](https://github.com/nginx/kubernetes-ingress/pull/8195) Add support for fips 140-3 compliance

### <i class="fa-solid fa-upload"></i> Dependencies

- [8208](https://github.com/nginx/kubernetes-ingress/pull/8208) Update Nginx agent to 3.3
- [7959](https://github.com/nginx/kubernetes-ingress/pull/7959), [7983](https://github.com/nginx/kubernetes-ingress/pull/7983), [8037](https://github.com/nginx/kubernetes-ingress/pull/8037), [8057](https://github.com/nginx/kubernetes-ingress/pull/8057), [8083](https://github.com/nginx/kubernetes-ingress/pull/8083), [8096](https://github.com/nginx/kubernetes-ingress/pull/8096), [8126](https://github.com/nginx/kubernetes-ingress/pull/8126), [8143](https://github.com/nginx/kubernetes-ingress/pull/8143), [8183](https://github.com/nginx/kubernetes-ingress/pull/8183), [8186](https://github.com/nginx/kubernetes-ingress/pull/8186), [8200](https://github.com/nginx/kubernetes-ingress/pull/8200), [8231](https://github.com/nginx/kubernetes-ingress/pull/8231) Bump Go dependencies
- [7946](https://github.com/nginx/kubernetes-ingress/pull/7946), [7961](https://github.com/nginx/kubernetes-ingress/pull/7961), [7977](https://github.com/nginx/kubernetes-ingress/pull/7977), [7979](https://github.com/nginx/kubernetes-ingress/pull/7979), [7978](https://github.com/nginx/kubernetes-ingress/pull/7978), [7984](https://github.com/nginx/kubernetes-ingress/pull/7984), [7996](https://github.com/nginx/kubernetes-ingress/pull/7996), [8012](https://github.com/nginx/kubernetes-ingress/pull/8012), [8036](https://github.com/nginx/kubernetes-ingress/pull/8036), [8044](https://github.com/nginx/kubernetes-ingress/pull/8044), [8063](https://github.com/nginx/kubernetes-ingress/pull/8063), [8085](https://github.com/nginx/kubernetes-ingress/pull/8085), [8107](https://github.com/nginx/kubernetes-ingress/pull/8107), [8114](https://github.com/nginx/kubernetes-ingress/pull/8114), [8128](https://github.com/nginx/kubernetes-ingress/pull/8128), [8134](https://github.com/nginx/kubernetes-ingress/pull/8134), [8147](https://github.com/nginx/kubernetes-ingress/pull/8147), [8154](https://github.com/nginx/kubernetes-ingress/pull/8154), [8173](https://github.com/nginx/kubernetes-ingress/pull/8173), [8188](https://github.com/nginx/kubernetes-ingress/pull/8188), [8228](https://github.com/nginx/kubernetes-ingress/pull/8228), [8239](https://github.com/nginx/kubernetes-ingress/pull/8239), [8235](https://github.com/nginx/kubernetes-ingress/pull/8235), [8246](https://github.com/nginx/kubernetes-ingress/pull/8246) Bump Docker dependencies

### <i class="fa-solid fa-download"></i> Upgrade

- For NGINX, use the 5.2.0 images from our [DockerHub](https://hub.docker.com/r/nginx/nginx-ingress/tags?page=1&ordering=last_updated&name=5.2.0), [GitHub Container](https://github.com/nginx/kubernetes-ingress/pkgs/container/kubernetes-ingress), [Amazon ECR Public Gallery](https://gallery.ecr.aws/nginx/nginx-ingress) or [Quay.io](https://quay.io/repository/nginx/nginx-ingress).
- For NGINX Plus, use the 5.2.0 images from the F5 Container registry or build your own image using the 5.2.0 source code.
- For Helm, use version 2.3.0 of the chart.

### <i class="fa-solid fa-life-ring"></i> Supported Platforms

We will provide technical support for NGINX Ingress Controller on any Kubernetes platform that is currently supported by its provider and that passes the Kubernetes conformance tests. This release was fully tested on the following Kubernetes versions: 1.26-1.34.

## 5.1.1

15 Aug 2025

### <i class="fa-solid fa-bug-slash"></i> Fixes

- [8046](https://github.com/nginx/kubernetes-ingress/pull/8046) Update interval checks for mgmt directive
- [8079](https://github.com/nginx/kubernetes-ingress/pull/8079) Status updates for vs endpoints 
- [8125](https://github.com/nginx/kubernetes-ingress/pull/8125) Don't send request headers & body to jwks uri

### <i class="fa-solid fa-upload"></i> Dependencies

- [8115](https://github.com/nginx/kubernetes-ingress/pull/8115) & [8131](https://github.com/nginx/kubernetes-ingress/pull/8131) Bump Go dependencies
- [8030](https://github.com/nginx/kubernetes-ingress/pull/8030), [8080](https://github.com/nginx/kubernetes-ingress/pull/8080) & [8112](https://github.com/nginx/kubernetes-ingress/pull/8112) Bump Docker dependencies
- [8139](https://github.com/nginx/kubernetes-ingress/pull/8139) Update to NGINX OSS 1.29.1, NGINX Plus r35, NGINX Agent v3.2, NGINX App Protect 4.16.0 & 5.8.0, and Alpine Linux 3.22

### <i class="fa-solid fa-download"></i> Upgrade

- For NGINX, use the 5.1.1 images from our [DockerHub](https://hub.docker.com/r/nginx/nginx-ingress/tags?page=1&ordering=last_updated&name=5.1.1), [GitHub Container](https://github.com/nginx/kubernetes-ingress/pkgs/container/kubernetes-ingress), [Amazon ECR Public Gallery](https://gallery.ecr.aws/nginx/nginx-ingress) or [Quay.io](https://quay.io/repository/nginx/nginx-ingress).
- For NGINX Plus, use the 5.1.1 images from the F5 Container registry or build your own image using the 5.1.1 source code.
- For Helm, use version 2.2.2 of the chart.

### <i class="fa-solid fa-life-ring"></i> Supported Platforms

We will provide technical support for NGINX Ingress Controller on any Kubernetes platform that is currently supported by its provider and that passes the Kubernetes conformance tests. This release was fully tested on the following Kubernetes versions: 1.25-1.33.

## 5.1.0

08 Jul 2025

This NGINX Ingress Controller release brings initial connectivity to the NGINX One Console! You can now use NGINX One Console to monitor NGINX instances that are part of your NGINX Ingress Controller cluster. See [here]({{< ref "/nginx-one-console/k8s/add-nic.md" >}}) to configure NGINX One Console with NGINX Ingress Controller.

This release also includes the ability to configure Rate Limiting for your APIs based on a specific NGINX variable and its value. This allows you more granular control over how frequently specific users access your resources.

Lastly, in our previous v5.0.0 release, we removed support for OpenTracing. This release replaces that observability capability with native [NGINX OpenTelemetry]({{< ref "/nic/logging-and-monitoring/opentelemetry.md" >}}) traces, allowing you to monitor the traffic of your applications.

### <i class="fa-solid fa-rocket"></i> Features

- [7642](https://github.com/nginx/kubernetes-ingress/pull/7642) Add [OpenTelemetry support]({{< ref "/nic/logging-and-monitoring/opentelemetry.md" >}})
- [7916](https://github.com/nginx/kubernetes-ingress/pull/7916) Add support for NGINX Agent version 3 and NGINX One Console
- [7884](https://github.com/nginx/kubernetes-ingress/pull/7884) Tiered rate limits with variables
- [7765](https://github.com/nginx/kubernetes-ingress/pull/7765) Add OIDC PKCE configuration through Policy
- [7832](https://github.com/nginx/kubernetes-ingress/pull/7832) Add request_method to rate-limit Policy
- [7695](https://github.com/nginx/kubernetes-ingress/pull/7695) Add ConfigMapKeys & MGMTConfigMapKeys to Telemetry
- [7705](https://github.com/nginx/kubernetes-ingress/pull/7705) Add Context to logging for JSON and TEXT formats

### <i class="fa-solid fa-bug-slash"></i> Fixes

- [7651](https://github.com/nginx/kubernetes-ingress/pull/7651) Use pod labels as headless selector labels
- [7691](https://github.com/nginx/kubernetes-ingress/pull/7691) Avoid applying updates on Ingress Controller shutdown
- [7748](https://github.com/nginx/kubernetes-ingress/pull/7748) Add ; in oidc files
- [7786](https://github.com/nginx/kubernetes-ingress/pull/7786) Correct namespace for mgmt secrets
- [7853](https://github.com/nginx/kubernetes-ingress/pull/7853) Update template for custom redirect URI
- [7865](https://github.com/nginx/kubernetes-ingress/pull/7865) Maintain HeadlessService on upgrade

### <i class="fa-solid fa-upload"></i> Dependencies

- [7647](https://github.com/nginx/kubernetes-ingress/pull/7647), [7666](https://github.com/nginx/kubernetes-ingress/pull/7666), [7711](https://github.com/nginx/kubernetes-ingress/pull/7711), [7767](https://github.com/nginx/kubernetes-ingress/pull/7767), [7798](https://github.com/nginx/kubernetes-ingress/pull/7798), [7824](https://github.com/nginx/kubernetes-ingress/pull/7824), [7854](https://github.com/nginx/kubernetes-ingress/pull/7854), [7900](https://github.com/nginx/kubernetes-ingress/pull/7900), [7918](https://github.com/nginx/kubernetes-ingress/pull/7918), [7926](https://github.com/nginx/kubernetes-ingress/pull/7926) Bump Go dependancies
- [7714](https://github.com/nginx/kubernetes-ingress/pull/7714), [7788](https://github.com/nginx/kubernetes-ingress/pull/7788), [7825](https://github.com/nginx/kubernetes-ingress/pull/7825), [7855](https://github.com/nginx/kubernetes-ingress/pull/7855), [7890](https://github.com/nginx/kubernetes-ingress/pull/7890), [7888](https://github.com/nginx/kubernetes-ingress/pull/7888), [7893](https://github.com/nginx/kubernetes-ingress/pull/7893), [7903](https://github.com/nginx/kubernetes-ingress/pull/7903) Bump Docker dependencies
- [7808](https://github.com/nginx/kubernetes-ingress/pull/7808) Update kubernetes version to v1.33.1 in helm schema
- [7896](https://github.com/nginx/kubernetes-ingress/pull/7896) Update go version to 1.24.4

### <i class="fa-solid fa-download"></i> Upgrade

- For NGINX, use the 5.1.0 images from our
[DockerHub](https://hub.docker.com/r/nginx/nginx-ingress/tags?page=1&ordering=last_updated&name=5.1.0),
[GitHub Container](https://github.com/nginx/kubernetes-ingress/pkgs/container/kubernetes-ingress),
[Amazon ECR Public Gallery](https://gallery.ecr.aws/nginx/nginx-ingress) or [Quay.io](https://quay.io/repository/nginx/nginx-ingress).
- For NGINX Plus, use the 5.1.0 images from the F5 Container registry or build your own image using the 5.1.0 source code
- For Helm, use version 2.2.1 of the chart.

### <i class="fa-solid fa-life-ring"></i> Supported Platforms

We will provide technical support for NGINX Ingress Controller on any Kubernetes platform that is currently supported by
its provider and that passes the Kubernetes conformance tests. This release was fully tested on the following Kubernetes
versions: 1.25-1.33.

## 5.0.0

16 Apr 2025

Added support for [NGINX Plus R34]({{< ref "/nginx/releases.md#nginxplusrelease-34-r34" >}}), users needing to use a forward proxy for license verification are now able to make use of the [`proxy`](https://nginx.org/en/docs/ngx_mgmt_module.html#proxy) directives available in F5 NGINX Plus.

{{< call-out "warning" >}}

With the removal of the OpenTracing dynamic module from [NGINX Plus R34]({{< ref "/nginx/releases.md#nginxplusrelease-34-r34" >}}), NGINX Ingress Controller also removes full OpenTracing support. This will affect users making use of OpenTracing with the ConfigMap, `server-snippets` & `location-snippets` parameters.  Support for tracing with [OpenTelemetry]({{< ref "/nginx/admin-guide/dynamic-modules/opentelemetry.md" >}}) will come in a future release.

{{< /call-out >}}

We have extended the rate-limit Policy to allow tiered rate limit groups with JWT claims.  This will also allow users to apply different rate limits to their `VirtualServer` or `VirtualServerRoutes` with the value of a JWT claim.  See [here](https://github.com/nginx/kubernetes-ingress/tree/v5.0.0/examples/custom-resources/rate-limit-tiered-jwt-claim/) for a working example.

We introduced NGINX Plus Zone Sync as a managed service within NGINX Ingress Controller in this release.  In previous releases, we had examples using `stream-snippets` for OIDC support, users can now enable `zone-sync` without the need for `snippets`.  NGINX Plus Zone Sync is available when utilising two or more replicas, it supports OIDC & rate limiting.

{{< call-out "note" >}}

For users who have previously installed OIDC or used the `zone_sync` directive with `stream-snippets`, please see the note in the [Configmap resources]({{< ref "/nic/configuration/global-configuration/configmap-resource.md#zone-sync" >}}) topic to use the new `zone-sync` ConfigMap option.

{{< /call-out >}}

Open Source NGINX Ingress Controller architectures `armv7`, `s390x` & `ppc64le` are deprecated and will be removed in the next minor release.

### <i class="fa-solid fa-bomb"></i> Breaking Changes

- [7633](https://github.com/nginx/kubernetes-ingress/pull/7633) & [7567](https://github.com/nginx/kubernetes-ingress/pull/7567) Remove OpenTracing support

### <i class="fa-solid fa-rocket"></i> Features

- [7054](https://github.com/nginx/kubernetes-ingress/pull/7054) Increase port number range
- [7175](https://github.com/nginx/kubernetes-ingress/pull/7175) Ratelimit based on JWT claim
- [7205](https://github.com/nginx/kubernetes-ingress/pull/7205), [7238](https://github.com/nginx/kubernetes-ingress/pull/7238), [7390](https://github.com/nginx/kubernetes-ingress/pull/7390) & [7393](https://github.com/nginx/kubernetes-ingress/pull/7393) Tiered Rate limit groups with JWT claim
- [7239](https://github.com/nginx/kubernetes-ingress/pull/7239), [7347](https://github.com/nginx/kubernetes-ingress/pull/7347), [7445](https://github.com/nginx/kubernetes-ingress/pull/7445), [7468](https://github.com/nginx/kubernetes-ingress/pull/7468), [7521](https://github.com/nginx/kubernetes-ingress/pull/7521) & [7654](https://github.com/nginx/kubernetes-ingress/pull/7654) Zone Sync support
- [7560](https://github.com/nginx/kubernetes-ingress/pull/7560) Add forward proxy support for NGINX Plus licensing connectivity
- [7299](https://github.com/nginx/kubernetes-ingress/pull/7299) & [7597](https://github.com/nginx/kubernetes-ingress/pull/7597) Add support for NGINX OSS 1.27.4, NGINX Plus R34 & F5 WAF for NGINX 4.13 & 5.6

### <i class="fa-solid fa-bug-slash"></i> Fixes

- [7121](https://github.com/nginx/kubernetes-ingress/pull/7121) Clean up and fix for NIC Pod failing to bind when NGINX exits unexpectedly
- [7185](https://github.com/nginx/kubernetes-ingress/pull/7185) Correct typo in helm lease annotations template
- [7400](https://github.com/nginx/kubernetes-ingress/pull/7400) Add tracking.info and copy into plus images
- [7519](https://github.com/nginx/kubernetes-ingress/pull/7519) Add NGINX state directory for ReadOnlyRootFilesystem

### <i class="fa-solid fa-box"></i> Helm Chart

- [7318](https://github.com/nginx/kubernetes-ingress/pull/7318) Allow customization of service http and https port names through helm

### <i class="fa-solid fa-upload"></i> Dependencies

- [6964](https://github.com/nginx/kubernetes-ingress/pull/6964), [6970](https://github.com/nginx/kubernetes-ingress/pull/6970), [6978](https://github.com/nginx/kubernetes-ingress/pull/6978), [6992](https://github.com/nginx/kubernetes-ingress/pull/6992), [7017](https://github.com/nginx/kubernetes-ingress/pull/7017), [7052](https://github.com/nginx/kubernetes-ingress/pull/7052), [7105](https://github.com/nginx/kubernetes-ingress/pull/7105), [7131](https://github.com/nginx/kubernetes-ingress/pull/7131), [7122](https://github.com/nginx/kubernetes-ingress/pull/7122), [7138](https://github.com/nginx/kubernetes-ingress/pull/7138), [7149](https://github.com/nginx/kubernetes-ingress/pull/7149), [7162](https://github.com/nginx/kubernetes-ingress/pull/7162), [7225](https://github.com/nginx/kubernetes-ingress/pull/7225), [7240](https://github.com/nginx/kubernetes-ingress/pull/7240), [7262](https://github.com/nginx/kubernetes-ingress/pull/7262), [7290](https://github.com/nginx/kubernetes-ingress/pull/7290), [7312](https://github.com/nginx/kubernetes-ingress/pull/7312), [7345](https://github.com/nginx/kubernetes-ingress/pull/7345), [7362](https://github.com/nginx/kubernetes-ingress/pull/7362), [7375](https://github.com/nginx/kubernetes-ingress/pull/7375), [7385](https://github.com/nginx/kubernetes-ingress/pull/7385), [7415](https://github.com/nginx/kubernetes-ingress/pull/7415), [7403](https://github.com/nginx/kubernetes-ingress/pull/7403), [7435](https://github.com/nginx/kubernetes-ingress/pull/7435), [7459](https://github.com/nginx/kubernetes-ingress/pull/7459), [7472](https://github.com/nginx/kubernetes-ingress/pull/7472), [7483](https://github.com/nginx/kubernetes-ingress/pull/7483), [7505](https://github.com/nginx/kubernetes-ingress/pull/7505), [7501](https://github.com/nginx/kubernetes-ingress/pull/7501), [7522](https://github.com/nginx/kubernetes-ingress/pull/7522), [7543](https://github.com/nginx/kubernetes-ingress/pull/7543), [7594](https://github.com/nginx/kubernetes-ingress/pull/7594), [7619](https://github.com/nginx/kubernetes-ingress/pull/7619), [7635](https://github.com/nginx/kubernetes-ingress/pull/7635) & [7650](https://github.com/nginx/kubernetes-ingress/pull/7650) Bump Go dependencies
- [7607](https://github.com/nginx/kubernetes-ingress/pull/7607) Bump Go version to 1.24.2
- [7006](https://github.com/nginx/kubernetes-ingress/pull/7006), [7016](https://github.com/nginx/kubernetes-ingress/pull/7016), [7020](https://github.com/nginx/kubernetes-ingress/pull/7020), [7045](https://github.com/nginx/kubernetes-ingress/pull/7045), [7069](https://github.com/nginx/kubernetes-ingress/pull/7069), [7080](https://github.com/nginx/kubernetes-ingress/pull/7080), [7099](https://github.com/nginx/kubernetes-ingress/pull/7099), [7115](https://github.com/nginx/kubernetes-ingress/pull/7115), [7132](https://github.com/nginx/kubernetes-ingress/pull/7132), [7140](https://github.com/nginx/kubernetes-ingress/pull/7140), [7150](https://github.com/nginx/kubernetes-ingress/pull/7150), [7173](https://github.com/nginx/kubernetes-ingress/pull/7173), [7243](https://github.com/nginx/kubernetes-ingress/pull/7243), [7256](https://github.com/nginx/kubernetes-ingress/pull/7256), [7288](https://github.com/nginx/kubernetes-ingress/pull/7288), [7293](https://github.com/nginx/kubernetes-ingress/pull/7293), [7306](https://github.com/nginx/kubernetes-ingress/pull/7306), [7309](https://github.com/nginx/kubernetes-ingress/pull/7309), [7319](https://github.com/nginx/kubernetes-ingress/pull/7319), [7376](https://github.com/nginx/kubernetes-ingress/pull/7376), [7409](https://github.com/nginx/kubernetes-ingress/pull/7409), [7404](https://github.com/nginx/kubernetes-ingress/pull/7404), [7452](https://github.com/nginx/kubernetes-ingress/pull/7452), [7454](https://github.com/nginx/kubernetes-ingress/pull/7454), [7461](https://github.com/nginx/kubernetes-ingress/pull/7461), [7474](https://github.com/nginx/kubernetes-ingress/pull/7474), [7490](https://github.com/nginx/kubernetes-ingress/pull/7490), [7511](https://github.com/nginx/kubernetes-ingress/pull/7511), [7523](https://github.com/nginx/kubernetes-ingress/pull/7523), [7527](https://github.com/nginx/kubernetes-ingress/pull/7527), [7534](https://github.com/nginx/kubernetes-ingress/pull/7534), [7539](https://github.com/nginx/kubernetes-ingress/pull/7539), [7551](https://github.com/nginx/kubernetes-ingress/pull/7551), [7564](https://github.com/nginx/kubernetes-ingress/pull/7564), [7590](https://github.com/nginx/kubernetes-ingress/pull/7590), [7631](https://github.com/nginx/kubernetes-ingress/pull/7631) & [7467](https://github.com/nginx/kubernetes-ingress/pull/7467) Bump Docker dependencies

### <i class="fa-solid fa-download"></i> Upgrade

- For NGINX Open Source, use the 5.0.0 images from our
[DockerHub](https://hub.docker.com/r/nginx/nginx-ingress/tags?page=1&ordering=last_updated&name=5.0.0),
[GitHub Container](https://github.com/nginx/kubernetes-ingress/pkgs/container/kubernetes-ingress),
[Amazon ECR Public Gallery](https://gallery.ecr.aws/nginx/nginx-ingress) or [Quay.io](https://quay.io/repository/nginx/nginx-ingress).
- For NGINX Plus, use the 5.0.0 images from the F5 Container registry or build your own image using the 5.0.0 source code
- For Helm, use version 2.1.0 of the chart.

### <i class="fa-solid fa-life-ring"></i> Supported Platforms

We will provide technical support for NGINX Ingress Controller on any Kubernetes platform that is currently supported by
its provider and that passes the Kubernetes conformance tests. This release was fully tested on the following Kubernetes
versions: 1.25-1.32.

## 4.0.1

07 Feb 2025

### <i class="fa-solid fa-bug-slash"></i> Fixes

- [7295](https://github.com/nginx/kubernetes-ingress/pull/7295) Clean up and fix for NIC Pod failing to bind when NGINX exits unexpectedly

### <i class="fa-solid fa-box"></i> Helm Chart

{{< call-out "warning" >}} From this release onwards, the Helm chart location has changed from `oci://ghcr.io/nginxinc/charts/nginx-ingress` to `oci://ghcr.io/nginx/charts/nginx-ingress`. {{< /call-out >}}

- [7188](https://github.com/nginx/kubernetes-ingress/pull/7188) Correct typo in helm lease annotations template

### <i class="fa-solid fa-upload"></i> Dependencies

- [7301](https://github.com/nginx/kubernetes-ingress/pull/7301), [7307](https://github.com/nginx/kubernetes-ingress/pull/7307) & [7310](https://github.com/nginx/kubernetes-ingress/pull/7310) Update to nginx 1.27.4
- [7163](https://github.com/nginx/kubernetes-ingress/pull/7163) Bump Go version to 1.23.5
- [7024](https://github.com/nginx/kubernetes-ingress/pull/7024), [7061](https://github.com/nginx/kubernetes-ingress/pull/7061), [7113](https://github.com/nginx/kubernetes-ingress/pull/7113), [7145](https://github.com/nginx/kubernetes-ingress/pull/7145), [7148](https://github.com/nginx/kubernetes-ingress/pull/7148), [7154](https://github.com/nginx/kubernetes-ingress/pull/7154), [7164](https://github.com/nginx/kubernetes-ingress/pull/7164), [7229](https://github.com/nginx/kubernetes-ingress/pull/7229), [7265](https://github.com/nginx/kubernetes-ingress/pull/7265), [7250](https://github.com/nginx/kubernetes-ingress/pull/7250), [7296](https://github.com/nginx/kubernetes-ingress/pull/7296) & [7321](https://github.com/nginx/kubernetes-ingress/pull/7321) Bump Go dependencies
- [7012](https://github.com/nginx/kubernetes-ingress/pull/7012), [7022](https://github.com/nginx/kubernetes-ingress/pull/7022), [7028](https://github.com/nginx/kubernetes-ingress/pull/7028), [7144](https://github.com/nginx/kubernetes-ingress/pull/7144), [7152](https://github.com/nginx/kubernetes-ingress/pull/7152), [7155](https://github.com/nginx/kubernetes-ingress/pull/7155), [7181](https://github.com/nginx/kubernetes-ingress/pull/7181), [7267](https://github.com/nginx/kubernetes-ingress/pull/7267), [7302](https://github.com/nginx/kubernetes-ingress/pull/7302), [7304](https://github.com/nginx/kubernetes-ingress/pull/7304) & [7320](https://github.com/nginx/kubernetes-ingress/pull/7320) Bump Docker dependencies

### <i class="fa-solid fa-download"></i> Upgrade

- For NGINX, use the 4.0.1 images from our
[DockerHub](https://hub.docker.com/r/nginx/nginx-ingress/tags?page=1&ordering=last_updated&name=4.0.1),
[GitHub Container](https://github.com/nginx/kubernetes-ingress/pkgs/container/kubernetes-ingress),
[Amazon ECR Public Gallery](https://gallery.ecr.aws/nginx/nginx-ingress) or [Quay.io](https://quay.io/repository/nginx/nginx-ingress).
- For NGINX Plus, use the 4.0.1 images from the F5 Container registry or build your own image using the 4.0.1 source code
- For Helm, use version 2.0.1 of the chart.

### <i class="fa-solid fa-life-ring"></i> Supported Platforms

We will provide technical support for NGINX Ingress Controller on any Kubernetes platform that is currently supported by
its provider and that passes the Kubernetes conformance tests. This release was fully tested on the following Kubernetes
versions: 1.25-1.32.