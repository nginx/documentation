---
title: "Getting Started with NGINX One"
date: 2024-01-17T10:18:02-08:00
# Change draft status to false to publish doc
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
doctypes: ["tutorial"]
journeys: ["researching", "getting started", "using", "renewing", "self service"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []
---

This guide provides step-by-step instructions on how to activate and start using NGINX One. NGINX One is a management console for monitoring and managing NGINX data plane deployments.

## How to get started with NGINX One

### Enable the NGINX One Service on F5 Distributed Cloud {#enable-nginx-one}

1. Log in to the [F5 Distributed Cloud Console](https://www.f5.com/cloud/products/distributed-cloud-console).
1. Select the **NGINX One** service on the dashboard.
1. Select **Enable Service**.
1. After the service has been enabled, select **Visit Service** to load the NGINX One console.

## How to add instances to NGINX One

This guide provides easy instructions for adding your NGINX data plane instances to NGINX One using the web interface. Additionally, it provides optional steps on how to configure the NGINX Agent in a containerized environment, should you need that.

To add your NGINX data plane instances to NGINX One with the web interface, follow these steps:

### Log in to NGINX One


1. Log in to the [F5 Distributed Cloud Console](https://www.f5.com/cloud/products/distributed-cloud-console).
1. Select the **NGINX One** service on the dashboard.

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

The section is informative but could be more streamlined for clarity and easier navigation, especially for users less familiar with technical procedures. Here's a revised version:

---

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

### View data plane metrics with the NGINX One dashboard

Once your NGINX instances have registered with NGINX One, you’ll want to keep track of how they're doing. The NGINX One Dashboard is designed for this purpose, offering a user-friendly interface to help you easily monitor your instances. Here’s how to get the insights you need:

1. **Access the Dashboard**. [Log in to NGINX One console](https://nginxone-team.staging.volterra.us/web/nginx/console/overview/dashboard). After logging in, you'll find yourself on the dashboard by default. This is where you can get an overview of your NGINX data plane's health and performance.

1. **Understand Your Metrics**. The dashboard is split into sections showing different metrics:
   - **Instance Availability**: See how many of your NGINX instances are online, offline, or unavailable.
   - **NGINX Versions by Instance**: Check the NGINX versions you're running across different instances.
   - **Operating Systems**: Know the operating systems your instances are running on.
   - **Certificates**: Track the status of your SSL certificates – see which are expiring soon, and which are still valid.
   - **Config Recommendations**: View the type and number of configuration suggestions for optimizing your instance setups.
   - **CVEs**: Assess the severity and quantity of identified Common Vulnerabilities and Exposures in your instances.
   - **CPU Utilization**: Monitor CPU usage trends and identify instances with high CPU consumption.
   - **Memory Utilization**: Observe memory usage patterns and spot instances with significant memory utilization.
   - **Disk Space Utilization**: Keep an eye on disk space consumption and pinpoint instances with nearly full storage volumes.
   - **Unsuccessful Response Codes**: Identify instances with high numbers of HTTP server errors and review their error codes.
   - **Top Network Usage**: Examine the network usage and bandwidth consumption of your instances.

1. **Drill Down Into Specifics**.
   - For details about a metric, such as viewing expiring certificates, select the corresponding link in the card. You'll be taken to an overview page with more information.

1. **Refine Metric Timeframe**
   - You have the option to view utilization metrics over various intervals. The initial setting displays data for the past hour. To change this, select the drop-down menu and choose your desired time period.

   <br>
   {{< img src="nginx-one/images/nginx-one-dashboard.png">}}
   <br>




