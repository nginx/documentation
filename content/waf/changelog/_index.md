---
nd-docs: DOCS-295
title: "Changelog"
url: /waf/changelog/
weight: 600
nd-landing-page: true
nd-content-type: reference
nd-product: F5WAFN
---

This changelog lists all of the information for F5 WAF for NGINX releases in 2025.

For older releases, check the changelogs for previous years: [2024]({{< ref "/waf/changelog/2024.md" >}}), [2023]({{< ref "/waf/changelog/2023.md" >}}).

## F5 WAF for NGINX 5.10

Released _December 1st, 2025_.

### New features

- Added support for NGINX Plus R36
- Added support for Alpine 3.22

### Important notes

- Alpine 3.19 is no longer supported
- Upgrade Go compiler to 1.24.10

### Resolved issues

- 13117 - Severity Field should contain a value based on the violation highest severity
- 13138 - Ability to bypass request when there is a 444 scenario
- 13130 - add --all-policy-signatures option to include all policy signatures in the conversion output

### Packages

{{< table >}}

| Distribution name        | NGINX Open Source (5.10)                                           |  NGINX Plus (5.10)                                              | NGINX Plus (5.10)                                |
| ------------------------ | ----------------------------------------------------------------- | -------------------------------------------------------------- |----------------------------------------------------|
| Alpine 3.22              | _app-protect-module-oss-1.29.3+5.550.0-r1.apk_                    | _app-protect-module-plus-36+5.550.0-r1.apk_                    | _app-protect-36.5.550.0-r1.apk_                    |
| Amazon Linux 2023        | _app-protect-module-oss-1.29.3+5.550.0-1.amzn2023.ngx.x86_64.rpm_ | _app-protect-module-plus-36+5.550.0-1.amzn2023.ngx.x86_64.rpm_ | _app-protect-36+5.550.0-1.amzn2023.ngx.x86_64.rpm_ |
| Debian 11                | _app-protect-module-oss_1.29.3+5.550.0-1\~bullseye_amd64.deb_     | _app-protect-module-plus_36+5.550.0--1\~bullseye_amd64.deb_    | _app-protect_36+5.550.0-1\~bullseye_amd64.deb_     |
| Debian 12                | _app-protect-module-oss_1.29.3+5.550.0-1\~bookworm_amd64.deb_     | _app-protect-module-plus_36+5.550.0--1\~bookworm_amd64.deb_    | _app-protect_36+5.550.0-1\~bookworm_amd64.deb_     |
| Oracle Linux 8.1         | _app-protect-module-oss-1.29.3+5.550.0-1.el8.ngx.x86_64.rpm_      | _app-protect-module-plus-36+5.550.0-1.el8.ngx.x86_64.rpm_      | _app-protect-36+5.550.0-1.el8.ngx.x86_64.rpm_      |
| Ubuntu 22.04             | _app-protect-module-oss_1.29.3+5.550.0-1\~jammy_amd64.deb_        | _app-protect-module-plus_36+5.550.0--1\~jammy_amd64.deb_       | _app-protect_36+5.550.0-1\~jammy_amd64.deb_        |
| Ubuntu 24.04             | _app-protect-module-oss_1.29.3+5.550.0-1\~noble_amd64.deb_        | _app-protect-module-plus_36+5.550.0--1\~noble_amd64.deb_       | _app-protect_36+5.550.0-1\~noble_amd64.deb_        |
| RHEL 8 and Rocky Linux 8 | _app-protect-module-oss-1.29.3+5.550.0-1.el8.ngx.x86_64.rpm_      | _app-protect-module-plus-36+5.550.0-1.el8.ngx.x86_64.rpm_      | _app-protect-36+5.550.0-1.el8.ngx.x86_64.rpm_      |
| RHEL 9 and Rocky Linux 9 | _app-protect-module-oss-1.29.3+5.550.0-1.el9.ngx.x86_64.rpm_      | _app-protect-module-plus-36+5.550.0-1.el9.ngx.x86_64.rpm_      | _app-protect-36+5.550.0-1.el9.ngx.x86_64.rpm_      |

