---
description: Tips and tricks for using the Metrics API query parameters to refine
  your data.
nd-docs: DOCS-825
title: Query the Metrics API
toc: true
weight: 200
type:
- tutorial
---

## Overview

You can use the Analytics module to monitor your NGINX instances and evaluate your applications' performance. The Metrics API query parameters let you fine-tune your system data based on parameters such as time window, aggregation, time resolution, and filter.

By using different combinations of these query parameters, you can gather information that lets you:

- Identify system health -- query for various system metrics such as CPU, Memory to get the current state of your system
- Identify traffic behavior -- query for the HTTP / Stream Requests handled by an instance.
- Monitor your application performance -- filter on HTTP response codes to track the number of successful or failed requests

## Usage

You can use the Metrics API to query for desired metric names and fine-tune the data returned based on the following parameters:

- time window (`startTime` and `endTime`)
- `filter`
- `dimensions`
- `resolution`
- `groupBy`

## Authentication

You can use basic authentication or JWT authentication to access the NGINX Instance Manager REST API, as described in the [NGINX Instance Manager API Overview]({{< ref "/nim/fundamentals/api-overview#authentication" >}}).

The examples in this guide demonstrate using a "bearer" token for authentication. The token is sent using the "Authorization" request header field and "Bearer" schema.

### Understanding the Metrics API Response

The Metrics API response consists of query metadata and an array of `metrics` -- one array element for each queried metric.

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
                  "instance":"instance-name-1",
                  "nginx_id":"nginx-id-1",
               },
               "timestamps":[
                  "2020-12-10T12:00:00Z"
               ],
               "values":[
                  1000
               ]
            },
            {
               "dimensions":{
                  "instance":"instance-name-2",
                  "nginx_id":"nginx-id-2",
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
   ]
}
```

In the preceding example, there are two data series for the queried metric. The differentiator between the two series is the "nginx_id" value. This value is what makes NGINX metrics instance centric: you can easily distinguish metrics based on their dimensions' values, such as an Instance, NGINX ID or System ID.

You can view the full list of the supported metrics and dimensions, with detailed descriptions, by querying the Catalog API:

```shell
curl -X GET --url "<NMS_FQDN>/api/platform/v1/analytics/catalogs/metrics" -H "Authorization: Bearer <access token>"
```

Likewise, you can get a full list of the available dimensions by querying the Catalogs API:

```shell
curl -X GET --url "<NMS_FQDN>/api/platform/v1/analytics/catalogs/dimensions" -H "Authorization: Bearer <access token>"
```

This information is also provided in the [Catalogs Reference]({{< ref "/nms/reference/catalogs//_index.md" >}})).

### Querying the Metrics API

This section provides an overview of each query parameter and examples of using the parameters together to refine your data.

The examples progress from basic usage to more advanced API queries.

#### Names

The `names` parameter is the only required parameter in the Metrics API.

The following example query returns a response with the last recorded value for the queried metric: `nginx.http.request.count`:

```shell
curl -X GET --url "<NMS_FQDN>/api/platform/v1/analytics/metrics?names=nginx.http.request.count" -H "Authorization: Bearer <access token>"
```

If the dimension values differ, the `series` array in the response will contain multiple items.

It is possible to query the API for several metrics simultaneously. To do so, provide the metric names as a comma-separated list:

```shell
curl -X GET --url "<NMS_FQDN>/api/platform/v1/analytics/metrics?names=nginx.http.request.count,nginx.http.conn.accepted" -H "Authorization: Bearer <access token>"
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

The following example request returns all the recorded metric values for the last 12 hours.

```shell
curl -X GET --url "<NMS_FQDN>/api/platform/v1/analytics/metrics?names=nginx.http.request.count&startTime=now-12h" -H "Authorization: Bearer <access token>"
```

The following example query contains a fully defined time window:

```shell
curl -X GET --url "<NMS_FQDN>/api/platform/v1/analytics/metrics?names=nginx.http.request.count&startTime=now-5h&endTime=2020-07-01T09:00:00Z" -H "Authorization: Bearer <access token>"
```

