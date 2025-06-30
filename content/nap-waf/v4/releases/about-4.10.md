---
title: NGINX App Protect WAF 4.10
weight: 130
toc: true
type: reference
product: NAP-WAF
docs: DOCS-1787
---

May 29, 2024

{{< note >}}
Release 4.8.1 cannot be upgraded to v4.10.  You must uninstall 4.8.1 and install 4.10.  Upgrade is supported for versions prior to 4.8.1.
{{< /note >}}

### New Features

In this release, NGINX App Protect WAF supports NGINX Plus R32.


### Supported Packages

#### App Protect


##### Alpine Linux 3.16 

- app-protect-32.5.48.0-r1.apk

##### Alpine Linux 3.17

- app-protect-32.5.48.0-r1.apk

##### CentOS 7.4+ / RHEL 7.4+ / Amazon Linux 2

- app-protect-32+5.48.0-1.el7.ngx.x86_64.rpm

##### Debian 11

- app-protect_32+5.48.0-1~bullseye_amd64.deb

##### Debian 12

- app-protect_32+5.48.0-1~bookworm_amd64.deb

##### Oracle Linux 8.1+

- app-protect-32+5.48.0-1.el8.ngx.x86_64.rpm

##### RHEL 8.1+ 

- app-protect-32+5.48.0-1.el8.ngx.x86_64.rpm

##### RHEL 9+

- app-protect-32+5.48.0-1.el9.ngx.x86_64.rpm

##### Ubuntu 20.04

- app-protect_32+5.48.0-1~focal_amd64.deb

##### Ubuntu 22.04

- app-protect_32+5.48.0-1~jammy_amd64.deb


### Resolved Issues

- 11038 Fixed- In some scenarios, autodetect does not correctly recognize the internal buffer as base_64 buffer and so does not decode the data.
- 11105 Fixed - Update libprotobuf to version 1.33.0+.

