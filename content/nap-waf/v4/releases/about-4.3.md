---
title: NGINX App Protect WAF 4.3
weight: 210
toc: true
type: reference
product: NAP-WAF
nd-docs: DOCS-1202
---

May 2, 2023

In this release, NGINX App Protect WAF supports NGINX Plus R29.

This release includes new signatures for [Anti Automation]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#anti-automation-bot-mitigation" >}}) (bot defense):

- Added the following Crawler bot signatures: YOURLS Crawler, Atomseo broken link checker, proxylist.to Checker, Aspiegel Crawler, digitalshadowsbot, idealo-bot pricevalidator
- Added the following Exploit Tool bot signatures: BackDoorBot
- Added the following Site Monitor bot signatures: RWTH Aachen University Scanner
- Added the following Service Agent bot signatures: AirPlay Server Info, WP Rocket Preload


### Supported Packages

#### App Protect

##### Debian 11

- app-protect_29+4.279.0-1~bullseye_amd64.deb

##### Ubuntu 18.04

- app-protect_29+4.279.0-1~bionic_amd64.deb

##### Ubuntu 20.04

- app-protect_29+4.279.0-1~focal_amd64.deb

##### CentOS 7.4+ / RHEL 7.4+ / Amazon Linux 2

- app-protect-29+4.279.0-1.el7.ngx.x86_64.rpm

##### RHEL 8.1+

- app-protect-29+4.279.0-1.el8.ngx.x86_64.rpm

##### Alpine 3.16

- app-protect-29.4.279.0-r1.apk

##### Oracle Linux 8.1+

- app-protect-29+4.279.0-1.el8.ngx.x86_64.rpm


#### NGINX Plus

- NGINX Plus R29


### Resolved Issues

- 7987 Fixed - Fixed Violation Rating calculation for trusted bots, untrusted bots and malicious bots.
- 8010 Fixed - Handling of response headers.

### **Important Note**

This release introduces a change in the `json_log` field output for Violation details. Starting with NGINX App Protect WAF release 4.3, the Security Log's `json_log` field will include all available information regarding Violation details in JSON format. Refer [Security Log]({{< ref "/nap-waf/v4/logging-overview/security-log.md#available-security-log-attributes" >}}) document for more details.

