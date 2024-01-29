---
authors: []
categories:
- releases
date: "2021-04-14T13:32:41+00:00"
description: ""
docs: DOCS-1360
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
title: NGINX App Protect WAF Release 4.8
toc: true
versions:
- "4.8"
weight: 160
---

February 6, 2024


### New Features

- [Debian 12 Support]({{< relref "/nap-waf/admin-guide/install.md#debian-10--debian-11--debian-12-installation" >}})
- [Actionable Rules in Override Rules Policy]({{< relref "/nap-waf/configuration-guide/configuration.md#override-rules" >}})
- [Geolocation Enforcement]({{< relref "/nap-waf/configuration-guide/configuration.md#geolocation-support-in-app-protect" >}}) 
- [Partial Masking of Data using Data Guard]({{< relref "/nap-waf/configuration-guide/configuration.md#partial-masking-of-data-using-data-guard" >}})


### Supported Packages

#### App Protect

##### Alpine 3.16

- app-protect-31.4.759.0-r1.apk

##### Alpine 3.17

- app-protect-31.4.759.0-r1.apk

##### CentOS 7.4+ / RHEL 7.4+ / Amazon Linux 2

- app-protect-31+4.759.0-1.el7.ngx.x86_64.rpm

##### Debian 11

- app-protect_31+4.759.0-1~bullseye_amd64.deb

##### Debian 12

- app-protect_31+4.759.0-1~bullseye_amd64.deb

##### Oracle Linux 8.1+

- app-protect-31+4.759.0-1.el8.ngx.x86_64.rpm

##### RHEL 8.1+

- app-protect-31+4.759.0-1.el8.ngx.x86_64.rpm

##### RHEL 9+ 

- app-protect-31+4.759.0-1.el9.ngx.x86_64.rpm

##### Ubuntu 20.04

- app-protect_31+4.759.0-1~focal_amd64.deb

##### Ubuntu 22.04

- app-protect_31+4.759.0-1~jammy_amd64.deb


### Resolved Issues

- 10063 Fixed - In some cases request could hang in when urlContentProfiles type set to "do-nothing".
- 10156 Fixed - Chunked requests connection is stuck in CLOSE_WAIT state.


### **Important Notes**

- Actionable Rules and Geolocation are now supported in [Policy Override Rules]({{< relref "/nap-waf/configuration-guide/configuration.md#override-rules" >}}).