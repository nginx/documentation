---
title: Upgrade NGINX Agent
toc: true
weight: 400
f5-content-type: how-to
f5-product: NGINX Agent
---

## Overview

{{< include "/agent/installation/update.md" >}}

## Find specific Agent version instances

If you manage many instances in F5 NGINX One Console, filter the **Instances** list to find instances running a specific NGINX Agent version (such as v2):

1. Go to **Manage** > **Instances**.
2. Select the settings (gear) icon next to the search box.
3. Select **Agent Version** to show the column.
4. Select **Add Filter**, then select **Agent Version**.
5. Select the version(s) you want to find (for example, **v2.x**). The **Instances** list now shows only instances running the selected version(s).

## Migrate NGINX Agent running in containers

To migrate NGINX Agent containers, we provide a script to convert NGINX Agent v2 config files to NGINX Agent v3 config files: [NGINX Agent Config Upgrade Script](https://github.com/nginx/agent/blob/v3/scripts/packages/upgrade-agent-config.sh)

To upgrade the configuration, you can follow this example:

```shell
wget https://raw.githubusercontent.com/nginx/agent/refs/heads/main/scripts/packages/upgrade-agent-config.sh
./upgrade-agent-config.sh --v2-config-file=./nginx-agent-v2.conf --v3-config-file=nginx-agent-v3.conf
```

If your NGINX Agent container was previously a member of a Config Sync Group, then your NGINX Agent config must be manually updated to add the Config Sync Group label.
See [Add Config Sync Group]({{< ref "/nginx-one-console/nginx-configs/config-sync-groups/manage-config-sync-groups.md" >}}) for more information.

### Rolling back from NGINX Agent v3 to v2

If you need to roll back your environment to NGINX Agent v2, the upgrade process creates a backup of the NGINX Agent v2 config in the file `/etc/nginx-agent/nginx-agent-v2-backup.conf`.

Replace the contents of `/etc/nginx-agent/nginx-agent.conf` with the contents of `/etc/nginx-agent/nginx-agent-v2-backup.conf` and then reinstall an older version of NGINX Agent.

