---
title: F5 WAF for NGINX 4.11
weight: 120
toc: true
type: reference
product: NAP-WAF
nd-docs: DOCS-1786
---

September 25, 2024

{{< call-out "warning" >}}
Release 4.8.1 cannot be upgraded to v4.11. You must uninstall 4.8.1 and install 4.11. Upgrade is supported for versions prior to 4.8.1.
{{< /call-out >}}

---

### New features

- [Ubuntu 24.04 support]({{< ref "/nap-waf/v4/admin-guide/install.md#ubuntu-1804--ubuntu-2004--ubuntu-2204--ubuntu-2404-installation" >}})

---

### Important notes

- Starting from this release, CentOS 7.4, Rhel 7.4 and Amazon Linux 2 support has been deprecated.

---

### Resolved issues

- 10775 Fixed - Resolved a threshold calculation in the base64 decoding mechanism.
- 11426 Fixed - Resolved log entry of an XFF header that contains more than one value.
- 11272 Fixed - Resolved an issue where, in certain instances, the original HTTP response code was shown for rejected requests.
- 5302 Fixed - The enforcer leaves an incomplete job when NGINX reloads during DNS resolution.

---

### Supported packages

| Distribution name        | Package file                                   |
|--------------------------|------------------------------------------------|
| Alpine 3.16 / 3.17       | _app-protect-32.5.144.0-r1.apk_                |
| Debian 11                | _app-protect_32+5.144.0-1\~bullseye_amd64.deb_ |
| Debian 12                | _app-protect_32+5.144.0-1\~bookworm_amd64.deb_ |
| Ubuntu 20.04             | _app-protect_32+5.144.0-1\~focal_amd64.deb_    |
| Ubuntu 22.04             | _app-protect_32+5.144.0-1\~jammy_amd64.deb_    |
| Ubuntu 24.04             | _app-protect_32+5.144.0-1\~noble_amd64.deb_    |
| RHEL 8 and Rocky Linux 8 | _app-protect-32+5.144.0-1.el8.ngx.x86_64.rpm_  |
| RHEL 9                   | _app-protect-32+5.144.0-1.el9.ngx.x86_64.rpm_  |
| Oracle Linux 8.1         | _app-protect-32+5.144.0-1.el8.ngx.x86_64.rpm_  |
