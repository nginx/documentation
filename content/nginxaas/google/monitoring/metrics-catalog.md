---
title: Metrics catalog
description: "Reference catalog of NGINX metrics exported by F5 NGINXaaS for Google Cloud deployments."
weight: 400
toc: false
f5-docs: DOCS-000
url: /nginxaas/google/monitoring/metrics-catalog/
f5-content-type: reference
f5-product: NGINXaaS for Google Cloud
f5-keywords: "NGINXaaS for Google, metrics catalog, Google Cloud monitoring, connections, requests, SSL, cache, memory, upstream, stream"
f5-summary: >
  Reference catalog of metrics exported by F5 NGINXaaS for Google Cloud.
  Use this guide to look up metric names, labels, data types, and roll-up scopes for NGINX config, connections, requests, SSL, cache, memory, upstream, and stream statistics.
f5-audience: operator
---

## Overview

F5 NGINXaaS for Google Cloud (NGINXaaS) provides a rich set of metrics that you can use to monitor the health and performance of your NGINXaaS deployment. This document provides a catalog of the metrics that are available for monitoring NGINXaaS for Google Cloud.

The following metrics are reported by NGINXaaS for Google Cloud in Google Cloud Monitoring.
The metrics are categorized by the namespace used in Google Cloud Monitoring. The labels allow you to filter or split your queries in Google Cloud Monitoring providing you with a granular view over the metrics reported.


{{< include "/nginxaas/metrics-catalog.md" >}}


## References

For more information, see:

- [Enable monitoring]({{< ref "/nginxaas/google/monitoring/enable-monitoring.md" >}})
- [Enable NGINX logs]({{< ref "/nginxaas/google/monitoring/enable-nginx-logs.md" >}})
- [Identity and access management]({{< ref "/nginxaas/google/deploy/access-management.md" >}})
