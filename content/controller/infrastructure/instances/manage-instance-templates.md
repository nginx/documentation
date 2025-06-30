---
description: Create and manage templates for your F5 NGINX Plus instances.
nd-docs: DOCS-776
title: Manage Your Instance Templates
toc: true
weight: 50
type:
- tutorial
---

## Overview

An Instance Template defines the parameters to use when creating a data plane instance.

## Create an Instance Template

Take the following steps to create an Instance Template:

1. Open the F5 NGINX Controller user interface and log in.
1. Select the NGINX Controller menu icon, then select **Infrastructure** > **Instance Templates**.
1. Select **Create Instance Template**.
1. Add a name.
1. (Optional) Add a display name.
1. (Optional) Add a description.
1. (Optional) Add tags.
1. Select a Location in the list, or select **Create New** to [create a Location]({{< ref "/controller/infrastructure/locations/manage-locations.md" >}}).
1. Select the Instance Template type.

    - Select `AWS_INSTANCE_TEMPLATE` to create a template for NGINX instances on Amazon Web Services. For instructions on how to deploy NGINX instances on AWS, refer to the tutorial [Add an AWS NGINX Instance]({{< ref "/controller/infrastructure/instances/add-aws-instance.md" >}}).

1. Specify whether a public IP address should be assigned to the instance.
1. Select **Submit**.

{{< note >}}

Enabling WAF via the App Security add-on is not supported when deploying Instances with an Instance Template.

{{< /note >}}

## View or Delete an Instance Template

Take the following steps to view or delete an Instance Template:

1. Open the NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select **Infrastructure**.
3. On the **Infrastructure Menu**, select **Instance Templates**.
4. On the **My Instance Templates** menu, select **Overview**.
5. To view the details for an Instance Template, choose the Instance Template from the list. This opens a side panel with the template's details.
6. To delete an Instance Template, choose the Instance Template from the list, then select **Delete** (trash icon).

## What's Next

- [Create an Instance on Amazon Web Services]({{< ref "add-aws-instance.md" >}})
- [Configure the Controller Agent]({{< ref "/controller/admin-guides/config-agent/configure-the-agent.md" >}})
- [Set up Metrics Collection]({{< ref "/controller/analytics/metrics/overview-metrics-metadata.md" >}})

{{< versions "3.6" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