In this case, the response contains metrics from 05:00:00 to 09:00:00 on the 1st of July 2020.

#### Aggregations

Using only `names` and time window parameters will give you the raw data points of metrics values.

To get a more organized response, you can provide an aggregate function for each queried metric: `AVG`, `SUM`, `COUNT`, `MAX`, `MIN`, or `RATE`.

{{< call-out "note" >}}
In the following definitions, `time period` refers to the `resolution` (if provided) or the difference between the `endTime` and `startTime` (when `resolution` is not provided).
{{< /call-out >}}

- `AVG` - calculates the average value of the metric data samples over the period
- `SUM` - calculates the total value of the metric data samples over the period
- `COUNT` - returns the number of collected data samples of the metric over the period
- `MIN`/`MAX` - returns the minimal/maximal data sample of the metric from the given period
- `RATE` - returns an average value of the metric calculated per second (always *per second*, regardless of the provided `resolution`), based on the data available in the given period

{{< call-out "note" >}}
You must define a `startTime` when using aggregate functions.
{{< /call-out >}}

{{< call-out "note" >}}
The list of supported aggregate functions for any particular metric is available in the [Metrics Catalog]({{< ref "/nms/reference/catalogs//metrics.md" >}})).
{{< /call-out>}}

For example, the following query returns a single value (per dimension set), which is the sum of the metric values for the last 12 hours. To get proper values, ensure that the `endTime` is greater than the `startTime`.

```shell
curl -X GET --url "<NMS_FQDN>/api/platform/v1/analytics/metrics?names=SUM(nginx.http.request.count)&startTime=now-12h" -H "Authorization: Bearer <access token>"
```

It is possible to use aggregated and non-aggregated metrics in a single query. For this query, the Metrics API returns a single value per dimension set. That value is the sum of all of the metric's values for the last 12 hours.

For example:

```shell
curl -X GET --url "<NMS_FQDN>/api/platform/v1/analytics/metrics?names=SUM(nginx.http.request.count),nginx.http.conn.accepted&startTime=now-12h" -H "Authorization: Bearer <access token>"
```

#### Resolution

If you want to change the returned data's granularity, you can use `resolution` parameter. This parameter must be used in conjunction with an aggregation function and a time window (at least `startTime` must be provided).

The `resolution` parameter must be a valid duration. The duration is a string that starts with a number, followed by a unit of time: `y`, `M`, `w`, `d`, `h`, `m`, or `s`.

The following example query returns three aggregated metric values. Here, we're asking for the data from last 12 hours with one-hour granularity:

```shell
curl -X GET --url "<NMS_FQDN>/api/platform/v1/analytics/metrics?names=SUM(nginx.http.request.count)&startTime=now-12h&resolution=1h" -H "Authorization: Bearer <access token>"
```

#### Filter

This parameter, as the name indicates, filters results based on the value of dimensions. Filtering by dimension value can help to refine the data that's returned into a more specific set.

The `filter` query consists of one or more predicates in the form of `<dimension><operator><dimension value>`, where:

- `<dimension>` is the name of the dimension;
- `<operator>` is one of the supported operators (`=`, `!=`, `<`, `<=`, `>=` `>`, `in` or `not`);
- `<dimension value>` is value of the dimension(s) that you want to filter on.

For example, the following query includes a simple filter on the app name. The query returns data for the application named `app1` for the last 12 hours.

```shell
curl -X GET --url "<NMS_FQDN>/api/platform/v1/analytics/metrics?names=nginx.http.request.count&filter=nginx_id='nginx_id1'&startTime=now-12h" -H "Authorization: Bearer <access token>"
```

{{< call-out "tip" >}}

- Predicates can be combined into logical expressions using `OR`, `AND`, and `(` `)`.
- For matching values, wildcard (`*`) use is supported.
- We recommend wrapping predicates in single quotes to ensure that the full query string is processed correctly.

{{< /call-out >}}

The following example request uses `filter` with logical expressions:

