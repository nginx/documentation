---
title: "Getting started with NGINX One"
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

<style>
h2 {
  margin-top: 20px;
  padding-top: 20px;
}
table {
 width: 100%;
 border-collapse: collapse;
}
th, td {
 padding: 8px;
 text-align: left;
}
th {
 background-color: #CCEAD7 ; /* Soft teal */
 /* Or use background-color: #8FD8D2; for a light blue-green */
 color: #333; /* Dark text for readability */
}
tr:nth-child(even) {
 background-color: #f9f9f9;
}
tr:nth-child(odd) {
 background-color: #ffffff;
}
th, td {
 border: none;
}
</style>


This guide provides step-by-step instructions on how to activate and start using NGINX One. NGINX One is a management console for monitoring and managing NGINX data plane instances.

## Enable the NGINX One service {#enable-nginx-one}

To get started using NGINX One, enable the service on F5 Distributed Cloud.

1. Log in to the [F5 Distributed Cloud Console](https://www.f5.com/cloud/products/distributed-cloud-console).
1. Select the **NGINX One** service on the dashboard.
1. Select **Enable Service**.
1. After the service has been enabled, select **Visit Service** to load the NGINX One console.

## Add your NGINX instances to NGINX One

Next, add your NGINX instances to NGINX One. You'll need to create a data plane key and then install the NGINX Agent on each instance you want to monitor. 

### Add an instance

Depending on whether this is your first time using the NGINX One console or you've used it before, follow the appropriate steps to add an instance:

- **For first-time users:** On the welcome screen, select **Add Instance**.
- **For returning users:** If you've added instances previously and want to add more, select **Instances** on the left menu, then select **Add Instance**.

### Generate a data plane key {#generate-data-plane-key}

A data plane key is a security token that ensures only trusted NGINX instances can register and communicate with NGINX One. 

To generate a data plane key:

- **For a new key:** In the **Add Instance** pane, select **Generate Data Plane Key**.
- **To reuse an existing key:** If you already have a data plane key and want to use it again, select **Use existing key**. Then, enter the key's value in the **Data Plane Key** box.

{{<important>}}
Data plane keys are displayed only once and cannot be retrieved later. Be sure to copy and store this key securely.

Data plane keys expire after one year. You can change this expiration date later by editing the key.

Revoking a data plane key will disconnect any instances that registered with that key.
{{</important>}}


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

## View instance metrics with the NGINX One dashboard

After connecting your NGINX instances to NGINX One, you can monitor their performance and health. The NGINX One Dashboard is designed for this purpose, offering an easy-to-use interface.

### Log in to NGINX One 

{{< include "nginx-one/xc-console/login.md" >}}


### Overview of the NGINX One dashboard

Navigating the dashboard:

- **Drill down into specifics**: For in-depth information on a specific metric, like expiring certificates, click on the relevant link in the metric's card to go to a detailed overview page.
- **Refine metric timeframe**: Metrics show the last hour's data by default. To view data from a different period, select the time interval you want from the drop-down menu.

<span style="display: inline-block; margin-top: 20px; margin-bottom: 50px;">
{{< img src="nginx-one/images/nginx-one-dashboard.png">}}
</span>

{{<bootstrap-table "table table-striped table-bordered">}}
NGINX One dashboard metrics
| Metric | Description | Details |
|---|---|---|
| **Instance availability** | Understand the operational status of your NGINX instances. | - `Online`: The NGINX instance is actively connected and functioning properly. <br> - `Offline`: The NGINX Agent is connected but the NGINX instance isn't running. <br> - `Unavailable`: The connection between the NGINX Agent and NGINX One has been lost. <br> - `Unknown`: The current state can't be determined at the moment. |
| **NGINX versions by instance** | See which NGINX versions are in use across your instances. | |
| **Operating systems** | Find out which operating systems your instances are running on. | |
| **Certificates** | Monitor the status of your SSL certificates to know which are expiring soon and which are still valid. | |
| **Config recommendations** | Get configuration recommendations to optimize your instances' settings. | |
| **CVEs (Common Vulnerabilities and Exposures)** | Evaluate the severity and number of potential security threats in your instances. | - `Major`: Indicates a high-severity threat that needs immediate attention. <br> - `Medium`: Implies a moderate threat level. <br> - `Minor` and `Low`: Represent less critical issues that still require monitoring. <br> - `Other`: Encompasses any threats that don't fit the standard categories. |
| **CPU utilization** | Track CPU usage trends and pinpoint instances with high CPU demand. | |
| **Memory utilization** | Watch memory usage patterns to identify instances using significant memory. | |
| **Disk space utilization** | Monitor how much disk space your instances are using and identify those nearing capacity. | |
| **Unsuccessful response codes** | Look for instances with a high number of HTTP server errors and investigate their error codes. | |
| **Top network usage** | Review the network usage and bandwidth consumption of your instances. | |
{{</bootstrap-table>}}