{{< /table >}}

## F5 WAF for NGINX 5.9

Released _September 29th, 2025_.

### New features

- Added [Kubernetes operations improvements]({{< ref "/waf/install/kubernetes-plm" >}}) as early availability

### Important notes

- Renamed F5 NGINX App Protect WAF to F5 WAF for NGINX
- Aligned F5 WAF for NGINX versions
    - Package and container artifacts now share the same version numbers
    - Upgrade processes remain the same as earlier releases
    - No breaking changes

{{< call-out "important" >}}

"_V4_" is now represented in the following pages or sections:

- [Virtual machine or bare metal]({{< ref "/waf/install/virtual-environment.md">}})
- Docker [Hybrid]({{< ref "/waf/install/docker.md#hybrid-configuration" >}}) and [Single container]({{< ref "/waf/install/docker.md#single-container-configuration" >}}) configuration

"_V5_" is now represented in the following pages or sections:

- [Kubernetes]({{< ref "/waf/install/kubernetes.md">}})
- Docker [Multi-container]({{< ref "/waf/install/docker.md#multi-container-configuration" >}}) configuration

{{< /call-out >}}

- Restructured documentation
    - Product name change
    - Version alignment
    - Grouped use cases into sections with single-purpose documents
- Upgrade Go compiler to 1.23.12

### Packages

{{< table >}}

| Distribution name        | NGINX Open Source (5.9)                                          | NGINX Plus (5.9)                                                | NGINX Plus (5.9)                                   |
| ------------------------ | ----------------------------------------------------------------- | -------------------------------------------------------------- |------------------                                  | 
| Alpine 3.19              | _app-protect-module-oss-1.29.0+5.527.0-r1.apk_                    | _app-protect-module-plus-35+5.527.0-r1.apk_                    | _app-protect-35.5.527.0-r1.apk_                    | 
| Amazon Linux 2023        | _app-protect-module-oss-1.29.0+5.527.0-1.amzn2023.ngx.x86_64.rpm_ | _app-protect-module-plus-35+5.527.0-1.amzn2023.ngx.x86_64.rpm_ | _app-protect-35+5.527.0-1.amzn2023.ngx.x86_64.rpm_ |
| Debian 11                | _app-protect-module-oss_1.29.0+5.527.0-1\~bullseye_amd64.deb_     | _app-protect-module-plus_35+5.527.0-1\~bullseye_amd64.deb_     | _app-protect_35+5.527.0-1\~bullseye_amd64.deb_     |
| Debian 12                | _app-protect-module-oss_1.29.0+5.527.0-1\~bookworm_amd64.deb_     | _app-protect-module-plus_35+5.527.0-1\~bookworm_amd64.deb_     | _app-protect_35+5.527.0-1\~bookworm_amd64.deb_     |
| Oracle Linux 8.1         | _app-protect-module-oss-1.29.0+5.527.0-1.el8.ngx.x86_64.rpm_      | _app-protect-module-plus-35+5.527.0-1.el8.ngx.x86_64.rpm_      | _app-protect-35+5.527.0-1.el8.ngx.x86_64.rpm_      |
| RHEL 8 and Rocky Linux 8 | _app-protect-module-oss-1.29.0+5.527.0-1.el8.ngx.x86_64.rpm_      | _app-protect-module-plus-35+5.527.0-1.el8.ngx.x86_64.rpm_      | _app-protect-35+5.527.0-1.el8.ngx.x86_64.rpm_      | 
| RHEL 9 and Rocky Linux 9 | _app-protect-module-oss-1.29.0+5.527.0-1.el9.ngx.x86_64.rpm_      | _app-protect-module-plus-35+5.527.0-1.el8.ngx.x86_64.rpm_      | _app-protect-35+5.527.0-1.el9.ngx.x86_64.rpm_      |
| Ubuntu 22.04             | _app-protect-module-oss_1.29.0+5.527.0-1\~jammy_amd64.deb_        | _app-protect-module-plus_35+5.527.0-1\~jammy_amd64.deb_        | _app-protect_35+5.527.0-1\~jammy_amd64.deb_        | 
| Ubuntu 24.04             | _app-protect-module-oss_1.29.0+5.527.0-1\~noble_amd64.deb_        | _app-protect-module-plus_35+5.527.0-1\~noble_amd64.deb_        | _app-protect_35+5.527.0-1\~noble_amd64.deb_        |

