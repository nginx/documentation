---
title: NGINX App Protect DoS 4.6
toc: true
weight: 60
docs: DOCS-000
---

Here you can find the release information for F5 NGINX App Protect DoS v4.6  

NGINX App Protect DoS provides behavioral protection against Denial of Service (DoS) for your web applications.

---

## Release 4.6

Mar 24, 2025

NGINX App Protect DoS 4.6 adds support for NGINX Plus R34.

---

### New features

- Support for NGINX Plus R34
- Add support for AmazonLinux 2023
- Remove support for Alpine 3.17 
- Telemetry Readiness - this feature enables periodic telemetry reporting for NGINX App Protect DoS, capturing key statistics and metrics. In the initial phase, telemetry data is temporarily logged to the NGINX error.log file every minute on DEBUG log level.
- Bug fixes

---

### Supported packages

| Distribution name        | Package file                                         |
|--------------------------|------------------------------------------------------|
| Alpine 3.19              | _app-protect-dos-34+4.6.1-r1.apk_                    |
| Amazon Linux 2023         | _app-protect-dos-34+4.6.1-1.amzn2023.ngx.x86_64.rpm_ |  
| RHEL 8 and Rocky Linux 8 | _app-protect-dos-34+4.6.1-1.el8.ngx.x86_64.rpm_      |
| RHEL 9                   | _app-protect-dos-34+4.6.1-1.el9.ngx.x86_64.rpm_      |
| Debian 11                | _app-protect-dos_34+4.6.1-1\~bullseye_amd64.deb_     |
| Debian 12                | _app-protect-dos_34+4.6.1-1\~bookworm_amd64.deb_     |
| Ubuntu 20.04             | _app-protect-dos_34+4.6.1-1\~focal_amd64.deb_        |
| Ubuntu 22.04             | _app-protect-dos_34+4.6.1-1\~jammy_amd64.deb_        |
| Ubuntu 24.04             | _app-protect-dos_34+4.6.1-1\~noble_amd64.deb_        |
| NGINX Plus               | _NGINX Plus R34_                                     |
