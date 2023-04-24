---
aliases:
- /analytics/metrics/reference/overview-metrics-metadata/
authors: []
categories:
- analytics
date: "2020-10-26T15:32:41-06:00"
description: Understanding how the NGINX Controller Agent collects and reports metrics
  and metadata
docs: DOCS-536
doctypes:
- reference
draft: false
journeys:
- researching
- getting started
- using
personas:
- devops
- netops
- secops
- support
roles:
- admin
- user
- read-only
tags:
- docs
title: 'Overview: Metrics and Metadata'
toc: true
weight: 20
---

## Overview

{{< include "analytics/traffic-metrics-overview.md" >}}

## Metadata and Metrics That Are Reported

The NGINX Controller Agent collects the following types of data:

* **NGINX metrics.** The Agent collects NGINX-related metrics using the NGINX Plus API, and by monitoring the NGINX log files and NGINX process state.
* **AVRD metrics.** AVRD sends app-centric data, so each metric has assigned dimensions like "application name" or "gateway". These metrics are related to processed traffic (for example, the number of bytes sent to a particular URL/endpoint).
* **NGINX configuration.** After the initial installation, the NGINX configuration is uploaded to the NGINX Controller server. Configuration updates are also uploaded to the NGINX Controller server.
* **System metrics.** These are key metrics describing the system. For example: CPU usage, memory usage, network traffic, etc.
* **NGINX metadata.** These describe your NGINX instances, and include package data, build information, the path to the binary, build configuration options, and so on. NGINX metadata also includes the NGINX configuration elements.
* **System metadata.** These are the basic information about the OS environment where the Agent runs. For example, the hostname, uptime, OS flavor, and other data.

For the full list of metrics, see the [Metrics Catalog Reference]({{< relref "analytics/catalogs/metrics.md" >}})

## Metrics Collection and Reporting Process

The Agent mostly uses Golang's [gopsutil](https://github.com/shirou/gopsutil) to collect OS metrics.

While the Agent is running on the host, it collects metrics at regular 20-second intervals. Metrics then are downsampled and sent to the Controller server once per minute. The Agent reports metadata  to the NGINX Controller server every minute. Changes to the metadata can be examined using the Controller user interface.

NGINX Controller stores historical metrics data in an analytics database. Metrics are aggregated and rolled-up as follows:

* Data not older than 8 days are stored with best possible resolution (usually 1 min).
* Data older than 8 days but not older than 30 days are stored with 5 min resolution.
* Data older than 30 days but not older than 15 months are stored with 1 hour resolution.
* Data older than 15 months are stored with 1 day resolution.

### Parsing and Analyzing NGINX Configuration Files

NGINX configuration updates are reported only when a configuration change is detected.

The Agent checks the Controller server every 30 seconds for pending NGINX configuration changes. When changes are pending, the changes are applied and the NGINX is reloaded.  Because the configuration is managed in the Controller server, the entire configuration is written to a single `nginx.conf` file.

If the Agent cannot reach the Controller server to send the accumulated metrics, it continues to collect metrics and sends them to the Controller server as soon as connectivity is re-established. The maximum amount of data that can be buffered by the Agent is about 2 hour's worth of data.

The Agent is able to automatically find all relevant NGINX configuration files, parse them, extract their logical structure, and send the associated JSON data to the Controller Server for further analysis and reporting.

To parse SSL certificate metadata, the NGINX Controller Agent uses standard `openssl`(1) functions. SSL certificates are parsed and analyzed only when the corresponding [Agent settings]({{< relref "admin-guides/config-agent/configure-the-agent.md#default-agent-settings" >}}) are turned on. SSL certificate analysis is `off` by default.

## Troubleshooting

Most metrics are collected by the Agent without requiring the user to perform any additional setup. For troubleshooting instructions, see [Troubleshooting NGINX Controller Metrics]({{< relref "support/troubleshooting-controller.md" >}}).

## What's Next

* [Set up Metrics Collection]({{< relref "admin-guides/config-agent/configure-metrics-collection.md" >}})
* [Metrics Reference]({{< relref "analytics/catalogs/metrics.md" >}})

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}