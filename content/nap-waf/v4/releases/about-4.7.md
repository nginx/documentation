---
title: NGINX App Protect WAF 4.7
weight: 170
toc: true
type: reference
product: NAP-WAF
nd-docs: DOCS-1360
---

December 19, 2023

In this release, NGINX App Protect WAF supports NGINX Plus R31.

### New Features

- [RHEL 9+ Support]({{< ref "/nap-waf/v4/admin-guide/install.md#rhel-9-installation" >}})


### Supported Packages

#### App Protect

##### Alpine 3.16

- app-protect-31.4.641.0-r1.apk

##### Alpine 3.17

- app-protect-31.4.641.0-r1.apk

##### CentOS 7.4+ / RHEL 7.4+ / Amazon Linux 2

- app-protect-31+4.641.0-1.el7.ngx.x86_64.rpm

##### Debian 11

- app-protect_31+4.641.0-1~bullseye_amd64.deb

##### Oracle Linux 8.1+

- app-protect-31+4.641.0-1.el8.ngx.x86_64.rpm

##### RHEL 8.1+

- app-protect-31+4.641.0-1.el8.ngx.x86_64.rpm

##### RHEL 9+

- app-protect-31+4.641.0-1.el9.ngx.x86_64.rpm

##### Ubuntu 20.04

- app-protect_31+4.641.0-1~focal_amd64.deb

##### Ubuntu 22.04

- app-protect_31+4.641.0-1~jammy_amd64.deb


#### NGINX Plus

- NGINX Plus R31


### Resolved Issues

- 9065 Fixed - Increasing the limit for "max_request_size" in log configuration from 2k to 10k. The default will change from "any" to 2k to maintain the old behaviour.
- 9297 Fixed - Add new limit from `responseCheckLength` to response ingress event handling in order to reduce the memory used for buffering.

### Limitation

- 9992 - There is a limitation on Edwards-curve Digital Signature Algorithm (EdDSA) protocol on CentOS 7 as the Enforcer does not support this protocol on this Operating System (OS). When a JSON Web Token (JWT) signed with EdDSA is used on CentOS 7, it results in a `VIOL_ACCESS_INVALID` error.

### **Important Notes**

- Starting with this release, the bot signatures list is generated automatically as a part of the **app-protect-bot-signatures** package, which is a dependency of the **app-protect-compiler** package. It resembles a format similar to the README-style text file found in the attack signature.
Refer to the [Bot Signatures Update File]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#bot-signatures-update-file" >}}) for more details.

- Starting with the next release version of NGINX App Protect WAF, the existing bot signatures file `included_bot_signatures` which is located at the following path: `/opt/app-protect/var/update_files/included_bot_signatures` will be removed from the **app-protect-compile** package.
