---
title: NGINX App Protect WAF 3.2
weight: 780
toc: true
type: reference
product: NAP-WAF
docs: DOCS-659
---

April 28, 2021

### New Features

In this release support for NGINX App Protect WAF is added to NGINX Plus R24, for which Debian 9 support has been deprecated.

- [Multiple Security Logs Support]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#app-protect-security-log" >}})
- [Default Policy Location Update]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#basic-configuration-and-the-default-policy" >}})
- [Tighten Default Enforcer Cookie Settings]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#enforcer-cookie-settings" >}})

### Supported Packages

#### App Protect

##### Debian 10

- app-protect_24+3.512.0-1~buster_amd64.deb

##### Ubuntu 18.04

- app-protect_24+3.512.0-1~bionic_amd64.deb

##### Ubuntu 20.04

- app-protect_24+3.512.0-1~focal_amd64.deb

##### Alpine 3.10

- app-protect-24.3.512.0-r1.apk

##### CentOS / RHEL

- app-protect-24+3.512.0-1.el7.ngx.x86_64.rpm

### Resolved Issues

- 3586 Fixed - Incorrect base64 cookie value in security log
- 3705 Fixed - SELinux alerts on reload
- 3706 Fixed - Reload failure as a result of a file descriptor leak
- 3708 Fixed - JSON characters in log format failure
- 3709 Fixed - Spaces in JSON values are disallowed
- 3710 Added - Allow `http-protocols` `High ASCII characters in headers` to be configurable
