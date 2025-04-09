---
title: NGINX App Protect WAF 4.4
weight: 200
toc: true
type: reference
product: NAP-WAF
docs: DOCS-1252
---

July 5, 2023

This release includes new signatures for [Anti Automation]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#anti-automation-bot-mitigation" >}}) (bot defense):

- Added the following Crawler bot signatures: IAS Crawler, Bing Crawler, DIS Group Crawler, WebBot Scrapper, AddSearch Bot, WPWS bot, iSec_Bot, Newstral Crawler, layoftheland.online Crawler, Quantcastbot, Spiceworks Crawlers, CYRATING Crawler, Jooblebot, YouBot, MetaJobBot, ScooperBot, WebwikiBot, JusProg - Domain Crawler, TinEye-Web, PEER39 Crawler, AMPPARIT Crawler, RuxitSynthetic
- Added the following HTTP Library bot signatures: Atoka Logo Fetcher, Zend Http Client Class, Home Assistant API, Probe Image Size, Webpage.rs, Okta Open ID Connect Library, MetadataScraper, node-openid-client, Embed PHP Library, PHP-SOAP
- Added the following Service Agent bot signatures: OpenSearch Service, Plesk screenshot bot, EasyBib+AutoCite
- Added the following Site Monitor bot signatures: Nx Witness Monitor, Newslitbot, Mattermost Bot
- Added the following RSS Reader bot signatures: RSStT, w1NewsBot-RSS, RSS Guard, FeedViewer
- Added the following Spam Bot bot signatures: Ixquick.com
- Added the following Search Bot bot signatures: Xpanse Search Bot


### New Feature

- [Override Rules]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#override-rules" >}})

### Supported Packages

#### App Protect

##### Debian 11

- app-protect_29+4.402.0-1~bullseye_amd64.deb

##### Ubuntu 18.04

- app-protect_29+4.402.0-1~bionic_amd64.deb

##### Ubuntu 20.04

- app-protect_29+4.402.0-1~focal_amd64.deb

##### CentOS 7.4+ / RHEL 7.4+ / Amazon Linux 2

- app-protect-29+4.402.0-1.el7.ngx.x86_64.rpm

##### RHEL 8.1+

- app-protect-29+4.402.0-1.el8.ngx.x86_64.rpm

##### Alpine 3.16

- app-protect-29.4.402.0-r1.apk

##### Oracle Linux 8.1+

- app-protect-29+4.402.0-1.el8.ngx.x86_64.rpm


### Resolved Issues

- 8302 Fixed - Remote logging destinations when IPv6 is disabled system-wide.
- 7819 Fixed - The login issue encountered on the iOS client when using the AJAX Response Page has been resolved. This problem specifically occurs on iOS devices when NGINX's `proxy_buffering` is disabled.
- 8261 Fixed - Binaries have been upgraded with module and version updates to address and resolve identified vulnerabilities.
- 8477 Fixed - TCP connections in the CLOSE_WAIT state for specific types of requests.

### **Important Notes**

- There is a limitation when using [Override Rules]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#override-rules" >}}) with gRPC. The Override Rules do not provide support for gRPC traffic. If the Override Rules are configured to match gRPC traffic, it will result in the blocking of such traffic.

- Starting with the upcoming release version of NGINX Plus R30, Ubuntu 18.04 will no longer be supported and will be deprecated.
