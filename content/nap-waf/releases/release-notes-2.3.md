---
authors: []
categories:
- releases
date: "2021-04-14T13:32:41+00:00"
description: ""
docs: DOCS-656
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
title: NGINX App Protect WAF Release 2.3
toc: true
versions:
- "2.3"
weight: 920
---

December 30, 2020

### New Features

- [Debian 10 Support]({{< relref "/nap-waf/admin-guide/install.md#debian-10-installation" >}})
- [Alpine 3.10 Support]({{< relref "/nap-waf/admin-guide/install.md#alpine-3-10-installation" >}})
- [User-defined HTTP Headers]({{< relref "/nap-waf/configuration-guide/configuration.md#user-defined-http-headers" >}})
- [Converter Tools]({{< relref "/nap-waf/configuration-guide/configuration.md#converter-tool" >}})
- [Attack Signature Report Tool]({{< relref "/nap-waf/configuration-guide/configuration.md#attack-signature-report-tool" >}})

### Supported Packages

#### App Protect

##### Debian 9

- app-protect_23+3.281.0-1~stretch_amd64.deb

##### Debian 10

- app-protect_23+3.281.0-1~buster_amd64.deb

##### Ubuntu

- app-protect_23+3.281.0-1~bionic_amd64.deb

##### Alpine 3.10

- app-protect-23.3.281.0-r1.apk

##### CentOS / RHEL

- app-protect-23+3.281.0-1.el7.ngx.x86_64.rpm

### Resolved Issues

- 1270 Fixed - Unit hostname `N/A` in security log.

### Known Issues

#### 3014 - HTTP2 browser traffic is classified as bot.

- Workaround - Disable bot defense in policies used on HTTP2 locations.