{{< /table >}}

## F5 NGINX App Protect WAF 5.8 / 4.16

Released _August 13th, 2025_.

### New features

- Added support for NGINX Plus R35

### Packages

{{< table >}}

| Distribution name        | NGINX Open Source (5.8)                                           | NGINX Plus (5.8)                                               | NGINX Plus (4.16)                                  |
| ------------------------ | ----------------------------------------------------------------- | -------------------------------------------------------------- |------------------                                  | 
| Alpine 3.19              | _app-protect-module-oss-1.29.0+5.498.0-r1.apk_                    | _app-protect-module-plus-35+5.498.0-r1.apk_                    | _app-protect-35.5.498.0-r1.apk_                    |         
| Amazon Linux 2023        | _app-protect-module-oss-1.29.0+5.498.0-1.amzn2023.ngx.x86_64.rpm_ | _app-protect-module-plus-35+5.498.0-1.amzn2023.ngx.x86_64.rpm_ | _app-protect-35+5.498.0-1.amzn2023.ngx.x86_64.rpm_ |
| Debian 11                | _app-protect-module-oss_1.29.0+5.498.0-1\~bullseye_amd64.deb_     | _app-protect-module-plus_35+5.498.0-1\~bullseye_amd64.deb_     | _app-protect_35+5.498.0-1\~bullseye_amd64.deb_     |
| Debian 12                | _app-protect-module-oss_1.29.0+5.498.0-1\~bookworm_amd64.deb_     | _app-protect-module-plus_35+5.498.0-1\~bookworm_amd64.deb_     | _app-protect_35+5.498.0-1\~bookworm_amd64.deb_     |
| Oracle Linux 8.1         | _app-protect-module-oss-1.29.0+5.498.0-1.el8.ngx.x86_64.rpm_      | _app-protect-module-plus-35+5.498.0-1.el8.ngx.x86_64.rpm_      | _app-protect-35+5.498.0-1.el8.ngx.x86_64.rpm_      |
| Ubuntu 22.04             | _app-protect-module-oss_1.29.0+5.498.0-1\~jammy_amd64.deb_        | _app-protect-module-plus_35+5.498.0-1\~jammy_amd64.deb_        | _app-protect_35+5.498.0-1\~jammy_amd64.deb_        | 
| Ubuntu 24.04             | _app-protect-module-oss_1.29.0+5.498.0-1\~noble_amd64.deb_        | _app-protect-module-plus_35+5.498.0-1\~noble_amd64.deb_        | _app-protect_35+5.498.0-1\~noble_amd64.deb_        |
| RHEL 8 and Rocky Linux 8 | _app-protect-module-oss-1.29.0+5.498.0-1.el8.ngx.x86_64.rpm_      | _app-protect-module-plus-35+5.498.0-1.el8.ngx.x86_64.rpm_      | _app-protect-35+5.498.0-1.el8.ngx.x86_64.rpm_      | 
| RHEL 9 and Rocky Linux 9 | _app-protect-module-oss-1.29.0+5.498.0-1.el9.ngx.x86_64.rpm_      | _app-protect-module-plus-35+5.498.0-1.el8.ngx.x86_64.rpm_      | _app-protect-35+5.498.0-1.el9.ngx.x86_64.rpm_      |

{{< /table >}}

## F5 NGINX App Protect WAF 5.7 / 4.15

Released _June 24th, 2025_.

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

{{< table >}}

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
  |

{{< /table >}}

## F5 NGINX App Protect WAF 5.6 / 4.14

Released _April 1st, 2025_.

### New features

