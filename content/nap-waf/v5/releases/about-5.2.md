---
title: NGINX App Protect WAF 5.2
weight: 890
toc: true
type: reference
product: NAP-WAF
docs: DOCS-000
---

May 29, 2024

{{< include "nap-waf/upgrade-recompile-warning.md" >}}

---

### New features

In this release, F5 NGINX App Protect WAF supports NGINX Open Source 1.25.5 and NGINX Plus R32.

- [Apreload support]({{<ref "nap-waf/v5/configuration-guide/configuration.md#apreload">}})

---

### Resolved issues

- 11038 Fixed - In some scenarios, autodetect does not correctly recognize the internal buffer as base_64 buffer and so does not decode the data.
- 11059 Fixed - Enforcer may crash in specific scenarios.
- 11105 Fixed - Update libprotobuf to version 1.33.0+.
- 11148 Fixed - When following the config guide for starting NAP v5 in docker or kubernetes and leaving nginx.conf without any 'app_protect' directive:  changing the conf to include NAP does not work. Enforcer times out every 40 secs waiting for the configuration.

---

### Supported packages

#### App Protect Module for NGINX Open Source

##### Alpine Linux 3.16 / Alpine Linux 3.17

- app-protect-module-oss-1.25.5.5.48.0-r1.apk

##### Debian 11

- app-protect-module-oss_1.25.5+5.48.0-1~bullseye_amd64.deb

##### Debian 12

- app-protect-module-oss_1.25.5+5.48.0-1~bookworm_amd64.deb

##### Ubuntu 20.04

- app-protect-module-oss_1.25.5+5.48.0-1~focal_amd64.deb

##### Ubuntu 22.04

- app-protect-module-oss_1.25.5+5.48.0-1~jammy_amd64.deb

##### RHEL 7.4+ / CentOS 7.4+ / Amazon Linux 2

- app-protect-module-oss-1.25.5+5.48.0-1.el7.ngx.x86_64.rpm

##### RHEL 8.1+ / Oracle Linux 8.1+

- app-protect-module-oss-1.25.5+5.48.0-1.el8.ngx.x86_64.rpm

##### RHEL 9+

- app-protect-module-oss-1.25.5+5.48.0-1.el9.ngx.x86_64.rpm

#### App Protect Module for NGINX Plus

##### Alpine Linux 3.16 / Alpine Linux 3.17

- app-protect-module-plus-32.5.48.0-r1.apk

##### Debian 11

- app-protect-module-plus_32+5.48.0-1~bullseye_amd64.deb

##### Debian 12

- app-protect-module-plus_32+5.48.0-1~bookworm_amd64.deb

##### Ubuntu 20.04

- app-protect-module-plus_32+5.48.0-1~focal_amd64.deb

##### Ubuntu 22.04

- app-protect-module-plus_32+5.48.0-1~jammy_amd64.deb

##### RHEL 7.4+ / CentOS 7.4+ / Amazon Linux 2

- app-protect-module-plus-32+5.48.0-1.el7.ngx.x86_64.rpm

##### RHEL 8.1+ / Oracle Linux 8.1+

- app-protect-module-plus-32+5.48.0-1.el8.ngx.x86_64.rpm

##### RHEL 9+

- app-protect-module-plus-32+5.48.0-1.el9.ngx.x86_64.rpm