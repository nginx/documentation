---
title: F5 DoS for NGINX 4.10
description: "Release notes for F5 DoS for NGINX 4.10, including support for NGINX Plus R37.1."
keywords: "F5 DoS for NGINX, release notes, 4.10, NGINX Plus R37.1"
toc: true
weight: 20
f5-docs: DOCS-1783
f5-content-type: reference
f5-product: F5 DOS for NGINX
f5-summary: >
  Review what changed in F5 DoS for NGINX 4.10 and check whether your platform and NGINX Plus version are supported.
  Version 4.10 adds support for NGINX Plus R37.1 and includes bug fixes.
---

F5 DoS for NGINX provides behavioral protection against Denial of Service (DoS) attacks for your web applications.

## Release 4.10

August 26, 2026

### New features

- NGINX Plus R37.1 support
- Bug fixes

### Supported packages

| Distribution name          | Package file                                          |
|----------------------------|-------------------------------------------------------|
| Alpine 3.21                | _app-protect-dos-37+4.10.0-r1.apk_                    |
| Alpine 3.22                | _app-protect-dos-37+4.10.0-r1.apk_                    |
| Amazon Linux 2023          | _app-protect-dos-37+4.10.0-1.amzn2023.ngx.x86_64.rpm_ |
| RHEL 8 and Rocky Linux 8   | _app-protect-dos-37+4.10.0-1.el8.ngx.x86_64.rpm_      |
| RHEL 9 and Rocky Linux 9   | _app-protect-dos-37+4.10.0-1.el9.ngx.x86_64.rpm_      |
| RHEL 10 and Rocky Linux 10 | _app-protect-dos-37+4.10.0-1.el10.ngx.x86_64.rpm_     |
| Debian 11                  | _app-protect-dos_37+4.10.0-1\~bullseye_amd64.deb_     |
| Debian 12                  | _app-protect-dos_37+4.10.0-1\~bookworm_amd64.deb_     |
| Debian 13 (Trixie)         | _app-protect-dos_37+4.10.0-1\~trixie_amd64.deb_       |
| Ubuntu 22.04               | _app-protect-dos_37+4.10.0-1\~jammy_amd64.deb_        |
| Ubuntu 24.04               | _app-protect-dos_37+4.10.0-1\~noble_amd64.deb_        |
| NGINX Plus                 | _NGINX Plus R37.1_                                    |

### Important notes

- F5 DoS for NGINX 4.10 requires NGINX Plus **R37.1**, whereas 4.9 requires **R37.0**. Each `nginx-plus-module-appprotectdos` package depends on a virtual package named `nginx-plus-r<release>` that only its own NGINX Plus release provides, so App Protect DoS and NGINX Plus must be upgraded together.
- On Debian and Ubuntu, `apt` considers only the newest `nginx-plus` available and will not select an older one on its own. When installing a specific App Protect DoS version, pin `nginx-plus` as well, or the install fails with `Unable to correct problems, you have held broken packages`. See the [F5 DoS for NGINX Deployment Guide]({{< ref "/nap-dos/deployment-guide/learn-about-deployment.md" >}}) for the exact commands.
