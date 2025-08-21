---
title: F5 WAF for NGINX 3.1
weight: 790
toc: true
type: reference
product: NAP-WAF
nd-docs: DOCS-658
---

March 31, 2021

### New Features

- [User-Defined Browser Control]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#user-defined-browser-control" >}})
- [CSRF Protection Using Origin Validation]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#csrf-protection-using-origin-validation" >}})
- [Clickjacking Protection]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#clickjacking-protection" >}})
- [Log Rotate]({{< ref "/nap-waf/v4/admin-guide/install.md#log-rotate" >}})
- [Enforcer Cookie Settings]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#enforcer-cookie-settings" >}})
- [Ubuntu 20.04 Support]({{< ref "/nap-waf/v4/admin-guide/install.md#ubuntu-20-04-installation" >}})

### Supported Packages

#### App Protect

##### Debian 9

- app-protect_23+3.462.0-1~stretch_amd64.deb

##### Debian 10

- app-protect_23+3.462.0-1~buster_amd64.deb

##### Ubuntu 18.04

- app-protect_23+3.462.0-1~bionic_amd64.deb

##### Ubuntu 20.04

- app-protect_23+3.462.0-1~focal_amd64.deb

##### Alpine 3.10

- app-protect-23.3.462.0-r1.apk

##### CentOS / RHEL

- app-protect-23+3.462.0-1.el7.ngx.x86_64.rpm

### Resolved Issues

- 3157 Fixed - Header settings case sensitivity issue
- 3259 Fixed - Disallow multiple cookie headers in request
- 3351 Fixed - Date-Time and Date formatted parameters in OpenAPI accept malformed values
- 3353 Fixed - ExclusiveMinimum in OpenAPI not enforced
- 3551 Fixed - Incorrect violation rating when low severity sub-violations are triggered
- 3576 Fixed - Cookie deletion configuration issue
- 3606 Fixed - Blocked logging filter is working incorrectly
