---
description: ''
docs: 
doctypes:
- concept
title: NGINX App Protect WAF Release 4.11
toc: true
weight: 120
---

September 25, 2024

{{< note >}}
Release 4.8.1 cannot be upgraded to v4.11. You must uninstall 4.8.1 and install 4.11. Upgrade is supported for versions prior to 4.8.1.
{{< /note >}}

### New Feature

- [Ubuntu 24.04 support]({{< relref "/nap-waf/v4/admin-guide/install.md#ubuntu-1804--ubuntu-2004--ubuntu-2204--ubuntu-2404-installation" >}})


### Supported Packages

#### App Protect

##### Alpine Linux 3.16 / Alpine Linux 3.17

- app-protect-32.5.144.0-r1.apk

##### Debian 11

- app-protect_32+5.144.0-1~bullseye_amd64.deb

##### Debian 12

- app-protect_32+5.144.0-1~bookworm_amd64.deb

##### Oracle Linux 8.1+

- app-protect-32+5.144.0-1.el8.ngx.x86_64.rpm

##### RHEL 8.1+ 

- app-protect-32+5.144.0-1.el8.ngx.x86_64.rpm

##### RHEL 9+

- app-protect-32+5.144.0-1.el9.ngx.x86_64.rpm

##### Ubuntu 20.04

- app-protect_32+5.144.0-1~focal_amd64.deb

##### Ubuntu 22.04

- app-protect_32+5.144.0-1~jammy_amd64.deb

##### Ubuntu 24.04

- app-protect_32+5.144.0-1~noble_amd64.deb


### Resolved Issues

- 10775 Fixed - Resolved a threshold calculation in the base64 decoding mechanism.
- 11426 Fixed - Resolved log entry of an XFF header that contains more than one value.
- 11272 Fixed - Resolved an issue where, in certain instances, the original HTTP response code was shown for rejected requests.
- 5302 Fixed - The enforcer leaves an incomplete job when NGINX reloads during DNS resolution.

### **Important Note**
- Starting from this release, CentOS 7.4, Rhel 7.4 and Amazon Linux 2 support has been deprecated.
