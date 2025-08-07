---
description: View and understand the Application Health Score for your application.
nd-docs: DOCS-526
title: Understanding the Application Health Score
toc: true
weight: 20
type:
- concept
---

## Overview

When you log in to the F5 NGINX Controller user interface, you will see the **Analytics Dashboard Overview** page. This page contains an Application Health Score (AHS) that reflects your application's performance.

The AHS is a customizable [Apdex-like numerical measure](https://www.apdex.org/) that can be used to estimate the quality of experience for your web application. It lets you configure service-level monitoring for your applications.

You can select any combination of the following three service-level indicators (SLI) to create your AHS:

- Successful requests (selected by default),
- (Optional) Request time (95th percentile), and
- (Optional) NGINX Controller Agent availability.

Successful requests are determined according to the total observed average request time (P95) either below the low threshold (100% satisfying) or between the low and high threshold (partially satisfying).

A simplified formula for AHS is as follows:

`AHS = (Successful Requests %) * (Timely Requests %) * (Agent Availability %)`

When you select the Request Time (95th percentile) for inclusion in the AHS, you can set two thresholds for the total observed average request time (P95):

- Low threshold for satisfying requests.
- High threshold for partially satisfying requests.

If the average request time (P95) for the selected time period is below the low threshold, this is considered as a "100% satisfying" state of requests.

If the request time is above the low threshold and below the high threshold, a "satisfaction ratio" is calculated accordingly.
Requests above the high threshold are considered to be "0%", or "unsatisfying".

For example: If the low threshold is 0.2s and the high threshold is 1s, a request time greater than 1s would be considered unsatisfying and the resulting score would be 0%.

The algorithm for calculating the AHS is as follows. Here, `T1` represents the low threshold and `T2` represents the high threshold.

```nginx
successful_req_pct = (nginx.http.request.count - nginx.http.status.5xx) / nginx.http.request.count

if (nginx.http.request.time.pctl95 < T1)
   timely_req_pct = 1
else
   if (nginx.http.request.time.pctl95 < T2)
       timely_req_pct = 1 - (nginx.http.request.time.pctl95 - T1) / (T2 - T1)
   else
       timely_req_pct = 0

m1 = successful_req_pct
m2 = timely_req_pct
m3 = agent_up_pct

app_health_score = m1 * m2 * m3
```

## Customize the Application Health Score

Take the steps below to customize the Application Health Score (AHS) that displays on the Overview page.

{{< call-out "note" >}}
By default, the AHS and other metrics on the **Overview** page are calculated for all of the Instances monitored by the Controller Agent.
{{< /call-out >}}

1. Open the NGINX Controller user interface and log in.
2. On the **Overview** page, select the Settings (gear) icon in the Application Health Score panel.
3. In the **Service Level Monitoring** window, define the following:

    - (Optional) Create a custom name for the monitor (replaces "Application Health Score").
    - (Optional) Select tags to narrow the data source(s) to a specific Instance or set of Instances.
    - Select the Service Indicators that you want to include in the score calculation.

      - Successful requests (selected by default).
      - Request time (95th percentile): Set a low threshold and a high threshold, in seconds.
      - Agent availability.

4. Select **Save**.

## What's Next

- [Overview of metrics and metadata]({{< ref "/controller/analytics/metrics/overview-metrics-metadata.md" >}})
- [Set up Metrics Collection]({{< ref "/controller/admin-guides/config-agent/configure-metrics-collection.md" >}})
- [Metrics Catalog Reference]({{< ref "/controller/analytics/catalogs/metrics.md" >}})
- [Dimensions Catalog Reference]({{< ref "/controller/analytics/catalogs/dimensions.md" >}})
- [Custom Dashboards]({{< ref "/controller/analytics/dashboards/custom-dashboards.md" >}})

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
