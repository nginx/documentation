---
title: NGINX App Protect WAF 5.4
weight: 870
toc: true
type: reference
product: NAP-WAF
docs: DOCS-000
---

November 19th, 2024

{{< include "nap-waf/upgrade-recompile-warning.md" >}}

---

## New features

- Added support for Amazon Linux 2023
- Added support for [readOnlyFileSystem in Kubernetes deployments]({{< relref "/nap-waf/v5/admin-guide/deploy-on-kubernetes.md#configure-read-only-file-systems" >}})
- Added a [a policy converter to the compiler]({{< relref "/nap-waf/v5/configuration-guide/configuration.md#policy-converter">}})
- NGINX App Protect WAF now supports NGINX Plus R33

Please read the [subscription licenses]({{< relref "/solutions/about-subscription-licenses.md" >}}) topic for information about R33.

---

## Important notes

- Alpine 3.16 is no longer supported.

---

## Resolved issues

- 11973 Fixed - Updated the Go version to 1.23.1
- 11469 Fixed _apt-get update_ warning for Ubuntu 22.04 

---

## Known issues

On Ubuntu 24.04, you may receive the following error when uninstalling an old version of NGINX App Protect and installing a newer version:

```text
APP_PROTECT failed to open /opt/app_protect/config/config_set.json
```

This can occur if you are not using the default `nginx.conf` file and are using the `app_protect_enforcer_address` directive.

To fix the problem, remove the file configuration folder and recreate the directory, then restart NGINX.

```bash
sudo rm /opt/app_protect/config
sudo mkdir /opt/app_protect/config
sudo service nginx restart
```

---

## Supported packages

### NGINX Open Source

| Distribution name        | Package file                                                      |
|--------------------------|-------------------------------------------------------------------|
| Alpine 3.17              | _app-protect-module-oss-1.27.2.5.210.0-r1.apk_                    |
| Debian 11                | _app-protect-module-oss_1.27.2+5.210.0-1\~bullseye_amd64.deb_     |
| Debian 12                | _app-protect-module-oss_1.27.2+5.210.0-1\~bookworm_amd64.deb_     |
| Ubuntu 20.04             | _app-protect-module-oss_1.27.2+5.210.0-1\~focal_amd64.deb_        |
| Ubuntu 22.04             | _app-protect-module-oss_1.27.2+5.210.0-1\~jammy_amd64.deb_        |
| Ubuntu 24.04             | _app-protect-module-oss_1.27.2+5.210.0-1\~noble_amd64.deb_        |
| Amazon Linux 2023        | _app-protect-module-oss-1.27.2+5.210.0-1.amzn2023.ngx.x86_64.rpm_ |
| RHEL 8 and Rocky Linux 8 | _app-protect-module-oss-1.27.2+5.210.0-1.el8.ngx.x86_64.rpm_      |
| RHEL 9                   | _app-protect-module-oss-1.27.2+5.210.0-1.el9.ngx.x86_64.rpm_      |
| Oracle Linux 8.1         | _app-protect-module-oss-1.27.2+5.210.0-1.el8.ngx.x86_64.rpm_      |

--- 

### NGINX Plus

| Distribution name        | Package file                                                   |
|--------------------------|----------------------------------------------------------------|
| Alpine 3.17              | _app-protect-module-plus-33.5.210.0-r1.apk_                    |
| Debian 11                | _app-protect-module-plus_33+5.210.0-1\~bullseye_amd64.deb_     |
| Debian 12                | _app-protect-module-plus_33+5.210.0-1\~bookworm_amd64.deb_     |
| Ubuntu 20.04             | _app-protect-module-plus_33+5.210.0-1\~focal_amd64.deb_        |
| Ubuntu 22.04             | _app-protect-module-plus_33+5.210.0-1\~jammy_amd64.deb_        |
| Ubuntu 24.04             | _app-protect-module-plus_33+5.210.0-1\~noble_amd64.deb_        |
| Amazon Linux 2023        | _app-protect-module-plus-33+5.210.0-1.amzn2023.ngx.x86_64.rpm_ |
| RHEL 8 and Rocky Linux 8 | _app-protect-module-plus-33+5.210.0-1.el8.ngx.x86_64.rpm_      |
| RHEL 9                   | _app-protect-module-plus-33+5.210.0-1.el9.ngx.x86_64.rpm_      |
| Oracle Linux 8.1         | _app-protect-module-plus-33+5.210.0-1.el8.ngx.x86_64.rpm_      |