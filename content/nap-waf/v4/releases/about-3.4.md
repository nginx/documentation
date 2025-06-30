---
title: NGINX App Protect WAF 3.4
weight: 760
toc: true
type: reference
product: NAP-WAF
nd-docs: DOCS-661
---

August 10, 2021

### New Features

- Improved startup times of NGINX App Protect WAF policy compiler when the configuration has not been changed.

### Supported Packages

#### App Protect

##### Debian 10

- app-protect_24+3.612.0-1~buster_amd64.deb

##### Ubuntu 18.04

- app-protect_24+3.612.0-1~bionic_amd64.deb

##### Ubuntu 20.04

- app-protect_24+3.612.0-1~focal_amd64.deb

##### Alpine 3.10

- app-protect-24.3.612.0-r1.apk

##### CentOS / RHEL / Amazon Linux 2

- app-protect-24+3.612.0-1.el7.ngx.x86_64.rpm

### Resolved Issues

- 4444 Fixed - Enforcer partially wrote config on startup.
- 4442 Fixed - Enforcer crash when using cookies that are over 2.6 Kb.
- 4397 Fixed - `Convert-policy` with `--full-export` is not suppressing all warnings.
- 4332 Fixed - Null character prefix and suffix in the Security log.
- 4407 Fixed - Empty signature names in the Security log.
- 4347 Fixed - Added `python3` dependency for NGINX App Protect WAF.






