---
description: Tips and tricks for using the Metrics API query parameters to refine
  your data.
docs: DOCS-535
title: Using the Metrics API
toc: true
weight: 50
type:
- tutorial
---

## Overview

You can use the F5 NGINX Controller Analytics module to monitor your NGINX instances and evaluate your applications' performance. The [Metrics API]({{< relref "/controller/api/_index.md" >}}) query parameters let you fine-tune your system data based on parameters such as time window, aggregation, time resolution, and filter.

By using different combinations of these query parameters, you can gather information that lets you:

- Identify which of your Apps receives the most traffic -- query for the highest number of requests among all apps.
- Understand the behavior of your back-end server(s) -- query for upstream latency by instance or location.
- Monitor your application performance -- filter on HTTP response codes to track the number of successful or failed requests by app and environment.
- Understand how your App behavior and/or usage changes across version releases -- compare data like the examples above across different versions of your application.

## Usage

You can use the NGINX Controller [Metrics API]({{< relref "/controller/api/_index.md" >}}) to query for desired metric names and fine-tune the data returned based on the following parameters:

- time window (`startTime` and `endTime`)
- `filter`
- `resolution`
- `groupBy`
- `seriesLimit`
- `orderSeriesBy`
- `dimensions`

{{< note >}}
Because NGINX Controller is constantly evolving, these example metrics and dimensions may differ from what you see with your NGINX Controller instance. Some metrics may require pre-configured applications to be visible in the API.
{{< /note >}}

### Understanding the Metrics API Response

The [Metrics API]({{< relref "/controller/api/_index.md" >}}) response consists of query metadata and an array of `metrics` -- one array element for each queried metric.

- The **metric** object includes the queried metric name and an array of data series associated with the metric.
- The **series** object groups metrics data according to dimension values. The series consists of dimensions (key-value map), timestamps, and the timestamps' metric values.

```json
{
   "metrics":[
      {
         "name":"http.request.count",
         "series":[
            {
               "dimensions":{
                  "app":"app-name",
                  "component":"component-name",
                  "environment":"environment-name",
                  "gateway":"gateway-name",
                  "instance":"instance-name"
               },
               "timestamps":[
                  "2020-07-01T12:00:00Z"
               ],
               "values":[
                  1000
               ]
            },
            {
               "dimensions":{
                  "app":"app-name-2",
                  "component":"component-name",
                  "environment":"environment-name",
                  "gateway":"gateway-name",
                  "instance":"instance-name"
               },
               "timestamps":[
                  "2020-07-01T12:00:00Z"
               ],
               "values":[
                  2000
               ]
            }
         ]
      }
   ],
   "queryMetadata":{
      "endTime":"2020-07-01T12:00:00.970106672Z"
   }
}
```

In the preceding example, there are two data series for the queried metric. The differentiator between the two series is the "app" name. This name is what makes NGINX metrics app-centric: you can easily distinguish metrics based on their dimensions' values, such as an App, Environment, or Gateway name.

You can view the full list of the supported metrics and dimensions, with detailed descriptions, by querying the Catalog API:

```curl
curl -X GET --cookie "session=<session cookie>" --url "{controller-IP}/api/v1/analytics/catalogs/metrics"
```

Likewise, you can get a full list of the available dimensions by querying the Catalogs API:

```curl
curl -X GET --cookie "session=<session cookie>" --url "{controller-IP}/api/v1/analytics/catalogs/dimensions"
```

This information is also provided in the [Catalogs Reference]({{< relref "/controller/analytics/catalogs/_index.md" >}})).

### Querying the Metrics API

This section provides an overview of each query parameter and examples of using the parameters together to refine your data.

The examples progress from basic usage to more advanced API queries.

#### Names

The `names` parameter is the only required parameter in the [Metrics API]({{< relref "/controller/api/_index.md" >}}).

The following example query returns a response with the last recorded value for the queried metric: `http.request.count`:

```curl
curl -X GET --cookie "session=<session cookie>" --url "{controller-IP}/api/v1/analytics/metrics?names=http.request.count"
```

If the dimension values differ, the `series` array in the response will contain multiple items.

It is possible to query the API for several metrics simultaneously. To do so, provide the metric names as a comma-separated list:

```curl
curl -X GET --cookie "session=<session cookie>" --url "{controller-IP}/api/v1/analytics/metrics?names=http.request.count,http.request.bytes_rcvd"
```

#### Time Window

To get more than the last recorded value for the queried metric, use the following time window parameters:

- `startTime` indicates the start of the time window to include metrics from (inclusive).
- `endTime` means the end of the time window to include metrics from (non-inclusive).

