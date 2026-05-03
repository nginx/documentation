---
title: "Changelog"
url: /waf/changelog/
weight: 600
nd-landing-page: true
nd-content-type: reference
nd-product: F5WAFN
---

This changelog lists all of the information for F5 WAF for NGINX releases in 2026.

For older releases, check the changelogs for previous years: [2025]({{< ref "/waf/changelog/2025.md" >}}), [2024]({{< ref "/waf/changelog/2024.md" >}}), [2023]({{< ref "/waf/changelog/2023.md" >}}).

## F5 WAF for NGINX 5.13

Released _May_ 13th, 2026_.

### New features

- Added support for Debian 13
- Added support for NGINX Plus R37
- Upgrade PCRE with PCRE2

### Resolved issues

- 14197 - Upgrade Go compiler to 1.26.2
- 14043 - wrong value in total memory used under bd-socket-plugin
- 14078 - Remove Mojolicious test files from the  product
- 14147 - fix recompilation race condition 
- 14002 - bd_cfg_manifest consumed with a corrupted record length header

### Packages

{{< table >}}

| Distribution name        | NGINX Open Source (5.13)                                          |  NGINX Plus (5.13)                                               | NGINX Plus (5.13)                                    |
| ------------------------ | ----------------------------------------------------------------- | ---------------------------------------------------------------- | ---------------------------------------------------- |
| Alpine 3.22              | _app-protect-module-oss-1.29.8.5.629.0-r1.apk_                    | _app-protect-module-plus-37.0.5.629.0-r1.apk_                    | _app-protect-37.0.5.629.0-r1.apk_                    |
| Amazon Linux 2023        | _app-protect-module-oss-1.29.8+5.629.0-1.amzn2023.ngx.x86_64.rpm_ | _app-protect-module-plus-37.0+5.629.0-1.amzn2023.ngx.x86_64.rpm_ | _app-protect-37.0+5.629.0-1.amzn2023.ngx.x86_64.rpm_ |
| Debian 11                | _app-protect-module-oss_1.29.8+5.629.0-1\~bullseye_amd64.deb_     | _app-protect-module-plus_37.0+5.629.0-1\~bullseye_amd64.deb_     | _app-protect_37.0+5.629.0-1\~bullseye_amd64.deb_     |
| Debian 12                | _app-protect-module-oss_1.29.8+5.629.0-1\~bookworm_amd64.deb_     | _app-protect-module-plus_37.0+5.629.0-1\~bookworm_amd64.deb_     | _app-protect_37.0+5.629.0-1\~bookworm_amd64.deb_     |
| Debian 13                | _app-protect-module-oss_1.29.8+5.629.0-1\~bookworm_amd64.deb_     | _app-protect-module-plus_37.0+5.629.0-1\~bookworm_amd64.deb_     | _app-protect_37.0+5.629.0-1\~trixie_amd64.deb_       |
| Ubuntu 22.04             | _app-protect-module-oss_1.29.8+5.629.0-1\~jammy_amd64.deb_        | _app-protect-module-plus_37.0+5.629.0-1\~jammy_amd64.deb_        | _app-protect_37.0+5.629.0-1\~jammy_amd64.deb_        |
| Ubuntu 24.04             | _app-protect-module-oss_1.29.8+5.629.0-1\~noble_amd64.deb_        | _app-protect-module-plus_37.0+5.629.0-1\~noble_amd64.deb_        | _app-protect_37.0+5.629.0-1\~noble_amd64.deb_        |
| Oracle Linux 8           | _app-protect-module-oss-1.29.8+5.629.0-1.el8.ngx.x86_64.rpm_      | _app-protect-module-plus-37.0+5.629.0-1.el8.ngx.x86_64.rpm_      | _app-protect-37.0+5.629.0-1.el8.ngx.x86_64.rpm_      |
| RHEL 8 and Rocky Linux 8 | _app-protect-module-oss-1.29.8+5.629.0-1.el8.ngx.x86_64.rpm_      | _app-protect-module-plus-37.0+5.629.0-1.el8.ngx.x86_64.rpm_      | _app-protect-37.0+5.629.0-1.el8.ngx.x86_64.rpm_      |
| RHEL 9 and Rocky Linux 9 | _app-protect-module-oss-1.29.8+5.629.0-1.el9.ngx.x86_64.rpm_      | _app-protect-module-plus-37.0+5.629.0-1.el9.ngx.x86_64.rpm_      | _app-protect-37.0+5.629.0-1.el9.ngx.x86_64.rpm_      |
| RHEL 10                  | _app-protect-module-oss-1.29.8+5.629.0-1.el10.ngx.x86_64.rpm_     | _app-protect-module-plus-37.0+5.629.0-1.el10.ngx.x86_64.rpm_     | _app-protect-37.0+5.629.0-1.el10.ngx.x86_64.rpm_     |

