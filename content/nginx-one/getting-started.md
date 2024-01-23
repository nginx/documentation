---
title: "Getting Started with NGINX One"
date: 2024-01-17T10:18:02-08:00
# Change draft status to false to publish doc
draft: false
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
doctypes: ["tutorial"]
journeys: ["researching", "getting started", "using", "renewing", "self service"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []
---

{{< custom-styles >}}

This guide provides step-by-step instructions on how to activate and start using NGINX One. NGINX One is a management console for monitoring and managing NGINX data plane deployments.

## Step 1: Enable the NGINX One Service on F5 Distributed Cloud

1. Log in to the [F5 Distributed Cloud Console](https://www.f5.com/cloud/products/distributed-cloud-console).
2. Find and select the **NGINX One** service on the dashboard.
3. Select **Enable Service**.
4. After the service has been enabled, select **Visit Service** to load the NGINX One console.

## Step 2: Add NGINX Instances

Once you've enabled NGINX One, the first thing to do is to add the NGINX instances you want to track.

1. **Add your NGINX instances with the web interface**. If this is your first time accessing the NGINX console, select **Add Instance** on the welcome screen. If you've added instances before and now you want to add more, select **Instances** on the console's left menu, then select **Add Instance**.
2. **Generate a data plane key**. A data plane key is a security token that ensures only trusted NGINX instances can register and communicate with NGINX One. To generate a data plane key, select **Generate Data Plane Key**.

   Alternatively, if you've already created a data plane key that you want to reuse, select **Use existing key**, then paste the key's value in the **Data Plane Key** box.

   {{<note>}}
   Data plane keys expire after one year. This is the default setting if you don't specify an expiration time when you create a key. If necessary, you can update the data plane key later to extend its expiration.

   Revoking a data plane key will disconnect the associated NGINX instances from NGINX One.
   {{</note>}}
   {{<important>}}
   Data plane keys are not saved and are displayed only once when you generate them. You should save this key in a secure location for future reference.
   {{</important>}}

3. **Install NGINX Agent on the NGINX instances you want to monitor**. After providing a data plane key, you'll see a curl command similar to the following example. Copy and run this command on each NGINX instance you want to connect to NGINX One.

   ```shell
   curl agent.connect.nginx.com/nginx-agent/install | DATAPLANE_KEY="<data-plane-key>" sh -s -- -y
   ```

   <br>

   Make sure your Linux version supports the NGINX Agent. For supported distributions, click the following link.

   <details closed>
   <summary><i class="fa-solid fa-circle-info"></i> NGINX Agent: Supported distributions </summary>

   The NGINX Agent is compatible with the following Linux distributions. To learn more about the NGINX Agent, refer to the [NGINX Agent documentation](https://docs.nginx.com/nginx-agent/).

   {{< include "nginx-one/nginx-agent/nginx-agent-tech-specs.md" >}}
   </details>

## After Setup: ... in progress



