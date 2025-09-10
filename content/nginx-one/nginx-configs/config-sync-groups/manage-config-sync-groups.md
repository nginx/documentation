---
nd-docs: null
title: Manage Config Sync Groups
toc: true
weight: 300
type:
- how-to
---

## Overview

If you work with several instances of NGINX, it can help to organize these instances in Config Sync Groups. Each instance in a Config Sync Group has the same configuration.

This guide explains how to create and manage Config Sync Groups in the F5 NGINX One Console. Config Sync Groups synchronize NGINX configurations across multiple NGINX instances, ensuring consistency and ease of management.

If you’ve used [instance groups in NGINX Instance Manager]({{< ref "/nim/nginx-instances/manage-instance-groups.md" >}}), you’ll find Config Sync Groups in NGINX One similar, though the steps and terminology differ slightly.

Config Sync Groups are functionally different from syncing instances in a cluster. They let you to manage and synchronize configurations across multiple NGINX instances, all at once.

This is particularly useful when your NGINX instances are load-balanced by an external load balancer, as it ensures consistency across all instances. In contrast, cluster syncing, like [zone syncing]({{< ref "nginx/admin-guide/high-availability/zone_sync_details.md" >}}), ensures data consistency and high availability across NGINX instances in a cluster. While Config Sync Groups focus on configuration management, cluster syncing supports failover and data consistency.

## Before you start

Before you create and manage Config Sync Groups, ensure:

- You have access to the NGINX One Console.
- You have the necessary permissions to create and manage Config Sync Groups.
- If you plan to add existing instances to a Config Sync Group, make sure those NGINX instances are properly registered with NGINX One.

## Configuration management

Config Sync Groups support configuration inheritance and persistance. If you've just created a Config Sync Group, you can define the configuration for that group in the following ways:

