---
docs: null
title: Manage config sync groups
toc: true
weight: 300
type:
- how-to
---

## Overview

This guide explains how to create and manage config sync groups in the F5 NGINX One Console. Config sync groups synchronize NGINX configurations across multiple NGINX instances, ensuring consistency and ease of management.

If you’ve used [instance groups in NGINX Instance Manager]({{< relref "/nim/nginx-instances/manage-instance-groups.md" >}}), you’ll find config sync groups in NGINX One similar, though the steps and terminology differ slightly.

## Before you start

Before you create and manage config sync groups, ensure:

- You have access to the NGINX One Console.
- You have the necessary permissions to create and manage config sync groups.
- NGINX instances are properly registered with NGINX One if you plan to add existing instances to a config sync group.

## Important considerations

- **NGINX Agent configuration file location**: When you run the NGINX Agent installation script to register an instance with NGINX One, the script creates the `agent-dynamic.conf` file, which contains settings for the NGINX Agent, including the specified config sync group. This file is typically located in `/var/lib/nginx-agent/` on most systems; however, on FreeBSD, it's located at `/var/db/nginx-agent/`.

- **Mixing NGINX Open Source and NGINX Plus instances**: You can add both NGINX Open Source and NGINX Plus instances to the same config sync group, but there are limitations. If your configuration includes features exclusive to NGINX Plus, synchronization will fail on NGINX Open Source instances because they don't support these features. NGINX One allows you to mix NGINX instance types for flexibility, but it’s important to ensure that the configurations you're applying are compatible with all instances in the group.

- **Single config sync group membership**: An instance can join only one config sync group at a time.

- **Configuration inheritance**: If the config sync group already has a configuration defined, that configuration will be pushed to instances when they join.

- **Using an instance's configuration for the group configuration**: If an instance is the first to join a config sync group and the group's configuration hasn't been defined, the instance’s configuration will become the group’s configuration. Any instances added later will automatically inherit this configuration. 

  {{< note >}} If you add multiple instances to a single config sync group, simultaneously (with automation), follow these steps. Your instances will inherit your desired configuration:
  
  1. Create a config sync group.
  1. Add a configuration to the config sync group, so all instances inherit it.
  1. Add the instances in a separate operation.
  
  Your instances should synchronize with your desired configuration within 30 seconds. {{< /note >}}

- **Persistence of a config sync group's configuration**: The configuration for a config sync group persists until you delete the group. Even if you remove all instances, the group's configuration stays intact. Any new instances that join later will automatically inherit this configuration.

- **Config sync groups vs. cluster syncing**: Config sync groups are not the same as cluster syncing. Config sync groups let you to manage and synchronize configurations across multiple NGINX instances as a single entity. This is particularly useful when your NGINX instances are load-balanced by an external load balancer, as it ensures consistency across all instances. In contrast, cluster syncing, like [zone syncing]({{< relref "nginx/admin-guide/high-availability/zone_sync_details.md" >}}), ensures data consistency and high availability across NGINX instances in a cluster. While config sync groups focus on configuration management, cluster syncing supports failover and data consistency.

## Create a config sync group

Creating a config sync group allows you to manage the configurations of multiple NGINX instances as a single entity.

1. On the left menu, select **Config Sync Groups**.
2. Select **Add Config Sync Group**.
3. In the **Name** field, type a name for your config sync group.
4. Select **Create** to add the config sync group.

## Manage config sync group membership

### Add an existing instance to a config sync group {#add-an-existing-instance-to-a-config-sync-group}

You can add existing NGINX instances that are already registered with NGINX One to a config sync group.

1. Open a command-line terminal on the NGINX instance.
2. Open the `/var/lib/nginx-agent/agent-dynamic.conf` file in a text editor.
3. At the end of the file, add a new line beginning with `instance_group:`, followed by the config sync group name.

   ``` text
   instance_group: <config_sync_group>
   ```

4. Restart NGINX Agent:

   ``` shell
   sudo systemctl restart nginx-agent
   ```  

### Add a new instance to a config sync group {#add-a-new-instance-to-a-config-sync-group}

When adding a new NGINX instance that is not yet registered with NGINX One, you need a data plane key to securely connect the instance. You can generate a new data plane key during the process or use an existing one if you already have it.

