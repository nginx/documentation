---
description: How to forward Analytics Metrics to OpenTelemetry Collector.
docs: DOCS-532
title: Forward Analytics Metrics to OpenTelemetry Collector
toc: true
weight: 201
type:
- tutorial
---

## Overview

Follow the steps in this guide to set up an F5 NGINX Controller integration that forwards metrics to OpenTelemetry Collector.

## Before You Begin

This guide assumes that you already have a working instance of any OpenTelemetry Collector.

You will also need to [Create an Integration]({{< relref "/controller/platform/integrations/otlp-integration.md" >}}) for your OpenTelemetry Collector forwarder.

## Create a Forwarder

Take the following steps to create a forwarder for OpenTelemetry Collector:

1. Open the NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select **Platform**.
3. On the **Platform** menu, select **Data Forwarders**.
4. On the **Data Forwarders** menu, select **Create Data Forwarder**.
5. Add a name.
6. (Optional) Add a display name.
7. (Optional) Add a description.
8. Select your **Integration Reference** from the dropdown list, or select **Create New** to create a new integration.
9. In the **Collector Type** list, select `OTLP_HTTP` or `OTLP_GRPC`.
10. In the **Source** list, select the type of data to forward: `METRICS`.
11. In the **Output Format** list, select `OTLP`.
12. The **Selector** field consists of the following query parameters (optional):

- `names`: The list of metrics names that you want to forward.
- `excluded_names`: The list of metric names that you don't want to forward.
- `filter`: The conditions to use to refine the metrics data.
- Example usage when selecting metrics: `"names=nginx.*&excluded_names=nginx.upstream.*&filter=app='myapp'"`

13. (Optional) Select **Add Stream** to add additional streams, as needed.

{{< important >}}

Each metric is prefixed with a common namespace -- for example,  "nginx-controller" -- before it's sent to OpenTelemetry Collector. This prefix is used only by OpenTelemetry Collector and is not applied to any internal NGINX Controller metrics. Refer to the [metrics catalog]({{< relref "/controller/analytics/catalogs/metrics.md" >}}) for the full list of valid metric names.

We have tested compatability with OTLP collector v0.33.0.  We will most likely support versions higher than this, assuming backwards compatability from OTLP.

{{< /important >}}

{{< see-also >}}

See the [NGINX Controller Metrics]({{< relref "/controller/analytics/metrics/_index.md" >}}) docs for more information.

{{< /see-also >}}

## What's Next

- Refer to [Troubleshooting Forwaders]({{< relref "/controller/support/troubleshooting-forwarders.md" >}}) for tips on resolving common issues.

{{< versions "3.16" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
