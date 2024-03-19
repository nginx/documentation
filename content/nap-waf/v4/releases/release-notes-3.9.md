---
authors: []
categories:
- releases
date: "2021-04-14T13:32:41+00:00"
description: ""
docs: DOCS-838
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
title: NGINX App Protect WAF Release 3.9
toc: true
versions:
- "3.9"
weight: 710
---

February 15, 2022 

In this release, support for NGINX App Protect WAF is added to NGINX Plus R26. 

### Supported Packages

#### App Protect

##### Debian 10

- app-protect_26+3.780.1-1~buster_amd64.deb

##### Ubuntu 18.04

- app-protect_26+3.780.1-1~bionic_amd64.deb

##### Ubuntu 20.04

- app-protect_26+3.780.1-1~focal_amd64.deb

##### CentOS 7.4+ / RHEL 7.4+ / Amazon Linux 2

- app-protect-26+3.780.1-1.el7.ngx.x86_64.rpm 

##### RHEL 8.1+

- app-protect-26+3.780.1-1.el8.ngx.x86_64.rpm

### Resolved Issues

- 5358 Fixed - neverLogRequests/blockRequests doesn't work for local IP addresses which starts with 127.0.0.*.
