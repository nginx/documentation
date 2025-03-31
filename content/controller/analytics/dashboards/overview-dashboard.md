---
description: Learn about the Dashboards that displays cumulative metrics for your
  NGINX Instances.
docs: DOCS-528
title: Analytics Overview
toc: true
weight: 10
type:
- how-to
---

## Overview

The **Analytics Dashboards** provides an at-a-glance summary of the state of your F5 NGINX infrastructure and your application performance.

## Before You Begin

- [Install the NGINX Controller Agent on Instances that you want to monitor]({{< ref "/controller/admin-guides/install/install-nginx-controller-agent.md" >}})

## Overview Dashboard

When you log in to the NGINX Controller user interface, the **Analytics Overview** page displays first by default. Select the Dashboards tab to see the **My Dashboards** list page. On the **Dashboard Overview** page, you can view the key indicators noted below. By default, the graphs display metrics for the last hour. You can select any of the default time periods -- one hour, four hours, one day, two days, or one week -- to get a better idea of your apps' overall health and performance. To view metrics over longer time periods, you can create a [custom dashboard]({{< ref "/controller/analytics/dashboards/custom-dashboards.md" >}}).

The cumulative [metrics]({{< ref "/controller/analytics/metrics/overview-metrics-metadata.md" >}}) displayed on the **Analytics Overview** page are:

### System Metrics

- [Application Health Score]({{< ref "/controller/analytics/dashboards/application-health-score.md" >}}): the health score for your application.
- Average CPU: 100 - AVG of the system.cpu.idle (CPU spent in an idle state)
- Average Memory: AVG of the `system.mem.used` metric

### Application Metrics

- Time to First Byte: AVG of the `client.ttfb.latency.max` metric
- Bytes In/s (Bytes In per second): RATE of the `http.request.bytes_rcvd` metric
- Bytes Out/s (Bytes Out per second): RATE of the `http.request.bytes_sent` metric

- Total Requests: SUM of the `nginx.http.request.count` metric.
- HTTP 5XX Errors: SUM of the `nginx.http.status.5xx` metric.
- HTTP 4XX Errors: SUM of the `nginx.http.status.4xx` metric.
- Request time (P95): AVG of the `nginx.http.request.time.pctl95` metric.

- Avg Client Response Latency: AVG of the `client.response.latency.max` metric
- Avg Upstream Response Latency: AVG of the `upstream.response.latency.max` metric
- Avg Client Network Latency: AVG of the `client.network.latency.max` metric.

{{< note >}}

By default, the metrics are calculated for **all** of your Controller Agent-monitored Instances.

To display metrics for a specific set of hosts (for example, only for "production"), select the gear icon on the Application Health Score panel, then add a tag or tags by which you want to filter the results.

{{< /note >}}

## What's Next

- [Overview of metrics and metadata]({{< ref "/controller/analytics/metrics/overview-metrics-metadata.md" >}})
- [Metrics Catalog Reference]({{< ref "/controller/analytics/catalogs/metrics.md" >}})
- [Dimensions Catalog Reference]({{< ref "/controller/analytics/catalogs/dimensions.md" >}})
- [Application Health Score]({{< ref "/controller/analytics/dashboards/application-health-score.md" >}})
- [Custom Dashboards]({{< ref "/controller/analytics/dashboards/custom-dashboards.md" >}})

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
