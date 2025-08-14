---
docs:
files:
   - content/agent/install-upgrade/update.md
   - content/nginx-one/agent/install-upgrade/update.md
---

To migrate NGINX Agent containers, we provide a script to convert NGINX Agent v2 config files to NGINX Agent v3 config files: [NGINX Agent Config Upgrade Script](https://github.com/nginx/agent/blob/v3/scripts/packages/upgrade-agent-config.sh)

To upgrade the configuration, you can follow this example:

```shell
wget https://raw.githubusercontent.com/nginx/agent/refs/heads/v3/scripts/packages/upgrade-agent-config.sh
./upgrade-agent-config.sh --v2-config-file=./nginx-agent-v2.conf --v3-config-file=nginx-agent-v3.conf
```

If your NGINX Agent container was previously a member of a Config Sync Group, then your NGINX Agent config must be manually updated to add the Config Sync Group label.
See [Add Config Sync Group]({{< ref "/nginx-one/nginx-configs/config-sync-groups/manage-config-sync-groups.md" >}}) for more information.

### Rolling back from NGINX Agent v3 to v2

If you need to roll back your environment to NGINX Agent v2, the upgrade process creates a backup of the NGINX Agent v2 config in the file `/etc/nginx-agent/nginx-agent-v2-backup.conf`.

Replace the contents of `/etc/nginx-agent/nginx-agent.conf` with the contents of `/etc/nginx-agent/nginx-agent-v2-backup.conf` and then reinstall an older version of NGINX Agent.
