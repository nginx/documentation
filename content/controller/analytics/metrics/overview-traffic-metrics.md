---
description: Understanding how traffic metrics are collected, aggregated, and reported.
nd-docs: DOCS-537
title: 'Overview: Traffic Metrics'
toc: true
weight: 100
type:
- concept
- reference
---

## Overview

The data that F5 NGINX Controller collects can be divided into two categories:

- **System metrics**: Data collected from the NGINX Plus API, the NGINX log files, and NGINX process state.
- **Traffic metrics**: Data related to processed traffic, with the ability to distinguish the Application, API endpoint, or Environment that traffic is directed through.

{{< note >}}
The key difference between system and traffic metrics is that traffic metrics are pre-aggregated for each time period.
{{< /note >}}

Metrics are published at a regular interval of 60 or 30 seconds for system and traffic metrics, respectively.

This topic gives an overview of the traffic metrics. Also known as "app-centric" metrics, traffic metrics contain information that lets you easily identify the App to which the data applies.

{{< see-also >}}
Refer to [View traffic metrics]({{< ref "/controller/analytics/metrics/view-traffic-metrics.md" >}}) for instructions on how to view traffic metrics using the [NGINX Controller REST API]({{< ref "/controller/api/_index.md" >}}).
{{< /see-also >}}

## Available traffic metrics

- `client.latency.{total | max | min | count}`
- `client.network.latency.{total | max | min | count}`
- `client.request.latency.{total | max | min | count}`
- `client.ttfb.latency.{total | max | min | count}`
- `client.response.latency.{total | max | min | count}`
- `upstream.network.latency.{total | max | min | count}`
- `upstream.header.latency.{total | max | min | count}`
- `upstream.response.latency.{total | max | min | count}`
- `http.request.bytes_rcvd`
- `http.request.bytes_sent`
- `http.request.count`

{{< see-also >}}
Refer to the [NGINX Controller Metrics Catalog]({{< ref "/controller/analytics/catalogs/metrics.md" >}}) for details about these and the other metrics that NGINX Controller reports.
{{< /see-also>}}

## Calculating traffic metrics

As traffic flows through a configured application, NGINX Controller collects the traffic-related data. With heavy traffic, the number of single, distinguishable metrics can be challenging to discern. For this reason, the metric values are aggregated.

The aggregation happens every publish period -- this period is stored in the `aggregation_duration` dimension, and is usually 30 seconds -- and is based on metric dimensions.

Metrics are aggregated using four aggregation functions:

- **SUM** for `http.request.bytes_rcvd`, `http.request.bytes_sent` and all metrics with `.total` suffix.
- **MAX** for metrics with `.max` suffix.
- **MIN** for metrics with `.min` suffix.
- **COUNT** for metrics with `.count` suffix.

### Example

To better understand how metrics are aggregated, consider the following example:

Imagine you have one application configured with one URI (recorded in the `http.uri` dimension of each traffic-related metric). In the last 30 seconds, a user queried that URI five times. The `client.request.latency` values for the requests were: 1 ms, 2 ms, 3 ms, 4 ms, and 5 ms.

The final metric values returned by the Metrics API will be:

- `http.request.count` = 5
- `client.request.latency.total` = 15 ms
- `client.request.latency.max` = 5 ms
- `client.request.latency.min` = 1 ms
- `client.request.latency.count` = 5

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
