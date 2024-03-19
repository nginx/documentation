---
title: "Metrics"
date: 2020-12-17T11:52:09-07:00
draft: false
description: "NGINX Instance Manager Metrics and Analytics Documentation"
# Assign weights in increments of 100
weight: 300
toc: true
tags: [ "docs" ]
# Taxonomies
# These are pre-populated with all available terms for your convenience.
# Remove all terms that do not apply.
categories: ["installation", "analytics"]
doctypes: ["tutorial"]
journeys: ["getting started", "using"]
personas: ["devops", "netops", "secops", "support"]
versions: []
docs: "DOCS-631"
---

{{< include "nim/previous-versions/old-version-warning.md" >}}

{{%heading "overview"%}}

This document explains how to use metrics and analytics in NGINX Instance Manager.

## Prerequisites {#prerequisites}

1. Install NGINX Instance Manager Server.
2. Install NGINX or NGINX Plus and the NGINX Agent.
3. Start and Enable Instance Manager.

{{%heading "metrics"%}}

## Accessing metrics externally {#access-metrics}

To access metrics externally, simply point to the API URL and append `/metrics` to the end of the URL. For example, if nginx-manager runs on `https://nginx-manager.example.com:11000`, you would use `https://nginx-manager.example.com:11000/metrics` as the endpoint.

In Grafana, you can simply create a Prometheus data source and point it to the metrics location above for metrics.

To access a sample dashboard, copy the following JSON into a new dashboard and adjust the settings to meet your needs.

{{<fa "download">}} {{<link "/nim/previous-versions/static/previous-versions/v1/examples/grafana/nginx-manager.json">}}

## Accessing metrics through GUI {#gui-metrics}

To access the metrics in the web interface, go to the instance on the inventory page and select the metrics icon. You will get a minimal set of metrics to view. We recommend using an external application to augment and expand the metrics and alerts for NGINX Instance Manager.

## List of metrics {#list-metrics}

```text
namespace, "cpu"
"user"
"system"
"idle"
"iowait"
"stolen"

namespace, "load"
"avg1"
"avg5"
"avg15"

namespace, "mem"
"total"
"used"
"used.all"
"cached"
"buffered"
"shared"
"pct_used"
"free"
"available"

namespace, "swap"
"total"
"used"
"free"
"pct.free"

group: "http"

dim "nginx":"oss"
"conn_active"
"conn_accepted"
"conn_handled"
"conn_reading"
"conn_waiting"
"conn_writing"
"requests_total"

dim "nginx":"plus"
"conn_accepted"
"conn_active"
"conn_dropped"
"conn_idle"
"requests_current"
"requests_total"
"ssl_ok"
"ssl_failed"
"ssl_reuses"

Plus zones:
"server":
"discarded_count"
"processing_count"
"received_count"
"processed_count"
"sent_count"
"responses_1xx_count"
"responses_2xx_count"
"responses_3xx_count"
"upstream":
"keepalives"
"zombies"
"queue_maxsize"
"queue_overflows"
"queue_size"
"stream":
"discarded"
"processing"
"received"
"connections"
"sent"
"sessions_2xx"
"sessions_4xx"
"sessions_5xx"
"cache":
"bypass"
"bypass_bytes"
"expired"
"expired_bytes"
"hit"
"hit_bytes"
"miss"
"miss_bytes"
"revalidated"
"revalidated_bytes"
"size"
"stale"
"stale_bytes"
"updating"
"updating_bytes"
```
