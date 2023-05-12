---
authors: []
categories:
- releases
date: "2021-04-14T13:32:41+00:00"
description: ""
docs: DOCS-657
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
title: NGINX App Protect WAF Release 3.0
toc: true
versions:
- "3.0"
weight: 800
---

January 29, 2021

### New Features

- [Advanced gRPC Protection for Unary Traffic]({{< relref "/nap-waf/configuration-guide/configuration.md#advanced-grpc-protection-for-unary-traffic" >}})

### Supported Packages

#### App Protect

##### Debian 9

- app-protect_23+3.332.0-1~stretch_amd64.deb

##### Debian 10

- app-protect_23+3.332.0-1~buster_amd64.deb

##### Ubuntu

- app-protect_23+3.332.0-1~bionic_amd64.deb

##### Alpine 3.10

- app-protect-23.3.332.0-r1.apk

##### CentOS / RHEL

- app-protect-23+3.332.0-1.el7.ngx.x86_64.rpm

### Resolved Issues

- 3014 Fixed - HTTP2 browser traffic is classified as bot.
- 3105 Fixed - Missing `app-protect-compiler` Debian package dependency required for `/opt/app_protect/bin/get-signatures` tool.