- Added support for NGINX Plus R34
- **5.6 Only:** You can now [deploy F5 WAF for NGINX 5+ using a Helm chart]({{< ref "/waf/install/kubernetes.md">}})

### Important notes

- Alpine 3.17 is no longer supported

### Resolved issues

- Upgraded the Go compiler to 1.23.7
- (12140) Changed the maximum memory of the XML processing engine to 8GB
- (12254) A modified YAML file referenced by a JSON policy file causes a reload error when running `nginx -t`
- (12296) "Violation Bad Unescape" is not enabled by default
- (12297) "Violation Encoding" is not enabled by default

### Packages

{{< table >}}

| Distribution name        | NGINX Open Source (5.6)                                           |  NGINX Plus (5.6)                                              | NGINX Plus (4.14)                                  |
| ------------------------ | ----------------------------------------------------------------- | -------------------------------------------------------------- |----------------------------------------------------|
| Alpine 3.19              | _app-protect-module-oss-1.27.4+5.342.0-r1.apk_                    | _app-protect-module-plus-34+5.342.0-r1.apk_                    | _app-protect-34.5.342.0-r1.apk_                    |
| Amazon Linux 2023        | _app-protect-module-oss-1.27.4+5.342.0-1.amzn2023.ngx.x86_64.rpm_ | _app-protect-module-plus-34+5.342.0-1.amzn2023.ngx.x86_64.rpm_ | _app-protect-34+5.342.0-1.amzn2023.ngx.x86_64.rpm_ |
| Debian 11                | _app-protect-module-oss_1.27.4+5.342.0-1\~bullseye_amd64.deb_     | _app-protect-module-plus_34+5.342.0-1\~bullseye_amd64.deb_     | _app-protect_34+5.342.0-1\~bullseye_amd64.deb_     |
| Debian 12                | _app-protect-module-oss_1.27.4+5.342.0-1\~bookworm_amd64.deb_     | _app-protect-module-plus_34+5.342.0-1\~bookworm_amd64.deb_     | _app-protect_34+5.342.0-1\~bookworm_amd64.deb_     |
| Oracle Linux 8.1         | _app-protect-module-oss-1.27.4+5.342.0-1.el8.ngx.x86_64.rpm_      | _app-protect-module-plus-34+5.342.0-1.el8.ngx.x86_64.rpm_      | _app-protect-34+5.342.0-1.el8.ngx.x86_64.rpm_      |
| Ubuntu 20.04             | _app-protect-module-oss_1.27.4+5.342.0-1\~focal_amd64.deb_        | _app-protect-module-plus_34+5.342.0-1\~focal_amd64.deb_        | _app-protect_34+5.342.0-1\~focal_amd64.deb_        |
| Ubuntu 22.04             | _app-protect-module-oss_1.27.4+5.342.0-1\~jammy_amd64.deb_        | _app-protect-module-plus_34+5.342.0-1\~jammy_amd64.deb_        | _app-protect_34+5.342.0-1\~jammy_amd64.deb_        |
| Ubuntu 24.04             | _app-protect-module-oss_1.27.4+5.342.0-1\~noble_amd64.deb_        | _app-protect-module-plus_34+5.342.0-1\~noble_amd64.deb_        | _app-protect_34+5.342.0-1\~noble_amd64.deb_        |
| RHEL 8 and Rocky Linux 8 | _app-protect-module-oss-1.27.4+5.342.0-1.el8.ngx.x86_64.rpm_      | _app-protect-module-plus-34+5.342.0-1.el8.ngx.x86_64.rpm_      | _app-protect-34+5.342.0-1.el8.ngx.x86_64.rpm_      |
| RHEL 9                   | _app-protect-module-oss-1.27.4+5.342.0-1.el9.ngx.x86_64.rpm_      | _app-protect-module-plus-34+5.342.0-1.el9.ngx.x86_64.rpm_      | _app-protect-34+5.342.0-1.el9.ngx.x86_64.rpm_      |

{{< /table >}}

## F5 NGINX App Protect WAF 5.5 / 4.13

Released _January 30th, 2025_.

