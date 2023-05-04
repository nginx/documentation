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
title = "NGINX App Protect WAF Release 2.1"
toc = true
versions = ["2.1"]
weight = 960
docs= "DOCS-654"

[menu]
  [menu.docs]
    parent = "Releases"
    weight = 45

+++

October 28, 2020

### New Features

- [Bot Signatures & Bot Origin Validation Support]({{< relref "/nap-waf/configuration-guide/configuration.md#bot-signatures" >}})
- [EPEL Repository Dependency Removal from RHEL]({{< relref "/nap-waf/admin-guide/install.md#rhel-7-4-installation" >}})

### Supported Packages

#### App Protect

##### Debian

- app-protect_22+3.216.0-1~stretch_amd64.deb

##### Ubuntu

- app-protect_22+3.216.0-1~bionic_amd64.deb

##### CentOS / RHEL

- app-protect-22+3.216.0-1.el7.ngx.x86_64.rpm

### Resolved Issues

- 2357 Fixed - Decoding of unpadded base64 encoded strings fails as invalid base64 encoding.
- 2354 Fixed - Positional parameter detected as illegal URL with open-api-files reference.
- 2319 Fixed - [Users permissions for users other than `nginx`]({{< relref "/nap-waf/admin-guide/install.md#user-permissions" >}}).
- 2297 Fixed - `Set-Cookie` header discarded on 302 response code.
- 2296 Fixed - Large number of configured locations in `nginx.conf` result in long startup and reload times.
- 2163 Fixed - `app-protect-compiler` RPM requires `epel-release`.
- 2155 Fixed - No support for IPv6 remote logging syslog destination address.
