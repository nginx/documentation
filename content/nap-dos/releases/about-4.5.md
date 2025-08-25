---
title: F5 DoS for NGINX 4.5
toc: true
weight: 70
nd-docs: DOCS-1784
---

Here you can find the release information for F5 F5 DoS for NGINX v4.5

F5 DoS for NGINX provides behavioral protection against Denial of Service (DoS) for your web applications.

---

## Release 4.5

Nov 19, 2024

F5 DoS for NGINX 4.5 adds support for NGINX Plus R33.

---

### New features

- Support for NGINX Plus R33
- Add support for Alpine 3.19
- Add support for Ubuntu 24.04
- Remove support for CentOS 7 / RHEL 7
- *eBPF Manager - Privileged Process for Secure Command Handling*
This feature introduces the eBPF Manager, a process that securely handles eBPF commands on behalf of other processes. By allowing certain processes to operate without elevated privileges, it enhances system security. As part of this enhancement, NGINX now runs under a non-root user account, which is required for deploying specific security solutions.

---

### Supported packages

| Distribution name        | Package file                                     |
|--------------------------|--------------------------------------------------|
| Alpine 3.17 / 3.19       | _app-protect-dos-33+4.5.2-r1.apk_                |
| RHEL 8 and Rocky Linux 8 | _app-protect-dos-33+4.5.2-1.el8.ngx.x86_64.rpm_  |
| RHEL 9                   | _app-protect-dos-33+4.5.2-1.el9.ngx.x86_64.rpm_  |
| Debian 11                | _app-protect-dos_33+4.5.2-1\~bullseye_amd64.deb_ |
| Debian 12                | _app-protect-dos_33+4.5.2-1\~bookworm_amd64.deb_ |
| Ubuntu 20.04             | _app-protect-dos_33+4.5.2-1\~focal_amd64.deb_    |
| Ubuntu 22.04             | _app-protect-dos_33+4.5.2-1\~jammy_amd64.deb_    |
| Ubuntu 24.04             | _app-protect-dos_33+4.5.2-1\~noble_amd64.deb_    |
| NGINX Plus               | _NGINX Plus R33_                                 |