1. On the left menu, select **Config Sync Groups**.
2. Select the config sync group in the list.
3. In the **Instances** pane, select **Add Instance to Config Sync Group**.
4. In the **Add Instance to Config Sync Group** dialog, select **Register a new instance with NGINX One then add to config sync group**.
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

   - Replace `YOUR_JWT_HERE` with your JSON Web Token (JWT) from [MyF5](https://my.f5.com/manage/s/).

   ```shell
   sudo docker login private-registry.nginx.com --username=YOUR_JWT_HERE --password=none
   ```

9. **Pull the Docker image**:

   - From the **OS Type** list, choose the appropriate operating system for your Docker image.
   - After selecting the OS, run the provided command to pull the Docker image.

   **Note**: Subject to availability, you can modify the `agent: <VERSION_TAG>` to match the specific NGINX Plus version, OS type, and OS version you need. For example, you might use `agent: r32-ubi-9`. For more details on version tags and how to pull an image, see [Deploying NGINX and NGINX Plus on Docker]({{< relref "nginx/admin-guide/installing-nginx/installing-nginx-docker.md#pulling-the-image" >}}).

10. Run the provided command, which includes the data plane key, in your NGINX instance terminal to start the Docker container.

11. Select **Done** to complete the process.

{{%/tab%}}

{{</tabs>}}

{{<call-out "note" "About data plane keys" "fas fa-key" >}}

Data plane keys are required for registering NGINX instances with the NGINX One Console. These keys serve as secure tokens, ensuring that only authorized instances can connect and communicate with NGINX One. 

For more details on creating and managing data plane keys, see [Create and manage data plane keys]({{<relref "/nginx-one/how-to/data-plane-keys/create-manage-data-plane-keys.md" >}}).

{{</call-out>}}

### Change the config sync group for an instance

If you need to move an NGINX instance to a different config sync group, follow these steps:

1. Open a command-line terminal on the NGINX instance.
2. Open the `/var/lib/nginx-agent/agent-dynamic.conf` file in a text editor.
3. Locate the line that begins with `instance_group:` and change it to the name of the new config sync group.

   ``` text
   instance_group: <new_config_sync_group>
   ```

4. Restart NGINX Agent by running the following command:

   ```shell
   sudo systemctl restart nginx-agent
   ```

**Important:** If the instance is the first to join the new config sync group and a group configuration hasn’t been added manually beforehand, the instance’s configuration will automatically become the group’s configuration. Any instances added to this group later will inherit this configuration.

### Remove an instance from a config sync group

If you need to remove an NGINX instance from a config sync group without adding it to another group, follow these steps:

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

By removing or commenting out this line, the instance will no longer be associated with any config sync group.

## Add the config sync group configuration

You can set the configuration for a config sync group in two ways:

### Define the group configuration manually

You can manually define the group's configuration before adding any instances. When you add instances to the group later, they automatically inherit this configuration.

To manually set the group configuration:

1. Follow steps 1–4 in the [**Create a config sync group**](#create-a-config-sync-group) section to create your config sync group.
2. After creating the group, select the **Configuration** tab.
3. Since no instances have been added, the **Configuration** tab will show an empty configuration with a message indicating that no config files exist yet.
4. To add a configuration, select **Edit Configuration**.
5. In the editor, define your NGINX configuration as needed. This might include adding or modifying `nginx.conf` or other related files.
6. After making your changes, select **Next** to view a split screen showing your changes.
7. If you're satisfied with the configuration, select **Save and Publish**.

### Use an instance's configuration

If you don't manually define a group config, the NGINX configuration of the first instance added to a config sync group becomes the group's configuration. Any additional instances added afterward inherit this group configuration.

To set the group configuration by adding an instance:

1. Follow the steps in the [**Add an existing instance to a config sync group**](#add-an-existing-instance-to-a-config-sync-group) or [**Add a new instance to a config sync group**](#add-a-new-instance-to-a-config-sync-group) sections to add your first instance to the group.
2. The NGINX configuration from this instance will automatically become the group's configuration.
3. You can further edit and publish this configuration by following the steps in the [**Publish the config sync group configuration**](#publish-the-config-sync-group-configuration) section.

## Publish the config sync group configuration {#publish-the-config-sync-group-configuration}

After the config sync group is created, you can modify and publish the group's configuration as needed. Any changes made to the group configuration will be applied to all instances within the group.

1. On the left menu, select **Config Sync Groups**.
2. Select the config sync group in the list.
3. Select the **Configuration** tab to view the group's NGINX configuration.
4. To modify the group's configuration, select **Edit Configuration**.
5. Make the necessary changes to the configuration. 
6. When you're finished, select **Next**. A split view displays the changes.
7. If you're satisfied with the changes, select **Save and Publish**.

Publishing the group configuration ensures that all instances within the config sync group are synchronized with the latest group configuration. This helps maintain consistency across all instances in the group, preventing configuration drift.

## Understanding config sync statuses

The **Config Sync Status** column on the **Config Sync Groups** page provides insight into the synchronization state of your NGINX instances within each group.

{{<bootstrap-table "table table-striped table-bordered">}}
| **Status**            | **Description**                                                                                                                                      |
|-----------------------|------------------------------------------------------------------------------------------------------------------------------------------------------|
| **In Sync**           | All instances within the config sync group have configurations that match the group configuration. No action is required.                            |
| **Out of Sync** | At least one instance in the group has a configuration that differs from the group's configuration. You may need to review and resolve discrepancies to ensure consistency. |
| **Sync&nbsp;in&nbsp;Progress**  | An instance is currently being synchronized with the group's configuration. This status appears when an instance is moved to a new group or when a configuration is being applied. |
| **Unknown**           | The synchronization status of the instances in this group cannot be determined. This could be due to connectivity issues, instances being offline, or other factors. Investigating the cause of this status is recommended. |
{{</bootstrap-table>}}

Monitoring the **Config Sync Status** helps ensure that your configurations are consistently applied across all instances in a group, reducing the risk of configuration drift.

## See also

- [Create and manage data plane keys]({{< relref "/nginx-one/how-to/data-plane-keys/create-manage-data-plane-keys.md" >}})
- [View and edit NGINX configurations]({{< relref "/nginx-one/how-to/nginx-configs/view-edit-nginx-configurations.md" >}})
