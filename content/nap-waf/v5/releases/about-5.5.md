---
title: F5 WAF for NGINX 5.5
weight: 860
toc: true
type: reference
product: NAP-WAF
nd-docs: DOCS-1795
---

January 30th, 2025

---

## New features

- Added support for Alpine 3.19
- Added support for [Brute force attack preventions]({{< ref "/nap-waf/v5/configuration-guide/configuration.md#brute-force-attack-preventions" >}})
- Enforcer can now upgrade without requiring policies to be recompiled
- The standalone converter within the Compiler now supports [user-defined signatures]({{< ref "/nap-waf/v5/admin-guide/compiler.md#user-defined-signatures" >}}).

---

## Supported packages

### NGINX Open Source

| Distribution name        | Package file                                                      |
|--------------------------|-------------------------------------------------------------------|
| Alpine 3.17              | _app-protect-module-oss-1.27.2.5.264.0-r1.apk_                    |
| Alpine 3.19              | _app-protect-module-oss-1.27.2.5.264.0-r1.apk_                    |
| Debian 11                | _app-protect-module-oss_1.27.2+5.264.0-1\~bullseye_amd64.deb_     |
| Debian 12                | _app-protect-module-oss_1.27.2+5.264.0-1\~bookworm_amd64.deb_     |
| Ubuntu 20.04             | _app-protect-module-oss_1.27.2+5.264.0-1\~focal_amd64.deb_        |
| Ubuntu 22.04             | _app-protect-module-oss_1.27.2+5.264.0-1\~jammy_amd64.deb_        |
| Ubuntu 24.04             | _app-protect-module-oss_1.27.2+5.264.0-1\~noble_amd64.deb_        |
| Amazon Linux 2023        | _app-protect-module-oss-1.27.2+5.264.0-1.amzn2023.ngx.x86_64.rpm_ |
| RHEL 8 and Rocky Linux 8 | _app-protect-module-oss-1.27.2+5.264.0-1.el8.ngx.x86_64.rpm_      |
| RHEL 9                   | _app-protect-module-oss-1.27.2+5.264.0-1.el9.ngx.x86_64.rpm_      |
| Oracle Linux 8.1         | _app-protect-module-oss-1.27.2+5.264.0-1.el8.ngx.x86_64.rpm_      |

### NGINX Plus

| Distribution name        | Package file                                                   |
|--------------------------|----------------------------------------------------------------|
| Alpine 3.17              | _app-protect-module-plus-33.5.264.0-r1.apk_                    |
| Alpine 3.19              | _app-protect-module-plus-33.5.264.0-r1.apk_                    |
| Debian 11                | _app-protect-module-plus_33+5.264.0-1\~bullseye_amd64.deb_     |
| Debian 12                | _app-protect-module-plus_33+5.264.0-1\~bookworm_amd64.deb_     |
| Ubuntu 20.04             | _app-protect-module-plus_33+5.264.0-1\~focal_amd64.deb_        |
| Ubuntu 22.04             | _app-protect-module-plus_33+5.264.0-1\~jammy_amd64.deb_        |
| Ubuntu 24.04             | _app-protect-module-plus_33+5.264.0-1\~noble_amd64.deb_        |
| Amazon Linux 2023        | _app-protect-module-plus-33+5.264.0-1.amzn2023.ngx.x86_64.rpm_ |
| RHEL 8 and Rocky Linux 8 | _app-protect-module-plus-33+5.264.0-1.el8.ngx.x86_64.rpm_      |
| RHEL 9                   | _app-protect-module-plus-33+5.264.0-1.el9.ngx.x86_64.rpm_      |
| Oracle Linux 8.1         | _app-protect-module-plus-33+5.264.0-1.el8.ngx.x86_64.rpm_      |
