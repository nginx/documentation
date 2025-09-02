---
# We use sentence case and present imperative tone
title: "Changelog"
# Weights are assigned in increments of 100: determines sorting order
weight: 800
# Creates a table of contents and sidebar, useful for large documents
toc: true
# Types have a 1:1 relationship with Hugo archetypes, so you shouldn't need to change this
nd-content-type: reference
# Intended for internal catalogue and search, case sensitive:
# Agent, N4Azure, NIC, NIM, NGF, NAP-DOS, NAP-WAF, NGINX One, NGINX+, Solutions, Unit
nd-product: NAP-WAF
---

{{< call-out "warning" "Information architecture note" >}}

The design intention for this page is to act as a single reference point for changes between each release. "Changelog" is the term being adopted across the entire NGINX product ecosystem.

Since both versions of NGINX App Protect WAF are released at the same time, they can be stored in the same note. Change items for only one specific version are explicitly annotated when necessary.

Updating the content of this page will likely be automated in the future, following some procedural changes to how tickets are managed within JIRA.

{{</ call-out>}}

This changelog lists all of the information for F5 WAF for NGINX releases in 2025.

For older releases, check the changelogs for previous years: [2024](), [2023]().

## NGINX App Protect WAF 5.7 / 4.15

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

### 5.7 packages

#### NGINX Open Source

| Distribution name        | Package file                                                      |
|--------------------------|-------------------------------------------------------------------|
| Alpine 3.19              | _app-protect-module-oss-1.27.4+5.442.0-r1.apk_                    |
| Amazon Linux 2023        | _app-protect-module-oss-1.27.4+5.442.0-1.amzn2023.ngx.x86_64.rpm_ |
| Debian 11                | _app-protect-module-oss_1.27.4+5.442.0-1\~bullseye_amd64.deb_     |
| Debian 12                | _app-protect-module-oss_1.27.4+5.442.0-1\~bookworm_amd64.deb_     |
| Oracle Linux 8.1         | _app-protect-module-oss-1.27.4+5.442.0-1.el8.ngx.x86_64.rpm_      |
| Ubuntu 22.04             | _app-protect-module-oss_1.27.4+5.442.0-1\~jammy_amd64.deb_        |
| Ubuntu 24.04             | _app-protect-module-oss_1.27.4+5.442.0-1\~noble_amd64.deb_        |
| RHEL 8 and Rocky Linux 8 | _app-protect-module-oss-1.27.4+5.442.0-1.el8.ngx.x86_64.rpm_      |
| RHEL 9 and Rocky Linux 9 | _app-protect-module-oss-1.27.4+5.442.0-1.el9.ngx.x86_64.rpm_      |

#### NGINX Plus

| Distribution name        | Package file                                                   |
|--------------------------|----------------------------------------------------------------|
| Alpine 3.19              | _app-protect-module-plus-34+5.442.0-r1.apk_                    |
| Amazon Linux 2023        | _app-protect-module-plus-34+5.442.0-1.amzn2023.ngx.x86_64.rpm_ |
| Debian 11                | _app-protect-module-plus_34+5.442.0-1\~bullseye_amd64.deb_     |
| Debian 12                | _app-protect-module-plus_34+5.442.0-1\~bookworm_amd64.deb_     |
| Oracle Linux 8.1         | _app-protect-module-plus-34+5.442.0-1.el8.ngx.x86_64.rpm_      |
| Ubuntu 22.04             | _app-protect-module-plus_34+5.442.0-1\~jammy_amd64.deb_        |
| Ubuntu 24.04             | _app-protect-module-plus_34+5.442.0-1\~noble_amd64.deb_        |
| RHEL 8 and Rocky Linux 8 | _app-protect-module-plus-34+5.442.0-1.el8.ngx.x86_64.rpm_      |
| RHEL 9 and Rocky Linux 9 | _app-protect-module-plus-34+5.442.0-1.el9.ngx.x86_64.rpm_      |

### 4.15 packages

| Distribution name        | Package file                                       |
|--------------------------|----------------------------------------------------|
| Alpine 3.19              | _app-protect-34.5.442.0-r1.apk_                    |
| Amazon Linux 2023        | _app-protect-34+5.442.0-1.amzn2023.ngx.x86_64.rpm_ |
| Debian 11                | _app-protect_34+5.442.0-1\~bullseye_amd64.deb_     |
| Debian 12                | _app-protect_34+5.442.0-1\~bookworm_amd64.deb_     |
| Oracle Linux 8.1         | _app-protect-34+5.442.0-1.el8.ngx.x86_64.rpm_      |
| Ubuntu 22.04             | _app-protect_34+5.442.0-1\~jammy_amd64.deb_        |
| Ubuntu 24.04             | _app-protect_34+5.442.0-1\~noble_amd64.deb_        |
| RHEL 8 and Rocky Linux 8 | _app-protect-34+5.442.0-1.el8.ngx.x86_64.rpm_      |
| RHEL 9 and Rocky Linux 9 | _app-protect-34+5.442.0-1.el9.ngx.x86_64.rpm_      |

## NGINX App Protect WAF 5.6 / 4.14

### New features

- Added support for NGINX Plus R34
- **5.6 Only:** You can now [deploy NGINX App Protect WAF 5+ using a Helm chart]({{< ref "/nap-waf/v5/admin-guide/deploy-with-helm.md">}})

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