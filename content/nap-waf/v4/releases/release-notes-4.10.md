---
description: ''
docs: 
doctypes:
- concept
title: NGINX App Protect WAF Release 4.10
toc: true
weight: 130
---

May 29, 2024

{{< note >}}
Release 4.8.1 cannot be upgraded to v4.10.  You must uninstall 4.8.1 and install 4.10.  Upgrade is supported for versions prior to 4.8.1.
{{< /note >}}

### New Features

In this release, NGINX App Protect WAF supports NGINX Open Source 1.25.5 and NGINX Plus R32.


### Supported Packages

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

- app-protect-module-oss-1.25.54+5.48.0-1.el8.ngx.x86_64.rpm

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


### Resolved Issues

- 11038 Fixed- In some scenarios, autodetect does not correctly recognize the internal buffer as base_64 buffer and so does not decode the data.
- 11059 Fixed - Enforcer may crash in specific scenarios.
- 11105 Fixed - Update libprotobuf to version 1.33.0+.