There are a few rules to remember when working with time window parameters:

- If you provide an `endTime`, you must also provide a `startTime`;
- `endTime` must be greater than `startTime`;
- If you give a `startTime` but don't give an `endTime`, the `endTime` defaults to the current time.

You can define time using the `ISO 8601` format or as an offset (for example, `2020-07-14T13:07:11Z`). An offset is a string that starts with `+` or `-`, followed by a number and a unit of time: `y`, `M`, `w`, `d`, `h`, `m`, or `s`.  You can also use `now` to indicate the current timestamp.

The following example request returns all the recorded metric values for the last three hours.

```curl
curl -X GET --cookie "session=<session cookie>" --url "{controller-IP}/api/v1/analytics/metrics?names=http.request.count&startTime=now-3h"
```

The following example query contains a fully defined time window:

```curl
curl -X GET --cookie "session=<session cookie>" --url "{controller-IP}/api/v1/analytics/metrics?names=http.request.count&startTime=now-5h&endTime=2020-07-01T09:00:00Z"
```

In this case, the response contains metrics from 05:00:00 to 09:00:00 on the 1st of July 2020.

#### Aggregations

Using only `names` and time window parameters will give you the raw data points of metrics values.

To get a more organized response, you can provide an aggregate function for each queried metric: `AVG`, `SUM`, `COUNT`, `MAX`, `MIN`, or `RATE`.

{{< note >}}
In the following definitions, `time period` refers to the `resolution` (if provided) or the difference between the `endTime` and `startTime` (when `resolution` is not provided).
{{< /note >}}

- `AVG` - calculates the average value of the metric data samples over the period
- `SUM` - calculates the total value of the metric data samples over the period
- `COUNT` - returns the number of collected data samples of the metric over the period
- `MIN`/`MAX` - returns the minimal/maximal data sample of the metric from the given period
- `RATE` - returns an average value of the metric calculated per second (always *per second*, regardless of the provided `resolution`), based on the data available in the given period

{{< note >}}
You must define a `startTime` when using aggregate functions.
{{< /note >}}

{{< see-also >}}
The list of supported aggregate functions for any particular metric is available in the [Metrics Catalog]({{< relref "/controller/analytics/catalogs/metrics.md" >}})).
{{< /see-also >}}

For example, the following query returns a single value (per dimension set), which is the sum of the metric values for the last three hours. To get proper values, ensure that the `endTime` is greater than the `startTime`.

```curl
curl -X GET --cookie "session=<session cookie>" --url "{controller-IP}/api/v1/analytics/metrics?names=SUM(http.request.count)&startTime=now-3h"
```

It is possible to use aggregated and non-aggregated metrics in a single query. For this query, the [Metrics API]({{< relref "/controller/api/_index.md" >}}) returns a single value per dimension set. That value is the sum of all of the metric's values for the last three hours.

For example:

```curl
curl -X GET --cookie "session=<session cookie>" --url "{controller-IP}/api/v1/analytics/metrics?names=SUM(http.request.count),http.request.bytes_rcvd&startTime=now-3h"
```

{{< important >}}
Using AVG aggregation with traffic metrics with the `.total` suffix may cause confusion because traffic metrics are already aggregated. To learn more, refer to the [Overview: Traffic Metrics]({{< relref "/controller/analytics/metrics/overview-traffic-metrics.md" >}})) topics.
{{< /important >}}

#### Resolution

If you want to change the returned data's granularity, you can use `resolution` parameter. This parameter must be used in conjunction with an aggregation function and a time window (at least `startTime` must be provided).

The `resolution` parameter must be a valid duration. The duration is a string that starts with a number, followed by a unit of time: `y`, `M`, `w`, `d`, `h`, `m`, or `s`.

The following example query returns three aggregated metric values. Here, we're asking for the data from last three hours with one-hour granularity:

```curl
curl -X GET --cookie "session=<session cookie>" --url "{controller-IP}/api/v1/analytics/metrics?names=SUM(http.request.count),&startTime=now-3h&resolution=1h"
```

There may be situations when the returned resolution is lower than that requested in the query. This has to do with metrics retention periods—the older the metric, the lower the resolution.

If the time window contains metrics with a lower resolution than was queried for, the API downsizes the granularity to the lowest possible value.  You will see a warning in the `responseMetadata`:

```json
"responseMetadata": {
    "warning": "Time window is above 8 days, Resolution is downsized to 300 seconds"
}
```

If no `resolution` is provided, the maximum available resolution is returned. This is calculated as `endTime` - `startTime`.

