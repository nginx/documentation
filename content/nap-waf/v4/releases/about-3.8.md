---
title: NGINX App Protect WAF 3.8
weight: 720
toc: true
type: reference
product: NAP-WAF
docs: DOCS-832
---

January 18, 2022

### New Features

- [RHEL 8.1+ Support]({{< ref "/nap-waf/v4/admin-guide/install.md#rhel-81-installation" >}})
- [Blocking Observability]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#blocking-observability" >}})
- [Memory Consumption Improvement](#important-notes)

### Supported Packages

#### App Protect

##### Debian 10

- app-protect_25+3.760.0-1~buster_amd64.deb

##### Ubuntu 18.04

- app-protect_25+3.760.0-1~bionic_amd64.deb

##### Ubuntu 20.04

- app-protect_25+3.760.0-1~focal_amd64.deb

##### CentOS 7.4+ / RHEL 7.4+ / Amazon Linux 2

- app-protect-25+3.760.0-1.el7.ngx.x86_64.rpm

##### RHEL 8.1+

- app-protect-25+3.760.0-1.el8.ngx.x86_64.rpm

### Resolved Issues

- 5207 Fixed - Improved warning for supported violations that have their settings derived from other policy elements, but are not directly configurable.


### Important Notes

- This release introduces a change in dependency for `attack signatures` and `threat campaigns` bundles from `app-protect` to `app-protect-compiler`. Due to the upcoming modern mode of operation development and new packaging, the dependency of these packages is now transferred to `app-protect-compiler` package.  This change in dependency will have a major impact that might be relevant to some customers, who are using commands to only install the attack signatures and on the way NGINX App Protect and NGINX Plus are installed as well.

- **Memory Consumption Improvement** - Beginning in release 3.8, NGINX App Protect WAF is optimized to consume ~70MB less per loaded policy, compared to the previous releases. Currently, when a policy contains an xml profile, NGINX App Protect WAF allocates up to 256 xml parsers, each consuming ~300KB. This is done at startup per thread, per xml profile, per policy.



