---
description: Learn how to view events and metrics in F5 NGINX Instance Manager.
nd-docs: DOCS-847
title: View events and metrics
toc: true
weight: 300
type:
- how-to
---

## Overview

F5 NGINX Instance Manager provides events and metrics data for your instances. You can access this information in the user interface, or by using the REST API.

{{<note>}}This topic provides examples for using the REST API to view, sort, and filter Events data that can be applied across the NGINX Instance Manager REST API.{{</note>}}

## View Events in the User Interface

To view events in the NGINX Instance Manager user interface, take the following steps:

1. In a web browser, go to the FQDN for your NGINX Instance Manager host and log in.
2. In the **Platform** section, select **Events**. The **Events** overview page lists the events from the last six hours, with the most recent event listed first.
3. You can use the filters to filter events by level and time range, and sort events by selecting the column heading.
4. Select an event from the list to view the details.

## Access Events data by using the REST API

You can use the Events API to view NGINX Instance Manager events data. You can use basic authentication or JWT authentication to access the NGINX Instance Manager REST API, as described in the [NGINX Instance Manager API Overview]({{< ref "/nim/fundamentals/api-overview#authentication" >}}).

The examples in this guide demonstrate using a "bearer" token for authentication. The token is sent using the "Authorization" request header field and "Bearer" schema.

### Query the Events API for all Events

To query the Events API, send a GET request similar to the following example to the Events endpoint:

```shell
curl -X GET --url "https://<NMS_FQDN>/api/platform/v1/analytics/events" -H "Authorization: Bearer <access token>"
```

<details closed>
<summary>Example Response</summary>

```json
{
	"Metadata": {
		"pagination": {
			"links": {
				"next": {},
				"prev": {}
			},
			"pageToken": "1639453182"
		}
	},
	"items": [{
		"category": "agent status",
		"dimensions": {
			"alias": "alias",
			"hostname": "hostname",
			"instance": "instance",
			"nginx_id": "nginx_id",
			"system_id": "system_id",
		},
		"id": "uuid",
		"level": "INFO",
		"message": "successfully applied config on <instance>",
		"status": "Config Apply Success",
		"timestamp": "2021-12-14T01:03:11Z"
	}, {
		"category": "agent status",
		"dimensions": {
			"alias": "alias",
			"hostname": "hostname",
			"instance": "instance",
			"nginx_id": "nginx_id",
			"system_id": "system_id",
		},
		"error": "Config apply failed (write): Error running nginx -t exit status 1",
		"id": "uuid",
		"level": "INFO",
		"message": "failed to apply nginx config on <instance>",
		"status": "Config Apply Failure",
		"timestamp": "2021-12-14T00:57:48Z"
	},{
		"category": "agent status",
		"dimensions": {
			"alias": "alias",
			"hostname": "hostname",
			"instance": "instance",
			"nginx_id": "nginx_id",
			"system_id": "system_id"
		},
		"id": "uuid",
		"level": "INFO",
		"message": "nginx-agent v2.1.6 stopped on <instance>",
		"status": "Agent Stop",
		"timestamp": "2021-12-13T20:08:49Z"
	}, {
		"category": "agent status",
		"dimensions": {
			"alias": "alias",
			"hostname": "hostname",
			"instance": "instance",
			"nginx_id": "nginx_id",
			"system_id": "system_id",
		},
		"id": "uuid",
		"level": "INFO",
		"message": "nginx-agent v2.1.6 started on <instance>",
		"status": "Agent Start",
		"timestamp": "2021-12-13T03:20:00Z"
	}]
}
```

</details>

### Filter Events with Query Parameters

The list of events can be filtered by passing different query parameters to the API request. The type of filtering depends on the chosen query parameters. This section introduces the list of available query parameters.

Note that query parameters are only intended for filtering an events collection, not for querying a single event resource.

#### Time interval

Events can be queried with an exclusive time interval by passing either a `startTime` or both a `startTime` and an `endTime`.

##### Start Time

Passing a `startTime` query parameter to an Events API request will return only the events that occurred after the provided timestamp:

```shell
curl -X GET --url "https://<NMS_FQDN>/api/platform/v1/analytics/events?startTime=2022-03-19T08:00:00.000000000Z" -H "Authorization: Bearer <access token>"
```

The `startTime` parameter can use the keyword `now` to signify the timestamp at the time of the request.

Timestamps relative to `now` can be passed by subtracting a period of time from the current time, for example `now-3h` or `now-30m`

For example:

```shell
curl -X GET --url "https://<NMS_FQDN>/api/platform/v1/analytics/events?startTime=now-3h" -H "Authorization: Bearer <access token>"
```

Alternatively, the UUID of an event can be passed as a `startTime`. In this case, the events that occurred after the given event will be returned:

```shell
curl -X GET --url "https://<NMS_FQDN>/api/platform/v1/analytics/events?startTime=c77b71b5-3afa-497a-8e1c-fdc11d676796" -H "Authorization: Bearer <access token>"
```

##### End Time

The `endTime` query parameter cannot be passed without a `startTime`. Together they form an exclusive time interval, where the `startTime` is inclusive and `endTime` is non-inclusive. It can be formatted in the same three ways as `startTime`.

