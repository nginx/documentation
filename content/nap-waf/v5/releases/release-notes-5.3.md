---
description: ''
docs: 
doctypes:
- concept
title: NGINX App Protect WAF Release 5.3
toc: true
weight: 880
---

September 25, 2024

{{< note >}}
All existing policy bundles and log bundles must be recompiled post upgrade using this version's WAF compiler. Older bundles will be detected and disallowed.   
{{< /note >}}

### New Features

- [Ubuntu 24.04 support]({{< relref "nap-waf/v5/admin-guide/install.md#common-steps-for-nginx-open-source-and-nginx-plus" >}})
- [Secure Traffic Between NGINX and App Protect Enforcer]({{< relref "/nap-waf/v5/configuration-guide/configuration.md#secure-traffic-between-nginx-and-app-protect-enforcer-using-mtls" >}})

### Supported Packages

#### App Protect Module for NGINX Open Source

##### Alpine Linux 3.16 / Alpine Linux 3.17

- app-protect-module-oss-1.25.5.5.144.0-r1.apk

##### Debian 11

- app-protect-module-oss_1.25.5+5.144.0-1~bullseye_amd64.deb

##### Debian 12

- app-protect-module-oss_1.25.5+5.144.0-1~bookworm_amd64.deb

##### Ubuntu 20.04

- app-protect-module-oss_1.25.5+5.144.0-1~focal_amd64.deb

##### Ubuntu 22.04

- app-protect-module-oss_1.25.5+5.144.0-1~jammy_amd64.deb

##### Ubuntu 24.04

- app-protect-module-oss_1.25.5+5.144.0-1~noble_amd64.deb	

##### RHEL 8.1+ / Oracle Linux 8.1+

- app-protect-module-oss-1.25.5+5.144.0-1.el8.ngx.x86_64.rpm

##### RHEL 9+

- app-protect-module-oss-1.25.5+5.144.0-1.el9.ngx.x86_64.rpm

#### App Protect Module for NGINX Plus

##### Alpine Linux 3.16 / Alpine Linux 3.17

- app-protect-module-plus-32.5.144.0-r1.apk

##### Debian 11

- app-protect-module-plus_32+5.144.0-1~bullseye_amd64.deb

##### Debian 12

- app-protect-module-plus_32+5.144.0-1~bookworm_amd64.deb

##### Ubuntu 20.04

- app-protect-module-plus_32+5.144.0-1~focal_amd64.deb

##### Ubuntu 22.04

- app-protect-module-plus_32+5.144.0-1~jammy_amd64.deb

##### Ubuntu 24.04

- app-protect-module-plus_32+5.144.0-1~noble_amd64.deb

##### RHEL 8.1+ / Oracle Linux 8.1+

- app-protect-module-plus-32+5.144.0-1.el8.ngx.x86_64.rpm

##### RHEL 9+

- app-protect-module-plus-32+5.144.0-1.el9.ngx.x86_64.rpm

### Resolved Issues

- 10775 Fixed - Resolved a threshold calculation in the base64 decoding mechanism.
- 11426 Fixed - Resolved log entry of an XFF header that contains more than one value.
- 11272 Fixed - Resolved an issue where, in certain instances, the original HTTP response code was shown for rejected requests.
- 11568 Fixed - Support seamless upgrades by using the latest tag instead of hardcoded versions.
- 5302 Fixed - The enforcer leaves an incomplete job when NGINX reloads during DNS resolution.

### **Important Note**
- Starting from this release, CentOS 7.4, Rhel 7.4 and Amazon Linux 2 support has been deprecated.