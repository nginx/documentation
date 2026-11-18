---
title: F5 DoS for NGINX 4.11
description: "Release notes for F5 DoS for NGINX 4.11, which moves to the NGINX Plus R37.0 long-term support release and removes Debian 11 support."
f5-keywords: "F5 DoS for NGINX, release notes, 4.11, NGINX Plus R37.0, Debian 11"
toc: true
weight: 10
f5-content-type: reference
f5-product: F5 DoS for NGINX
f5-summary: >
  Review what changed in F5 DoS for NGINX 4.11 and check whether your platform and NGINX Plus version are supported.
  Version 4.11 moves to the NGINX Plus R37.0 long-term support release and removes support for Debian 11.
---

F5 DoS for NGINX provides behavioral protection against denial-of-service (DoS) attacks for your web applications.

## Release 4.11

October 14, 2026

### New features

- NGINX Plus R37.0 support, the long-term support release
- Debian 11 support removed

### Fixes

- Errors in the security log configuration now name the file that failed to parse.

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

- F5 DoS for NGINX 4.11 requires NGINX Plus R37.0, but 4.10 requires R37.1. R37.0 is the long-term support release, so you move NGINX Plus back from R37.1 to R37.0 when you update from 4.10 to 4.11. Plan the update as a coordinated change, not a routine one.
- Each `nginx-plus-module-appprotectdos` package depends on a virtual package named `nginx-plus-r<RELEASE>`. `<RELEASE>` is the NGINX Plus release number. Only the matching NGINX Plus release provides that package, so update F5 DoS for NGINX and NGINX Plus together.
- On Debian and Ubuntu, `apt` installs only the newest `nginx-plus` and won't choose an older one. When you install a specific F5 DoS for NGINX version, pin `nginx-plus` too. Otherwise, the install fails with "Unable to correct problems, you have held broken packages". For the exact commands, see the [F5 DoS for NGINX Deployment Guide]({{< ref "/nap-dos/deployment-guide/learn-about-deployment.md" >}}).
- If you use L4 accelerated mitigation, pin `app-protect-dos-ebpf-manager` to the same version as `app-protect-dos`. An unpinned package installs the newest version, which can differ from your other packages.
- Debian 11 reached end of life and is no longer supported. If you run Debian 11, upgrade to Debian 12 or Debian 13 before you update to 4.11.
