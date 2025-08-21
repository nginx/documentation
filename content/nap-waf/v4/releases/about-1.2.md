---
title: F5 WAF for NGINX 1.2
weight: 1020
toc: true
type: reference
product: NAP-WAF
nd-docs: DOCS-1791
---

June 30, 2020

### New Features

- [External References]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#external-references" >}})
- [Threat Campaigns]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#threat-campaigns" >}})


### Supported Packages

#### App Protect

##### Debian

- app-protect_22+3.74.0-1~stretch_amd64.deb

##### CentOS

- app-protect-22+3.74.0-1.el7.ngx.x86_64.rpm


### Resolved Issues

- 1455 Fixed - Data Guard masking policy resulted in core for large responses over 100MB.
- 1487 Fixed - HTTP compliance sub-violation "Chunked request with Content-Length" was not enabled.
- 1520 Fixed - Data Guard masking policy didn't mask CCN/SSN found at the end of responses over 32KB.
- 1575 Added - Any request containing a value other than "identity" in a Content-Encoding Header will be dropped/passed according to the new directive: `app_protect_compressed_requests_action`. Such requests will be dropped by default if the directive is not set.
- 1576 Fixed - Signature matched on wrong context.
- 1580 Fixed - Crash during fail mode.
- 1742 Fixed - Documentation did not reflect the correct HTTP compliance sub-violations.

