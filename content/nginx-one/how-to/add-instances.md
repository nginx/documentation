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

## How to add instances to NGINX One

This guide provides easy instructions for adding your NGINX data plane instances to NGINX One using the web interface. Additionally, it provides optional steps on how to configure the NGINX Agent in a containerized environment, should you need that.

To add your NGINX data plane instances to NGINX One with the web interface, follow these steps:

### Log in to NGINX One


1. Log in to the [F5 Distributed Cloud Console](https://www.f5.com/cloud/products/distributed-cloud-console).
1. Select the **NGINX One** service on the dashboard.

### Add an instance

If this is your first time accessing the NGINX console, select **Add Instance** on the welcome screen. 

*–or–*

If you've added instances before and now you want to add more, select **Instances** on the console's left menu, then select **Add Instance**.

### Generate a data plane key {#generate-data-plane-key}

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


#### Configuring a containerized NGINX Agent {#configure-containerized-nginx-agent}

This section assumes you've already installed the NGINX Agent in a container environment. For guidance on how to do this, refer to the [NGINX Agent in a Container Environment guide](https://docs.nginx.com/nginx-management-suite/nginx-agent/nginx-agent-in-container/).

To register your containerized NGINX Agent with NGINX One:

1. On your local host, create an **nginx-agent.conf** file similar to the following example. 
   
   In the `server` block, replace `<data-plane-key>` with the actual data plane key you generated in NGINX One.

   ```yaml
    server:
      token: "<data-plane-key>"
      host: agent.connect.nginxlab.net
      grpcPort: 443
    ```

    <details open>
    <summary><i class="fas fa-file"></i> Example nginx-agent.conf</summary>

    ``` yaml
    # 
    # /etc/nginx-agent/nginx-agent.conf
    #
    # Configuration file for NGINX Agent.
    #
    # This file is to track NGINX Agent configuration values that are meant to be statically set. There  
    # are additional NGINX Agent configuration values that are set via the API and NGINX Agent install script
    # which can be found in /var/lib/nginx-agent/agent-dynamic.conf. 

    log:
      # set log level (panic, fatal, error, info, debug, trace; default "info")
      level: info
      # set log path. if empty, don't log to file.
      path: /var/log/nginx-agent/
    # data plane status message / 'heartbeat'
    nginx:
      # path of NGINX logs to exclude
      exclude_logs: ""
      socket: "unix:/var/run/nginx-agent/nginx.sock"

    dataplane:
      status:
        # poll interval for data plane status - the frequency the NGINX Agent will query the dataplane for changes
        poll_interval: 30s
        # report interval for data plane status - the maximum duration to wait before syncing dataplane information if no updates have being observed
        report_interval: 24h
    metrics:
      # specify the size of a buffer to build before sending metrics
      bulk_size: 20
      # specify metrics poll interval
      report_interval: 1m
      collection_interval: 15s
      mode: aggregated

    # OSS NGINX default config path
    # path to aux file dirs can also be added
    config_dirs: "/etc/nginx:/usr/local/etc/nginx:/usr/share/nginx/modules:/etc/nms"

      # api:
      # The port at which NGINX Agent accepts remote connections
      # The API address and port allow for remote management of NGINX and NGINX Agent
      #
      # ~~~ WARNING ~~~ 
      # Set API address to allow remote management
      # host: agent.connect.nginxlab.net
      # 
      # Set this value to a secure port number to prevent information leaks. 
      # port: 8038

    server:
      token: "<data-plane-key>"
      host: agent.connect.nginxlab.net
      grpcPort: 443

    tls:
      enable: True
      skip_verify: False
    ```

    </details>

2. Start the Docker container, mounting the **nginx-agent.conf** file on the host to the specified path inside the container:

    ```shell
    docker run \
    --mount type=bind,source=<path-to-your-nginx-agent.conf>,target=/etc/nginx-agent/nginx-agent.conf,readonly \
    <nginx-image-with-nginx-agent>
    ```

    - `<path-to-your-nginx-agent.conf>`: Replace with the path to your **nginx-agent.conf** file you created on the host.
    - `<nginx-image-with-nginx-agent>`: Replace with the name of the Docker image with the NGINX Agent
