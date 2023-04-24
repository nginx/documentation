---
authors: []
categories:
- installation
- infrastructure
- platform management
date: "2020-10-26T15:32:41-06:00"
description: Create and manage templates for your NGINX Plus instances.
docs: DOCS-776
doctypes:
- tutorial
draft: false
journeys:
- researching
- getting started
- using
personas:
- devops
roles:
- admin
tags:
- docs
title: Manage Your Instance Templates
toc: true
weight: 50
---


## Overview

An Instance Template defines the parameters to use when creating a data plane instance.

## Create an Instance Template

{{< include "instance-templates/add-instance-template.md" >}}

## View or Delete an Instance Template

{{< include "instance-templates/view-delete-instance-templates.md" >}}

## What's Next

- [Create an Instance on Amazon Web Services]({{< relref "add-aws-instance.md" >}})
- [Configure the Controller Agent]({{< relref "/admin-guides/config-agent/configure-the-agent.md" >}})
- [Set up Metrics Collection]({{< relref "/analytics/metrics/overview-metrics-metadata.md" >}})

{{< versions "3.6" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
