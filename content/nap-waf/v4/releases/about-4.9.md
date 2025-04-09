---
title: NGINX App Protect WAF 4.9
weight: 140
toc: true
type: reference
product: NAP-WAF
docs: DOCS-1478
---

April 18, 2024

{{< note >}}
Release 4.8.1 cannot be upgraded to v4.9.  You must uninstall 4.8.1 and install 4.9.  Upgrade is supported for versions prior to 4.8.1.
{{< /note >}}

### New Features

- [Authorization Rules in URLs]({{<ref "nap-waf/v4/configuration-guide/configuration.md#authorization-rules-in-urls">}})
- New [JSON Web Token]({{<ref "nap-waf/v4/configuration-guide/configuration.md#json-web-token-protection">}}) signature signing algorithm support for:

    - **RSA**: RS256, RS384, RS512
    - **PSS**: PS256, PS384, PS512
    - **ECDSA**: ES256, ES256K, ES384, ES512
    - **EdDSA**
- [Time-Based Signature Staging]({{<ref "nap-waf/v4/configuration-guide/configuration.md#time-based-signature-staging">}})

### Supported Packages

#### App Protect

##### Alpine 3.16

- app-protect-31.5.17.0-r1.apk

##### Alpine 3.17

- app-protect-31.5.17.0-r1.apk

##### CentOS 7.4+ / RHEL 7.4+ / Amazon Linux 2

- app-protect-31+5.17.0-1.el7.ngx.x86_64.rpm

##### Debian 11

- app-protect_31+5.17.0-1~bullseye_amd64.deb

##### Debian 12

- app-protect_31+5.17.0-1~bookworm_amd64.deb

##### Oracle Linux 8.1+

- app-protect-31+5.17.0-1.el8.ngx.x86_64.rpm

##### RHEL 8.1+

- app-protect-31+5.17.0-1.el8.ngx.x86_64.rpm

##### RHEL 9+

- app-protect-31+5.17.0-1.el9.ngx.x86_64.rpm

##### Ubuntu 20.04

- app-protect_31+5.17.0-1~focal_amd64.deb

##### Ubuntu 22.04

- app-protect_31+5.17.0-1~jammy_amd64.deb


### Resolved Issues

- 10219 & 10512 Fixed -  Resolved issues related to base64 detection and decoding.
- 10465 Fixed - Resolved the "header already sent" alert message in the NGINX error log.
- 10250 & 10251 Resolved - Fixed issues related to upgrading on Debian and Ubuntu.