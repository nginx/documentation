---
description: ''
f5-content-type: how-to
f5-product: NONECO
title: Switch an instance to a new namespace
toc: true
weight: 350
---

## Overview

This guide explains how to move an existing NGINX instance from one namespace to another in F5 NGINX One Console. You might need to do this when reorganizing your infrastructure, changing team ownership, or migrating instances between tenants.

The process involves creating a new data plane key in the target namespace, updating the NGINX Agent configuration on the instance to use that key, and restarting the agent so it registers under the new namespace.

## Before you start

Before switching an instance to a new namespace, ensure:

- You have [administrator access]({{< ref "/nginx-one-console/rbac/roles.md" >}}) to both the current and target namespaces in NGINX One Console.
- You know the name of the target namespace.
- You have access to the NGINX host where the instance is running, with permissions to edit configuration files and restart services.

{{< call-out class="note" >}}Switching an instance to a new namespace does not affect the NGINX configuration or traffic on that instance. The switch only changes which namespace the instance is registered under in NGINX One Console.{{< /call-out >}}

## Switch to a new namespace

### Step 1: Create a data plane key in the target namespace

1. Switch to the target namespace in NGINX One Console by selecting it from the namespace selector.
2. On the left menu, select **Data Plane Keys**.
3. Select **Add Data Plane Key**.
4. Enter a name for the new key (for example, `namespace-switch-key`). Optionally, set an expiration date.
5. Select **Generate**.
6. Copy and save the new data plane key. It is displayed only once and cannot be retrieved later.

For more information, see [Prepare - Create and manage data plane keys]({{< ref "/nginx-one-console/connect-instances/create-manage-data-plane-keys.md" >}}).

### Step 2: Revoke the old data plane key

Once the instance has been switched to the new namespace, you should revoke the old data plane key used in the previous namespace to prevent unauthorized access.

1. Switch back to the original namespace in NGINX One Console.
2. On the left menu, select **Data Plane Keys**.
3. Find the data plane key that the instance was previously registered with.
4. In the **Actions** column, select the ellipsis (three dots) and then select **Revoke**.
5. Confirm by selecting **Revoke** in the dialog.

{{< call-out class="important" >}}Revoking a data plane key disconnects all instances registered with that key. If other instances use the same key, create a new key for them before revoking.{{< /call-out >}}

### Step 3: Update the NGINX Agent configuration

On the host where the NGINX instance is running, update the agent configuration to point to the new data plane key.

1. Open the NGINX Agent configuration file in a text editor:

   ```shell
   sudo vim /etc/nginx-agent/nginx-agent.conf
   ```

2. Find the `command` section and update the `auth.token` value with the new data plane key:

   ```yaml
   command:
     server:
       host: "agent.connect.nginx.com"
       port: 443
     auth:
       token: "<your-new-data-plane-key>"
     tls:
       skip_verify: false
   ```

3. Save and exit the editor.

### Step 4: Restart NGINX Agent

Restart the agent to apply the updated configuration:

```shell
sudo systemctl restart nginx-agent
```

To verify the agent is running:

```shell
sudo systemctl status nginx-agent
```

### Step 5: Verify the instance appears in the target namespace

1. Switch to the target namespace in NGINX One Console.
2. On the left menu, select **Instances**.
3. Confirm that your instance appears in the list and its status is **Connected**.

{{< call-out class="note" >}}It may take up to 60 seconds for the instance to appear in the new namespace after restarting the agent.{{< /call-out >}}

If the instance does not appear, check the NGINX Agent logs for errors:

```shell
sudo journalctl -u nginx-agent -f
```

Common issues include:

- **Incorrect data plane key**: Verify the token in `nginx-agent.conf` matches the key generated in the target namespace.
- **Firewall rules**: Ensure the NGINX host can reach `agent.connect.nginx.com` on port `443`.
- **Agent not running**: Check the agent status with `sudo systemctl status nginx-agent`.
