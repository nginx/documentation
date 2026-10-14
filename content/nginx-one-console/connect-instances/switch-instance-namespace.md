---
title: Switch an instance to a new namespace
description: 'Move an NGINX instance from one namespace to another in NGINX One Console.'
f5-audience: admin
f5-content-type: how-to
f5-keywords: "namespace, switch namespace, data plane key, NGINX Agent, NGINX One Console"
f5-product: NGINX One Console
f5-summary: >
  This guide explains how to move an existing NGINX instance from one namespace to another in NGINX One Console.
  You might do this when you reorganize your infrastructure or move an instance to a different team.
toc: true
weight: 350
---

## Overview

This guide explains how to move an existing NGINX instance from one namespace to another in F5 NGINX One Console. You might do this when you reorganize your infrastructure or move an instance to a different team.

To switch namespaces, create a data plane key in the target namespace and point NGINX Agent to it. Then restart NGINX Agent and confirm the instance appears in the target namespace. Finally, revoke the old key.

## Before you start

Before switching an instance to a new namespace, make sure:

- You have [administrator access]({{< ref "/nginx-one-console/rbac/roles.md" >}}) to both the current and target namespaces in NGINX One Console.
- You know the name of the target namespace.
- You have access to the NGINX host where the instance is running, with permissions to edit configuration files and restart services.

{{< call-out class="note" >}}Switching an instance to a new namespace doesn't affect the NGINX configuration or traffic on that instance. The switch only changes which namespace the instance is registered under in NGINX One Console.{{< /call-out >}}

## Switch to a new namespace

### Create a data plane key in the target namespace

1. From the namespace selector, select the target namespace in NGINX One Console.
1. Select **Data Plane Keys**.
1. Select **Add Data Plane Key**.
1. Enter a name for the new key (for example, `namespace-switch-key`).
1. (Optional) Set an expiration date.
1. Select **Generate**.
1. Copy the new data plane key and store it securely. NGINX One Console shows the key only once.

For more information, see [Prepare - Create and manage data plane keys]({{< ref "/nginx-one-console/connect-instances/create-manage-data-plane-keys.md" >}}).

### Revoke the old data plane key

Revoke the old data plane key in the original namespace. A revoked key can't connect instances to NGINX One Console.

1. Switch back to the original namespace in NGINX One Console.
1. Select **Data Plane Keys**.
1. Find the data plane key that the instance was previously registered with.
1. In the **Actions** column, select the ellipsis (three dots).
1. Select **Revoke**.
1. In the pop-up window, select **Revoke** to confirm.

{{< call-out class="important" >}}Revoking a data plane key disconnects all instances registered with that key. If other instances use the same key, create a new key for them before revoking.{{< /call-out >}}

### Update the NGINX Agent configuration

On the host where the NGINX instance is running, update the NGINX Agent configuration to point to the new data plane key.

1. Open the configuration file for NGINX Agent in a text editor:

   ```shell
   sudo vim /etc/nginx-agent/nginx-agent.conf
   ```

1. Find the `command` section and update the `auth.token` value with the new data plane key:

   ```yaml
   command:
     server:
       host: "agent.connect.nginx.com"
       port: 443
     auth:
       token: "<NEW_DATA_PLANE_KEY>"
     tls:
       skip_verify: false
   ```

1. Save and exit the editor.

### Restart NGINX Agent

1. Restart NGINX Agent to apply the updated configuration:

   ```shell
   sudo systemctl restart nginx-agent
   ```

1. Verify that NGINX Agent is running:

   ```shell
   sudo systemctl status nginx-agent
   ```

### Verify the instance appears in the target namespace

1. Switch to the target namespace in NGINX One Console.
1. Select **Instances**.
1. Confirm that your instance appears in the list and its status is **Connected**. The instance can take up to 60 seconds to appear after you restart NGINX Agent.

{{< call-out class="note" >}}It may take up to 60 seconds for the instance to appear in the new namespace after restarting NGINX Agent.{{< /call-out >}}

If the instance doesn't appear, check the NGINX Agent logs for errors:

```shell
sudo journalctl -u nginx-agent -f
```

Common issues include:

- **Incorrect data plane key**: Verify the token in `nginx-agent.conf` matches the key generated in the target namespace.
- **Firewall rules**: Make sure the NGINX host can reach `agent.connect.nginx.com` on port `443`.
- **Agent not running**: Check the NGINX Agent status with `sudo systemctl status nginx-agent`.