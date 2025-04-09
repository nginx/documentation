---
description: How to view the traffic metrics gathered by NGINX Controller Analytics.
docs: DOCS-538
title: View Traffic Metrics
toc: true
weight: 150
type:
- how-to
- tutorial
---

## Overview

This topic explains how to use the [NGINX Controller REST API]({{< ref "/controller/api/_index.md" >}})
 to view traffic metrics.

{{< see-also >}}
Refer to [Overview: Traffic Metrics]({{< ref "/controller/analytics/metrics/overview-traffic-metrics.md" >}}) to learn how NGINX Controller collects, aggregates, and reports traffic metrics.
{{< /see-also >}}

## Before You Begin

To view traffic metrics, first confirm that you've correctly configured NGINX Controller.

The following resources should have the status `Configured`:

- [Environment]({{< ref "/controller/services/manage-environments.md" >}})
- [Gateway]({{< ref "/controller/services/manage-gateways.md" >}})
- [App and Component]({{< ref "/controller/app-delivery/manage-apps.md" >}})

Initially, the graphs will display `No data yet`, and querying the Metrics API for traffic metrics will result in an empty response. As soon as the Component starts to receive traffic, the traffic-related data will be displayed in the graphs and the [Dashboards]({{< ref "/controller/analytics/dashboards/overview-dashboard.md" >}}) in the NGINX Controller user interface and will be returned in API responses.

{{< note >}}
If traffic stops flowing to a resource (for example, an Application or Component), then no traffic metrics will be available for the resource.
{{< /note >}}

## View Traffic Metrics Using the REST API

- To view the full list of metrics and dimensions, send a GET request to the `/analytics/catalogs/metrics` endpoint:

    ```curl
    curl -X GET --cookie "session=<session cookie>" --url "{Controller-FQDN}/api/v1/analytics/catalogs/metrics"
    ```

- To view a detailed description for a metric, send a GET request to the `/analytics/catalogs/metrics/{metricName}` endpoint:

    ```curl
    curl -X GET --cookie "session=<session cookie>" --url "{Controller-FQDN}/api/v1/analytics/catalogs/metrics/client.latency.total"
    ```

- Likewise, to view the full list of available dimensions, send a GET request to the `/analytics/catalogs/dimensions` endpoint:

    ```curl
    curl -X GET --cookie "session=<session cookie>" --url "{Controller-FQDN}/api/v1/analytics/catalogs/dimensions"
    ```

{{< see-also >}}
Refer to the [Catalogs Reference]({{< ref "/controller/analytics/catalogs/_index.md" >}}) for information about all of the dimensions and metrics collected by NGINX Controller.
{{< /see-also >}}

## Example REST API Queries for Traffic Metrics

Because traffic metrics are already aggregated, you should be careful about using the Metrics API for aggregations.

### Example 1

Goal: Retrieve the total number of requests for the last 3 hours:

```curl
curl -X GET --cookie "session=<session cookie>" --url "{Controller-FQDN}/api/v1/analytics/metrics?names=SUM(http.request.count)&startTime=now-3h"
```

The Metrics API returns a single value per dimension set. That value is the sum of the aggregated values (in 30s intervals) for the last 3 hours.

### Example 2

Goal: Retrieve an average value of max client latencies for my app -- let's call it `app1` -- for the last day:

```curl
curl -X GET --cookie "session=<session cookie>" --url "{Controller-FQDN}/api/v1/analytics/metrics?names=AVG(client.latency.max)&startTime=now-24h&filter=app='app1'"
```

### Example 3

{{< important >}}
Because traffic metrics are pre-aggregated, using AVG aggregation with these metrics isn't recommended.
{{< /important >}}

Imagine you have one application configured with one URI (recorded in the `http.uri` dimension of each traffic-related metric). In the last 30 seconds, a user queried that URI 5 times. The `client.request.latency` values for each request were: 1 ms, 2 ms, 3 ms, 4 ms, 5 ms.

The final metric values returned by the Metrics API will be:

- `client.request.latency.total` = 15 ms
- `client.request.latency.count` = 5

The following query returns the average `client.request.latency.total = 15`, as you have one aggregated sample with value 15.

```curl
curl -X GET --cookie "session=<session cookie>" --url "{Controller-FQDN}/api/v1/analytics/metrics?names=AVG(client.request.latency.total)&startTime=now-24h"
```

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
