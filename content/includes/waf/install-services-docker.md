---
nd-docs:
---

{{< call-out "warning" >}}

This section **only** applies to NGINX Open Source and NGINX Plus deployments. 

Skip to [Post-installation checks](#post-installation-checks) if you're using a V4 package.

{{< /call-out>}}

F5 WAF for NGINX uses Docker containers for its services when installed with a NGINX Open Source or NGINX Plus package, which requires extra set-up steps.

First, create new directories for the services:

```shell
sudo mkdir -p /opt/app_protect/config /opt/app_protect/bd_config
```

Then assign new owners, with `101:101` as the default UID/GID

```shell
sudo chown -R 101:101 /opt/app_protect/
```