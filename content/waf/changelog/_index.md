---
nd-docs: DOCS-295
title: "Changelog"
url: /waf/changelog/
weight: 600
nd-landing-page: true
nd-content-type: reference
nd-product: F5WAFN
---

This changelog lists all of the information for F5 WAF for NGINX releases in 2026.

For older releases, check the changelogs for previous years: [2025]({{< ref "/waf/changelog/2025.md" >}}), [2024]({{< ref "/waf/changelog/2024.md" >}}), [2023]({{< ref "/waf/changelog/2023.md" >}}).

## F5 WAF for NGINX 5.11

Released _January 13th, 2026_.

### New features

- Added support for the Brotli data compression algorithm

### Important notes

- Upgrade Go compiler to 1.24.11

### Resolved issues

- 13340 - F5 WAF for NGINX leaked sockets and terminated on-going requests during graceful reload of NGINX (SIGHUP)
- 12728 - Fixing a scenario under memory pressure, causing NGINX to return HTTP 503 and log SECURITY_WAF_BYPASS

### Packages

{{< table >}}

| Distribution name        | NGINX Open Source (5.11)                                           |  NGINX Plus (5.11)                                              | NGINX Plus (5.11)                                |
| ------------------------ | ----------------------------------------------------------------- | -------------------------------------------------------------- |----------------------------------------------------|
| Alpine 3.22              | _app-protect-module-oss-1.29.3+5.575.0-r1.apk_                    | _app-protect-module-plus-36+5.575.0-r1.apk_                    | _app-protect-36.5.575.0-r1.apk_                    |
| Amazon Linux 2023        | _app-protect-module-oss-1.29.3+5.575.0-1.amzn2023.ngx.x86_64.rpm_ | _app-protect-module-plus-36+5.575.0-1.amzn2023.ngx.x86_64.rpm_ | _app-protect-36+5.575.0-1.amzn2023.ngx.x86_64.rpm_ |
| Debian 11                | _app-protect-module-oss_1.29.3+5.575.0-1\~bullseye_amd64.deb_     | _app-protect-module-plus_36+5.575.0--1\~bullseye_amd64.deb_    | _app-protect_36+5.575.0-1\~bullseye_amd64.deb_     |
| Debian 12                | _app-protect-module-oss_1.29.3+5.575.0-1\~bookworm_amd64.deb_     | _app-protect-module-plus_36+5.575.0--1\~bookworm_amd64.deb_    | _app-protect_36+5.575.0-1\~bookworm_amd64.deb_     |
| Oracle Linux 8.1         | _app-protect-module-oss-1.29.3+5.575.0-1.el8.ngx.x86_64.rpm_      | _app-protect-module-plus-36+5.575.0-1.el8.ngx.x86_64.rpm_      | _app-protect-36+5.575.0-1.el8.ngx.x86_64.rpm_      |
| Ubuntu 22.04             | _app-protect-module-oss_1.29.3+5.575.0-1\~jammy_amd64.deb_        | _app-protect-module-plus_36+5.575.0--1\~jammy_amd64.deb_       | _app-protect_36+5.575.0-1\~jammy_amd64.deb_        |
| Ubuntu 24.04             | _app-protect-module-oss_1.29.3+5.575.0-1\~noble_amd64.deb_        | _app-protect-module-plus_36+5.575.0--1\~noble_amd64.deb_       | _app-protect_36+5.575.0-1\~noble_amd64.deb_        |
| RHEL 8 and Rocky Linux 8 | _app-protect-module-oss-1.29.3+5.575.0-1.el8.ngx.x86_64.rpm_      | _app-protect-module-plus-36+5.575.0-1.el8.ngx.x86_64.rpm_      | _app-protect-36+5.575.0-1.el8.ngx.x86_64.rpm_      |
| RHEL 9 and Rocky Linux 9 | _app-protect-module-oss-1.29.3+5.575.0-1.el9.ngx.x86_64.rpm_      | _app-protect-module-plus-36+5.575.0-1.el9.ngx.x86_64.rpm_      | _app-protect-36+5.575.0-1.el9.ngx.x86_64.rpm_      |

{{< /table >}}