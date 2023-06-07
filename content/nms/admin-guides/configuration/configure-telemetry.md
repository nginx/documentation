---
title: "Configure Telemetry"
date: 2023-06-06T15:09:35Z
draft: false
description: "The NGINX Management Suite platform has the option to share telemetry data with F5 NGINX. This data provides valuable insights into software usage and adoption, which F5 NGINX uses to inform product development and support our customers worldwide in maximizing their success with the platform.  In this document, you will find an overview of the transmitted data, instructions for enabling or disabling the feature, and instructions for configuring firewalls."
# Assign weights in increments of 100
weight: 260
toc: true
tags: [ "docs" ]
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "platform management", "analytics"]
doctypes: ["task"]
personas: ["devops", "netops", "secops", "support"]
versions: []
authors: []
---

{{<custom-styles>}}

## Telemetry Data and Purpose

NGINX Management Suite sends a limited set of data points to F5 for analysis. This telemetry data is associated only with the subscription ID from the applied license and does not include any other identifiable information about the management plane, data plane, users, or other details.

The purpose of collecting this telemetry data is twofold. Firstly, it helps drive and validate product development decisions, ensuring optimal outcomes for our users. Secondly, it assists our Customer Success and Support teams ensure that our users successfully achieve their goals.

The table below shows the captured data points, the trigger conditions, and their respective purposes. We may add additional data points in the future.

{{<bootstrap-table "table table-striped table-bordered">}}
| <div style="width:250px">Data Point</div>            | Triggering Event                            | Purpose |
|--------------------------|------------------------------------|-------|
| Installation | The first time NGINX Management Suite processes are started. | To measure the difficulty of the installation and how long it takes for users to see value from NGINX Management Suite. |
| Login | When a user logs in to NGINX Management Suite. No data about the user is sent, only the fact that a user successfully authenticated and the timestamp of the login event. | To understand how often users or systems access NGINX Management Suite. |
| Start/Stop NGINX Management Suite processes | When any NGINX Management Suite processes are started or stopped. | To understand how often users are upgrading or troubleshooting issues with NGINX Management suite. This information assists F5 Support in diagnosing issues. |
| Adding Data Plane(s)      | When NGINX Agent registers with NGINX Management Suite for the first time. No data about the data plane is sent, just that an NGINX Agent registered with the platform. | To understand how often and how many data planes are added to NGINX Management Suite. This information helps inform our scale and performance targets and assists F5 Support in diagnosing issues. |
{{</bootstrap-table>}}

## Enabling and Disabling Telemetry

Once you've successfully applied a valid license to NGINX Management Suite, the platform will automatically try to send the specified data points to F5. It may also include data points captured shortly before the license was applied. For instance, if you install NGINX Management Suite and immediately apply the license, the Installation data point will be sent.

You can disable telemetry sharing at any time: Access the NGINX Management Suite web interface and select **Settings > License**. Additionally, you can disable the feature using the `/license` API endpoint. You can re-enable telemetry from the same locations if you change your mind.

## Firewall Settings

In order to successfully transmit telemetry data to NGINX F5, ensure that your NGINX Management Suite deployment can establish outbound connections to the IP address range 159.60.126.0/25 on port 443.
