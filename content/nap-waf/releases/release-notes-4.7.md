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

- app-protect-31.4.641.0-r1.apk

##### Alpine 3.17

- app-protect-31.4.641.0-r1.apk

##### CentOS 7.4+ / RHEL 7.4+ / Amazon Linux 2

- app-protect-31+4.641.0-1.el7.ngx.x86_64.rpm

##### Debian 11

- app-protect_31+4.641.0-1~bullseye_amd64.deb

##### Oracle Linux 8.1+

- app-protect-31+4.641.0-1.el8.ngx.x86_64.rpm

##### RHEL 8.1+

- app-protect-31+4.641.0-1.el8.ngx.x86_64.rpm

##### RHEL 9+ 

- app-protect-31+4.641.0-1.el9.ngx.x86_64.rpm

##### Ubuntu 20.04

- app-protect_31+4.641.0-1~focal_amd64.deb

##### Ubuntu 22.04

- app-protect_31+4.641.0-1~jammy_amd64.deb


#### NGINX Plus

- NGINX Plus R31


### Resolved Issues

- 9065 Fixed - Increasing the limit for "max_request_size" in log configuration from 2k to 10k. The default will change from "any" to 2k to maintain the old behaviour.
- 9297 Fixed - Add new limit from `responseCheckLength` to response ingress event handling in order to reduce the memory used for buffering. 
- 7877 Fixed - If a JSON value contains an URL-decoded value, it should to be decoded and then matched against the signatures.
- 7876 Fixed - Perform percent decoding on textual parameters received from multipart requests.
- 9992 Fixed - Enforcer does not support Edwards-curve Digital Signature Algorithm (EdDSA) on CentOS 7. When a JSON Web Token (JWT) signed with EdDSA is used on CentOS 7, it results in a `VIOL_ACCESS_INVALID` error.


### **Important Note**

- Starting with this release, the bot signatures list is generated automatically as a part of the `app-protect-bot-signatures` package, which is a dependency of the `app-protect-compiler` package. It resembles a text file similar to the readme-files found in the attack-signature. <br>
Refer to the [Bot Signatures Updated File]({{< relref "/nap-waf/configuration-guide/configuration.md#bot-signatures-updated-file" >}}) for more details.
