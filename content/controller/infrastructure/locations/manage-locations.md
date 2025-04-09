---
description: Create and manage Locations for your F5 NGINX Instances.
docs: DOCS-778
title: Manage Locations
toc: true
weight: 10
type:
- tutorial
---

## Overview

You can logically group your NGINX instances and instance groups by their physical locations using the **Locations** settings page in the F5 NGINX Controller web interface.

{{< note >}}
By default, NGINX Instances are added to the `unspecified` Location. The unspecified Location is a system-owned resource that can’t be updated or deleted.
{{< /note >}}

## Create a Location

To create a Location, take the following steps:

1. Open the NGINX Controller user interface and log in.
1. Select the NGINX Controller menu icon, then select **Infrastructure**.
1. On the **Infrastructure Menu**, select **Locations**.
1. On the **Quick Action** menu, select **Create Location**.
1. On the **Create Location** page, provide the Location name.
1. (Optional) Add a display name.
1. Select the Location type:

    - Select `OTHER_LOCATION` to create a Location that's not an orchestrated cloud environment.
    - Select `AWS_LOCATION` to create a location for NGINX instances on Amazon Web Services. For instructions on how to deploy NGINX instances on AWS, refer to the tutorial [Add an AWS NGINX Instance]({{< ref "/controller/infrastructure/instances/add-aws-instance.md" >}}).

1. (Optional) Add a description.
1. (Optional) Add tags.

1. Select **Submit**.

## View, Edit, and Delete Locations

Take the following steps to view, edit, or delete a Location:

1. Open the NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select **Infrastructure**.
3. On the **Infrastructure Menu**, select **Locations**.
4. On the **My Locations** menu, select **Overview**.
5. To view the details for a Location, including the linked Instances, select the Location name in the list of Locations.
6. To edit a Location, select **Edit**.
7. To delete a Location, select **Delete**.

## What's Next

- [Add an Instance to a Location]({{< ref "/controller/infrastructure/instances/manage-instances.md" >}})
- [Add an AWS NGINX Instance]({{< ref "/controller/infrastructure/instances/add-aws-instance.md" >}})
- [Add an Azure NGINX Instance]({{< ref "/controller/infrastructure/instances/add-azure-instance.md" >}})
- [Add a VSphere NGINX Instance]({{< ref "/controller/infrastructure/instances/add-vsphere-instance.md" >}})
- [Manage your NGINX Instances]({{< ref "/controller/infrastructure/instances/manage-instances.md" >}})
- [Manage your NGINX Instance Groups]({{< ref "/controller/infrastructure/instances/manage-instances.md#instance-groups" >}})

{{< versions "3.5" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
