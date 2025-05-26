---
docs: DOCS-1387
title: NGINX Instance Manager dashboard
toc: true
weight: 300
type:
- reference
---

The NGINX Instance Manager dashboard gives you a high-level view of the health and performance of your NGINX instances. It provides a central place to identify, diagnose, and resolve issues in your data plane. You can also track how deployments affect the performance of individual instances and identify trends over time.

This document walks you through the different panels in the dashboard and shows how to use them to monitor your data plane.

You’ll need a user with access to these RBAC features to use the dashboard:

- Instance Management
- Certificates
- Analytics

To learn more about Role-based Access Control and the available features, see the [Getting Started with RBAC]({{< ref "/nim/admin-guide/rbac/overview-rbac.md" >}}) documentation.

## Prerequisites

Follow these steps to stream and display all relevant metrics in the dashboard:

1. Install NGINX Agent v2.30 or later on your NGINX data plane instances. See the [Upgrade NGINX Agent Package](https://docs.nginx.com/nginx-agent/installation-upgrade/upgrade/) for more information.
2. Ensure that NGINX Plus or NGINX Open Source Stub Status APIs are configured to send NGINX metrics using NGINX Agent. See the [Instance Metrics Overview]({{< ref "/nim/monitoring/overview-metrics.md" >}}) for more details.

## Certificates

The Certificates panel shows the number of certificates in your data plane, categorized by their status. Use this panel to identify certificates that will expire in the next 30 days or have already expired.

Select **See all certificates** to open the Certificates and Keys section, where you can view a list of all certificates in your data plane.

Select any certificate from the list to view its details and resolve any issues.

## CPU Utilization

The CPU Utilization panel shows the instances in your data plane with the highest average CPU usage for the selected period, along with utilization trends. The list is sorted in descending order. Use this panel to identify instances with high CPU usage and track performance trends over time.

Select **See more** to open a detailed view where you can see a list of all instances in your data plane along with their CPU usage averages and trends.

Use the menu in the top-right corner to change the time range for CPU utilization data. Select any hostname in the list to view a full set of metrics specific to that instance.

## Memory Utilization

The Memory Utilization panel shows the instances in your data plane with the highest average memory usage for the selected period, along with their utilization trends. The list is sorted in descending order. Use this panel to identify instances with high memory usage and to track trends over time.

Select **See more** to open a detailed view where you can see a list of all instances in your data plane along with their memory usage averages and trends.

Use the menu in the top-right corner to change the time range for memory utilization data. Select any hostname in the list to view a full set of metrics specific to that instance.

## Disk Space Utilization

The Disk Space Utilization panel shows the instances in your data plane with the highest average disk usage on the root partition for the selected period, along with utilization trends. The list is sorted in descending order. Use this panel to identify instances with high disk usage and spot volumes that are nearly full.

Select **See more** to open a detailed view where you can see a list of all instances in your data plane and their disk usage averages. Select the <i class="fa-solid fa-chevron-right"></i> chevron next to the hostname to see the disk usage for each partition.

Use the menu in the top-right corner to change the time range for disk utilization data. Select any hostname in the list to view a full set of metrics specific to that instance.

{{< note >}}The value in the **Current Value** column reflects the disk usage of the root partition on the instance. An <i class="fa-solid fa-triangle-exclamation"></i> alert appears next to the hostname if the available space on the root partition drops below 20%.{{< /note >}}

## Network Utilization

The Network Utilization panel shows the instances in your data plane with the highest average inbound network traffic rate, outbound network traffic rate, or number of incoming requests for the selected period. The list is sorted in descending order. Use this panel to detect traffic spikes, identify instances with abnormally high or low network traffic, and track trends over time.

Select **See more** to open a detailed view where you can see a list of all instances in your data plane, along with their traffic averages, trends, and request counts.

Use the menu in the top-right corner to change the time range for utilization data. Select any hostname in the list to view a full set of metrics specific to that instance.

## HTTP Errors

The HTTP Errors panel shows the instances in your data plane with the highest number of HTTP server error responses for the selected period. The list is sorted in descending order. Use this panel to identify instances with high HTTP error counts and take corrective actions.

Select **See more** to open a detailed view where you can see a list of all instances in your data plane and their HTTP error counts. Select any hostname in the list to view a full set of metrics specific to that instance.

Use the menu at the top of the panel to select the HTTP status code(s) to display. Use the menu in the top-right corner to change the time range for error data. Select any hostname in the list to view a full set of metrics specific to that instance.