- Before adding an instance to a group, you can [Define the Config Sync Group configuration manually](#define-the-config-sync-group-configuration-manually).
- When you add the first instance to a group, that instance defines the configuration for that Config Sync Group.
- Afterwards, you can modify the configuration of the Config Sync Group. That modifies the configuration of all member instances. Future members of that group inherit that modified configuration.

On the other hand, if you remove all instances from a Config Sync Group, the original configuration persists. In other words, the group retains the configuration from that first instance (or the original configuration). Any new instance that you add later still inherits that configuration.

{{< call-out "tip" >}}You can use _unmanaged_ certificates. Your actions can affect the [Config Sync Group status](#config-sync-group-status). For future instances on the data plane, if it:

- Has unmanaged certificates in the same file paths as defined by the NGINX configuration as the Config Sync Group, that instance will be [**In Sync**](#config-sync-group-status).
- Will be [**Out of Sync**](#config-sync-group-status) if the instance:
   - Does not have unmanaged certificates in the same file paths
   - Has unmanaged certificates in a different directory from the Config Sync Group
{{< /call-out >}}

### Risk when adding multiple instances to a Config Sync Group

If you add multiple instances to a single Config Sync Group, simultaneously (with automation), there's a risk that the instance selects a random configuration. To prevent this problem, you should:

1. Create a Config Sync Group.
1. Add a configuration to the Config Sync Group, so all instances inherit it.
1. Add the instances in a separate operation.

Your instances should synchronize with your desired configuration within 30 seconds.

### Use an instance to define the Config Sync Group configuration

1. Follow the steps in the [**Add an existing instance to a Config Sync Group**](#add-an-existing-instance-to-a-config-sync-group) or [**Add a new instance to a Config Sync Group**](#add-a-new-instance-to-a-config-sync-group) sections to add your first instance to the group.
2. The NGINX configuration from this instance will automatically become the group's configuration.
3. You can further edit and publish this configuration by following the steps in the [**Publish the Config Sync Group configuration**](#publish-the-config-sync-group-configuration) section.

### Define the Config Sync Group configuration manually

You can manually define the group's configuration before adding any instances. When you add instances to the group later, they automatically inherit this configuration.

To manually set the group configuration:

1. Follow steps 1–4 in the [**Create a Config Sync Group**](#create-a-config-sync-group) section to create your Config Sync Group.
2. After creating the group, select the **Configuration** tab.
3. Since no instances have been added, the **Configuration** tab will show an empty configuration with a message indicating that no config files exist yet.
4. To add a configuration, select **Edit Configuration**.
5. In the editor, define your NGINX configuration as needed. This might include adding or modifying `nginx.conf` or other related files.
6. After making your changes, select **Next** to view a split screen showing your changes.
7. If you're satisfied with the configuration, select **Save and Publish**.

## Important considerations

When you plan Config Sync Groups, consider the following factors:

- **Single Config Sync Group membership**: You can add an instance to only one Config Sync Group.

- **NGINX Agent configuration file location**: When you run the NGINX Agent installation script to register an instance with NGINX One, the script creates the `nginx-agent.conf` (or `agent-dynamic.conf` if you are using NGINX Agent 2.x) file, which contains settings for the NGINX Agent, including the specified Config Sync Group. This file is typically located in `/etc/nginx-agent/` on most systems.

- **Mixing NGINX Open Source and NGINX Plus instances**: You can add both NGINX Open Source and NGINX Plus instances to the same Config Sync Group, but there are limitations. If your configuration includes features exclusive to NGINX Plus, synchronization will fail on NGINX Open Source instances because they don't support these features. NGINX One allows you to mix NGINX instance types for flexibility, but it’s important to ensure that the configurations you're applying are compatible with all instances in the group.

## Create a Config Sync Group

When you create a Config Sync Group, you can manage the configurations of multiple NGINX instances as a single entity.

1. On the left menu, select **Config Sync Groups**.
2. Select **Add Config Sync Group**.
3. In the **Name** field, type a name for your Config Sync Group.
4. Select **Create** to add the Config Sync Group.

## Manage Config Sync Group membership

Now that you created a Config Sync Group, you can add instances to that group. As described in [Configuration management](#configuration-management), the first instance you add to a group, when you add it, defines the initial configuration for the group. You can update the configuration for the entire Config Sync Group.

Any instance that joins the group afterwards inherits that configuration.

### Add an existing instance to a Config Sync Group {#add-an-existing-instance-to-a-config-sync-group}

You can add existing NGINX instances that are already registered with NGINX One to a Config Sync Group.

{{< tabs name="Add existing instance to Config Sync Group" >}}

{{%tab name="NGINX Agent 3.x"%}}

1. Open a command-line terminal on the NGINX instance.
2. Open the `/etc/nginx-agent/nginx-agent.conf` file in a text editor.
3. Find or create the `labels` section and change the `config_sync_group` label to the name of the new Config Sync Group.

   ``` text
   labels:
      config-sync-group: <config_sync_group>
   ```

4. Restart NGINX Agent:

   ``` shell
   sudo systemctl restart nginx-agent
   ```

{{%/tab%}}
{{%tab name="NGINX Agent 2.x"%}}

1. Open a command-line terminal on the NGINX instance.
2. Open the `/var/lib/nginx-agent/agent-dynamic.conf` file in a text editor.
3. At the end of the file, add a new line beginning with `instance_group:`, followed by the Config Sync Group name.

   ``` text
   instance_group: <config_sync_group>
   ```

4. Restart NGINX Agent:

   ``` shell
   sudo systemctl restart nginx-agent
   ```

{{%/tab%}}
{{< /tabs >}}

### Add a new instance to a Config Sync Group {#add-a-new-instance-to-a-config-sync-group}

When adding a new NGINX instance that is not yet registered with NGINX One, you need a data plane key to securely connect the instance. You can generate a new data plane key during the process or use an existing one if you already have it.

1. On the left menu, select **Config Sync Groups**.
2. Select the Config Sync Group in the list.
3. In the **Instances** pane, select **Add Instance to Config Sync Group**.
4. In the **Add Instance to Config Sync Group** dialog, select **Register a new instance with NGINX One then add to Config Sync Group**.
5. Select **Next**.
6. **Generate a new data plane key** (choose this option if you don't have an existing key):

   - Select **Generate new key** to create a new data plane key for the instance.
   - Select **Generate Data Plane Key**.
   - Copy and securely store the generated key, as it is displayed only once.

7. **Use an existing data plane key** (choose this option if you already have a key):

   - Select **Use existing key**.
   - In the **Data Plane Key** field, enter the existing data plane key.

{{<tabs name="add-new-instance-to-config-sync-group">}}

{{%tab name="Virtual Machine or Bare Metal"%}}

8. Run the provided command, which includes the data plane key, in your NGINX instance terminal to register the instance with NGINX One.
9. Select **Done** to complete the process.

{{%/tab%}}

{{%tab name="Docker Container"%}}

8. **Log in to the NGINX private registry**:

   - Replace `YOUR_JWT_HERE` with your JSON Web Token (JWT) license from [MyF5](https://my.f5.com/manage/s/).

   ```shell
   sudo docker login private-registry.nginx.com --username=YOUR_JWT_HERE --password=none
   ```

9. **Pull the Docker image**:

   - From the **OS Type** list, choose the appropriate operating system for your Docker image.
   - After selecting the OS, run the provided command to pull the Docker image.

   **Note**: Subject to availability, you can modify the `agentv3:<version-tag>` to match the specific NGINX Plus version, OS type, and OS version you need. For example, you might use `agentv3:r32-ubi-9`. For more details on version tags and how to pull an image, see [Deploying NGINX and NGINX Plus on Docker]({{< ref "nginx/admin-guide/installing-nginx/installing-nginx-docker.md#pull-the-image" >}}).


10. Run the provided command, which includes the data plane key, in your NGINX instance terminal to start the Docker container.

11. Select **Done** to complete the process.

{{%/tab%}}

{{</tabs>}}

{{<call-out "note" "About data plane keys" "fas fa-key" >}}

Data plane keys are required for registering NGINX instances with the NGINX One Console. These keys serve as secure tokens, ensuring that only authorized instances can connect and communicate with NGINX One.

For more details on creating and managing data plane keys, see [Create and manage data plane keys]({{<ref "/nginx-one/connect-instances/create-manage-data-plane-keys.md" >}}).

{{</call-out>}}

### Move an instance to a different Config Sync Group

If you need to move an NGINX instance to a different Config Sync Group, follow these steps:

{{< tabs name="Move instance to Config Sync Group" >}}

{{%tab name="NGINX Agent 3.x"%}}

1. Open a command-line terminal on the NGINX instance.
2. Open the `/etc/nginx-agent/nginx-agent.conf` file in a text editor.
3. Find the `labels` section and change the `config_sync_group` label to the name of the new Config Sync Group.

   ``` text
   labels:
      config-sync-group: <new_config_sync_group>
   ```

4. Restart NGINX Agent by running the following command:

   ```shell
   sudo systemctl restart nginx-agent
   ```

{{%/tab%}}
{{%tab name="NGINX Agent 2.x"%}}


1. Open a command-line terminal on the NGINX instance.
2. Open the `/var/lib/nginx-agent/agent-dynamic.conf` file in a text editor.
3. Locate the line that begins with `instance_group:` and change it to the name of the new Config Sync Group.

   ``` text
   instance_group: <new_config_sync_group>
   ```

4. Restart NGINX Agent by running the following command:

   ```shell
   sudo systemctl restart nginx-agent
   ```

{{%/tab%}}
{{< /tabs >}}


If you move an instance with certificates from one Config Sync Group to another, NGINX One adds or removes those certificates from the data plane, to synchronize with the deployed certificates of the group.

### Remove an instance from a Config Sync Group

If you need to remove an NGINX instance from a Config Sync Group without adding it to another group, follow these steps:


{{< tabs name="Remove instance from Config Sync Group" >}}

{{%tab name="NGINX Agent 3.x"%}}

1. Open a command-line terminal on the NGINX instance.
2. Open the `/etc/nginx-agent/nginx-agent.conf` file in a text editor.
3. Locate the line that begins with `labels:` section and either remove the `config-sync-group` line or comment it out by adding a `#` at the beginning of the line.

   ```text
   labels:
      # config-sync-group: <new_config_sync_group>
   ```

4. Restart NGINX Agent:

   ```shell
   sudo systemctl restart nginx-agent
   ```

{{%/tab%}}
{{%tab name="NGINX Agent 2.x"%}}

1. Open a command-line terminal on the NGINX instance.
2. Open the `/var/lib/nginx-agent/agent-dynamic.conf` file in a text editor.
3. Locate the line that begins with `instance_group:` and either remove it or comment it out by adding a `#` at the beginning of the line.

   ```text
   # instance_group: <config_sync_group>
   ```

4. Restart NGINX Agent:

   ```shell
   sudo systemctl restart nginx-agent
   ```

{{%/tab%}}
{{< /tabs >}}


By removing or commenting out this line, the instance will no longer be associated with any Config Sync Group.

## Publish the Config Sync Group configuration {#publish-the-config-sync-group-configuration}

After the Config Sync Group is created, you can modify and publish the group's configuration as needed. Any changes made to the group configuration will be applied to all instances within the group.

1. On the left menu, select **Config Sync Groups**.
2. Select the Config Sync Group in the list.
3. Select the **Configuration** tab to view the group's NGINX configuration.
4. To modify the group's configuration, select **Edit Configuration**.
5. Make the necessary changes to the configuration.
6. When you're finished, select **Next**. A split view displays the changes.
7. If you're satisfied with the changes, select **Save and Publish**.

Publishing the group configuration ensures that all instances within the Config Sync Group are synchronized with the latest group configuration. This helps maintain consistency across all instances in the group, preventing configuration drift.

## Config Sync Group status

The **Config Sync Status** column on the **Config Sync Groups** page provides insight into the synchronization state of your NGINX instances within each group.

{{<bootstrap-table "table table-striped table-bordered">}}
| **Status**            | **Description**                                                                                                                                      |
|-----------------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| **In Sync**           | All instances within the Config Sync Group have configurations that match the group configuration. No action is required.                            |
| **Out of Sync** | At least one instance in the group has a configuration that differs from the group's configuration. You may need to review and resolve discrepancies to ensure consistency. |
| **Sync&nbsp;in&nbsp;Progress**  | An instance is currently being synchronized with the group's configuration. This status appears when an instance is moved to a new group or when a configuration is being applied. |
| **Unknown**           | The synchronization status of the instances in this group cannot be determined. This could be due to connectivity issues, instances being offline, or other factors. Investigating the cause of this status is recommended. |
{{</bootstrap-table>}}

Monitor the **Config Sync Status** column. It can help you ensure that your configurations are consistently applied across all instances in a group.

## See also

- [Create and manage data plane keys]({{< ref "/nginx-one/connect-instances/create-manage-data-plane-keys.md" >}})
- [Add an NGINX instance]({{< ref "/nginx-one/connect-instances/add-instance.md" >}})
