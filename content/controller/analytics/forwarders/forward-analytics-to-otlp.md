---
authors: []
categories:
- analytics
date: "2021-03-15T15:32:41-06:00"
description: How to forward Analytics Metrics to OpenTelemetry Collector
docs: DOCS-532
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
title: Forward Analytics Metrics to OpenTelemetry Collector
toc: true
weight: 201
---

## Overview

Follow the steps in this guide to set up an NGINX Controller integration that forwards metrics to OpenTelemetry Collector.

## Before You Begin

This guide assumes that you already have a working instance of any OpenTelemetry Collector.

You will also need to [Create an Integration]({{< relref "platform/integrations/otlp-integration.md" >}}) for your OpenTelemetry Collector forwarder.

## Create a Forwarder



{{< include "forwarders/add-otlp-forwarder.md" >}}



## What's Next

- Refer to [Troubleshooting Forwaders]({{< relref "support/troubleshooting-forwarders.md" >}}) for tips on resolving common issues.

{{< versions "3.16" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}