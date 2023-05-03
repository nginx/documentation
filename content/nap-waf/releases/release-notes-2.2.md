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
title = "NGINX App Protect WAF Release 2.2"
toc = true
versions = ["2.2"]
weight = 940
docs= "DOCS-655"

[menu]
  [menu.docs]
    parent = "Releases"
    weight = 45

+++

December 09, 2020

### New Features

In this release support for NGINX App Protect WAF is added to NGINX Plus R23.

- [Detect Base64]({{< relref "/configuration-guide/configuration.md#detect-base64" >}})
- [Anti Automation Header Anomalies]({{< relref "/configuration-guide/configuration.md#header-anomalies" >}})

### Supported Packages

#### App Protect

##### Debian

- app-protect_23+3.263.0-1~stretch_amd64.deb

##### Ubuntu

- app-protect_23+3.263.0-1~bionic_amd64.deb

##### CentOS / RHEL

- app-protect-23+3.263.0-1.el7.ngx.x86_64.rpm

### Resolved Issues

- 2482 Fixed - 100% CPU reached on reload of new security log configuration during traffic.
- 2670 Fixed - Cookie value in security log violation details showed `name=value` instead of `value` for base64 decodable cookies.
- 2872 Fixed - Security logs get sent to the previous destination as well as the new one after reload.