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
title = "NGINX App Protect WAF Release 1.3"
toc = true
versions = ["1.3"]
weight = 1000
docs= "DOCS-652"

[menu]
  [menu.docs]
    parent = "Releases"
    weight = 45

+++

July 21, 2020

### New Features

- [RHEL 7.4+ Support]({{< relref "/nap-waf/admin-guide/install.md#rhel-7-4-installation" >}})
- [RHEL UBI7 Support]({{< relref "/nap-waf/admin-guide/install.md#rhel-ubi7-docker-deployment-example" >}})
- [SELinux Configuration]({{< relref "/nap-waf/admin-guide/install.md#selinux-configuration" >}})
- [New Strict Security Policy]({{< relref "/nap-waf/configuration-guide/configuration.md#the-strict-policy" >}})
- [Security Log Write To File]({{< relref "/nap-waf/configuration-guide/configuration.md#security-logs" >}})


### Supported Packages

#### App Protect

##### Debian

- app-protect_22+3.90.2-1~stretch_amd64.deb

##### CentOS / RHEL

- app-protect-22+3.90.2-1.el7.ngx.x86_64.rpm


### Known Issues

#### 1868 - Removal of the app-protect RPM package results in SELinux-related failure messages

This is a cosmetic issue only:

```shell
yum remove app-protect

Erasing : app-protect-22+3.90.2-1.el7.ngx.x86_64 1/5
libsemanage.semanage_direct_remove_key: Removing last app-protect module (no other app-protect module exists at another priority).
restorecon: lstat(/usr/lib64/systemd/system/nginx-app-protect-compiler.service) failed: No such file or directory
restorecon: lstat(/usr/lib64/systemd/system/nginx-app-protect.service) failed: No such file or directory
```

### Resolved Issues

- 1758 Fixed - Non-CSV-compliant escaping of quotes as %22 in default security log fields.
- 1774 Added - Default security log settings file `/etc/app_protect/conf/log_default.json`.
- 1784 Added - "Unescaped space in URL" sub-violation.
- 1785 Fixed - `LIBDATASYNC|ERR` messages in `bd-socket-plugin.log`.
- 1811 Fixed - Empty non-CSV-compliant 'is_truncated' field in default security log settings.