{{< /table >}}

## F5 WAF for NGINX 5.12.1

Released _March 31th, 2026_.

### Important notes

- This is a patch release, not a full feature release

### Resolved issues

- 14052 - Upgrade Go compiler to 1.26.1
- 14036 - Fix a cookie parser issue


### Packages

{{< table >}}

| Distribution name        | NGINX Open Source (5.12)                                           |  NGINX Plus (5.12)                                              | NGINX Plus (5.12)                                |
| ------------------------ | ----------------------------------------------------------------- | -------------------------------------------------------------- |----------------------------------------------------|
| Alpine 3.22              | _app-protect-module-oss-1.29.3+5.607.1-r1.apk_                    | _app-protect-module-plus-36+5.607.1-r1.apk_                    | _app-protect-36.5.607.1-r1.apk_                    |
| Amazon Linux 2023        | _app-protect-module-oss-1.29.3+5.607.1-1.amzn2023.ngx.x86_64.rpm_ | _app-protect-module-plus-36+5.607.1-1.amzn2023.ngx.x86_64.rpm_ | _app-protect-36+5.607.1-1.amzn2023.ngx.x86_64.rpm_ |
| Debian 11                | _app-protect-module-oss_1.29.3+5.607.1-1\~bullseye_amd64.deb_     | _app-protect-module-plus_36+5.607.1--1\~bullseye_amd64.deb_    | _app-protect_36+5.607.1-1\~bullseye_amd64.deb_     |
| Debian 12                | _app-protect-module-oss_1.29.3+5.607.1-1\~bookworm_amd64.deb_     | _app-protect-module-plus_36+5.607.1--1\~bookworm_amd64.deb_    | _app-protect_36+5.607.1-1\~bookworm_amd64.deb_     |
| Oracle Linux 8           | _app-protect-module-oss-1.29.3+5.607.1-1.el8.ngx.x86_64.rpm_      | _app-protect-module-plus-36+5.607.1-1.el8.ngx.x86_64.rpm_      | _app-protect-36+5.607.1-1.el8.ngx.x86_64.rpm_      |
| Ubuntu 22.04             | _app-protect-module-oss_1.29.3+5.607.1-1\~jammy_amd64.deb_        | _app-protect-module-plus_36+5.607.1--1\~jammy_amd64.deb_       | _app-protect_36+5.607.1-1\~jammy_amd64.deb_        |
| Ubuntu 24.04             | _app-protect-module-oss_1.29.3+5.607.1-1\~noble_amd64.deb_        | _app-protect-module-plus_36+5.607.1--1\~noble_amd64.deb_       | _app-protect_36+5.607.1-1\~noble_amd64.deb_        |
| RHEL 8 and Rocky Linux 8 | _app-protect-module-oss-1.29.3+5.607.1-1.el8.ngx.x86_64.rpm_      | _app-protect-module-plus-36+5.607.1-1.el8.ngx.x86_64.rpm_      | _app-protect-36+5.607.1-1.el8.ngx.x86_64.rpm_      |
| RHEL 9 and Rocky Linux 9 | _app-protect-module-oss-1.29.3+5.607.1-1.el9.ngx.x86_64.rpm_      | _app-protect-module-plus-36+5.607.1-1.el9.ngx.x86_64.rpm_      | _app-protect-36+5.607.1-1.el9.ngx.x86_64.rpm_      |
| RHEL 10                  | _app-protect-module-oss-1.29.3+5.607.1-1.el10.ngx.x86_64.rpm_     | _app-protect-module-plus-36+5.607.1-1.el10.ngx.x86_64.rpm_     | _app-protect-36+5.607.1-1.el10.ngx.x86_64.rpm_     |

