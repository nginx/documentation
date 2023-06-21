---
authors: []
categories:
- releases
date: "2021-04-14T13:32:41+00:00"
description: ""
docs: DOCS-1202
doctypes:
- concept
draft: false
journeys:
- researching
- getting started
- using
- self service
menu:
  docs:
    parent: Releases
    weight: 45
personas:
- devops
- netops
- secops
- support
roles:
- admin
- user
title: NGINX App Protect WAF Release 4.4
toc: true
versions:
- "4.4"
weight: 200
---

July 5, 2023

This release includes new signatures for [Anti Automation]({{< relref "/nap-waf/configuration-guide/configuration.md#anti-automation-bot-mitigation" >}}) (bot defense):


- Added the following Crawler bot signatures: IAS Crawler, Bing Crawler, DIS Group Crawler, WebBot Scrapper, AddSearch Bot, WPWS bot, iSec_Bot, Newstral Crawler, layoftheland.online Crawler, Quantcastbot, Spiceworks Crawlers, CYRATING Crawler, Jooblebot, YouBot, MetaJobBot, ScooperBot, WebwikiBot, JusProg - Domain Crawler, TinEye-Web 
- Added the following HTTP Library bot signatures: Atoka Logo Fetcher, Zend Http Client Class, Home Assistant API, Probe Image Size, Webpage.rs, Okta Open ID Connect Library, MetadataScraper, node-openid-client, Embed PHP Library, PHP-SOAP
- Added the following Service Agent bot signatures: OpenSearch Service, Plesk screenshot bot, EasyBib+AutoCite
- Added the following Site Monitor bot signatures: Nx Witness Monitor, Newslitbot
- Added the following RSS Reader bot signatures: RSStT, w1NewsBot-RSS, RSS Guard, FeedViewer
- Added the following Spam Bot bot signatures: Ixquick.com
- Added the following Search Bot bot signatures: Xpanse Search Bot


### Supported Packages

#### App Protect

##### Debian 11

- app-protect_29+4.377.0-1~bullseye_amd64.deb

##### Ubuntu 18.04

- app-protect_29+4.377.0-1~bionic_amd64.deb

##### Ubuntu 20.04

- app-protect_29+4.377.0-1~focal_amd64.deb

##### CentOS 7.4+ / RHEL 7.4+ / Amazon Linux 2

- app-protect-29+4.377.0-1.el7.ngx.x86_64.rpm

##### RHEL 8.1+

- app-protect-29+4.377.0-1.el8.ngx.x86_64.rpm

##### Alpine 3.16

- app-protect-29.4.377.0-r1.apk

##### Oracle Linux 8.1+

- app-protect-29+4.377.0-1.el8.ngx.x86_64.rpm



### Resolved Issues

- 8133 Fixed - Fixed the issue where NGINX App Protect was unable to retrieve compilation status. 
- 8302 Fixed - Fixed remote logging destinations when IPv6 is disabled system-wide.
- 7819 Fixed - Fixed iOS clients login issue when using AJAX Response Page. This problem specifically occurs on iOS devices when NGINX's `proxy_buffering` is disabled.
- 8250 Fixed - 
- 8261 Fixed - 
- 8716 Fixed - not sure if we want to add it
- 8131 Fixed - Check with ohad if we need to add it, as it is a customer case

### **Important Note**
 
There is a limitation when using [Policy Override Rules]({{< relref "/nap-waf/configuration-guide/configuration.md#policy-override-rules" >}}) with gRPC. The Policy Override Rules do not provide support for gRPC traffic. If policy override rules are configured to match gRPC traffic, it will result in blocking of such traffic.