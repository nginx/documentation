---
authors: []
categories:
- releases
date: "2021-04-14T13:32:41+00:00"
description: ""
docs: DOCS-842
doctypes:
- concept
draft: false
journeys:
- researching
- getting started
- using
- self service
personas:
- devops
- netops
- secops
- support
roles:
- admin
- user
title: NGINX App Protect WAF Release 3.9.1
toc: true
versions:
- 3.9.1
weight: 700
---

March 9, 2022


Support for NGINX App Protect WAF is added to NGINX Plus R26 starting with release 3.9.

This release includes updated signatures for the [Anti Automation](https://docs.nginx.com{{< relref "/nap-waf/v4/configuration-guide/configuration.md#anti-automation-bot-mitigation" >}}) (bot defense) feature as follows:

- Added the following Spam Bot bot signatures: meow, ANETInspect, OnlyScans, HonoluluBot, Search engine under construction, browsergetproto1.2
- Added the following Service Agent bot signatures: YandeG, FGX-Web, Detectify, AndroidDownloadManager
- Added the following Web Spider bot signatures: DoCoMo 2.0, GGG
- Added the following HTTP Library bot signatures: Alamofire, PerlDAV, node-fetch
- Added the following Crawler bot signatures: CryptoAPI
- Added the following Network Scanner bot signatures: Exchange scanner
- Added the following Exploit Tool bot signatures: Exchange RCE Detector(CVE-2021-34473)
- Added the following Vulnerability Scanner bot signatures: Log4Shell detector
- Updated the following Crawler bot signatures: ds9, coccoc
- Updated the following Exploit Tool bot signatures: JNDI Exploit Bot


### Supported Packages

#### App Protect

##### Debian 10

- app-protect_26+3.796.0-1~buster_amd64.deb

##### Ubuntu 18.04

- app-protect_26+3.796.0-1~bionic_amd64.deb

##### Ubuntu 20.04

- app-protect_26+3.796.0-1~focal_amd64.deb

##### CentOS 7.4+ / RHEL 7.4+ / Amazon Linux 2

- app-protect-26+3.796.0-1.el7.ngx.x86_64.rpm

##### RHEL 8.1+

- app-protect-26+3.796.0-1.el8.ngx.x86_64.rpm

### Resolved Issues

- 5633 Fixed - Syslog contains undesired line breaks.
