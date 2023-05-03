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
title = "NGINX App Protect WAF Release 3.12.2"
toc = true
versions = ["3.12.2"]
weight = 620
docs = "DOCS-988"

[menu]
  [menu.docs]
    parent = "Releases"
    weight = 45

+++

November 17, 2022

This release is intended to support NGINX Instance Manager.

### New Features

- The NGINX App Protect WAF release includes the support of NGINX Instance Manager capability to edit and publish policy bundles. <br> See [NGINX Instance Manager releases](https://docs.nginx.com/nginx-management-suite/nim/releases/).

### Supported Packages

#### App Protect

##### Debian 10

- app-protect_27+3.1088.2-1~buster_amd64.deb

##### Ubuntu 18.04

- app-protect_27+3.1088.2-1~bionic_amd64.deb

##### Ubuntu 20.04

- app-protect_27+3.1088.2-1~focal_amd64.deb

##### CentOS 7.4+ / RHEL 7.4+ / Amazon Linux 2

- app-protect-27+3.1088.2-1.el7.ngx.x86_64.rpm

##### RHEL 8.1+

- app-protect-27+3.1088.2-1.el8.ngx.x86_64.rpm

##### Oracle Linux 8.1+

- app-protect-27+3.1088.2-1.el8.ngx.x86_64.rpm
