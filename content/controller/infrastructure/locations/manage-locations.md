---
authors: []
categories:
- infrastructure
date: "2020-10-26T15:32:41-06:00"
description: Create and manage Locations for your NGINX Instances.
docs: DOCS-778
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
title: Manage Locations
toc: true
weight: 10
---

## Overview

You can logically group your NGINX instances and instance groups by their physical locations using the **Locations** settings page in the NGINX Controller web interface.

{{< note >}}
By default, NGINX Instances are added to the `unspecified` Location. The unspecified Location is a system-owned resource that can’t be updated or deleted.
{{< /note >}}

## Create a Location

{{< include "locations/add-location.md" >}}

## View, Edit, and Delete Locations

{{< include "locations/view-edit-delete-locations.md" >}}

## What's Next

- [Add an Instance to a Location]({{< relref "/infrastructure/instances/manage-instances.md" >}})
- [Add an AWS NGINX Instance]({{< relref "/infrastructure/instances/add-aws-instance.md" >}})
- [Add an Azure NGINX Instance]({{< relref "/infrastructure/instances/add-azure-instance.md" >}})
- [Add a VSphere NGINX Instance]({{< relref "/infrastructure/instances/add-vsphere-instance.md" >}})
- [Manage your NGINX Instances]({{< relref "/infrastructure/instances/manage-instances.md" >}})
- [Manage your NGINX Instance Groups]({{< relref "/infrastructure/instances/manage-instances.md#instance-groups" >}})

{{< versions "3.5" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
