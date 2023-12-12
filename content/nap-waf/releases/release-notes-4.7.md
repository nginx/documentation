---
authors: []
categories:
- releases
date: "2021-04-14T13:32:41+00:00"
description: ""
docs: DOCS-0000
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
title: NGINX App Protect WAF Release 4.7
toc: true
versions:
- "4.7"
weight: 170
---

December 19, 2023

In this release, NGINX App Protect WAF supports NGINX Plus R31.

### New Features

- [RHEL 9+ Support]({{< relref "/nap-waf/admin-guide/install.md#rhel-9-installation" >}})


### Supported Packages

#### App Protect

##### Alpine 3.16

- app-protect-30.4.461.0-r1.apk

##### Alpine 3.17

- app-protect-30.4.641.0-r1.apk

##### CentOS 7.4+ / RHEL 7.4+ / Amazon Linux 2

- app-protect-31+4.641.0-1.el7.ngx.x86_64.rpm

##### Debian 11

- app-protect_31+4.641.0-1~bullseye_amd64.deb

##### Oracle Linux 8.1+

- app-protect-31+4.641.0-1.el8.ngx.x86_64.rpm

##### RHEL 8.1+

- app-protect-31+4.641.0-1.el8.ngx.x86_64.rpm

#### RHEL 9+ 

- app-protect-31+4.641.0-1.el8.ngx.x86_64.rpm

##### Ubuntu 20.04

- app-protect_31+4.641.0-1~focal_amd64.deb

##### Ubuntu 22.04

- app-protect_31+4.641.0-1~jammy_amd64.deb


#### NGINX Plus

- NGINX Plus R31


### Resolved Issues

- 9065 Fixed - Increasing the limit for "max_request_size" in log configuration from 2k to 10k. The default will change from "any" to 2k to maintain old the behaviour.
- 9297 Fixed - Add new limit from `responseCheckLength` to response ingress event handling in order to reduce the memory used for buffering. 
- 7877 Fixed - If a JSON value contains an URL-decoded value, it should to be decoded and then matched against the signatures. (Check with Edgar/Beni)
- 7876 Fixed - Perform percent decoding on textual parameters received from multipart requests.
- 9459 Fixed - Add RFC checks on the URL referer header as per RFC-3986. If a request contains a referer header with a URL that doesn't comply with RFC standards as per RFC-3986, it will trigger the `VIOL_HTTP_PROTOCOL` violation along with its associated sub-violations.
- 9810 Fixed - Should we add it to RN ? This is something we need to add to docs.
- 9992 Fixed - Should we add this?

### **Important Notes**

