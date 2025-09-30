---
# We use sentence case and present imperative tone
title: "Changelog"
# Weights are assigned in increments of 100: determines sorting order
weight: 600
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: reference
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

{{< call-out "warning" "Information architecture note" >}}

This page is incomplete, only listing the most recent releases: the remainder will be migrated and reformatted to fit the package table format.

{{</ call-out>}}

This changelog lists all of the information for F5 WAF for NGINX releases in 2025.

<!-- For older releases, check the changelogs for previous years: [2024](), [2023](). -->

## F5 WAF for NGINX 5.9

_September 29th, 2025_

### New features

- Added [Kubernetes operations improvements]({{< ref "/waf/install/kubernetes-plm" >}}) as early availability

### Important notes

- Restructured documentation
    - NGINX App Protect WAF renamed to F5 WAF for NGINX - no workflow or breaking changes
    - Packaged NAP version (VM-based or bare-metal deployments) alignment - renamed from v4 to v5 so both packaged and containerized offerings now share the same version number (v5.9).
          This doesn't introduce breaking changes.
          For example: Upgrades work exactly the same. Users can upgrade from v4.x (for example, 4.16) to 5.9 just as they did between earlier v4 releases (for example, 4.15 → 4.16).
- Upgrade Go compiler to 1.23.12

### Packages

{{< table >}}

| Distribution name        | NGINX Open Source                                                 | NGINX Plus                                                     | NGINX Plus (Virtual/Single container) |
| ------------------------ | ----------------------------------------------------------------- | -------------------------------------------------------------- |------------------ | 
| Alpine 3.19              | _app-protect-module-oss-1.29.0+5.527.0-r1.apk_                    | _app-protect-module-plus-35+5.527.0-r1.apk_                    | _app-protect-35.5.527.0-r1.apk_ |               
| Amazon Linux 2023        | _app-protect-module-oss-1.29.0+5.527.0-1.amzn2023.ngx.x86_64.rpm_ | _app-protect-module-plus-35+5.527.0-1.amzn2023.ngx.x86_64.rpm_ | _app-protect-35+5.527.0-1.amzn2023.ngx.x86_64.rpm_ |
| Debian 11                | _app-protect-module-oss_1.29.0+5.527.0-1\~bullseye_amd64.deb_     | _app-protect-module-plus_35+5.527.0-1\~bullseye_amd64.deb_     | _app-protect_35+5.527.0-1\~bullseye_amd64.deb_     |
| Debian 12                | _app-protect-module-oss_1.29.0+5.527.0-1\~bookworm_amd64.deb_     | _app-protect-module-plus_35+5.527.0-1\~bookworm_amd64.deb_     | _app-protect_35+5.527.0-1\~bookworm_amd64.deb_     |
| Oracle Linux 8.1         | _app-protect-module-oss-1.29.0+5.527.0-1.el8.ngx.x86_64.rpm_      | _app-protect-module-plus-35+5.527.0-1.el8.ngx.x86_64.rpm_      | _app-protect-35+5.527.0-1.el8.ngx.x86_64.rpm_      |
| RHEL 8 and Rocky Linux 8 | _app-protect-module-oss-1.29.0+5.527.0-1.el8.ngx.x86_64.rpm_      | _app-protect-module-plus-35+5.527.0-1.el8.ngx.x86_64.rpm_      | _app-protect-35+5.527.0-1.el8.ngx.x86_64.rpm_      | 
| RHEL 9 and Rocky Linux 9 | _app-protect-module-oss-1.29.0+5.527.0-1.el9.ngx.x86_64.rpm_      | _app-protect-module-plus-35+5.527.0-1.el8.ngx.x86_64.rpm_      | _app-protect-35+5.527.0-1.el9.ngx.x86_64.rpm_      |
| Ubuntu 22.04             | _app-protect-module-oss_1.29.0+5.527.0-1\~jammy_amd64.deb_        | _app-protect-module-plus_35+5.527.0-1\~jammy_amd64.deb_        | _app-protect_35+5.527.0-1\~jammy_amd64.deb_        | 
| Ubuntu 24.04             | _app-protect-module-oss_1.29.0+5.527.0-1\~noble_amd64.deb_        | _app-protect-module-plus_35+5.527.0-1\~noble_amd64.deb_        | _app-protect_35+5.527.0-1\~noble_amd64.deb_        |

