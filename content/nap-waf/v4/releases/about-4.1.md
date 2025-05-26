---
title: NGINX App Protect WAF 4.1
weight: 400
toc: true
type: reference
product: NAP-WAF
docs: DOCS-1116
---

January 31, 2023

This release includes new signatures for [Anti Automation]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#anti-automation-bot-mitigation">}}) (bot defense):

- Added the following Site Monitor bot signatures: OhDear, Cloudflare Monitor, Google Uptime Monitor, NIXStatsbot
- Added the following Service Agent bot signatures: semanticbot, Datafeedwatch, W3C_Unicorn
- Added the following Crawler bot signatures: SearchAtlas, Baidu-YunGuanCe-Bot, Capsulink Crawler, arocom Crawler, sovrn Crawler, TangibleeBot Crawler, Curebot Crawler, DnyzBot Crawler, bitbot Crawler, Botify Crawler, myUsage Cralwer, RepoLookoutBot, Grafana Crawler

### New Features

- [Alpine 3.16 Support]({{< ref "/nap-waf/v4/admin-guide/install.md#alpine-316--alpine-317-installation" >}})
- [Apreload - NGINX App Protect WAF Standalone Configuration]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#nginx-app-protect-waf-standalone-configuration" >}})

### Supported Packages

#### App Protect

##### Debian 11

- app-protect_28+4.100.1-1~bullseye_amd64.deb

##### Ubuntu 18.04

- app-protect_28+4.100.1-1~bionic_amd64.deb

##### Ubuntu 20.04

- app-protect_28+4.100.1-1~focal_amd64.deb

##### CentOS 7.4+ / RHEL 7.4+ / Amazon Linux 2

- app-protect-28+4.100.1-1.el7.ngx.x86_64.rpm

##### RHEL 8.1+

- app-protect-28+4.100.1-1.el8.ngx.x86_64.rpm

##### Alpine 3.16

- app-protect-28.4.100.0-r1.apk

##### Oracle Linux 8.1+

- app-protect-28+4.100.1-1.el8.ngx.x86_64.rpm


### Resolved Issues

- 7298 Fixed - [decodeValueAsBase64]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#detect-base64" >}}) feature is now disabled and the default value for `decodeValueAsBase64` is set to `disabled` to avoid high chance of false positive violations.
- 7238 Fixed - Hyphen metacharacter is now allowed by default in JSON and XML Profiles.
