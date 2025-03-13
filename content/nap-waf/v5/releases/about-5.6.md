---
title: NGINX App Protect WAF 5.6
weight: 850
toc: true
type: reference
product: NAP-WAF
docs: DOCS-000
---

March 18th, 2025

---

## New features

- You can now install NGINX App Protect WAF 5+ using a Helm chart
- NGINX App Protect WAF Enforcer now supports multiple signature versions
- Changed the maximum memory of the XML processing engine to 8GB
- Upgraded the Go compiler to 1.23.7

---

## Known issues

- "Violation Encoding" is not enabled by default
- "Violation Bad Unescape" is not enabled by default

---

## Important notes

- Alpine 3.17 is no longer supported

---


## Supported packages

### NGINX Open Source

| Distribution name        | Package file                                                      |
|--------------------------|-------------------------------------------------------------------|
| Alpine 3.19              | _app-protect-module-oss-1.27.####.0-r1.apk_                    |
| Debian 11                | _app-protect-module-oss_1.27.####.0-1\~bullseye_amd64.deb_     |
| Debian 12                | _app-protect-module-oss_1.27.####.0-1\~bookworm_amd64.deb_     |
| Ubuntu 20.04             | _app-protect-module-oss_1.27.####.0-1\~focal_amd64.deb_        |
| Ubuntu 22.04             | _app-protect-module-oss_1.27.####.0-1\~jammy_amd64.deb_        |
| Ubuntu 24.04             | _app-protect-module-oss_1.27.####.0-1\~noble_amd64.deb_        |
| Amazon Linux 2023        | _app-protect-module-oss-1.27.####.0-1.amzn2023.ngx.x86_64.rpm_ |
| RHEL 8 and Rocky Linux 8 | _app-protect-module-oss-1.27.####.0-1.el8.ngx.x86_64.rpm_      |
| RHEL 9                   | _app-protect-module-oss-1.27.####.0-1.el9.ngx.x86_64.rpm_      |
| Oracle Linux 8.1         | _app-protect-module-oss-1.27.####.0-1.el8.ngx.x86_64.rpm_      |

### NGINX Plus

| Distribution name        | Package file                                                   |
|--------------------------|----------------------------------------------------------------|
| Alpine 3.19              | _app-protect-module-plus-33.####.0-r1.apk_                    |
| Debian 11                | _app-protect-module-plus_33+####.0-1\~bullseye_amd64.deb_     |
| Debian 12                | _app-protect-module-plus_33+####.0-1\~bookworm_amd64.deb_     |
| Ubuntu 20.04             | _app-protect-module-plus_33+####.0-1\~focal_amd64.deb_        |
| Ubuntu 22.04             | _app-protect-module-plus_33+####.0-1\~jammy_amd64.deb_        |
| Ubuntu 24.04             | _app-protect-module-plus_33+####.0-1\~noble_amd64.deb_        |
| Amazon Linux 2023        | _app-protect-module-plus-33+####.0-1.amzn2023.ngx.x86_64.rpm_ |
| RHEL 8 and Rocky Linux 8 | _app-protect-module-plus-33+####.0-1.el8.ngx.x86_64.rpm_      |
| RHEL 9                   | _app-protect-module-plus-33+####.0-1.el9.ngx.x86_64.rpm_      |
| Oracle Linux 8.1         | _app-protect-module-plus-33+####.0-1.el8.ngx.x86_64.rpm_      |
