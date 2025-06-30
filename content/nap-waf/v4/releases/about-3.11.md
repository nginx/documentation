---
title: NGINX App Protect WAF 3.11
weight: 660
toc: true
type: reference
product: NAP-WAF
nd-docs: DOCS-891
---

June 28, 2022

In this release, support for NGINX App Protect WAF is added to NGINX Plus R27.

This release includes updated signatures for the [Anti Automation]({{< ref "/nap-waf/v4/configuration-guide/configuration.md#anti-automation-bot-mitigation" >}}) (bot defense) feature as follows:

- Added the following HTTP Library bot signatures: req
- Added the following Exploit Tool bot signatures: spring4shell-scan, DIVD Vulnerability Scanner, JNDI Exploit Bot, D-Link DNS Change Exploiter
- Added the following Spam Bot bot signatures: l9scan, HomeNet
- Added the following Crawler bot signatures: Keybot Translation-Search-Machine
- Updated the following Exploit Tool bot signatures: JNDI Exploit Bot, Hello-World API

### New Features

- [Oracle Linux 8.1+ Support]({{< ref "/nap-waf/v4/admin-guide/install.md#oracle-linux-81-installation" >}})

### Supported Packages

#### App Protect

##### Debian 10

- app-protect_27+3.954.0-1~buster_amd64.deb

##### Ubuntu 18.04

- app-protect_27+3.954.0-1~bionic_amd64.deb

##### Ubuntu 20.04

- app-protect_27+3.954.0-1~focal_amd64.deb

##### CentOS 7.4+ / RHEL 7.4+ / Amazon Linux 2

- app-protect-27+3.954.0-1.el7.ngx.x86_64.rpm

##### RHEL 8.1+

- app-protect-27+3.954.0-1.el8.ngx.x86_64.rpm

##### Oracle Linux 8.1+

- app-protect-27+3.954.0-1.el8.ngx.x86_64.rpm

#### NGINX Plus

- NGINX Plus R27

### Resolved Issues

- 6084 Fixed - The `nginx -t` command will fail in cases when there is no `user` directive defined in `nginx.conf`.
- 6321 Fixed - Updated the `max_request_size` log format parameter to accept the 2k range value using k string.


### **Important Note**

When upgrading the NGINX App Protect WAF deployments on Virtual Machines (VM), where the upgrade includes a NGINX Plus release upgrade as well, customers might witness some error messages about the upgrade failure.
Customers are advised to ignore these messages and continue with the [upgrade procedure]({{< ref "/nap-waf/v4/admin-guide/install.md#upgrading-app-protect" >}}) as described in the NGINX App Protect WAF Admin guide.
Additional NGINX restart might be required in order to complete the upgrade procedure.
