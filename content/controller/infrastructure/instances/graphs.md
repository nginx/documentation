---
description: View key metrics for all of your monitored systems.
nd-docs: DOCS-773
title: View System Metrics Graphs
toc: true
weight: 70
type:
- how-to
- tutorial
- concept
- reference
---

## Overview

You can use the F5 NGINX Controller **Graphs** viewer to view key metrics for all of your monitored systems.

## Before You Begin

- [Install the NGINX Controller Agent on instances that you want to monitor]({{< ref "/controller/admin-guides/install/install-nginx-controller-agent.md" >}})
- [Configure Metrics collection on your NGINX instances]({{< ref "/controller/admin-guides/config-agent/configure-metrics-collection.md" >}})

## How to View Systems Graphs

Take the steps below to view metrics graphs for your individual systems.

1. Open the NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select **Infrastructure**.
3. On the **Infrastructure** menu, select **Analytics**.
4. Select the desired Instance from the list to view its graphs.

## Graphs

The following metrics graphs are displayed for all systems:

- NGINX Connections/s
- NGINX Requests/s
- NGINX Current Connections
- NGINX Current Requests
- NGINX HTTP Errors
- NGINX HTTP Version
- NGINX Workers
- NGINX File Descriptors
- NGINX CPU Usage %
- NGINX Memory Usage
- NGINX Traffic
- NGINX Disk I/O
- NGINX Request Time
- NGINX Disk Buffered
- NGINX Upstream Errors

Some graphs have an additional selector. For example, with "Disk Latency" or "Network Traffic," you can select the device or interface that you're analyzing.

Above the graphs, you will find the following:

- Hostname or alias for the selected system
- System properties editor where you can set up an alias for the host, and/or assign host tags
- List of tags assigned to the system
- Time range selector, which helps to display different periods for the graphs
- Time zone selector

You can also copy a predefined graph to a custom dashboard by selecting the graph and clicking the up arrow that appears in the top-right corner of the graph.

See the [Metrics and Metadata]({{< ref "/controller/analytics/metrics/overview-metrics-metadata.md" >}}) topic to learn more about the displayed metrics.

## What's Next

- [Overview of Metrics and Metadata]({{< ref "/controller/analytics/metrics/overview-metrics-metadata.md" >}})
- [Metrics Reference]({{< ref "/controller/analytics/catalogs/metrics.md" >}})

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
