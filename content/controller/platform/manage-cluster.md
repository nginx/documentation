---
authors: []
categories:
- installation
- infrastructure
- platform management
- services
- api management
- service mesh
- security
- analytics
date: "2020-10-26T15:32:41-06:00"
description: Learn how to add and manage additional NGINX Controller nodes to create
  a resilient cluster.
docs: DOCS-788
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
title: Manage Your Cluster
toc: true
weight: 140
---

## Overview

This topic explains how to update your cluster settings and how to manage nodes for a multi-node cluster.

{{< see-also >}}
For instructions on how to deploy NGINX Controller as a multi-node resilient cluster, refer to the following deployment guide:

- [Deploy NGINX Controller as a Resilient Cluster on a Private Cloud]({{< relref "/admin-guides/install/resilient-cluster-private-cloud.md" >}})

{{< /see-also >}}

## Set the Floating IP


{{< include "installer/multi-node/add-floating-ip.md" >}}


## Update the FQDN


{{< include "cluster/update-fqdn-overview.md" >}}

### Update the FQDN for NGINX Controller

{{< include "installer/multi-node/change-fqdn-controller.md" >}}

### Update the FQDN for Controller Agents

{{< include "installer/multi-node/change-fqdn-agents.md" >}}


## Update the API Gateway SSL Certificate


{{< include "installer/multi-node/update-apigw-cert.md" >}}


## Add Nodes to a Cluster


{{< include "installer/multi-node/add-node.md" >}}


## View Node Status


{{< include "installer/multi-node/view-node-status.md" >}}


## Delete a Node


{{< include "installer/multi-node/delete-node.md" >}}


## Replace a Failed Node


{{< include "installer/multi-node/replace-failed-node.md" >}}


## Update Cluster


{{< include "installer/multi-node/update-cluster.md" >}}


{{< versions "3.12" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
