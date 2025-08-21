---
title: F5 WAF for NGINX 4.12
weight: 110
toc: true
type: reference
product: NAP-WAF
nd-docs: DOCS-1788
---

November 19th, 2024

---

### New features

- Added support for Amazon Linux 2023
- F5 WAF for NGINX now supports NGINX Plus R33.

Please read the [subscription licenses]({{< ref "/solutions/about-subscription-licenses.md" >}}) topic for information about R33.

---

### Important notes

- Alpine 3.16 is no longer supported.

---

### Resolved issues

- 11973 Fixed - Updated the Go version to 1.23.1
- 11469 Fixed _apt-get update_ warning for Ubuntu 22.04

---

### Supported packages

| Distribution name        | Package file                                       |
|--------------------------|----------------------------------------------------|
| Alpine 3.17              | _app-protect-33.5.210.0-r1.apk_                    |
| Debian 11                | _app-protect_33+5.210.0-1\~bullseye_amd64.deb_     |
| Debian 12                | _app-protect_33+5.210.0-1\~bookworm_amd64.deb_     |
| Ubuntu 20.04             | _app-protect_33+5.210.0-1\~focal_amd64.deb_        |
| Ubuntu 22.04             | _app-protect_33+5.210.0-1\~jammy_amd64.deb_        |
| Ubuntu 24.04             | _app-protect_33+5.210.0-1\~noble_amd64.deb_        |
| Amazon Linux 2023        | _app-protect-33+5.210.0-1.amzn2023.ngx.x86_64.rpm_ |
| RHEL 8 and Rocky Linux 8 | _app-protect-33+5.210.0-1.el8.ngx.x86_64.rpm_      |
| RHEL 9                   | _app-protect-33+5.210.0-1.el9.ngx.x86_64.rpm_      |
| Oracle Linux 8.1         | _app-protect-33+5.210.0-1.el8.ngx.x86_64.rpm_      |