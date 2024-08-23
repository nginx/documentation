---
description: Learn how to get performance and health insights into your NGINX deployment
  using F5 NGINX Management Suite Instance Manager.
docs: DOCS-1387
doctypes:
- reference
tags:
- docs
title: Instance Manager Dashboard Overview
toc: true
weight: 400
---

The Instance Manager Dashboard provides a high-level overview of the health and performance of your NGINX instances. It offers a central location to identify, diagnose, and resolve issues in your data plane, understand how deployments impact the performance of individual instances, and identify trends in your data plane over time.

This document will walk you through the different panels in the dashboard and how to use them to monitor your data plane.

The dashboard functions require a user with access to these specific RBAC features:

- Instance Management
- Certificates
- Analytics

To learn more about Role-based Access Control and the different available features, see the [Getting Started with RBAC]({{< relref "nms/admin-guides/rbac/rbac-getting-started.md" >}}) documentation.

## Prerequisites

Follow these steps to stream and display all relevant metrics in the dashboard:

1. Make sure NGINX Agent v2.30 or later is installed on your NGINX data plane instances. See the [Upgrade NGINX Agent Package](https://docs.nginx.com/nginx-agent/installation-upgrade/upgrade/) for more information.
1. Make sure that NGINX Plus or NGINX Open Source Stub Status APIs are configured to send NGINX metrics using NGINX Agent. See [Instance Metrics Overview]({{< relref "nms/nim/about/overview-metrics.md" >}}) for more information.

## Certificates

The Certificates panel shows the number of certificates in your data plane, split by their status. You can use this panel to identify any certificates that are within 30 days of expiring or have already expired.

Select **See all certificates** to open the Certificates and Keys section and see a list of all certificates in your data plane.

Select any certificate from the list to open the details page for that certificate and correct any issues.

## CPU Utilization

The CPU Utilization panel shows the instances in your data plane with the highest average CPU usage for the selected period, along with their utilization trend, in descending order. Use this panel to identify any instances with high CPU usage and any trends in your data plane over time.

Select **See more** to open a drawer where you can see a list of all instances in your data plane along with their CPU usage averages and trends.

Use the menu at the top right corner to change the time range used for calculating CPU utilization data. Select any hostname in the list to see a full set of metrics specific to that instance.

## Memory Utilization

The Memory Utilization panel shows the instances in your data plane with the highest average memory usage for the selected period, along with their utilization trend, in descending order. Use this panel to identify any instances with high memory usage and any trends in your data plane over time.

Select **See more** to open a drawer where you can see a list of all instances in your data plane along with their memory usage averages and trends.

Use the menu at the top right corner to change the time range used for calculating memory utilization data. Select any hostname in the list to see a full set of metrics specific to that instance.

## Disk Space Utilization

The Disk Utilization panel shows the instances in your data plane with the highest average disk usage on the root partition for the selected period, along with their utilization trend, in descending order. Use this panel to identify any instances with high disk usage and which volumes are close to full.

Select **See more** to open a drawer where you can see a list of all instances in your data plane and their disk usage average. Select the <i class="fa-solid fa-chevron-right"></i> chevron next to the hostname to see the disk usage for each partition. Use the menu at the top right corner to change the time range used for calculating disk utilization data. Select any hostname in the list to see a full set of metrics specific to that instance.

{{< note >}}The value used to calculate the disk usage and shown in the **Current Value** column corresponds to the disk usage of the root partition on the instance. An <i class="fa-solid fa-triangle-exclamation"></i> alert will be displayed next to the hostname if the available space on the root partition drops below 20%.{{< /note >}}

## Network Utilization

The Network Utilization panel shows the instances in your data plane with the highest average inbound network traffic rate, outbound network traffic rate, or number of incoming requests for the selected period in descending order. Use this panel to detect traffic spike patterns, identify any instances with abnormally high or low network traffic, and any associated trends in your data plane over time.

Select **See more** to open a drawer where you can see a list of all instances in your data plane, their traffic averages, trends, and number of requests. Use the menu at the top right corner to change the time range used for calculating utilization data. Select any hostname in the list to see a full set of metrics specific to that instance.

## HTTP Errors

The HTTP Errors panel shows the instances in your data plane with the highest count of HTTP server error responses for the selected period, in descending order. Use this panel to identify any instances with high HTTP server error responses and take action to correct them.

Select **See more** to open a drawer where you can see a list of all instances in your data plane and their count of HTTP server error responses. Select any hostname in the list to see a full set of metrics specific to that instance.

Use the menu at the top of the panel to select the HTTP status code(s) ranges to display. Use the menu on the top right corner to change the time range used for calculating response error data. Select any hostname in the list to see a full set of metrics specific to that instance.
