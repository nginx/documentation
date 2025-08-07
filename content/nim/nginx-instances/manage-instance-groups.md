---
description: Learn how to use F5 NGINX Management Suite Instance Manager to create
  instance groups, which you can use to manage multiple NGINX instances as a single
  entity.
nd-docs: DOCS-935
title: Create and manage instance groups
toc: true
weight: 600
type:
- tutorial
---

## Overview

You can easily manage multiple NGINX instances as a single entity by creating an instance group in Instance Manager and adding NGINX instances to it.

---

## Before You Begin

To complete the instructions in this guide, you need the following:

- An installed version of [Instance Manager]({{< ref "/nim/deploy/vm-bare-metal/_index.md" >}})
- One or more NGINX data plane instances

---

## Create Instance Groups {#add-instance-groups}

To create an instance group:

1. {{< include "nim/webui-nim-login.md" >}}
2. On the left navigation menu, select **Instance Groups**.
3. Select **Create**.
4. On the **Create Instance Group** form, complete the necessary fields:

   - **Name**: add a name for the instance group.
   - **Display Name**: add a friendly name to show for the instance group.
   - (Optional) **Description**: add a brief description for the instance group.

5. Select **Save**.

{{< call-out "note" >}}
When an Instance Group is initially created via the UI/API, its NGINX config will be empty. Adding an Instance to the Instance Group will populated
the Instance Group NGINX nginx with the first member's NGINX config.
{{< /call-out >}}

---

## Add Instances to Instance Groups

You can assign NGINX instances to instance groups in the following ways:

- (Preferred) Edit the `agent-dynamic.conf` file on an NGINX instance and specify the instance group.
- Alternatively, when installing the NGINX Agent, you can specify the instance group as a command-line option.

<br>

{{<tabs name="add-instance-to-group">}}

{{%tab name="agent-dynamic.conf"%}}

### Specify Instance Group in Agent-Dynamic.Conf

You can easily add instances to a default instance group that you specify. To do so, [install the NGINX Agent on an instance]({{< ref "/nms/nginx-agent/install-nginx-agent.md" >}}), then edit the `/var/lib/nginx-agent/agent-dynamic.conf` file as described below.

{{< call-out "note" >}}If you're running Instance Manager 2.10.1 or earlier or NGINX Agent 2.25.1 or earlier, the `agent-dynamic.conf` file is located in `/etc/nginx-agent/`.{{< /call-out >}}

{{< call-out "important" >}}If the specified instance group doesn't already exist, the NGINX Agent installer will create it, using the current instance's config file as the group's config file. This means that all instances added to the group later will use this config as well. If you're using a script to add instances, you should consider carefully which instance to run the script on first.{{< /call-out >}}

1. Open a secure shell (SSH) connection to the NGINX instance and log in.
2. Open the `/var/lib/nginx-agent/agent-dynamic.conf` for editing.
3. Add a value for `instance_group: <group name>`, similar to the following example:

    Example:

    ```yaml
    #
    # /etc/nginx-agent/dynamic-agent.conf
    #
    # Dynamic configuration file for NGINX Agent.
    #
    # The purpose of this file is to track agent configuration
    # values that can be dynamically changed via the API and the agent install script.
    # You may edit this file, but API calls that modify the tags on this system will
    # overwrite the tag values in this file.
    #
    # The agent configuration values that API calls can modify are as follows:
    #    - tags
    #
    # The agent configuration values that the agent install script can modify are as follows:
    #    - instance_group

    instance_group: default
    ```

4. Save the changes and exit the editor.
5. Restart the NGINX Agent:

    ```bash
    sudo systemctl restart nginx-agent
    ```

To verify an instance was added to an instance group:

1. {{< include "nim/webui-nim-login.md" >}}
2. On the left menu, select **Instance Groups**.
3. Your instance group should be displayed in the list with the assigned instances.

{{%/tab%}}

{{%tab name="Command-Line Option"%}}

### Adding Instances to Instance Groups with NGINX Agent  {#add-instance-agent-install}

