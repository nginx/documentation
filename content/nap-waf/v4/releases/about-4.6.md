---
title: NGINX App Protect WAF 4.6
weight: 180
toc: true
type: reference
product: NAP-WAF
docs: DOCS-1347
---

October 17, 2023

This release includes new signatures for [Anti Automation]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#anti-automation-bot-mitigation" >}}) (bot defense):

- Added the following Crawler bot signature: CheckMarkNetwork, FileHound, ReverseEngineeringBot, University Of Edinburgh, Audisto, crawler eb germany, FAST Enterprise, AASA-Bot, Neticle, newslookup-bot, MYIP.MS, Boomtrain Content Bot, Ads Standards Bot, Seamless Link Tester, CMS detector bot, Aesop, BullsEye, Drip, EyeNetIE Scanner, IIS bot, OWLer, RetrevoPageAnalyzer, criteo-crawler, trafilatura
- Added the following HTTP Library bot signatures: libtorrent, Apache-HttpAsyncClient, RobotsTxtParser-VIPnytt, OpenAI Python Library, OpenAPI Generator, ServiceNow Http Client, CarrierWave
- Added the following Service Agent bot signatures: Symbolicator, admantx-sap, SISTRIX Optimizer, anomify.ai ssl_check, CyberPatrol SiteCat Webbot, DaniBot, SiteMonitor Enterprise, GumGum
- Added the following Vulnerability Scanner bot signatures: interact.sh bot, AcuMonitor bot, interact.sh 2 bot 
- Added the following Exploit Tool bot signatures: feroxbuster, WebApp Attacker 
- Added the following Site Monitor bot signature: Allmystery, httpstatus
- Added the following Web Downloader bot signatures: FlashGet
- Updated the following Vulnerability Scanner bot signature: OpenVAS
- Updated the following HTTP Library bot signature: DynatraceSynthetic


### New Features

- [Ubuntu 22.04 Support]({{< ref "/nap-waf/v4/admin-guide/install.md#ubuntu-1804--ubuntu-2004--ubuntu-2204--ubuntu-2404-installation" >}})
- [JSON Web Token Protection]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#json-web-token-protection" >}})
- [Custom Dimensions Log Entries]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#custom-dimensions-log-entries" >}})


### Supported Packages

#### App Protect

##### Alpine 3.16

- app-protect-30.4.583.0-r1.apk

##### Alpine 3.17

- app-protect-30.4.583.0-r1.apk

##### CentOS 7.4+ / RHEL 7.4+ / Amazon Linux 2

- app-protect-30+4.583.0-1.el7.ngx.x86_64.rpm

##### Debian 11

- app-protect_30+4.583.0-1~bullseye_amd64.deb

##### Oracle Linux 8.1+

- app-protect-30+4.583.0-1.el8.ngx.x86_64.rpm

##### RHEL 8.1+

- app-protect-30+4.583.0-1.el8.ngx.x86_64.rpm

##### Ubuntu 20.04

- app-protect_30+4.583.0-1~focal_amd64.deb

##### Ubuntu 22.04

- app-protect_30+4.583.0-1~jammy_amd64.deb


### Resolved Issues

- 8264 Fixed - Implemented the capability to turn enforcer debug logs on/off without the need for a system reload to apply the changes.
- 9060 Fixed - Default uri size is changed from 2k to 8k so that the user can send bigger uri without any configuration change. Now the user will be able to control the size by using policy configuration.
- 9185 Fixed - Unparsable requests, rejected by NGINX are now flagged with `SECURITY_WAF_VIOLATION` instead of `SECURITY_WAF_VIOLATION_TRANSPARENT`.
- 8339 Fixed - Attack signatures accuracy is now available for configuration in the security log.


### **Important Notes**

- Starting with this release, the `app_protect_compressed_requests_action` directive has been deprecated from the nginx configuration. Now by default the enforcer will decompress all the HTTP compressed payload request and will apply the enforcment. See [Handling Compressed Requests]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#handling-compressed-requests" >}}) for more details.

- The NGINX App Protect WAF has been enhanced to include response signature checks within the "filetypes" section. You have an option to enable the signature verification in the response by setting the `responseCheck` parameter to true. By default, this parameter is set to false. See [Restrict Response Signatures]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#restrict-response-signatures" >}}) for more details.
