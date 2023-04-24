---
authors: []
categories:
- infrastructure
- platform management
date: "2021-09-01T10:36:03-07:00"
description: Integrate NGINX Controller with Amazon Web Services
docs: DOCS-785
doctypes:
- tutorial
draft: false
journeys:
- using
personas:
- devops
roles:
- admin
tags:
- docs
title: AWS Integration
toc: true
weight: 20
---

## AWS Integration Requirements

{{< include "integrations/aws-integration-requirements.md" >}}

## Add an AWS Integration

{{< include "integrations/add-aws-integration.md" >}}

## What's Next

- [Deploy an Instance on Amazon Web Services]({{< relref "/infrastructure/instances/add-aws-instance.md" >}})

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
