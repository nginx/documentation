---
title: NGINX App Protect WAF 5.1
weight: 900
toc: true
type: reference
product: NAP-WAF
nd-docs: DOCS-1479
---

April 18, 2024

{{< include "nap-waf/upgrade-recompile-warning.md" >}}

---

### New features

In this release, F5 NGINX App Protect WAF supports NGINX Open Source 1.25.4 and NGINX Plus R31 P1.

- [Authorization Rules in URLs]({{< ref "nap-waf/v5/configuration-guide/configuration.md#authorization-rules-in-urls" >}})
- New [JSON Web Token]({{< ref "nap-waf/v5/configuration-guide/configuration.md#json-web-token-protection" >}}) signature signing algorithm support for:

    - **RSA**: RS256, RS384, RS512
    - **PSS**: PS256, PS384, PS512
    - **ECDSA**: ES256, ES256K, ES384, ES512
    - **EdDSA**
- [Time-Based Signature Staging]({{< ref "nap-waf/v5/configuration-guide/configuration.md#time-based-signature-staging" >}})

---

### Resolved issues

- 10219 & 10512 Fixed - Resolved issues related to base64 detection and decoding.
- 10465 Fixed - Resolved the "header already sent" alert message in the NGINX error log.
- 10844 Fixed - Resolved an issue ensuring the WAF-enforcer container starts up, even if a local file logging destination is inaccessible.

---

### Supported packages

#### App Protect Module for NGINX Open Source

##### Alpine Linux 3.16 / Alpine Linux 3.17

- app-protect-module-oss-1.25.4.5.17.0-r1.apk

##### Debian 11

- app-protect-module-oss_1.25.4+5.17.0-1~bullseye_amd64.deb

##### Debian 12

- app-protect-module-oss_1.25.4+5.17.0-1~bookworm_amd64.deb

##### Ubuntu 20.04

- app-protect-module-oss_1.25.4+5.17.0-1~focal_amd64.deb

##### Ubuntu 22.04

- app-protect-module-oss_1.25.4+5.17.0-1~jammy_amd64.deb

##### RHEL 7.4+ / CentOS 7.4+ / Amazon Linux 2

- app-protect-module-oss-1.25.4+5.17.0-1.el7.ngx.x86_64.rpm

##### RHEL 8.1+ / Oracle Linux 8.1+

- app-protect-module-oss-1.25.4+5.17.0-1.el8.ngx.x86_64.rpm

##### RHEL 9+

- app-protect-module-oss-1.25.4+5.17.0-1.el9.ngx.x86_64.rpm

#### App Protect Module for NGINX Plus

##### Alpine Linux 3.16 / Alpine Linux 3.17

- app-protect-module-plus-31.5.17.0-r1.apk

##### Debian 11

- app-protect-module-plus_31+5.17.0-1~bullseye_amd64.deb

##### Debian 12

- app-protect-module-plus_31+5.17.0-1~bookworm_amd64.deb

##### Ubuntu 20.04

- app-protect-module-plus_31+5.17.0-1~focal_amd64.deb

##### Ubuntu 22.04

- app-protect-module-plus_31+5.17.0-1~jammy_amd64.deb

##### RHEL 7.4+ / CentOS 7.4+ / Amazon Linux 2

- app-protect-module-plus-31+5.17.0-1.el7.ngx.x86_64.rpm

##### RHEL 8.1+ / Oracle Linux 8.1+

- app-protect-module-plus-31+5.17.0-1.el8.ngx.x86_64.rpm

##### RHEL 9+

- app-protect-module-plus-31+5.17.0-1.el9.ngx.x86_64.rpm