---
categories:
- installation
date: "2021-12-21T12:00:00-07:00"
description: 'Follow the steps in this guide to create tags for organizing your instances.'
doctypes:
- tutorial
draft: false
journeys:
- getting started
- using
personas:
- devops
- netops
- secops
- support
tags:
- docs
title: Add Tags to Instances
toc: true
versions: []
weight: 650
docs: "DOCS-829"
aliases:
- /nginx-instance-manager/tutorials/tagging/
- /nginx-instance-manager/how-to/add-tags/
- /nim/how-to/add-tags/
---

{{< shortversions "2.0.0" "latest" "nimvers" >}}
## Overview

Tags allow you to label and group NGINX instances in Instance Manager.

## Adding a Tag {#add-tag}

There are two ways you can add tags:

- Add tags to the `agent-dynamic.conf` file.
- Add tags using the Instance Manager web interface.

### Add Tags with a Configuration File {#add-tag-config}

You can edit the `agent-dynamic.conf` file to add a tag to an instance.

These tags show up during registration and can't be removed from the web interface -- if you try to remove these tags in the web interface, the NGINX Agent adds them back when restarting.

To add tags to the configuration file, take the following steps:

1. Edit the `/var/lib/nginx-agent/agent-dynamic.conf` file and add the tags in a list under the key `tags:` <!-- get new nginx-agent.conf example -->

    {{<note>}}If you're running Instance Manager 2.10.1 or earlier or NGINX Agent 2.25.1 or earlier, the `agent-dynamic.conf` file is located in `/etc/nginx-agent/`.{{</note>}}

2. Restart the NGINX Agent service:

    ```bash
    sudo systemctl restart nginx-agent
    ```

### Add Tags using the Web Interface {#add-tags-UI}

To add tags using the Instance Manager web interface, take the following steps:

1. Open the NGINX Management Suite web interface and log in.

1. In the left menu, select **Instances**.

1. Select an instance row in the list of instances. An informational panel for the instance is displayed.

1. Select **Edit**.

1. In the **System Tags** box, select one or more tags to associate with the instance. To add a new tag, type the name for the tag, then select **Add New Tag**.

   - You can remove a tag from an instance by clicking the `x` next to the tag's   name.

1. Select **Save**.
