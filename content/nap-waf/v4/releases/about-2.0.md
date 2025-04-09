---
title: NGINX App Protect WAF 2.0
weight: 980
toc: true
type: reference
product: NAP-WAF
docs: DOCS-653
---

September 08, 2020

### New Features

- [Ubuntu 18.04 Support]({{< ref "/nap-waf/v4/admin-guide/install.md#ubuntu-18-04-installation" >}})
- [OpenAPI Support]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#openapi-specification-file-reference" >}})
- [JSON Schema Validation]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#applying-a-json-schema" >}})
- [User-Defined Signatures]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#user-defined-signatures" >}})
- [User-Defined URLs]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#user-defined-urls" >}})
- [User-Defined Parameters]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#user-defined-parameters" >}})
- [Offline Installation]({{< ref "/nap-waf/v4/admin-guide/install.md#offline-installation" >}})


### Supported Packages

#### App Protect

##### Debian

- app-protect_22+3.158.1-1~stretch_amd64.deb

##### Ubuntu

- app-protect_22+3.158.1-1~bionic_amd64.deb

##### CentOS / RHEL

- app-protect-22+3.158.1-1.el7.ngx.x86_64.rpm

### Resolved Issues

- 1868 Fixed - Removal of the app-protect RPM package results in SELinux-related failure messages.
- 2099 Fixed - Missing SELinux configuration required to support writing the security log to a file.
- 2119 Fixed - Logging Profiles do not disassociate from location when multiple changes are made.
- 2134 Fixed - No security logs for requests on servers using IPv6 addresses.