```shell
curl -X GET --url "<NMS_FQDN>/api/platform/v1/analytics/metrics?names=nginx.http.request.count&filter=nginx_id='nginx_id1*' and server_zone='zone1'&startTime=now-12h" -H "Authorization: Bearer <access token>"
```

#### GroupBy

Using filters and aggregation functions may not be enough to allow you to get comprehensive information about a specific application or environment.

The `groupBy` parameter helps to gather results according to the specified dimension(s). You can provide multiple dimension names as a comma-separated list.

{{< call-out "note" >}}

- When using `groupBy`, you must use an aggregate function and a time window (`startTime` must be defined; `endTime` is optional).
- If a request contains aggregated and non-aggregated metrics, the `groupBy` parameter will apply only to the aggregated metrics.

{{< /call-out >}}

For example, the following query returns data grouped by `nginx_id` for the last 12 hours.

```shell
curl -X GET --url "<NMS_FQDN>/api/platform/v1/analytics/metrics?names=SUM(nginx.http.request.count)&groupBy=nginx_id&startTime=now-12h" -H "Authorization: Bearer <access token>"
```

The API response for the query looks similar to the following:

```json
{
   "metrics":[
      {
         "aggr": "SUM",
         "name":"nginx.http.request.count",
         "series":[
            {
               "dimensions":{
                  "nginx_id":"nginx-id-1",
               },
               "timestamps":[
                  "2020-12-13T12:00:00Z"
               ],
               "values":[
                  1000
               ]
            },
            {
               "dimensions":{
                  "nginx_id":"nginx-id-2",
               },
               "timestamps":[
                  "2020-12-13T12:00:00Z"
               ],
               "values":[
                  2000
               ]
            }
         ]
      }
   ]
}
```

The API returns the data for the last 12 hours grouped by `nginx_id` dimension. Unlike other queries, the API only returns those dimensions that have been selected in `groupBy`. However, the series of different dimension values are still distinguished.

#### Dimensions

You can use the `dimensions` query parameter to specify which dimension(s) should be included in each metric series' response.

Dimensions not specified in the query parameter will not be included in the response. This may result in some series having the same dimension set but being returned as separate list items.

The following example returns results for the specified metric, where `dimensions=nginx_id`:

```shell
curl -X GET --url "<NMS_FQDN>/api/platform/v1/analytics/metrics?names=SUM(nginx.http.request.count)&dimensions=nginx_id&startTime=now-12h" -H "Authorization: Bearer <access token>"
```

```json
{
   "metrics":[
      {
         "aggr": "SUM",
         "name":"nginx.http.request.count",
         "series":[
            {
               "dimensions":{
                  "nginx_id":"nginx-id-1"
               },
               "timestamps":[
                  "2020-12-13T12:00:00Z"
               ],
               "values":[
                  1000
               ]
            },
            {
               "dimensions":{
                  "nginx_id":"nginx-id-2"
               },
               "timestamps":[
                  "2020-12-13T12:00:00Z"
               ],
               "values":[
                  2000
               ]
            }
         ]
      }
   ]
}
```

If `dimensions` and `groupBy` parameters are both used, the list of provided `dimensions` must be a subset of the list provided in `groupBy`.

The following example uses `dimensions` with `groupBy`:

```shell
curl -X GET --url "<NMS_FQDN>/api/platform/v1/analytics/metrics?names=SUM(nginx.http.request.count)&groupBy=nginx_id&dimensions=system_id&startTime=now-12h&resolution=5m" -H "Authorization: Bearer <access token>"
```

The `dimensions` parameter also lets you omit the dimensions from the response altogether. To do so, define `dimensions` as an empty list (`dimensions=`).

This results in several data series for the `http.request.count` metric without any dimensions being visible. That is not useful on its own; however, if you combine the empty `dimensions` parameter with metric aggregation, you will receive a single series with aggregated values.

For example, the following example query sums all the values in all of the series of the `http.request.count` metric for the past three hours using the default `resolution`.

```shell
curl -X GET --url "<NMS_FQDN>/api/platform/v1/analytics/metrics?names=SUM(nginx.http.request.count)&startTime=now-12h&dimensions=" -H "Authorization: Bearer <access token>"
```
