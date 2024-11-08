---
description: Understanding how the NGINX Agent collects and reports metrics
docs: DOCS-826
doctypes:
- reference
tags:
- docs
title: "Overview: NGINX instance metrics"
toc: true
weight: 300
---

## Overview

The data that Instance Manager collects can be divided into two categories:

- **System metrics**: Data collected about the data plane system, such as CPU and memory usage.
- **Traffic metrics**: Data related to processed traffic from sources such as NGINX OSS, NGINX Plus, or NGINX logs.

Metrics are collected every 15 seconds and are published at 60-second intervals.

For the full list of metrics, see the [Metrics Catalog Reference]({{< relref "/nms/reference/catalogs//metrics.md" >}})

## Metrics Collection and Reporting Process

While the NGINX Agent is running on the host, it collects metrics at regular 15-second intervals. Metrics then are downsampled and sent to the Manager server once per minute.

Instance Manager stores historical metrics data in an analytics database. Metrics are aggregated and rolled-up as follows:

- Data not older than 8 days are stored with best possible resolution (usually 1 min).
- Data older than 8 days but not older than 30 days are stored with 5 min resolution.
- Data older than 30 days but not older than 15 months are stored with 1 hour resolution.
- Data older than 15 months are stored with 1 day resolution.

### F5 NGINX Plus Metrics

Enable the NGINX Plus API to collect NGINX Plus metrics by uncommenting the `/api/` location section in `/etc/nginx/conf.d/default.conf`:

```nginx {hl_lines=[4]}
# enable /api/ location with appropriate access control in order
# to make use of NGINX Plus API
#
location /api/ {
    api write=on;
    allow 127.0.0.1;
    deny all;
}
```

### NGINX OSS Metrics

Enable NGINX Stub Status API to collect NGINX metrics in NGINX OSS. A sample Stub Status API configuration is shown below:

```nginx
server {
    listen 127.0.0.1:8080;
    location /api {
        stub_status;
        allow 127.0.0.1;
        deny all;
    }
}
```

### NGINX Access Log Metrics

Enable NGINX Access Logging to collect metrics from parsing access logs. A sample Access Log format is shown below:

```nginx
log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                  '$status $body_bytes_sent "$http_referer" '
                  '"$http_user_agent" "$http_x_forwarded_for" '
                  '"$bytes_sent" "$request_length" "$request_time" '
                  '"$gzip_ratio" $server_protocol ';

access_log  /var/log/nginx/access.log  main;
```

## Troubleshooting

System metrics are collected by the NGINX Agent without requiring the user to perform any additional setup. Additional setup is required to enable collection of NGINX related metrics.
