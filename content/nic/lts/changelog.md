---
title: Changelog
url: /nginx-ingress-controller/lts/changelog
weight: 10200
f5-landing-page: true
f5-content-type: reference
f5-product: NGINX Ingress Controller
nollms: true
---

## New release model {#intro}

Since June 4, 2026, NGINX Ingress Controller follows a new release model: Long-Term Support (LTS) and Continuous Releases (CR).

**NGINX Ingress Controller Long-Term Support (LTS) Releases** are published once a year and focus on stability and security. Each LTS version is supported for up to three years and receives only security and stability bug fixes during this time. New features are delivered through Continuous Releases (CRs) within the LTS release period.

**NGINX Ingress Controller Continuous Releases (CR)** are published multiple times during the life of the latest LTS release and include the newest features and performance improvements

{{< details summary="NGINX Ingress Controller LTS compatibility matrix" open=false >}}

{{< include "/nic/compatibility-tables/nic-lts-k8s.md" >}}

{{< /details >}}

{{< call-out "note" "Important" >}} Since June 3, 2026, NGINX Ingress Controller transitions to a new release model: Long-Term Support Releases (LTS) and Continuous Releases (CR). {{< /call-out >}}

This changelog lists all of the information for F5 NGINX Ingress Controller LTS.

## 2026-lts-r3

## 2026-lts-r2

18 Jun 2026

### {{% icon bug %}} Fixes

- [10162](https://github.com/nginx/kubernetes-ingress/pull/10162) Update oidc njs code

### {{% icon arrow-up %}} Dependencies

- Update NGINX Plus to 37.0.2.1 LTS

## 2026-lts-r1

4 Jun 2026

Based on NIC v5.4.3. See [Changelog]({{<ref "/nic/changelog/#543">}}).
