---
title: Metrics catalog
description: "Reference catalog of NGINX metrics exported by F5 Application Delivery Service for Google Cloud deployments."
weight: 400
toc: false
f5-docs: DOCS-000
url: /application-delivery-service/google/monitoring/metrics-catalog/
f5-content-type: reference
f5-product: F5 Application Delivery Service for Google Cloud
f5-keywords: "F5 Application Delivery Service for Google Cloud, metrics catalog, Google Cloud monitoring, connections, requests, SSL, cache, memory, upstream, stream"
f5-summary: >
  Reference catalog of metrics exported by F5 Application Delivery Service for Google Cloud.
  Use this guide to look up metric names, labels, data types, and roll-up scopes for NGINX config, connections, requests, SSL, cache, memory, upstream, and stream statistics.
f5-audience: operator
---

## Overview

F5 Application Delivery Service for Google Cloud provides a rich set of metrics that you can use to monitor the health and performance of your F5 Application Delivery Service for Google Cloud deployment. This document provides a catalog of the metrics that are available for monitoring F5 Application Delivery Service for Google Cloud.

The following metrics are reported by F5 Application Delivery Service for Google Cloud in Google Cloud Monitoring.
The metrics are categorized by the namespace used in Google Cloud Monitoring. The labels allow you to filter or split your queries in Google Cloud Monitoring providing you with a granular view over the metrics reported.


{{< include "/ads/metrics-catalog.md" >}}


## References

For more information, see:

- [Enable monitoring]({{< ref "/ads/google/monitoring/enable-monitoring.md" >}})
- [Enable NGINX logs]({{< ref "/ads/google/monitoring/enable-nginx-logs.md" >}})
- [Identity and access management]({{< ref "/ads/google/deploy/access-management.md" >}})
