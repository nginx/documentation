---
description: How to forward Analytics data to Splunk.
nd-docs: DOCS-533
title: Forward Analytics Data to Splunk
toc: true
weight: 200
type:
- tutorial
---

## Overview

Follow the steps in this guide to set up an F5 NGINX Controller Integration that forwards data to [Splunk](https://www.splunk.com/).

## Before You Begin

This guide assumes that you are already an active Splunk user. If you haven't already done so, you will need to [install and configure Splunk](https://docs.splunk.com/Documentation) before you proceed.

You will also need to [Create an Integration]({{< ref "/controller/platform/integrations/splunk-integration.md" >}}) for your Splunk forwarder.

## Create a Forwarder

Take the following steps to create a Forwarder for Splunk:

1. Open the NGINX Controller user interface and log in.
1. Select the NGINX Controller menu icon, then select **Platform**.
1. On the **Platform** menu, select **Data Forwarders**.
1. On the **Data Forwarders** menu, select the **Create Data Forwarder** quick action.
1. Add a name.
1. (Optional) Add a display name.
1. (Optional) Add a description.
1. Select your **Integration Reference** from the dropdown menu or select **Create New** to create a new Integration.
1. In the **Collector Type** list, select `SPLUNK`.
1. In the **Source** list, select the type of data to forward: `metrics` or `events`.
1. In the **Output Format** list, select `SPLUNK`.
1. The **Selector** field consists of the following query parameters (optional):

   - `names` (inapplicable for `EVENTS`): The list of metrics names that you want to forward.
   - `excluded_names` (inapplicable for `EVENTS`): The list of metric names that you don't want to forward.
   - `filter`: The conditions to use to refine the metrics or events data.
   - Example usage when selecting metrics: `"names=nginx.*&excluded_names=nginx.upstream.*filter=app='myapp'"`
   - Example usage when selecting events: `"filter=type='security violation' AND app='my-app'"`

1. (Optional) Add additional **Streams** as required using the **Add Stream** button.

{{< important >}}

Each metric will be prefixed with a common namespace -- such as `nginx-controller` -- before it is sent to Splunk. This prefix is used by Splunk only and is not applied to any of the internal NGINX Controller metrics. Refer to the [metrics catalog]({{< ref "/controller/analytics/catalogs/metrics.md" >}}) for the full list of valid metric names.

In case of events, the "nginx-controller" namespace will be placed in the ["source" key](https://docs.splunk.com/Documentation/Splunk/8.1.1/Data/FormateventsforHTTPEventCollector#Event_metadata) and sent with each event.

{{< /important >}}

{{< see-also >}}

See the [NGINX Controller Metrics]({{< ref "/controller/analytics/metrics/_index.md" >}}) docs for more information.

{{< /see-also >}}

## What's Next

- Refer to [Troubleshooting Forwaders]({{< ref "/controller/support/troubleshooting-forwarders.md" >}}) for tips on resolving common issues.

{{< versions "3.6" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
