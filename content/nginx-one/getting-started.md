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
2. **Add a data plane key**. A data plane key is a security token that ensures only trusted NGINX instances can register and communicate with NGINX One. To generate a data plane key, select **Generate Data Plane Key**.

   Alternatively, if you've already created a data plane key that you want to reuse, select **Use existing key**, then paste the key's value in the **Data Plane Key** box.

   {{<note>}}
   Data plane keys expire after one year. This is the default setting if you don't specify an expiration time when you create a key. If necessary, you can update the data plane key later to extend its expiration.

   Revoking a data plane key will disconnect the associated NGINX instances from NGINX One.
   {{</note>}}
   {{<important>}}
   Data plane keys are not saved and are displayed only once when you generate them. You should save this key in a secure location for future reference.
   {{</important>}}

   <br>
   {{< img src="nginx-one/images/generate-data-plane-key.png" width="732" height="316">}}
   <br>
3. **Install NGINX Agent on the NGINX instances you want to monitor**. After providing a data plane key, you'll see a curl command similar to the following example. Copy and run this command on each NGINX instance you want to connect to NGINX One.

   ```shell
   curl agent.connect.nginx.com/nginx-agent/install | DATAPLANE_KEY="DTROJy0El8ArZ/oTtYQoAUFRvO8Zm5jG9EXAMPLEKEY=" sh -s -- -y
   ```

   <br>

   Make sure your Linux version supports the NGINX Agent. For supported distributions, click the following link.

   <details closed>
   <summary><i class="fa-solid fa-circle-info"></i> NGINX Agent: Supported distributions </summary>

   The NGINX Agent is compatible with the following Linux distributions. To learn more about the NGINX Agent, refer to the [NGINX Agent documentation](https://docs.nginx.com/nginx-agent/).

   {{< include "nginx-one/nginx-agent/nginx-agent-tech-specs.md" >}}
   </details>

## Step 3: View Data Plane Metrics with the NGINX One Dashboard

Once your NGINX instances have registered with NGINX One, you’ll want to keep track of how they're doing. The NGINX One Dashboard is designed for this purpose, offering a user-friendly interface to help you easily monitor your instances. Here’s how to get the insights you need:

1. **Access the Dashboard**. [Log in to NGINX One console](https://nginxone-team.staging.volterra.us/web/nginx/console/overview/dashboard). After logging in, you'll find yourself on the dashboard by default. This is where you can get an overview of your NGINX data plane's health and performance.

2. **Understand Your Metrics**. The dashboard is split into sections showing different metrics:
   - **Instance Availability**: See how many of your NGINX instances are online, offline, or unavailable.
   - **NGINX Versions by Instance**: Check the NGINX versions you're running across different instances.
   - **Operating Systems**: Know the operating systems your instances are running on.
   - **Certificates**: Track the status of your SSL certificates – which are expiring soon, which are still valid.
   - **Config Recommendations**: View the type and number of configuration suggestions for optimizing your instance setups.
   - **CVEs**: Assess the severity and quantity of identified Common Vulnerabilities and Exposures in your instances.
   - **CPU Utilization**: Monitor CPU usage trends and identify instances with high CPU consumption.
   - **Memory Utilization**: Observe memory usage patterns and spot instances with significant memory utilization.
   - **Disk Space Utilization**: Keep an eye on disk space consumption and pinpoint instances with nearly full storage volumes.
   - **Unsuccessful Response Codes**: Identify instances with high numbers of HTTP server errors and review their error codes.
   - **Top Network Usage**: Examine the network usage and bandwidth consumption of your instances.

3. **Drill Down Into Specifics**.
   - For details about a metric, such as viewing expiring certificates, select the corresponding link in the card. You'll be taken to an overview page with more information.

4. **Refine Metric Timeframe**
   - You have the option to view utilization metrics over various intervals. The initial setting displays data for the past hour. To change this, select the drop-down menu and choose your desired time period.

   <br>
   {{< img src="nginx-one/images/nginx-one-dashboard.png">}}
   <br>




