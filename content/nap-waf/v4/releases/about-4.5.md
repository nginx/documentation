---
title: NGINX App Protect WAF 4.5
weight: 190
toc: true
type: reference
product: NAP-WAF
docs: DOCS-1253
---

August 15, 2023

This release includes new signatures for [Anti Automation]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#anti-automation-bot-mitigation" >}}) (bot defense):

- Added the following Crawler bot signatures: SEOChecker, ev-crawler, FFZBot ImageGrabber, ConveraCrawler, EveryoneSocialBot, Google Ads Bot
- Added the following HTTP Library bot signatures: Airbnb calendar importer
- Added the following Exploit Tool bot signatures: ThinkPHP Malicious Bot, KPLR-requests
- Added the following Service Agent bot signatures: Pleroma, ChatGPT-User, Netflix Media Player, KickFire Extension
- Added the following Social Media Agent bot signatures: Misskey Agent, Lemmy Agent
- Added the following Site Monitor bot signatures: StatusCake Monitor
- Added the following Web Downloader bot signatures: Transmission Bot


### New Feature

In this release, NGINX App Protect WAF supports NGINX Plus R30.

- [Alpine 3.17 Support]({{< ref "/nap-waf/v4/admin-guide/install.md#alpine-316--alpine-317-installation" >}})

### Supported Packages

#### App Protect

##### Alpine 3.16

- app-protect-30.4.457.0-r1.apk

##### Alpine 3.17

- app-protect-30.4.457.0-r1.apk

##### CentOS 7.4+ / RHEL 7.4+ / Amazon Linux 2

- app-protect-30+4.457.0-1.el7.ngx.x86_64.rpm

##### Debian 11

- app-protect_30+4.457.0-1~bullseye_amd64.deb

##### Oracle Linux 8.1+

- app-protect-30+4.457.0-1.el8.ngx.x86_64.rpm

##### RHEL 8.1+

- app-protect-30+4.457.0-1.el8.ngx.x86_64.rpm

##### Ubuntu 20.04

- app-protect_30+4.457.0-1~focal_amd64.deb


#### NGINX Plus

- NGINX Plus R30


### Resolved Issues

- 8976 Fixed - When using multiple arcsight remote loggers for NGINX App Protect WAF policy, some requests may cause enforcer to crash.
- 8312 Fixed - Running the get-signatures utility writes output to a different location.
- 8936 Fixed - To reduce potential false positives, user defined Headers and Cookies that do not specify whether their decodeValueAsBase64 value, are now `disabled` instead of `enabled` by default.
- 8939 Fixed - The issue with rejected gRPC request support id logged as "Passed" has been fixed.
- 8821 Fixed - The Override Rules now support gRPC traffic. The previous limitation regarding the use of [Override Rules]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#override-rules" >}}) with gRPC traffic has been resolved.
- 9061 Fixed - Evasions configuration does not work in an Override Rule policy.


### **Important Note**

- Starting with this release, Ubuntu 18.04 support has been deprecated.
