---
title: NGINX App Protect WAF 3.3
weight: 770
toc: true
type: reference
product: NAP-WAF
nd-docs: DOCS-660
---

July 7, 2021

### New Features

- [Amazon Linux 2 LTS Support]({{< ref "/nap-waf/v4/admin-guide/install.md#amazon-linux-2-lts-installation" >}})
- [Base64 auto-detection applies on JSON content type]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#xml-and-json-content-profiles" >}})
- [Full security policy export includes the policy base template]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#policy-converter" >}})
- [FQDNs are now permitted in syslog destinations]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#security-logs" >}})


### Supported Packages

#### App Protect

##### Debian 10

- app-protect_24+3.583.0-1~buster_amd64.deb

##### Ubuntu 18.04

- app-protect_24+3.583.0-1~bionic_amd64.deb

##### Ubuntu 20.04

- app-protect_24+3.583.0-1~focal_amd64.deb

##### Alpine 3.10

- app-protect-24.3.583.0-r1.apk

##### CentOS / RHEL

- app-protect-24+3.583.0-1.el7.ngx.x86_64.rpm

##### Amazon Linux 2

- app-protect-24+3.583.0-1.el7.ngx.x86_64.rpm

### Resolved Issues

- 4214 Fixed - Cookie false positives blocked requests and false reporting
- 4226 Fixed - Error in parsing OpenAPI file
- 4318 Fixed - Incorrect Export for convert-policy - gwt-content-profiles are not exported in NGINX App Protect WAF policy converter anymore.

### Known Issues

#### 4347 - Missing dependency of python3 for Alpine Linux

- Workaround - run `apk add python3` before installing NGINX App Protect WAF on Alpine Linux