{{< /table >}}

## F5 WAF for NGINX 5.12

Released _March 23th, 2026_.

### New features

- Added support for RHEL 10

### Resolved issues

- 13383 - gRPC disable signatures and meta chars scan on byte fields
- 13952 - The ip-address-lists feature doesn't work when processed by the express compiler
- 13845 - Fix perl toolchain inclusions for RHEL 8+
- 13466 - Make SOCK_RCV_BUF_SIZE_MAX_SIZE configurable
- 13948 - Discrepancy in schema generation for dynamic object fields that are stored as JSON

### Packages

{{< table >}}

| Distribution name        | NGINX Open Source (5.12)                                           |  NGINX Plus (5.12)                                              | NGINX Plus (5.12)                                |
| ------------------------ | ----------------------------------------------------------------- | -------------------------------------------------------------- |----------------------------------------------------|
| Alpine 3.22              | _app-protect-module-oss-1.29.3+5.607.0-r1.apk_                    | _app-protect-module-plus-36+5.607.0-r1.apk_                    | _app-protect-36.5.607.0-r1.apk_                    |
| Amazon Linux 2023        | _app-protect-module-oss-1.29.3+5.607.0-1.amzn2023.ngx.x86_64.rpm_ | _app-protect-module-plus-36+5.607.0-1.amzn2023.ngx.x86_64.rpm_ | _app-protect-36+5.607.0-1.amzn2023.ngx.x86_64.rpm_ |
| Debian 11                | _app-protect-module-oss_1.29.3+5.607.0-1\~bullseye_amd64.deb_     | _app-protect-module-plus_36+5.607.0--1\~bullseye_amd64.deb_    | _app-protect_36+5.607.0-1\~bullseye_amd64.deb_     |
| Debian 12                | _app-protect-module-oss_1.29.3+5.607.0-1\~bookworm_amd64.deb_     | _app-protect-module-plus_36+5.607.0--1\~bookworm_amd64.deb_    | _app-protect_36+5.607.0-1\~bookworm_amd64.deb_     |
| Oracle Linux 8           | _app-protect-module-oss-1.29.3+5.607.0-1.el8.ngx.x86_64.rpm_      | _app-protect-module-plus-36+5.607.0-1.el8.ngx.x86_64.rpm_      | _app-protect-36+5.607.0-1.el8.ngx.x86_64.rpm_      |
| Ubuntu 22.04             | _app-protect-module-oss_1.29.3+5.607.0-1\~jammy_amd64.deb_        | _app-protect-module-plus_36+5.607.0--1\~jammy_amd64.deb_       | _app-protect_36+5.607.0-1\~jammy_amd64.deb_        |
| Ubuntu 24.04             | _app-protect-module-oss_1.29.3+5.607.0-1\~noble_amd64.deb_        | _app-protect-module-plus_36+5.607.0--1\~noble_amd64.deb_       | _app-protect_36+5.607.0-1\~noble_amd64.deb_        |
| RHEL 8 and Rocky Linux 8 | _app-protect-module-oss-1.29.3+5.607.0-1.el8.ngx.x86_64.rpm_      | _app-protect-module-plus-36+5.607.0-1.el8.ngx.x86_64.rpm_      | _app-protect-36+5.607.0-1.el8.ngx.x86_64.rpm_      |
| RHEL 9 and Rocky Linux 9 | _app-protect-module-oss-1.29.3+5.607.0-1.el9.ngx.x86_64.rpm_      | _app-protect-module-plus-36+5.607.0-1.el9.ngx.x86_64.rpm_      | _app-protect-36+5.607.0-1.el9.ngx.x86_64.rpm_      |
| RHEL 10                  | _app-protect-module-oss-1.29.3+5.607.0-1.el10.ngx.x86_64.rpm_     | _app-protect-module-plus-36+5.607.0-1.el10.ngx.x86_64.rpm_     | _app-protect-36+5.607.0-1.el10.ngx.x86_64.rpm_     |

{{< /table >}}

## F5 WAF for NGINX 5.11.2

Released _February 13th, 2026_.

