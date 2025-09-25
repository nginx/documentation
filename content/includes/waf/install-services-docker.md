---
nd-docs:
---

First, create new directories for the services:

```shell
sudo mkdir -p /opt/app_protect/config /opt/app_protect/bd_config
```

Then assign new owners, with `101:101` as the default UID/GID

```shell
sudo chown -R 101:101 /opt/app_protect/
```