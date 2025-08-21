---
title: F5 WAF for NGINX 3.7
weight: 730
toc: true
type: reference
product: NAP-WAF
nd-docs: DOCS-664
---

December 15, 2021

### New Features

- [Protection of large requests]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#supported-security-policy-features" >}}) - To increase the protection of resources at both the NGINX Plus and upstream application tiers, F5 WAF for NGINX 3.7 contains a change in the default policy behavior that will block requests that are larger than 10 MB in size even if the Violation Rating is less than 4. In previous versions, requests greater than 10 MB would be allowed. When these requests are blocked, a `VIOL_REQUEST_MAX_LENGTH` violation will be logged.

- [New http-protocols violation]({{< ref "/nap-waf/v4/declarative-policy/policy.md" >}}) -  **Check maximum number of cookies**. F5 WAF for NGINX policies can now configure and enforce the maximum cookies allowed in a request.


### Supported Packages

#### App Protect

##### Debian 10

- app-protect_25+3.733.0-1~buster_amd64.deb

##### Ubuntu 18.04

- app-protect_25+3.733.0-1~bionic_amd64.deb

##### Ubuntu 20.04

- app-protect_25+3.733.0-1~focal_amd64.deb

##### CentOS 7.4+ / RHEL 7.4+ / Amazon Linux 2

- app-protect-25+3.733.0-1.el7.ngx.x86_64.rpm

### Resolved Issues

- 4700 Fixed - Schema validation fails with unresolved $ref and missing type.
- 4672 Fixed - Some signatures are not matched under specific conditions.
- 4676 Fixed - Not all the payload gets validated on specific scenario.
- 4681 Fixed - Attack detection is not triggered as expected.
- 4682 Fixed - Attack signature may not match as expected.
- 4683 Fixed - Fixing issue with input normalization.
- 4697 Fixed - An error message that relates to a missing bot anomaly appears endlessly on the `bd-socket-plugin.log`.
- 4933 Fixed - Enforcer timeout when consuming very large configurations.
- 5096 Fixed - signatureOverrides were not allowed to be defined on cookies.
- 5112 Fixed - Violation Rating score is higher than expected in some of the cases.

### Important Note
This version introduces a new value `SECURITY_WAF_VIOLATION_TRANSPARENT_MODE` for `outcome_reason` field in the security log. This new value is for future compatibility and it should be ignored for now.

