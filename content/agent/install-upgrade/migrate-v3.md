---
title: Upgrade from v2.x to v3.0
weight: 500
docs: DOCS-000
---

This topic describes how to migrate from F5 NGINX Agent v2 to NGINX Agent v3.

## Overview

---

## Before you begin

To begin this task, you will require the following:

- A [working NGINX Agent instance]({{< ref "/agent/install-upgrade/install.md" >}}).
- An NGINX Agent connected to NGINX One. For a quick guide on how to connect to NGINX One Console see: [Connect to NGINX One Console]({{< ref "/nginx-one/how-to/nginx-configs/add-instance.md" >}})

---

## Migrate from NGINX Agent v2 to v3

The migration from NGINX Agent v2 to v3 is handled automatically by the package manager on your OS during the installation of NGINX Agent v3.

To install NGINX Agent v3 see [Install NGINX Agent]({{< ref "/agent/install-upgrade/install.md" >}})

To migrate NGINX Agent containers, we provide a script to convert NGINX Agent v2 config files to NGINX Agent v3 config files: [NGINX Agent Config Upgrade Script](https://github.com/nginx/agent/blob/v3/scripts/packages/upgrade-agent-config.sh)

To upgrade the configuration, you can follow this example:

```shell
wget https://github.com/nginx/agent/blob/v3/scripts/packages/upgrade-agent-config.sh
./upgrade-agent-config.sh --v2-config-file=./nginx-agent-v2.conf --v3-config-file=nginx-agent-v3.conf
```

If your NGINX Agent container was previously a member of a config sync group, then your NGINX Agent config must be manually updated to add the config sync group label.
See [Add Config Sync Group]({{< ref "/nginx-one/how-to/config-sync-groups/manage-config-sync-groups.md" >}}) for more information.

---

## Rolling back from NGINX Agent v3 to v2

If you need to roll back your environment to NGINX Agent v2, the upgrade process creates a backup of the NGINX Agent v2 config in the file `/etc/nginx-agent/nginx-agent-v2-backup.conf`.

Replace the conents of `/etc/nginx-agent/nginx-agent.conf` with the contents of `/etc/nginx-agent/nginx-agent-v2-backup.conf` and then reinstall an older version of NGINX Agent.