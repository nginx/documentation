---
description: Use the Data Explorer to examine the metrics that F5 NGINX Controller collects.
docs: DOCS-529
doctypes:
- task
tags:
- docs
title: How To Use the Data Explorer
toc: true
weight: 20
---

## Overview

This topic explains how to use the Data Explorer to view the metrics that F5 NGINX Controller collects.

The Data Explorer lets you perform these following tasks:

- Easily switch between contexts, metrics, and dimensions
- Specify a time range of interest
- Set the aggregation mode
- Compare results to previous periods
- Export the query that's used to generate the charts as a URL, which you can use outside of NGINX Controller

&nbsp;

## Select the Context

To get started with the Data Explorer, you need to select the context for the data you want to view.

1. Open the NGINX Controller user interface and log in.
1. Select the NGINX Controller menu icon, then select **Analytics > Explorer**.
1. On the Data Explorer detail page, select a context area -- **Instances**, **Environments**, **Gateways**, or **Apps** -- for which you want to view data.

{{< note >}}
When you access the Data Explorer from other areas of the browser interface, the context is already defined. So, for example, if you select Data Explorer from within the Instances module (**Infrastructure > Instances > Data Explorer**), the data for your instances is displayed. When you switch between contexts, the metrics options, such as `system.cpu.idle` or `system.load.5`, are updated.
{{< /note >}}

&nbsp;

## Select a Resource

When you [select the context](#select-the-context) for the Data Explorer, a list of related resources is shown. If there aren't any related resources for the selected context, you'll see the message "No Data" on the Data Explorer detail page.

{{< note >}}

If you don't see a resource in the list, but you expect it to be there, check the [selected metric](#metrics) and the [selected time range](#time-range). When a resource doesn't have the data for the [selected time range](#time-range) it won't be added to the resources list.

{{< /note >}}

To view data for a resource, select the resource's name from the resource list.

{{< img src="/ctlr/img/data-explorer_resource.png">}}

## Metrics

The [list of metrics]({{< relref "/controller/analytics/catalogs/metrics.md" >}}) is sorted alphabetically, and you can use the search feature to filter the list. As previously mentioned, the list of metrics depends on the context you've selected for the Data Explorer. For example, if you've chosen Instances for the context, then the list of metrics will be for instances.

{{< img src="/ctlr/img/data-explorer_metric.png">}}

When the selected metric changes, the **Aggregation** and **Group By** selectors are updated correspondingly (as well as the [list of resources](#select-a-resource) and the [Dimensions panel](#dimensions-panel)). Some metrics have different lists of **Aggregation** and **Group By** values. For example, the `http.response_code` dimension, which is a valid **Group By** value for the `http.request.count` metric, is not available for the `nginx.workers.cpu.user` metric because these items are from different contexts and aren't related to each other.

## Aggregation Mode

Use the Aggregation selector -- the &Sigma; symbol with possible values of `AVG`, `MAX`, `MIN`, `RATE`, and `SUM` -- to [aggregate the data]({{< relref "/controller/analytics/metrics/metrics-api.md#aggregations" >}}). The list of possible aggregation values depends on the metrics that's selected.

{{< img src="/ctlr/img/data-explorer_aggregation.png">}}

## Group by Dimension

Use the **Group By** selector to [group the data by a chosen dimension]({{< relref "/controller/analytics/metrics/metrics-api.md#groupby" >}}).

In the following example image, the data for the `bytes_rcvd` metric is grouped by the dimension `http.request_method`, which displays a data series for the HTTP methods `DELETE`, `GET`, `LINK`, and so on.

{{< img src="/ctlr/img/data-explorer_group-by.png">}}

When a **Group By** selection is applied, the chart displays a top-10 data series. For example, let's say you want to check disk usage, so you select the metric `system.disk.total` and `file_path` as the dimension to group by. The chart would then display the top-10 mount points with the highest values. If you have more than 10 mount points, you'll see the top-10 mount points plus an 11th data series that's an aggregation of the rest of the data using the same selection criteria. In other words, you'll see a chart of the 10 most used mount points plus a chart of all the other mount points aggregated into one data series. When a **Group By** dimension is selected, and there are more than 10 dimensions, the 11th data series is named "Other."

{{< note >}} When MIN is selected as the aggregation method, the top-10 series are sorted ascending, lowest-to-highest. For all of the other aggregation methods, the top-10 values are sorted descending, highest-to-lowest. {{< /note >}}

&nbsp;

## Time Range

Use the time range selector above the chart to select the time range you want to examine. You can specify a custom time range if the predefined options aren't what you need.

The granularity of the data series is based on the selected time range and can vary from 30 seconds to five days to make the chart easier to read.

When you change the time range, the [list of resources](#select-a-resource) is updated correspondingly and it only includes the resources which have the data for the selected time range.

## Compare To

Next to the [time range](#time-range) selector, you'll find the `Compare To` list of options. This list allows you to compare data for the selected time frame with data from an earlier period. For example, you may want to view CPU usage for the last hour and compare the results to the same time from yesterday, last week, or even the previous year.

{{< img src="/ctlr/img/data-explorer_comparison.png">}}

{{< note >}}

- When comparison is turned on for a data series, the data have the suffix "Compare" in their names.
- If there is no data available for a comparison period, the comparison data series is not shown.
- When a Group By dimension is applied, data comparisons are made only with the top-10 data series and not with the "Other" series, if there is one. See the [Group By](#group-by) section for a discussion of the top-10 and "Other" series.
{{< /note >}}

&nbsp;

## Show Query

On the Data Explorer details page, you can select the **Show Query** button (eye icon) to view the URL that's used to query the Metrics API to get the data you see in the chart. If you copy the query and use it outside of NGINX Controller, you'll get the same data but in JSON format.

The query updates whenever the selection options change. The query doesn't include requests for comparison data.

{{< see-also >}}
For instructions on how to understand the Metrics API response, refer to the topic [Using the Metrics API]({{< relref "/controller/analytics/metrics/metrics-api#understanding-the-metrics-api-response" >}}).
{{< /see-also >}}

&nbsp;

## Dimensions panel

On the right of the screen there is a panel with the list of dimensions available for the [selected metric](#metrics).

{{< img src="/ctlr/img/data-explorer_dimensions-drawer.png">}}

Each dimension is presented as a section in which you can expand and see the values for it. The values are aggregated with the [selected aggregation method](#aggregation-mode) for the [selected time range](#time-range). They depend on the following selected parameters:

- [context](#select-the-context)
- [resource](#select-a-resource)
- [metric](#metrics)
- [aggregation](#aggregation-mode)
- [time range](#time-range)

When one of the parameters changes, you'll see the values for expanded dimensions are also updated.

You can see only top-10 values for each dimension, and based on the [selected aggregation](#aggregation-mode), they are sorted in following ways:

- When MIN is selected as the aggregation method, the top-10 series are sorted ascending, lowest-to-highest.
- For all of the other aggregation methods, the top-10 values are sorted descending, highest-to-lowest.

{{< note >}}

- When the selected metric changes, the list of dimensions may change as well, and some of the dimensions you recently explored may disappear from the panel.
- This panel was added in NGINX Controller v3.18.

{{< /note >}}

&nbsp;

{{< versions "3.17" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
