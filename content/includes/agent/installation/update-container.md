---
nd-product: NAGENT
nd-files:
- content/nginx-one-console/agent/install-upgrade/update.md
---

To migrate NGINX Agent containers, we provide a script to convert NGINX Agent v2 config files to NGINX Agent v3 config files: [NGINX Agent Config Upgrade Script](https://github.com/nginx/agent/blob/v3/scripts/packages/upgrade-agent-config.sh)

To upgrade the configuration, you can follow this example:

```shell
wget https://raw.githubusercontent.com/nginx/agent/refs/heads/main/scripts/packages/upgrade-agent-config.sh
./upgrade-agent-config.sh --v2-config-file=./nginx-agent-v2.conf --v3-config-file=nginx-agent-v3.conf
```

If your NGINX Agent container was previously a member of a Config Sync Group, then your NGINX Agent config must be manually updated to add the Config Sync Group label.
See [Add Config Sync Group]({{< ref "/nginx-one-console/nginx-configs/config-sync-groups/manage-config-sync-groups.md" >}}) for more information.
