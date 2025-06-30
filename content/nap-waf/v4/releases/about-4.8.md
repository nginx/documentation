---
title: NGINX App Protect WAF 4.8
weight: 160
toc: true
type: reference
product: NAP-WAF
nd-docs: DOCS-1391
---

February 6, 2024


### New Features

- [Debian 12 Support]({{< ref "/nap-waf/v4/admin-guide/install.md#debian-10--debian-11--debian-12-installation" >}})
- [Actionable Rules in Override Rules Policy]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#override-rules" >}})
- [Geolocation Enforcement]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#geolocation-support-in-app-protect" >}})
- [Partial Masking of Data using Data Guard]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#partial-masking-of-data-using-data-guard" >}})


### Supported Packages

#### App Protect

##### Alpine 3.16

- app-protect-31.4.762.0-r1.apk

##### Alpine 3.17

- app-protect-31.4.762.0-r1.apk

##### CentOS 7.4+ / RHEL 7.4+ / Amazon Linux 2

- app-protect-31+4.762.0-1.el7.ngx.x86_64.rpm

##### Debian 11

- app-protect_31+4.762.0-1~bullseye_amd64.deb

##### Debian 12

- app-protect_31+4.762.0-1~bookworm_amd64.deb

##### Oracle Linux 8.1+

- app-protect-31+4.762.0-1.el8.ngx.x86_64.rpm

##### RHEL 8.1+

- app-protect-31+4.762.0-1.el8.ngx.x86_64.rpm

##### RHEL 9+

- app-protect-31+4.762.0-1.el9.ngx.x86_64.rpm

##### Ubuntu 20.04

- app-protect_31+4.762.0-1~focal_amd64.deb

##### Ubuntu 22.04

- app-protect_31+4.762.0-1~jammy_amd64.deb


### Resolved Issues

- 10063 Fixed - In some cases request could hang in when urlContentProfiles type set to "do-nothing".
- 10156 Fixed - Chunked requests connection is stuck in CLOSE_WAIT state.


### **Important Note**

- Actionable Rules and Geolocation are now supported in [Policy Override Rules]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#override-rules" >}}).