### Important notes

- This is a patch release, not a full feature release

### Resolved issues

- 13840 - Upgrade Go compiler to 1.24.13

## F5 WAF for NGINX 5.11.1

{{< call-out "note" >}}

The patch fix is also included in versions 5.9.1 and 5.10.1.

{{< /call-out >}}

Released _February 11th, 2026_.

### Important notes

- This is a patch release, not a full feature release

### Resolved issues

- 13720 - Fixed a case where reloading NGINX in WAF deployments can interrupt in‑flight requests.

## F5 WAF for NGINX 5.11

Released _January 13th, 2026_.

### New features

- Added support for the Brotli data compression algorithm

### Important notes

- Upgrade Go compiler to 1.24.11

### Resolved issues

- 13340 - F5 WAF for NGINX leaked sockets and terminated on-going requests during graceful reload of NGINX (SIGHUP)
- 12728 - Fixing a scenario under memory pressure, causing NGINX to return HTTP 503 and log SECURITY_WAF_BYPASS
- 13592 – Increased signature compiler capacity to support larger signature sets and avoid legacy signature count limits.

### Packages

{{< table >}}

| Distribution name        | NGINX Open Source (5.11)                                           |  NGINX Plus (5.11)                                              | NGINX Plus (5.11)                                |
| ------------------------ | ----------------------------------------------------------------- | -------------------------------------------------------------- |----------------------------------------------------|
| Alpine 3.22              | _app-protect-module-oss-1.29.3+5.575.0-r1.apk_                    | _app-protect-module-plus-36+5.575.0-r1.apk_                    | _app-protect-36.5.575.0-r1.apk_                    |
| Amazon Linux 2023        | _app-protect-module-oss-1.29.3+5.575.0-1.amzn2023.ngx.x86_64.rpm_ | _app-protect-module-plus-36+5.575.0-1.amzn2023.ngx.x86_64.rpm_ | _app-protect-36+5.575.0-1.amzn2023.ngx.x86_64.rpm_ |
| Debian 11                | _app-protect-module-oss_1.29.3+5.575.0-1\~bullseye_amd64.deb_     | _app-protect-module-plus_36+5.575.0--1\~bullseye_amd64.deb_    | _app-protect_36+5.575.0-1\~bullseye_amd64.deb_     |
| Debian 12                | _app-protect-module-oss_1.29.3+5.575.0-1\~bookworm_amd64.deb_     | _app-protect-module-plus_36+5.575.0--1\~bookworm_amd64.deb_    | _app-protect_36+5.575.0-1\~bookworm_amd64.deb_     |
| Oracle Linux 8         | _app-protect-module-oss-1.29.3+5.575.0-1.el8.ngx.x86_64.rpm_      | _app-protect-module-plus-36+5.575.0-1.el8.ngx.x86_64.rpm_      | _app-protect-36+5.575.0-1.el8.ngx.x86_64.rpm_      |
| Ubuntu 22.04             | _app-protect-module-oss_1.29.3+5.575.0-1\~jammy_amd64.deb_        | _app-protect-module-plus_36+5.575.0--1\~jammy_amd64.deb_       | _app-protect_36+5.575.0-1\~jammy_amd64.deb_        |
| Ubuntu 24.04             | _app-protect-module-oss_1.29.3+5.575.0-1\~noble_amd64.deb_        | _app-protect-module-plus_36+5.575.0--1\~noble_amd64.deb_       | _app-protect_36+5.575.0-1\~noble_amd64.deb_        |
| RHEL 8 and Rocky Linux 8 | _app-protect-module-oss-1.29.3+5.575.0-1.el8.ngx.x86_64.rpm_      | _app-protect-module-plus-36+5.575.0-1.el8.ngx.x86_64.rpm_      | _app-protect-36+5.575.0-1.el8.ngx.x86_64.rpm_      |
| RHEL 9 and Rocky Linux 9 | _app-protect-module-oss-1.29.3+5.575.0-1.el9.ngx.x86_64.rpm_      | _app-protect-module-plus-36+5.575.0-1.el9.ngx.x86_64.rpm_      | _app-protect-36+5.575.0-1.el9.ngx.x86_64.rpm_      |

{{< /table >}}