#### Filter

This parameter, as the name indicates, filters results based on the value of dimensions. Filtering by dimension value can help to refine the data that's returned into a more specific set.

The `filter` query consists of one or more predicates in the form of `<dimension><operator><dimension value>`, where:

- `<dimension>` is the name of the dimension;
- `<operator>` is one of the supported operators (`=`, `!=`, `<`, `<=`, `>=` `>`, `in` or `not`);
- `<dimension value>` is value of the dimension(s) that you want to filter on.

For example, the following query includes a simple filter on the app name. The query returns data for the application named `app1` for the last three hours.

```curl
curl -X GET --cookie "session=<session cookie>" --url "{controller-IP}/api/v1/analytics/metrics?names=http.request.count&filter=app='app1'&startTime=now-3h"
```

{{< tip >}}

- Predicates can be combined into logical expressions using `OR`, `AND`, and `(` `)`.
- For matching values, wildcard (`*`) use is supported.
- We recommend wrapping predicates in single quotes to ensure that the full query string is processed correctly.

{{< /tip >}}

The following example request uses `filter` with logical expressions:

```curl
curl -X GET --cookie "session=<session cookie>" --url "{controller-IP}/api/v1/analytics/metrics?names=http.request.count&filter=app='ap*' and environment='prod'&startTime=now-3h"
```

#### GroupBy

Using filters and aggregation functions may not be enough to allow you to get comprehensive information about a specific application or environment.

The `groupBy` parameter helps to gather results according to the specified dimension(s). You can provide multiple dimension names as a comma-separated list.

{{< note >}}

- When using `groupBy`, you must use an aggregate function and a time window (`startTime` must be defined; `endTime` is optional).
- If a request contains aggregated and non-aggregated metrics, the `groupBy` parameter will apply only to the aggregated metrics.

{{< /note >}}

For example, the following query returns data for any application with a name that starts with `ap` in the `prod` environment for the last three hours.

```curl
curl -X GET --cookie "session=<session cookie>" --url "{controller-IP}/api/v1/analytics/metrics?names=SUM(http.request.count)&groupBy=app,alias&startTime=now-3h"
```

The API response for the query looks similar to the following:

```json
{
   "metrics":[
      {
         "aggr": "SUM",
         "name":"http.request.count",
         "series":[
            {
               "dimensions":{
                  "app":"app-name",
                  "alias": "alias1"
               },
               "timestamps":[
                  "2020-07-01T12:00:00Z"
               ],
               "values":[
                  1000
               ]
            },
            {
               "dimensions":{
                  "app":"app-name-2",
                  "component":"alias1"
               },
               "timestamps":[
                  "2020-07-01T12:00:00Z"
               ],
               "values":[
                  2000
               ]
            }
         ]
      }
   ],
   "queryMetadata":{
      "endTime":"2020-07-01T12:00:00.970106672Z"
   }
}
```

The API returns the data for the last three hours grouped by `app` and `alias` dimensions. Unlike other queries, the API only returns those dimensions that have been selected in `groupBy`. However, the series of different dimension values are still distinguished.

#### SeriesLimit and OrderSeriesBy

There are cases when you might want to view only a specific data series (for example, "Top-5"). To query the API for a particular series of data, you can define the `seriesLimit` and `orderSeriesBy` query parameters.

- `seriesLimit` sets an upper limit on the number of series returned.
- `orderSeriesBy` sorts the series values according to the order specified:

  - Must consist of two tokens -- an aggregate function and a sort order. For example, `SUM DESC`, `MIN ASC`, and so on.
  - Can be used only in combination with `seriesLimit`.

When you specify a `seriesLimit`, the response always includes one other series with an `all` metric. This series aggregates the metric values of all the series that are not included in the result. If the total number of series returned is greater than the limit specified in the query parameter, an additional series named `other` is returned. This series aggregates the metrics values of the series outside of the specified limit.

{{< note >}}
When using `seriesLimit`, you can only specify one metric name in the `names` parameter and one `groupBy` parameter.
{{< /note >}}

**Example 1**
The following example request uses `seriesLimit` to restrict the data returned to five series:

```curl
curl -X GET --cookie "session=<session cookie>" --url "{controller-IP}/api/v1/analytics/metrics?names=SUM(http.request.count)&groupBy=app&seriesLimit=5&startTime=now-3h&resolution=5m
```

The response contains data for the last three hours, grouped by the `app` and `alias` dimensions. Unlike the other example queries, in this example, the API returns just those dimensions that have been selected in `groupBy`.  Each dimension and its corresponding values are provided as distinct items in a series.

