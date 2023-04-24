---
authors: []
categories:
- installation
- platform management
date: "2021-12-01T17:32:41-06:00"
description: Learn how to safely change the management IP of NGINX Controller .
docs: DOCS-779
doctypes:
- task
- tutorial
draft: false
journeys:
- researching
- getting started
- using
personas:
- devops
- netops
- secops
roles:
- admin
- user
tags:
- docs
title: Changing the IP address
toc: true
weight: 135
---

## Overview

This topic explains how to safely update the management IP of NGINX Controller.

{{< see-also >}}
For instructions on how to deploy NGINX Controller as a multi-node resilient cluster, refer to the following deployment guide:

- [Deploy NGINX Controller as a Resilient Cluster on a Private Cloud]({{< relref "/admin-guides/install/resilient-cluster-private-cloud.md" >}})

{{< /see-also >}}

## Changing the IP of a multi-node cluster

{{< include "installer/multi-node/change-multinode-ip.md" >}}

## Changing the IP of a single node

{{< include "installer/install-guide/change-ip.md" >}}

{{< versions "3.12" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
