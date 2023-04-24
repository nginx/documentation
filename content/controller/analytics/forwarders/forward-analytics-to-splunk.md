---
authors: []
categories:
- analytics
date: "2020-10-26T15:32:41-06:00"
description: How to forward Analytics data to Splunk
docs: DOCS-533
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
title: Forward Analytics Data to Splunk
toc: true
weight: 200
---

## Overview

Follow the steps in this guide to set up an NGINX Controller Integration that forwards data to [Splunk](https://www.splunk.com/).

## Before You Begin

This guide assumes that you are already an active Splunk user. If you haven't already done so, you will need to [install and configure Splunk](https://docs.splunk.com/Documentation) before you proceed.

You will also need to [Create an Integration]({{< relref "platform/integrations/splunk-integration.md" >}}) for your Splunk forwarder.

## Create a Forwarder



{{< include "forwarders/add-splunk-forwarder.md" >}}



## What's Next

- Refer to [Troubleshooting Forwaders]({{< relref "support/troubleshooting-forwarders.md" >}}) for tips on resolving common issues.

{{< versions "3.6" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}