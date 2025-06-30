---
title: NGINX App Protect WAF 2.2
weight: 940
toc: true
type: reference
product: NAP-WAF
nd-docs: DOCS-655
---

December 09, 2020

### New Features

In this release support for NGINX App Protect WAF is added to NGINX Plus R23.

- [Detect Base64]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#detect-base64" >}})
- [Anti Automation Header Anomalies]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#header-anomalies" >}})

### Supported Packages

#### App Protect

##### Debian

- app-protect_23+3.263.0-1~stretch_amd64.deb

##### Ubuntu

- app-protect_23+3.263.0-1~bionic_amd64.deb

##### CentOS / RHEL

- app-protect-23+3.263.0-1.el7.ngx.x86_64.rpm

### Resolved Issues

- 2482 Fixed - 100% CPU reached on reload of new security log configuration during traffic.
- 2670 Fixed - Cookie value in security log violation details showed `name=value` instead of `value` for base64 decodable cookies.
- 2872 Fixed - Security logs get sent to the previous destination as well as the new one after reload.
