---
authors: []
categories:
- infrastructure
date: "2020-10-26T15:32:41-06:00"
description: Use the Instance Overview page to view and manage your NGINX Instances
docs: DOCS-777
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
title: Manage Your NGINX Instances
toc: true
weight: 10
---

## Overview

The **Infrastructure > Instances > Overview** page allows you to check the status of all your NGINX instances at a glance.

When the [Controller Agent is installed]({{< relref "/admin-guides/install/install-nginx-controller-agent.md" >}}) on a new system and the system registers with NGINX Controller, the instance is visible on the **Instances** overview page.

## Objective

- Add an NGINX instance
- View the number, location, type, and status of all instances registered with NGINX Controller
- View monitoring graphs for instances
- Delete an instance
- Update the NGINX Controller Agent

## Create an Instance

{{< include "controller/instances/add-existing-instance.md" >}}

## Create an Instance Using a Template

{{< include "instances/create-instance-using-a-template.md" >}}

## View or Edit an Instance

{{< include "instances/view-edit-instance.md" >}}

## Delete an Instance

Take the following steps to uninstall the Controller Agent and delete an instance.

{{< important >}}Be sure to uninstall the Controller Agent first, before you delete an instance. If you don't uninstall the Controller Agent first, the instance may reappear in NGINX Controller after it has been deleted.{{< /important >}}

1. On your NGINX Plus instance, stop the Controller Agent service:

    - On Ubuntu/Debian:

        ```bash
        service controller-agent stop
        ```

    - On CentOS/Red Hat Enterprise Linux:

        ```bash
        systemctl stop controller-agent
        ```

1. Run the appropriate command for your distribution to uninstall the Controller Agent:

    - On Ubuntu/Debian:

        ``` bash
        apt-get purge nginx-controller-agent
        ```

    - On CentOS/Red Hat Enterprise Linux:

        ``` bash
        yum remove nginx-controller-agent
        ```

        After the package is removed, you can safely delete the files in `/etc/controller-agent/` and `/var/log/nginx-controller/`.

1. (Optional) If you use SELinux on CentOS or Red Hat Enterprise Linux, take the following steps to remove the SELinux policy that was created when the Controller Agent was installed:

    1. Revert the installed permissions:

        ```bash
        sudo semodule -r nginx
        ```

    1. Remove the following files:

        - `nginx.te`
        - `nginx.mod`
        - `nginx.pp`

1. Delete the NGINX Plus instance from the NGINX Controller user interface:

    1. Open the NGINX Controller user interface and log in.

    1. Select the NGINX Controller menu icon, then select **Infrastructure**.

    1. On the **Infrastructure** menu, select **Instances** > **Overview**.

    1. On the **Instances** overview page, select the NGINX Plus instance that you want to delete.

    1. Select the delete icon (trash can).

1. Delete alerts:

    {{< note >}}When you delete an instance, any related alerts for that instance are not deleted automatically. You can delete the alerts manually, however.{{< /note >}}

   1. Open the NGINX Controller user interface and log in.
   2. On the Analytics menu, select **Alerts > Alert Rules**.
   3. Select the alert rule that you want to delete.
   4. Select the delete (trash can) icon to delete the alert rule.
   5. Select **Delete** in the pop-up box to confirm that you want to proceed.


## Instance Groups

{{< include "instance-groups/about-instance-groups.md" >}}

### Create an Instance Group

{{< include "instance-groups/add-instance-group.md" >}}

### Edit or Delete an Instance Group

{{< include "instance-groups/edit-delete-instance-group.md" >}}

### Add or Remove Instances from an Instance Group

{{< include "instance-groups/add-instances-to-groups.md">}}

## Update the NGINX Controller Agent

When you [update NGINX Controller]({{< relref "admin-guides/install/install-nginx-controller.md#update-nginx-controller" >}}), you also need to update the NGINX Controller Agent software on each monitored NGINX Plus instance.

To update the NGINX Controller Agent, take the following steps:

1. Open the NGINX Controller user interface and log in.
1. Select the NGINX Controller menu icon, then select **Infrastructure**.
1. On the **Infrastructure** menu, select **Instances** > **Overview**.
1. On the **Instances** overview page, select **Create**.
1. Follow the instructions in the **Install Instructions** pane to connect to the NGINX instance and install the updated Controller Agent package.

      {{< note >}}

NGINX Controller 3.6 and earlier require Python 2.6 or 2.7. You'll be prompted to install Python if it's not installed already. Python is not required for NGINX Controller 3.7 and later.

      {{< /note >}}


## Troubleshooting



{{< include "support/instance-failed-state.md" >}}



## What's Next

- [Configure the NGINX Controller Agent]({{< relref "/admin-guides/config-agent/configure-the-agent.md" >}})
- [Set up Metrics Collection]({{< relref "/analytics/metrics/overview-metrics-metadata.md" >}})
- [Create and Manage Locations for your Instances]({{< relref "/infrastructure/locations/manage-locations.md" >}})
- [Create and Manage Instance Templates]({{< relref "/infrastructure/instances/manage-instance-templates.md" >}})
- [Add an AWS NGINX Instance]({{< relref "/infrastructure/instances/add-aws-instance.md" >}})
- [Add an Azure NGINX Instance]({{< relref "/infrastructure/instances/add-azure-instance.md" >}})
- [Add a VSphere NGINX Instance]({{< relref "/infrastructure/instances/add-vsphere-instance.md" >}})

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
