---
title: NGINX App Protect WAF 4.15
weight: 80
toc: true
nd-content-type: reference
nd-product: NAP-WAF
docs: DOCS-1789
---

June 24th, 2025

## New features

- Added support for [IP Intelligence]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#ip-intelligence-configuration" >}})
- Added support for Rocky Linux 9 
- Added support for Override rules for [IP Address Lists]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#ip-address-lists" >}})

## Important notes

- Ubuntu 20.04 is no longer supported
- 12447 - Upgrade libk5crypto3 package
- 12520 - Upgrade Go compiler to 1.23.8

## Resolved issues

- 12527 - Remove CPAN - installed certs and source files
- 11112 - Remove systemd/init.d leftovers in NAP WAF v5 pkgs
- 12400 - Cookie attributes are not added to a TS cookie when there is more than one TS cookie
- 12498 - Undefined behavior when using huge XFF 
- 12731 - Multiple clean_resp_reset internal error messages in logs when loading NAP

## Supported packages

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
