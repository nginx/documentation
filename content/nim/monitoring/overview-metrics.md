---
description: Understanding how the NGINX Agent collects and reports metrics
docs: DOCS-826
title: 'Overview: NGINX instance metrics'
toc: true
weight: 100
type:
- reference
---

## Overview

F5 NGINX Instance Manager collects two types of data:

- **System metrics**: Data about the data plane system, such as CPU and memory usage.
- **Traffic metrics**: Data from processed traffic, including NGINX OSS, NGINX Plus, and NGINX logs.

The NGINX Agent collects metrics every 15 seconds and publishes them every 60 seconds.

For a full list of available metrics, see the [Metrics Catalog Reference]({{< relref "/nms/reference/catalogs//metrics.md" >}}).

## How metrics are collected and reported

The NGINX Agent collects metrics every 15 seconds while running on the host. Metrics are then downsampled and sent to the Manager server once per minute.

NGINX Instance Manager stores historical data in an analytics database and applies roll-ups:

- Data up to **8 days old** is stored with **1-minute resolution**.
- Data **8 to 30 days old** is stored with **5-minute resolution**.
- Data **30 days to 15 months old** is stored with **1-hour resolution**.
- Data older than **15 months** is stored with **1-day resolution**.

### F5 NGINX Plus metrics

{{< include "/use-cases/monitoring/enable-nginx-plus-api.md" >}}

### NGINX Open Source metrics

{{< include "/use-cases/monitoring/enable-nginx-oss-stub-status.md" >}} 

### NGINX access log metrics

Enable access logging to collect traffic metrics by parsing logs. Use the following log format:

```nginx
log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                  '$status $body_bytes_sent "$http_referer" '
                  '"$http_user_agent" "$http_x_forwarded_for" '
                  '"$bytes_sent" "$request_length" "$request_time" '
                  '"$gzip_ratio" $server_protocol ';

access_log  /var/log/nginx/access.log  main;
```

## Troubleshooting

System metrics are collected automatically by the NGINX Agent. To collect NGINX-specific metrics, additional configuration is required.