### New features

- Added support for Alpine 3.19
- Added support for [Brute force attack preventions]({{< ref "/waf/policies/brute-force-attacks.md" >}})
- **5.5 Only:** Enforcer can now upgrade without requiring policies to be recompiled
- **5.5 Only:** The standalone converter within the Compiler now supports [user-defined signatures]({{< ref "/waf/configure/compiler.md#user-defined-signatures" >}}).

### Packages

{{< table >}}

| Distribution name        | NGINX Open Source (5.5)                                           |  NGINX Plus (5.5)                                              | NGINX Plus (4.13)                                  |
| ------------------------ | ----------------------------------------------------------------- | -------------------------------------------------------------- |----------------------------------------------------|
| Alpine 3.17              | _app-protect-module-oss-1.27.4+5.210.0-r1.apk_                    | _app-protect-module-plus-34+5.210.0-r1.apk_                    | _app-protect-34.5.210.0-r1.apk_                    |
| Alpine 3.19              | _app-protect-module-oss-1.27.4+5.210.0-r1.apk_                    | _app-protect-module-plus-34+5.210.0-r1.apk_                    | _app-protect-34.5.210.0-r1.apk_                    |
| Amazon Linux 2023        | _app-protect-module-oss-1.27.4+5.210.0-1.amzn2023.ngx.x86_64.rpm_ | _app-protect-module-plus-34+5.210.0-1.amzn2023.ngx.x86_64.rpm_ | _app-protect-34+5.210.0-1.amzn2023.ngx.x86_64.rpm_ |
| Debian 11                | _app-protect-module-oss_1.27.4+5.210.0-1\~bullseye_amd64.deb_     | _app-protect-module-plus_34+5.210.0-1\~bullseye_amd64.deb_     | _app-protect_34+5.210.0-1\~bullseye_amd64.deb_     |
| Debian 12                | _app-protect-module-oss_1.27.4+5.210.0-1\~bookworm_amd64.deb_     | _app-protect-module-plus_34+5.210.0-1\~bookworm_amd64.deb_     | _app-protect_34+5.210.0-1\~bookworm_amd64.deb_     |
| Oracle Linux 8.1         | _app-protect-module-oss-1.27.4+5.210.0-1.el8.ngx.x86_64.rpm_      | _app-protect-module-plus-34+5.210.0-1.el8.ngx.x86_64.rpm_      | _app-protect-34+5.210.0-1.el8.ngx.x86_64.rpm_      |
| Ubuntu 20.04             | _app-protect-module-oss_1.27.4+5.210.0-1\~focal_amd64.deb_        | _app-protect-module-plus_34+5.210.0-1\~focal_amd64.deb_        | _app-protect_34+5.210.0-1\~focal_amd64.deb_        |
| Ubuntu 22.04             | _app-protect-module-oss_1.27.4+5.210.0-1\~jammy_amd64.deb_        | _app-protect-module-plus_34+5.210.0-1\~jammy_amd64.deb_        | _app-protect_34+5.210.0-1\~jammy_amd64.deb_        |
| Ubuntu 24.04             | _app-protect-module-oss_1.27.4+5.210.0-1\~noble_amd64.deb_        | _app-protect-module-plus_34+5.210.0-1\~noble_amd64.deb_        | _app-protect_34+5.210.0-1\~noble_amd64.deb_        |
| RHEL 8 and Rocky Linux 8 | _app-protect-module-oss-1.27.4+5.210.0-1.el8.ngx.x86_64.rpm_      | _app-protect-module-plus-34+5.210.0-1.el8.ngx.x86_64.rpm_      | _app-protect-34+5.210.0-1.el8.ngx.x86_64.rpm_      |
| RHEL 9                   | _app-protect-module-oss-1.27.4+5.210.0-1.el9.ngx.x86_64.rpm_      | _app-protect-module-plus-34+5.210.0-1.el9.ngx.x86_64.rpm_      | _app-protect-34+5.210.0-1.el9.ngx.x86_64.rpm_      |

{{< /table >}}
