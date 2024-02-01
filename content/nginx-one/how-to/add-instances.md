---
title: "Add Instances"
date: 2024-01-25T13:11:38-08:00
# Change draft status to false to publish doc.
draft: true
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: ""
# Assign weights in increments of 100
weight: 100
toc: true
tags: [ "docs" ]
# Create a new entry in the Jira DOCS Catalog and add the ticket ID (DOCS-<number>) below
docs: "DOCS-000"
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management", "load balancing", "api management", "service mesh", "security", "analytics"]
doctypes: ["task"]
journeys: ["researching", "getting started", "using", "renewing", "self service"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []

---

## How to add instances to NGINX One

This guide provides easy instructions for adding your NGINX data plane instances to NGINX One using the web interface. Additionally, it provides optional steps on how to configure the NGINX Agent in a containerized environment, should you need that.

To add your NGINX data plane instances to NGINX One with the web interface, follow these steps:

### Log in to NGINX One


{{< include "nginx-one/xc-console/login.md" >}}

### Add an instance

Depending on whether this is your first time using the NGINX One console or you've used it before, follow the appropriate steps to add an instance:

{{< include "nginx-one/instances/add-instances.md" >}}

### Generate a data plane key {#generate-data-plane-key}

A data plane key is a security token that ensures only trusted NGINX instances can register and communicate with NGINX One. 

To generate a data plane key:

- **For a new key:** In the **Add Instance** pane, select **Generate Data Plane Key**. Be sure to copy and store this key securely. It is displayed *only once* and cannot be retrieved later.

- **To reuse an existing key:** If you already have a data plane key and want to use it again, select **Use existing key**. Then, enter the key's value in the **Data Plane Key** box.

{{<important>}}
Data plane keys are displayed only once and cannot be retrieved later. Be sure to copy and store this key securely.
{{</important>}}

{{<note>}}
Data plane keys expire after one year. You can change this expiration date later by editing the key.

Revoking a data plane key will disconnect any NGINX instances that registered using that key from NGINX One.
{{</note>}}

### Install NGINX Agent

After entering your data plane key, you'll see a `curl` command similar to the one below. Copy and run this command on each NGINX instance to install the NGINX Agent. Once installed, the NGINX Agent typically registers with NGINX One within a few seconds.

``` shell
curl agent.connect.nginx.com/nginx-agent/install | DATAPLANE_KEY="<data-plane-key>" sh -s -- -y
```

- Replace `<data-plane-key>` with your actual data plane key.
- The `-y` option automatically confirms any prompts during installation.

<span style="display: inline-block; margin-top: 10px;" >
<details open>
<summary><span style="background-color: #eef2f7; color: #008000; padding: 5px; border-radius: 5px;"><i class="fa-solid fa-list-alt"></i> NGINX Agent installation script: supported distributions</span></summary>

Make sure your Linux operating system is listed below. The installation script for the NGINX Agent is compatible with these distributions and versions.

{{< include "nginx-one/nginx-agent/nginx-agent-tech-specs.md" >}}

</details> 
</span>
