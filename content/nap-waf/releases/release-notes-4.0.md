+++
authors = []
categories = ["releases"]
date = "2021-04-14T13:32:41+00:00"
description = ""
doctypes = ["concept"]
draft = false
journeys = ["researching", "getting started", "using", "self service"]
personas = ["devops", "netops", "secops", "support"]
roles = ["admin", "user"]
title = "NGINX App Protect WAF Release 4.0"
toc = true
versions = ["4.0"]
weight = 410
docs = "DOCS-994"

[menu]
  [menu.docs]
    parent = "Releases"
    weight = 45

+++

November 29, 2022

In this release, NGINX App Protect WAF supports NGINX Plus R28.

This release includes new signatures for [Anti Automation]({{< relref "/configuration-guide/configuration.md#anti-automation-bot-mitigation" >}}) (bot defense):

- Added the following Spam Bot bot signatures: RealStresser, AraTurka, Ocarinabot, A Fake Google Certificates Bridge
- Added the following Exploit Tool bot signatures: RealityCheats, Root S, Report Runner, Momentum, 103scUWU
- Added the following Service Agent bot signatures: AppDynamics, Blackbox Exporter, B2B Bot, BlogTraffic, Fyrebot, CipaCrawler, redditbot, jpg-newsbot, Elastic-Heartbeat, W3C-mobileOK, WGETbot, BoxcarBot, DynatraceSynthetic, Rackspace Monitoring, Site24x7, webchk
- Added the following Crawler bot signatures: blogmuraBot Crawler, contxbot, SocialRankIO Bot, DataProvider crawler, Speedy Spider, SiteExplorer, Taboolabot, Eyeotabot, Mappy, PiplBot, PR-CY.RU, NTENTbot, FemtosearchBot, CrunchBot, Whoiswebsitebot, CC Metadata Scaper, eright, wp.com feedbot, G2 Web Services, duedil crawler, IT Stuttgart Crawler, 2ip.ru CMS Crawler, startmebot, StorygizeBot
- Added the following Social Media Agent bot signatures: @LinkArchiver twitter bot
- Added the following Site Monitor bot signatures: Uptime-Kuma, Google-Structured-Data-Testing-Tool, Dubbotbot
- Added the following RSS Reader bot signatures: rssbot
- Added the following Network Scanner bot signatures: Baidu-YunGuanCe-SLABot


### New Features

- [Debian 11 Support]({{< relref "/admin-guide/install.md#debian-11-installation" >}})
- [gRPC Protection for Bidirectional Streaming]({{< relref "/configuration-guide/configuration.md#grpc-protection-for-bidirectional-streaming" >}})
- [Product Release Info File]({{< relref "/troubleshooting-guide/troubleshooting.md#opening-a-support-ticket" >}})

### Supported Packages

#### App Protect

##### Debian 11

- app-protect_28+4.2.0-1~bullseye_amd64.deb

##### Ubuntu 18.04

- app-protect_28+4.2.0-1~bionic_amd64.deb

##### Ubuntu 20.04

- app-protect_28+4.2.0-1~focal_amd64.deb

##### CentOS 7.4+ / RHEL 7.4+ / Amazon Linux 2

- app-protect-28+4.2.0-1.el7.ngx.x86_64.rpm

##### RHEL 8.1+

- app-protect-28+4.2.0-1.el8.ngx.x86_64.rpm

##### Oracle Linux 8.1+

- app-protect-28+4.2.0-1.el8.ngx.x86_64.rpm

 #### NGINX Plus
 
 - NGINX Plus R28

### Resolved Issues

- 6561 Fixed - Some updates to NGINX App Protect WAF policy template as listed below:<br><br><ol><li>The policy field `enablePassiveMode` is not supported in NGINX App Protect WAF and has been removed from configurable elements.</li><li>HTTP protocol compliance sub-violation "Check maximum number of cookies" is now enabled by default. A request which contains over 100 cookies will be marked illegal.</li></ol>