{{< /table >}}

## F5 WAF for NGINX 5.8 / 4.16

_August 13th, 2025_

### New features

- Added support for NGINX Plus R35

### Packages

{{< table >}}

| Distribution name        | NGINX Open Source (5.8)                                           | NGINX Plus (5.8)                                               | NGINX Plus (4.16) |
| ------------------------ | ----------------------------------------------------------------- | -------------------------------------------------------------- |------------------ | 
| Alpine 3.19              | _app-protect-module-oss-1.29.0+5.498.0-r1.apk_                    | _app-protect-module-plus-35+5.498.0-r1.apk_                    | _app-protect-35.5.498.0-r1.apk_ |               
| Amazon Linux 2023        | _app-protect-module-oss-1.29.0+5.498.0-1.amzn2023.ngx.x86_64.rpm_ | _app-protect-module-plus-35+5.498.0-1.amzn2023.ngx.x86_64.rpm_ | _app-protect-35+5.498.0-1.amzn2023.ngx.x86_64.rpm_ |
| Debian 11                | _app-protect-module-oss_1.29.0+5.498.0-1\~bullseye_amd64.deb_     | _app-protect-module-plus_35+5.498.0-1\~bullseye_amd64.deb_     | _app-protect_35+5.498.0-1\~bullseye_amd64.deb_     |
| Debian 12                | _app-protect-module-oss_1.29.0+5.498.0-1\~bookworm_amd64.deb_     | _app-protect-module-plus_35+5.498.0-1\~bookworm_amd64.deb_     | _app-protect_35+5.498.0-1\~bookworm_amd64.deb_     |
| Oracle Linux 8.1         | _app-protect-module-oss-1.29.0+5.498.0-1.el8.ngx.x86_64.rpm_      | _app-protect-module-plus-35+5.498.0-1.el8.ngx.x86_64.rpm_      | _app-protect-35+5.498.0-1.el8.ngx.x86_64.rpm_      |
| Ubuntu 22.04             | _app-protect-module-oss_1.29.0+5.498.0-1\~jammy_amd64.deb_        | _app-protect-module-plus_35+5.498.0-1\~jammy_amd64.deb_        | _app-protect_35+5.498.0-1\~jammy_amd64.deb_        | 
| Ubuntu 24.04             | _app-protect-module-oss_1.29.0+5.498.0-1\~noble_amd64.deb_        | _app-protect-module-plus_35+5.498.0-1\~noble_amd64.deb_        | _app-protect_35+5.498.0-1\~noble_amd64.deb_        |
| RHEL 8 and Rocky Linux 8 | _app-protect-module-oss-1.29.0+5.498.0-1.el8.ngx.x86_64.rpm_      | _app-protect-module-plus-35+5.498.0-1.el8.ngx.x86_64.rpm_      | _app-protect-35+5.498.0-1.el8.ngx.x86_64.rpm_      | 
| RHEL 9 and Rocky Linux 9 | _app-protect-module-oss-1.29.0+5.498.0-1.el9.ngx.x86_64.rpm_      | _app-protect-module-plus-35+5.498.0-1.el8.ngx.x86_64.rpm_      | _app-protect-35+5.498.0-1.el9.ngx.x86_64.rpm_      |

{{< /table >}}

## F5 WAF for NGINX 5.7 / 4.15

_June 24th, 2025_

### New features

- Added support for Rocky Linux 9
- Added support for IP Intelligence
- Added support for Override rules for IP Address Lists

### Important notes

- Ubuntu 20.04 is no longer supported
- (12447) Upgrade libk5crypto3 package
- (12520) Upgrade Go compiler to 1.23.8

### Resolved issues

