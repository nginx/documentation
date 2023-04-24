---
authors: []
categories:
- installation
- infrastructure
- security
date: "2020-11-03T14:06:51-07:00"
description: Learn how to register an NGINX App Protect instance with NGINX Controller
  for use with the ADC module.
docs: DOCS-770
doctypes:
- task
draft: false
journeys:
- researching
- getting started
- using
personas:
- netops
- support
roles:
- admin
tags:
- docs
title: Add an NGINX App Protect Instance
toc: true
weight: 20
---

## Overview

Follow the directions in this topic to deploy NGINX App Protect and add the instance to NGINX Controller.

## Deploy NGINX App Protect

<div data-proofer-ignore>

{{< include "instances/deploy-app-protect.md" >}}

</div>

## Add the NGINX App Protect Instance

Take the steps below to add the NGINX App Protect instance by using the NGINX Controller user interface.

{{< include "controller/instances/add-existing-instance.md" >}}

## What's Next

- [Set up NGINX Controller Agent to emit Security Events]({{< relref "/admin-guides/config-agent/configure-the-agent.md#enable-security-events" >}})
- [Learn about App Security]({{< relref "/app-delivery/security/concepts/what-is-waf.md" >}})
- [Manage App Security]({{< relref "/app-delivery/security/tutorials/add-app-security-with-waf.md" >}})

{{< versions "3.11" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
