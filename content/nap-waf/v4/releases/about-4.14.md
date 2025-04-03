---
title: NGINX App Protect WAF 4.14
weight: 90
toc: true
type: reference
product: NAP-WAF
docs: DOCS-000
---

April 1st, 2025

---

## New features

- Added support for NGINX Plus R34

---

## Important notes

- Alpine 3.17 is no longer supported

---

## Resolved issues

- Upgraded the Go compiler to 1.23.7
- (12140) Changed the maximum memory of the XML processing engine to 8GB
- (12254) A modified YAML file referenced by a JSON policy file causes a reload error when running `nginx -t`
- (12296) "Violation Bad Unescape" is not enabled by default
- (12297) "Violation Encoding" is not enabled by default

---

## Supported packages

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