- (12527) Remove CPAN - installed certs and source files
- (11112) Remove systemd/init.d leftovers in NAP WAF v5 pkgs
- (12400) Cookie attributes are not added to a TS cookie when there is more than one TS cookie
- (12498) Undefined behavior when using huge XFF
- (12731) Multiple clean_resp_reset internal error messages in logs when loading NAP

### Packages


| Distribution name        | NGINX Open Source (5.7)                                           |  NGINX Plus (5.7)                                              | NGINX Plus (4.15)                                  |
| ------------------------ | ----------------------------------------------------------------- | -------------------------------------------------------------- |----------------------------------------------------|
| Alpine 3.19              | _app-protect-module-oss-1.27.4+5.442.0-r1.apk_                    | _app-protect-module-plus-34+5.442.0-r1.apk_                    | _app-protect-34.5.442.0-r1.apk_                    |
| Amazon Linux 2023        | _app-protect-module-oss-1.27.4+5.442.0-1.amzn2023.ngx.x86_64.rpm_ | _app-protect-module-plus-34+5.442.0-1.amzn2023.ngx.x86_64.rpm_ | _app-protect-34+5.442.0-1.amzn2023.ngx.x86_64.rpm_ |
| Debian 11                | _app-protect-module-oss_1.27.4+5.442.0-1\~bullseye_amd64.deb_     | _app-protect-module-plus_34+5.442.0-1\~bullseye_amd64.deb_     | _app-protect_34+5.442.0-1\~bullseye_amd64.deb_     |
| Debian 12                | _app-protect-module-oss_1.27.4+5.442.0-1\~bookworm_amd64.deb_     | _app-protect-module-plus_34+5.442.0-1\~bookworm_amd64.deb_     | _app-protect_34+5.442.0-1\~bookworm_amd64.deb_     |
| Oracle Linux 8.1         | _app-protect-module-oss-1.27.4+5.442.0-1.el8.ngx.x86_64.rpm_      | _app-protect-module-plus-34+5.442.0-1.el8.ngx.x86_64.rpm_      | _app-protect-34+5.442.0-1.el8.ngx.x86_64.rpm_      |
| Ubuntu 22.04             | _app-protect-module-oss_1.27.4+5.442.0-1\~jammy_amd64.deb_        | _app-protect-module-plus_34+5.442.0-1\~jammy_amd64.deb_        | _app-protect_34+5.442.0-1\~jammy_amd64.deb_        |
| Ubuntu 24.04             | _app-protect-module-oss_1.27.4+5.442.0-1\~noble_amd64.deb_        | _app-protect-module-plus_34+5.442.0-1\~noble_amd64.deb_        | _app-protect_34+5.442.0-1\~noble_amd64.deb_        |
| RHEL 8 and Rocky Linux 8 | _app-protect-module-oss-1.27.4+5.442.0-1.el8.ngx.x86_64.rpm_      | _app-protect-module-plus-34+5.442.0-1.el8.ngx.x86_64.rpm_      | _app-protect-34+5.442.0-1.el8.ngx.x86_64.rpm_      |
| RHEL 9 and Rocky Linux 9 | _app-protect-module-oss-1.27.4+5.442.0-1.el9.ngx.x86_64.rpm_      | _app-protect-module-plus-34+5.442.0-1.el9.ngx.x86_64.rpm_      | _app-protect-34+5.442.0-1.el9.ngx.x86_64.rpm_      |

## F5 WAF for NGINX 5.6 / 4.14

_April 1st, 2025_

### New features

- Added support for NGINX Plus R34
- **5.6 Only:** You can now [deploy F5 WAF for NGINX 5+ using a Helm chart]({{< ref "/nap-waf/v5/admin-guide/deploy-with-helm.md">}})

### Important notes

- Alpine 3.17 is no longer supported

### Resolved issues

- Upgraded the Go compiler to 1.23.7
- (12140) Changed the maximum memory of the XML processing engine to 8GB
- (12254) A modified YAML file referenced by a JSON policy file causes a reload error when running `nginx -t`
- (12296) "Violation Bad Unescape" is not enabled by default
- (12297) "Violation Encoding" is not enabled by default

### 5.6 packages

