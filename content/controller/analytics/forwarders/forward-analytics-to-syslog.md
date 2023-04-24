---
authors: []
categories:
- analytics
date: "2021-03-15T15:32:41-06:00"
description: How to forward Analytics Events to Syslog
docs: DOCS-534
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
title: Forward Analytics Events to Syslog
toc: true
weight: 201
---

## Overview

Follow the steps in this guide to set up a NGINX Controller Integration that forwards events to a syslog server.

## Before You Begin

This guide assumes that you already have a working instance of any syslog server.

If you haven't already done so, you can use an open-source version of [Syslog-NG](https://www.syslog-ng.com/products/open-source-log-management/).

You will also need to [Create an Integration]({{< relref "platform/integrations/syslog-integration.md" >}}) for your Syslog forwarder.

## Create a Forwarder



{{< include "forwarders/add-syslog-forwarder.md" >}}



## What's Next

- Refer to [Troubleshooting Forwaders]({{< relref "support/troubleshooting-forwarders.md" >}}) for tips on resolving common issues.

{{< versions "3.16" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}