To add an instance to an instance group when installing the NGINX Agent:

1. Open a secure shell (SSH) connection to the NGINX instance and log in.
2. Download the NGINX Agent installation script:

    ```bash
    curl https://<NMS_FQDN>/install/nginx-agent > install.sh
    ```

3. Install the NGINX Agent and specify the instance group by using the `--instance_group` flag:

    ```bash
    sudo sh ./install.sh --instance-group <group name>
    ```

    For example, the following command adds the instance to an instance group called `nginx-01`.

    ```bash
    sudo sh install.sh --instance-group nginx-01
    ```

{{< call-out "important" >}}
If the specified instance group doesn't already exist, the NGINX Agent installer will create it, using the current instance's NGINX config as the group's config file. This means that all instances added to the group later will use this config as well. If you're using a script to add instances, you should consider carefully which instance to run the script on first.
{{< /call-out >}}

{{%/tab%}}
{{</tabs>}}


---

## Update Instance Groups

To edit the display name or description for an instance group:

1. {{< include "nim/webui-nim-login.md" >}}
2. On the left menu, select **Instance Groups**.
3. Locate the instance group you want to update. Select the **Actions** menu (represented by an ellipsis, `...`), then select **Edit**.

---

## Delete Instance Groups

To delete an instance group in the web interface, perform the following:

1. {{< include "nim/webui-nim-login.md" >}}
2. On the left menu, select **Instance Groups**.
3. Locate the instance group you want to delete. Select the **Actions** menu (represented by an ellipsis, `...`), then select **Delete**.

If the instance group you deleted was specified in the `agent-dynamic.conf` file of an instance, you'll need to remove the reference. Otherwise, upon restarting the NGINX Agent, the instance group will be recreated.

1. Open a secure shell (SSH) connection to the NGINX instance and log in.
2. Open the `/var/lib/nginx-agent/agent-dynamic.conf` for editing.
3. Locate and remove or comment out the `instance_group: <group name>` setting, similar to the following example:

    Example:

    ```yaml
    #
    # /var/lib/nginx-agent/agent-dynamic.conf
    #
    # Dynamic configuration file for NGINX Agent.
    #
    # The purpose of this file is to track agent configuration
    # values that can be dynamically changed via the API and the agent install script.
    # You may edit this file, but API calls that modify the tags on this system will
    # overwrite the tag values in this file.
    #
    # The agent configuration values that API calls can modify are as follows:
    #    - tags
    #
    # The agent configuration values that the agent install script can modify are as follows:
    #    - instance_group

    # instance_group: default
    ```

4. Save the changes and exit the editor.
5. Restart the NGINX Agent:

    ```bash
    sudo systemctl restart nginx-agent
    ```

---

## Permission for Instance Groups

See [Set Up RBAC]({{< ref "/nim/admin-guide/rbac/overview-rbac.md" >}}), for detail information on setting up role-based access control (RBAC) for Instance Groups.

{{< call-out "note" >}}
Members of Instance Group automatically inherit role-based access control (RBAC) permissions from their parent.
{{< /call-out >}}

## Publishing to Instance Groups

- For instructions on publishing to instance groups, see the topic [Publish NGINX configs]({{< ref "/nim/nginx-configs/publish-configs.md" >}}).

## Additional Information Regarding Instance Groups

When updating Instance Group NGINX config using the UI or API, only the currently "online" members of Instance Group will be affected. Newly registered Instance or
reconnected Instance should get NGINX config updated automatically to the last "successful" published NGINX config.

A NGINX config update to Instance Group is considered "successful" with one of the following conditions:

- Instance Group does not have a member Instance online
- Any Instance Group member reported "successful" to the NGINX config update

{{< call-out "note" >}}
Check the Instance details page for the last NGINX config publish status.
{{< /call-out >}}

### Common Usage of Instance Groups

Instance Groups can be used for the following workflows:

- Preset NGINX config for new Instances, i.e. containerized Instances
- Group permissions for a set of Instances that share the same NGINX config