**Example 2**
The following example query uses both `seriesLimit` and `orderSeriesBy`:

```curl
curl -X GET --cookie "session=<session cookie>" --url "{controller-IP}/api/v1/analytics/metrics?names=SUM(some.metric.name)&groupBy=someDimension&seriesLimit=5&orderSeriesBy=MAX DESC&startTime=now-1d&endTime=now&resolution=5m
```

**Example 3**
Building on the previous examples, here we use `seriesLimit` and `orderSeriesBy` to get the top-5 URIs with the highest number of bytes received for a specific App and Environment:

```curl
curl -X GET --cookie "session=<session cookie>" --url "{controller-IP}/api/v1/analytics/metrics?names=SUM(http.request.bytes_rcvd)&startTime=now-1h&filter=app='app1' AND environment='qa'&groupBy=http.uri&seriesLimit=5&orderSeriesBy=MAX DESC
```

In this case, the API returns five data series for the last hour ordered by MAX value in descending order for bytes received per URL, where the data is related to the application `app1` deployed on the environment `prod`.

Together, these parameters are particularly useful for refining data. The  `seriesLimit` says how many series should be returned, `orderSeriesBy` parameter defines the criteria for ordering series.

#### Dimensions

You can use the `dimensions` query parameter to specify which dimension(s) should be included in each metric series' response.

Dimensions not specified in the query parameter will not be included in the response. This may result in some series having the same dimension set but being returned as separate list items.

The following example returns results for the specified metric, where `dimensions=environment`:

```curl
curl -X GET --cookie "session=<session cookie>" --url "{controller-IP}/api/v1/analytics/metrics?names=SUM(http.request.count)&dimensions=environment&startTime=now-3h
```

If you have multiple Apps, the response looks similar to the following example:

```json
{
   "metrics":[
      {
         "aggr": "SUM",
         "name":"http.request.count",
         "series":[
            {
               "dimensions":{
                  "environment":"prod"
               },
               "timestamps":[
                  "2020-07-01T12:00:00Z"
               ],
               "values":[
                  1000
               ]
            },
            {
               "dimensions":{
                  "environment":"prod"
               },
               "timestamps":[
                  "2020-07-01T12:00:00Z"
               ],
               "values":[
                  2000
               ]
            }
         ]
      }
   ],
   "queryMetadata":{
      "endTime":"2020-07-01T12:00:00.970106672Z"
   }
}
```

If `dimensions` and `groupBy` parameters are both used, the list of provided `dimensions` must be a subset of the list provided in `groupBy`.

The following example uses `dimensions` with `groupBy`:

```curl
curl -X GET --cookie "session=<session cookie>" --url "{controller-IP}/api/v1/analytics/metrics?names=SUM(http.request.count)&groupBy=app,location&dimensions=app&startTime=now-3h&resolution=5m
```

The `dimensions` parameter also lets you omit the dimensions from the response altogether. To do so, define `dimensions` as an empty list (`dimensions=`).

This results in several data series for the `http.request.count` metric without any dimensions being visible. That is not useful on its own; however, if you combine the empty `dimensions` parameter with metric aggregation, you will receive a single series with aggregated values.

For example, the following example query sums all the values in all of the series of the `http.request.count` metric for the past three hours using the default `resolution`.

```curl
curl -X GET --cookie "session=<session cookie>" --url "{controller-IP}/api/v1/analytics/metrics?names=SUM(http.request.count)&startTime=now-3h&dimensions=
```

The response looks similar to the following example:

```json
{
   "metrics":[
      {
         "aggr": "SUM",
         "name":"http.request.count",
         "series":[
            {
               "dimensions":{},
               "timestamps":[
                  "2020-07-01T12:00:00Z",
                  "2020-07-01T12:00:30Z",
                  "2020-07-01T12:01:00Z",
                  "2020-07-01T12:01:30Z",
                  ...
               ],
               "values":[
                  3000,
                  2500,
                  2800,
                  1900,
                  ...
               ]
            }
         ]
      }
   ],
   "queryMetadata":{
      "endTime":"2020-07-01T15:00:00Z"
   }
}
```

{{< important >}}
You cannot use `dimensions` with the `seriesLimit` parameter.
{{< /important >}}

## What's Next

- [Metrics Reference]({{< relref "/controller/analytics/catalogs/metrics.md" >}}))
- [Dimensions Reference]({{< relref "/controller/analytics/catalogs/dimensions.md" >}}))
- [Create Custom Dashboards]({{< relref "/controller/analytics/dashboards/custom-dashboards.md" >}}))

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
