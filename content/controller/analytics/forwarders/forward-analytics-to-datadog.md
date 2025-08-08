---
description: How to forward Analytics data to Datadog.
nd-docs: DOCS-531
title: Forward Analytics Data to Datadog
toc: true
weight: 100
type:
- tutorial
---

## Overview

Follow the steps in this guide to set up an F5 NGINX Controller Integration that forwards data to [Datadog](https://www.datadoghq.com/).

## Before You Begin

This guide assumes that you are already an active Datadog user. If you haven't already done so, you will need to [install and configure Datadog](https://docs.datadoghq.com/) before you proceed.

You will also need to [Create an Integration]({{< ref "/controller/platform/integrations/datadog-integration.md" >}}) for your Datadog forwarder.

## Create a Forwarder

Take the following steps to create a Forwarder for Datadog:

1. Open the NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select **Platform**.
3. On the **Platform** menu, select **Data Forwarders**.
4. On the **Data Forwarders** menu, select the **Create Data Forwarder** quick action.
5. Add a name.
6. (Optional) Add a display name.
7. (Optional) Add a description.
8. Select your **Integration Reference** from the dropdown menu or select **Create New** to create a new Integration.
9. In the **Collector Type** list, select `DATADOG`.
10. In the **Source** list, select the type of data to forward: `metrics` or `events`.
11. In the **Output Format** list, select `DATADOG`.
12. The **Selector** field consists of the following query parameters (optional):

- `names` (inapplicable for `EVENTS`): The list of metrics names that you want to forward.
- `excluded_names` (inapplicable for `EVENTS`): The list of metric names that you don't want to forward.
- `filter`: The conditions to use to refine the metrics or events data.
- Example usage when selecting metrics: `"names=nginx.*&excluded_names=nginx.upstream.*filter=app='myapp'"`
- Example usage when selecting events: `"filter=type='security violation' AND app='my-app'"`

13. (Optional) Add additional **Streams** as required using the **Add Stream** button.

{{< call-out "important" >}}

Each metric will be prefixed with a common namespace -- such as "nginx-controller" -- before it is sent to Datadog. This prefix is used by Datadog only and is not applied to any of the internal NGINX Controller metrics. Refer to the [metrics catalog]({{< ref "/controller/analytics/catalogs/metrics.md" >}}) for the full list of valid metric names.

For events, the "nginx-controller" namespace is added to the ["ddsource" key](https://docs.datadoghq.com/api/v1/logs/#send-logs).

{{< /call-out >}}

NGINX Controller events are sent to Datadog as logs and NGINX Controller dimensions are sent as tags. The Forwarder converts the dimension data to comply with the Datadog [tags format](https://docs.datadoghq.com/getting_started/tagging/#defining-tags) prior to forwarding it. In some cases, the original dimension value may be transformed to fit the tag requirements. This includes replacing comma characters (`,`) with semicolons (`;`) to ensure that Datadog will properly handle the incoming payload.

{{< call-out "note" >}}

See the [NGINX Controller Metrics]({{< ref "/controller/analytics/metrics/_index.md" >}}) docs for more information.

{{< /call-out>}}

## Verification

Soon after you create the Datadog forwarder, you can view the selected metrics in Datadog.

1. Log into the [Datadog web interface](https://app.datadoghq.com/).
2. On the navigation menu, select **Metrics** > **Summary**.

## What's Next

- Refer to [Troubleshooting Forwaders]({{< ref "/controller/support/troubleshooting-forwarders.md" >}}) for tips on resolving common issues.

{{< versions "3.8" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
