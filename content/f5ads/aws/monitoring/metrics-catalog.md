---
title: Metrics catalog
description: "Reference catalog of Amazon CloudWatch metrics exported by F5 Application Delivery Service for AWS deployments."
weight: 400
toc: false
f5-docs: DOCS-000
url: /f5ads/aws/monitoring/metrics-catalog/
f5-content-type: reference
f5-product: F5 Application Delivery Service for AWS
f5-keywords: "F5 ADS for AWS, metrics catalog, CloudWatch, connections, requests, SSL, cache, memory, upstream, stream"
f5-summary: >
  Reference catalog of metrics exported by F5 Application Delivery Service for AWS to Amazon CloudWatch under the NGINXaaS namespace.
  Use this guide to look up metric names, labels, data types, and roll-up scopes for NGINX config, connections, requests, SSL, cache, memory, upstream, and stream statistics.
f5-audience: operator
---

## Overview

F5 Application Delivery Service for AWS provides a rich set of metrics that you can use to monitor the health and performance of your F5 ADS deployment. This document provides a catalog of the metrics that are available for monitoring F5 ADS for AWS.

F5 ADS exports these metrics to Amazon CloudWatch using the [Embedded Metric Format (EMF)](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Embedded_Metric_Format.html). CloudWatch extracts them into metrics under the `NGINXaaS` namespace. See [Enable monitoring]({{< ref "/f5ads/aws/monitoring/enable-monitoring.md" >}}) to configure metric export.

The following metrics are reported by F5 ADS for AWS in Amazon CloudWatch under the `NGINXaaS` namespace. The labels allow you to filter or split your queries in Amazon CloudWatch providing you with a granular view over the metrics reported.

{{< include "/f5ads/metrics-catalog.md" >}}

## References

For more information, see:

- [Enable monitoring]({{< ref "/f5ads/aws/monitoring/enable-monitoring.md" >}})
- [Enable NGINX logs]({{< ref "/f5ads/aws/monitoring/enable-nginx-logs.md" >}})
- [Identity and access management]({{< ref "/f5ads/aws/deploy/access-management.md" >}})
