---
title: F5 DoS for NGINX 4.11
description: "Release notes for F5 DoS for NGINX 4.11, which moves to the NGINX Plus R37.0 long-term support release and removes Debian 11 support."
keywords: "F5 DoS for NGINX, release notes, 4.11, NGINX Plus R37.0, Debian 11"
toc: true
weight: 10
f5-docs: DOCS-1783
f5-content-type: reference
f5-product: F5 DOS for NGINX
f5-summary: >
  Review what changed in F5 DoS for NGINX 4.11 and check whether your platform and NGINX Plus version are supported.
  Version 4.11 moves to the NGINX Plus R37.0 long-term support release and removes support for Debian 11.
---

F5 DoS for NGINX provides behavioral protection against Denial of Service (DoS) attacks for your web applications.

## Release 4.11

October 14, 2026

### New features

- NGINX Plus R37.0 support, the long-term support release
- Debian 11 support removed

### Fixes

- Security log configuration errors now name the configuration file that failed to parse

### Supported packages

| Distribution name          | Package file                                          |
|----------------------------|-------------------------------------------------------|
| Alpine 3.21                | _app-protect-dos-37+4.11.0-r1.apk_                    |
| Alpine 3.22                | _app-protect-dos-37+4.11.0-r1.apk_                    |
| Amazon Linux 2023          | _app-protect-dos-37+4.11.0-1.amzn2023.ngx.x86_64.rpm_ |
| RHEL 8 and Rocky Linux 8   | _app-protect-dos-37+4.11.0-1.el8.ngx.x86_64.rpm_      |
| RHEL 9 and Rocky Linux 9   | _app-protect-dos-37+4.11.0-1.el9.ngx.x86_64.rpm_      |
| RHEL 10 and Rocky Linux 10 | _app-protect-dos-37+4.11.0-1.el10.ngx.x86_64.rpm_     |
| Debian 12                  | _app-protect-dos_37+4.11.0-1\~bookworm_amd64.deb_     |
| Debian 13                  | _app-protect-dos_37+4.11.0-1\~trixie_amd64.deb_       |
| Ubuntu 22.04               | _app-protect-dos_37+4.11.0-1\~jammy_amd64.deb_        |
| Ubuntu 24.04               | _app-protect-dos_37+4.11.0-1\~noble_amd64.deb_        |
| NGINX Plus                 | _NGINX Plus R37.0_                                    |

### Important notes

- F5 DoS for NGINX 4.11 requires NGINX Plus **R37.0**, whereas 4.10 requires **R37.1**. Because R37.0 is the long-term support release, upgrading from 4.10 to 4.11 means moving NGINX Plus back from R37.1 to R37.0. Plan this as a coordinated change rather than a routine upgrade.
- Each `nginx-plus-module-appprotectdos` package depends on a virtual package named `nginx-plus-r<RELEASE>` (where `<RELEASE>` is the NGINX Plus release number) that only its own NGINX Plus release provides, so F5 DoS for NGINX and NGINX Plus must be upgraded together.
- On Debian and Ubuntu, `apt` considers only the newest `nginx-plus` available and will not select an older one on its own. When installing a specific F5 DoS for NGINX version, pin `nginx-plus` as well, or the install fails with `Unable to correct problems, you have held broken packages`. See the [F5 DoS for NGINX Deployment Guide]({{< ref "/nap-dos/deployment-guide/learn-about-deployment.md" >}}) for the exact commands.
- If you use the L4 accelerated mitigation feature, pin `app-protect-dos-ebpf-manager` to the same version as `app-protect-dos`. Left unpinned, it installs the most recent version, which may not match the rest of your installation.
- Debian 11 reached end of life and is no longer supported. If you run Debian 11, upgrade to Debian 12 or Debian 13 before upgrading to 4.11.
