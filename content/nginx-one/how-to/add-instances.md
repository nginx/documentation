---
title: "Add Instances"
date: 2024-01-25T13:11:38-08:00
# Change draft status to false to publish doc.
draft: false
# Description
# Add a short description (150 chars) for the doc. Include keywords for SEO. 
# The description text appears in search results and at the top of the doc.
description: ""
# Assign weights in increments of 100
weight: 
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

## How to Add Instances to NGINX One

This guide provides easy instructions for adding your NGINX data plane instances to NGINX One using the web interface. Additionally, it provides optional steps on how to configure the NGINX Agent in a containerized environment, should you need that.

To add your NGINX data plane instances to NGINX One with the web interface, follow these steps:

### Log In to NGINX One


1. Log in to the [F5 Distributed Cloud Console](https://www.f5.com/cloud/products/distributed-cloud-console).
1. Select the **NGINX One** service on the dashboard.

### Add an Instance

If this is your first time accessing the NGINX console, select **Add Instance** on the welcome screen. 

*–or–*

If you've added instances before and now you want to add more, select **Instances** on the console's left menu, then select **Add Instance**.

### Generate a Data Plane Key

A data plane key is a security token that ensures only trusted NGINX instances can register and communicate with NGINX One. 

To generate a data plane key:

In the **Add Instance** pane, select **Generate Data Plane Key**.

*–or–*

Alternatively, if you've already created a data plane key that you want to reuse, select **Use existing key**, then paste the key's value in the **Data Plane Key** box.

<br>

{{<important>}}
Data plane keys are not saved and are displayed only once when you generate them. You should save this key in a secure location for future reference.
{{</important>}}

{{<note>}}
Data plane keys expire after one year. This is the default setting if you don't specify an expiration time when you create a key. If necessary, you can update the data plane key later to extend its expiration.

Revoking a data plane key will disconnect the associated NGINX instances from NGINX One.
{{</note>}}

### Install NGINX Agent

{{<call-out "tip" "Are you running NGINX Agent in a container?" >}}If you're running NGINX Agent in a container, you can jump to [Configuring a Containerized NGINX Agent](#configure-containerized-nginx-agent). 
{{</call-out>}}

After you enter a data plane key, a curl command like the one shown below will appear. Copy this command and run it on each NGINX instance to install the NGINX Agent. Once the NGINX Agent is installed, it typically registers with NGINX One within a few seconds.

{{< include "nginx-one/nginx-agent/nginx-agent-curl.md" >}}

<br>

<details open>
<summary><span style="background-color: #eef2f7; color: #008000; padding: 5px; border-radius: 5px;"><i class="fa-solid fa-list-alt"></i> NGINX Agent: Supported Distributions</span></summary>

Make sure your Linux version supports the NGINX Agent. The NGINX Agent is compatible with the following Linux distributions.

Related guide: [NGINX Agent: Technical Specifications](https://docs.nginx.com/nginx-agent/).

{{< include "nginx-one/nginx-agent/nginx-agent-tech-specs.md" >}}


</details> 

<br>


#### Configuring a Containerized NGINX Agent {#configure-containerized-nginx-agent}

This section assumes you've already installed the NGINX Agent in a container environment. For guidance on how to do this, refer to the [NGINX Agent in a Container Environment guide](https://docs.nginx.com/nginx-management-suite/nginx-agent/nginx-agent-in-container/).

To register your containerized NGINX Agent with NGINX One:

1. Start the NGINX Agent by running the Docker image. This action creates an NGINX Agent configuration file name **nginx-agent.conf** in the **etc/nginx-agent** directory inside the container.

    ``` bash
    docker run <nginx-image-with-nginx-agent>
    ```

    - `<nginx-image-with-nginx-agent>`: Replace with name of the Docker image that has the NGINX Agent.

1. Within the docker container, modify the **/etc/nginx-agent/nginx-agent.conf** file. Add the following settings with your actual data plane key value.

    ```yaml
    server:
     token: <data-plane-key>
     host: agent.connect.nginx.com
     grpcPort: 443

    tls:
     enable: true
     skip_verify: false
    ```

    - `<data-plane-key>`: Replace with the actual data plane key value.

1. Restart the NGINX Agent with the new settings. Afterward, you should see the newly registered instance in NGINX One.

    ```bash
    docker restart <container-id>
    ```

    - `<container-id>`: Replace with the ID of your Docker container.