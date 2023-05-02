---
title: "Working with Instance Groups"
date: 2022-07-20T16:10:04-07:00
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: "Learn how to use NGINX Management Suite Instance Manager to create instance groups, which you can use to manage multiple NGINX instances as a single entity."
# Assign weights in increments of 100
weight: 600
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-935"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["infrastructure", "instance groups"]
doctypes: ["tutorial"]
journeys: ["using"]
personas: ["devops", "netops", "secops"]
versions: []
authors: []
aliases:
- /nim/how-to/manage-instance-groups/
---

{{< custom-styles >}}

## Overview

You can easily manage multiple NGINX instances as a single entity by creating an instance group in Instance Manager and adding NGINX instances to it.

---

## Before You Begin

To complete the instructions in this guide, you need the following:

- An installed version of [Instance Manager]({{< relref "/admin-guides/installation/on-prem/install-guide.md" >}})
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

---

## Add Instances to Instance Groups

You can assign NGINX instances to instance groups in the following ways:

- (Preferred) Edit the `agent-dynamic.conf` file on an NGINX instance and specify the instance group.
- Alternatively, when installing the NGINX Agent, you can specify the instance group as a command-line option.

<br>

{{<tabs name="add-instance-to-group">}}

{{%tab name="agent-dynamic.conf"%}}

### Specify Instance Group in Agent-Dynamic.Conf

You can easily add instances to a default instance group that you specify. To do so, [install the NGINX Agent on an instance]({{< relref "nginx-agent/install-nginx-agent.md" >}}), then edit the `/etc/nginx-agent/agent-dynamic.conf` file as described below.

{{< important >}}If the specified instance group doesn't already exist, the NGINX Agent installer will create it, using the current instance's config file as the group's config file. This means that all instances added to the group later will use this config as well. If you're using a script to add instances, you should consider carefully which instance to run the script on first.{{< /important >}}

1. Open a secure shell (SSH) connection to the NGINX instance and log in.
2. Open the `/etc/nginx-agent/agent-dynamic.conf` for editing.
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
    curl https://<NMS-FQDN>/install/nginx-agent > install.sh
    ```

3. Install the NGINX Agent and specify the instance group by using the `--instance_group` flag:

    ```bash
    sudo sh ./install.sh --instance-group <group name>
    ```

    For example, the following command adds the instance to an instance group called `nginx-01`.

    ```bash
    sudo sh install.sh --instance-group nginx-01
    ```

{{< important >}}
If the specified instance group doesn't already exist, the NGINX Agent installer will create it, using the current instance's config file as the group's config file. This means that all instances added to the group later will use this config as well. If you're using a script to add instances, you should consider carefully which instance to run the script on first.
{{< /important >}}

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
2. Open the `/etc/nginx-agent/agent-dynamic.conf` for editing.
3. Locate and remove or comment out the `instance_group: <group name>` setting, similar to the following example:

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

    # instance_group: default
    ```

4. Save the changes and exit the editor.
5. Restart the NGINX Agent:

    ```bash
    sudo systemctl restart nginx-agent
    ```

---

## Publishing to Instance Groups

### Publish Config Changes to Instance Groups

{{< include "nim/how-to/publish-to-instance-group.md" >}}

### Publish Configs with Hash Versioning (API Only) {#publish-configs-with-hash-versioning}

{{< include "nim/how-to/version-control/instance-group-hash-version-config.md" >}}