```shell
curl -X GET --url "https://<NMS_FQDN>/api/platform/v1/analytics/events?startTime=2022-03-19T08:00:00Z&endTime=2022-03-19T12:00:00Z" -H "Authorization: Bearer <access token>"
```

### Filtering

The `filter` parameter enables filtering events based on predicates. Predicates are in the form:

`<dimension><operator><dimension value>`

Where a `<dimension>` is one of the event's dimensions
`<operator>` is one of `=`, `!=`, `>=`, `<=`, `<`, `>`, `in`, `not`
`<dimension>` and `<dimension value>` are both case sensitive.

Predicates can be combined into logical expressions using `OR`, `AND`, `(` and `)`. Wildcards (`*`) are supported for matching values.

```shell
curl -X GET --url "https://<NMS_FQDN>/api/platform/v1/analytics/events?filter=category IN ('agent','nms') AND level='debug' AND count > 100" -H "Authorization: Bearer <access token>"
```

### Sorting

Events can be sorted based on any of their dimensions with the `orderBy` query parameter.

`orderBy` dimensions are separated by commas and can optionally given an order.

```shell
curl -X GET --url "https://<NMS_FQDN>/api/platform/v1/analytics/events?orderBy=timestamp DESC,id" -H "Authorization: Bearer <access token>"
```

The order of the dimensions can be either ascending (ASC) or descending (DESC). By default, that is when the order is omitted, dimensions are sorted in ascending order.

In the above example, events are sorted in descending timestamp order first, and second in ascending ID order (in cases where timestamps are equal).

### Pagination

There are several query parameters related to pagination in the API. By default, pagination is enabled with one hundred events returned per page.

#### Page

The `page` query parameter returns the events for the given page number. By default the first page is returned.

```shell
curl -X GET --url "https://<NMS_FQDN>/api/platform/v1/analytics/events?page=3" -H "Authorization: Bearer <access token>"
```

#### Page Size

`pageSize` determines how many events are returned per page, up to a maximum of 100. Setting `pageSize` to zero disables pagination.

```shell
curl -X GET --url "https://<NMS_FQDN>/api/platform/v1/analytics/events?pageSize=3" -H "Authorization: Bearer <access token>"
```

#### Page Token

`pageToken` is a transactional token that ensures consistency of queries across requests. Responses to queries made with the same `pageToken` will always be the same. The response is a snapshot of the database contents at the time of the original request when the `pageToken` was first used.

If `pageToken` is omitted, a token is automatically generated and returned in the response's metadata. Subsequent requests can then use that token to ensure consistency.

```shell
curl -X GET --url "https://<NMS_FQDN>/api/platform/v1/analytics/events?pageToken=1573653786" -H "Authorization: Bearer <access token>"
```

### Aggregations

#### Count

Passing the `includeTotal` query parameter with a value of `true` will return the total number of events of the response. The count of events will be in the response's metadata.

```shell
curl -X GET --url "https://<NMS_FQDN>/api/platform/v1/analytics/events?includeTotal=true" -H "Authorization: Bearer <access token>"
```

### Query a Single Event

Querying for a unique event requires only the event's UUID.

```shell
curl -X GET --url "https://<NMS_FQDN>/api/platform/v1/analytics/events/7cb91de6-49ae-4ddc-a8b3-3255e00b9346" -H "Authorization: Bearer <access token>"
```

<details closed>
<summary>Example response</summary>

```json
{
    "category": "agent status",
    "dimensions": {
        "alias": "devenv-agent",
        "hostname": "devenv-agent",
        "instance": "3d54a8fe-7c90-374f-9cad-fa2b8fccb0cd",
        "nginx_id": "3d54a8fe-7c90-374f-9cad-fa2b8fccb0cd",
        "system_id": "3d54a8fe-7c90-374f-9cad-fa2b8fccb0cd"
    },
    "id": "7cb91de6-49ae-4ddc-a8b3-3255e00b9346",
    "level": "INFO",
    "message": "nginx-agent v2.11.0 started on devenv-agent",
    "status": "Agent Start",
    "timestamp": "2022-03-21T14:33:37Z"
}
```

</details>
---

## View Metrics in the User Interface

{{< shortversions "2.3.0" "latest" "nimvers" >}}

The **Metrics Summary** page includes a highlights section of the most important metrics reported in the last minute, plus a summary of the key system, network, HTTP request, and connection metrics at a glance.

To view the metrics summary for an NGINX instance, take the following steps:

1. In a web browser, go to the FQDN for your NGINX Instance Manager host and log in.
2. Under **Modules**, select the **Instance Manager**.
3. Select an instance on the **Instances** detail page.
4. Select the **Metrics Summary** tab.
5. To view detailed metrics as graphs, select the **Metrics** tab.

{{<note>}}
Select a time range to change the period for the metrics display. The metrics data refreshes every 30 seconds.
{{</note>}}

For NGINX OSS instances, you can view basic system metrics and metrics for the NGINX data plane. These provide a high-level overview of your system.

Additional tabs for NGINX metrics are available if the selected instance is an NGINX Plus instance. These metrics provide a more in-depth overview of your system.
