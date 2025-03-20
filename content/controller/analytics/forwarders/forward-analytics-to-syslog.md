---
description: How to forward Analytics Events to Syslog.
docs: DOCS-534
title: Forward Analytics Events to Syslog
toc: true
weight: 201
type:
- tutorial
---

## Overview

Follow the steps in this guide to set up a F5 NGINX Controller Integration that forwards events to a syslog server.

## Before You Begin

This guide assumes that you already have a working instance of any syslog server.

If you haven't already done so, you can use an open-source version of [Syslog-NG](https://www.syslog-ng.com/products/open-source-log-management/).

You will also need to [Create an Integration]({{< relref "/controller/platform/integrations/syslog-integration.md" >}}) for your Syslog forwarder.

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
1. In the **Collector Type** list, select `SYSLOG`.
1. In the **Source** list, select the type of data to forward: `events`. NGINX Controller can forward only `EVENTS` data to syslog.
1. In the **Output Format** list, select `SYSLOG`.
1. The **Selector** field consists of the following query parameters (optional):

   - `filter`: The conditions to use to refine the metrics or events data.
   - Example usage: `"filter=type='security violation' AND app='my-app'"`

1. (Optional) Add additional **Streams** as required using the **Add Stream** button.

## What's Next

- Refer to [Troubleshooting Forwaders]({{< relref "/controller/support/troubleshooting-forwarders.md" >}}) for tips on resolving common issues.

{{< versions "3.16" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
