---
f5-product: F5 WAF for NGINX
f5-files:
- content/waf/install/docker.md
---

First, create new directories for the services:

```shell
sudo mkdir -p /opt/app_protect/config /opt/app_protect/bd_config
```

Then give ownership of the directories to the `waf` user that the F5 WAF for NGINX containers run as. The user ID (UID) depends on the release:

- Release 5.16.0 and later: UID `100`, group ID (GID) `101`
- Releases earlier than 5.16.0: UID `101`, GID `101`

For release 5.16.0 and later, run:

```shell
sudo chown -R 100:101 /opt/app_protect/
sudo chmod -R g+rwX /opt/app_protect/
```

For releases earlier than 5.16.0, run:

```shell
sudo chown -R 101:101 /opt/app_protect/
sudo chmod -R g+rwX /opt/app_protect/
```

The `chmod` command gives group `101` read and write access, so the containers can still use the directories if the UID changes.

To update an existing deployment from a release earlier than 5.16.0, follow the steps in [Update Docker deployments to 5.16.0]({{< ref "/waf/install/upgrade.md#update-docker-deployments-to-5160" >}}).
