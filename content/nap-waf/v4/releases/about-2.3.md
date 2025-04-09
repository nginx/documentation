---
title: NGINX App Protect WAF 2.3
weight: 920
toc: true
type: reference
product: NAP-WAF
docs: DOCS-656
---

December 30, 2020

### New Features

- [Debian 10 Support]({{< ref "/nap-waf/v4/admin-guide/install.md#debian-10-installation" >}})
- [Alpine 3.10 Support]({{< ref "/nap-waf/v4/admin-guide/install.md#alpine-3-10-installation" >}})
- [User-defined HTTP Headers]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#user-defined-http-headers" >}})
- [Converter Tools]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#converter-tools" >}})
- [Attack Signature Report Tool]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#attack-signature-report-tool" >}})

### Supported Packages

#### App Protect

##### Debian 9

- app-protect_23+3.281.0-1~stretch_amd64.deb

##### Debian 10

- app-protect_23+3.281.0-1~buster_amd64.deb

##### Ubuntu

- app-protect_23+3.281.0-1~bionic_amd64.deb

##### Alpine 3.10

- app-protect-23.3.281.0-r1.apk

##### CentOS / RHEL

- app-protect-23+3.281.0-1.el7.ngx.x86_64.rpm

### Resolved Issues

- 1270 Fixed - Unit hostname `N/A` in security log.

### Known Issues

#### 3014 - HTTP2 browser traffic is classified as bot

- Workaround - Disable bot defense in policies used on HTTP2 locations.