#### NGINX Open Source

| Distribution name        | Package file                                                      |
|--------------------------|-------------------------------------------------------------------|
| Alpine 3.19              | _app-protect-module-oss-1.27.4+5.342.0-r1.apk_                    |
| Amazon Linux 2023        | _app-protect-module-oss-1.27.4+5.342.0-1.amzn2023.ngx.x86_64.rpm_ |
| Debian 11                | _app-protect-module-oss_1.27.4+5.342.0-1\~bullseye_amd64.deb_     |
| Debian 12                | _app-protect-module-oss_1.27.4+5.342.0-1\~bookworm_amd64.deb_     |
| Oracle Linux 8.1         | _app-protect-module-oss-1.27.4+5.342.0-1.el8.ngx.x86_64.rpm_      |
| Ubuntu 20.04             | _app-protect-module-oss_1.27.4+5.342.0-1\~focal_amd64.deb_        |
| Ubuntu 22.04             | _app-protect-module-oss_1.27.4+5.342.0-1\~jammy_amd64.deb_        |
| Ubuntu 24.04             | _app-protect-module-oss_1.27.4+5.342.0-1\~noble_amd64.deb_        |
| RHEL 8 and Rocky Linux 8 | _app-protect-module-oss-1.27.4+5.342.0-1.el8.ngx.x86_64.rpm_      |
| RHEL 9                   | _app-protect-module-oss-1.27.4+5.342.0-1.el9.ngx.x86_64.rpm_      |

#### NGINX Plus

| Distribution name        | Package file                                                   |
|--------------------------|----------------------------------------------------------------|
| Alpine 3.19              | _app-protect-module-plus-34+5.342.0-r1.apk_                    |
| Amazon Linux 2023        | _app-protect-module-plus-34+5.342.0-1.amzn2023.ngx.x86_64.rpm_ |
| Debian 11                | _app-protect-module-plus_34+5.342.0-1\~bullseye_amd64.deb_     |
| Debian 12                | _app-protect-module-plus_34+5.342.0-1\~bookworm_amd64.deb_     |
| Oracle Linux 8.1         | _app-protect-module-plus-34+5.342.0-1.el8.ngx.x86_64.rpm_      |
| Ubuntu 20.04             | _app-protect-module-plus_34+5.342.0-1\~focal_amd64.deb_        |
| Ubuntu 22.04             | _app-protect-module-plus_34+5.342.0-1\~jammy_amd64.deb_        |
| Ubuntu 24.04             | _app-protect-module-plus_34+5.342.0-1\~noble_amd64.deb_        |
| RHEL 8 and Rocky Linux 8 | _app-protect-module-plus-34+5.342.0-1.el8.ngx.x86_64.rpm_      |
| RHEL 9                   | _app-protect-module-plus-34+5.342.0-1.el9.ngx.x86_64.rpm_      |

### 4.14 packages

| Distribution name        | Package file                                       |
|--------------------------|----------------------------------------------------|
| Alpine 3.19              | _app-protect-34.5.342.0-r1.apk_                    |
| Amazon Linux 2023        | _app-protect-34+5.342.0-1.amzn2023.ngx.x86_64.rpm_ |
| Debian 11                | _app-protect_34+5.342.0-1\~bullseye_amd64.deb_     |
| Debian 12                | _app-protect_34+5.342.0-1\~bookworm_amd64.deb_     |
| Oracle Linux 8.1         | _app-protect-34+5.342.0-1.el8.ngx.x86_64.rpm_      |
| Ubuntu 20.04             | _app-protect_34+5.342.0-1\~focal_amd64.deb_        |
| Ubuntu 22.04             | _app-protect_34+5.342.0-1\~jammy_amd64.deb_        |
| Ubuntu 24.04             | _app-protect_34+5.342.0-1\~noble_amd64.deb_        |
| RHEL 8 and Rocky Linux 8 | _app-protect-34+5.342.0-1.el8.ngx.x86_64.rpm_      |
| RHEL 9                   | _app-protect-34+5.342.0-1.el9.ngx.x86_64.rpm_      |
