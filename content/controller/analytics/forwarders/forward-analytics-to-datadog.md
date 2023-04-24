---
authors: []
categories:
- analytics
date: "2020-10-26T15:32:41-06:00"
description: How to forward Analytics data to Datadog
docs: DOCS-531
doctypes:
- tutorial
draft: false
journeys:
- using
personas:
- devops
- netops
- secops
- support
roles:
- admin
tags:
- docs
title: Forward Analytics Data to Datadog
toc: true
weight: 100
---

## Overview

Follow the steps in this guide to set up an NGINX Controller Integration that forwards data to [Datadog](https://www.datadoghq.com/).

## Before You Begin

This guide assumes that you are already an active Datadog user. If you haven't already done so, you will need to [install and configure Datadog](https://docs.datadoghq.com/) before you proceed.

You will also need to [Create an Integration]({{< relref "platform/integrations/datadog-integration.md" >}}) for your Datadog forwarder.

## Create a Forwarder



{{< include "forwarders/add-datadog-forwarder.md" >}}



## Verification

Soon after you create the Datadog forwarder, you can view the selected metrics in Datadog.

1. Log into the [Datadog web interface](https://app.datadoghq.com/).
2. On the navigation menu, select **Metrics** > **Summary**.

## What's Next

- Refer to [Troubleshooting Forwaders]({{< relref "support/troubleshooting-forwarders.md" >}}) for tips on resolving common issues.

{{< versions "3.8" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}