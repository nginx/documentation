---
description: Use the Instance Overview page to view and manage your F5 NGINX Instances.
docs: DOCS-777
title: Manage Your NGINX Instances
toc: true
weight: 10
type:
- tutorial
---

## Overview

The **Infrastructure > Instances > Overview** page allows you to check the status of all your F5 NGINX instances at a glance.

When the [Controller Agent is installed]({{< ref "/controller/admin-guides/install/install-nginx-controller-agent.md" >}}) on a new system and the system registers with NGINX Controller, the instance is visible on the **Instances** overview page.

## Objective

- Add an NGINX instance
- View the number, location, type, and status of all instances registered with NGINX Controller
- View monitoring graphs for instances
- Delete an instance
- Update the NGINX Controller Agent

## Create an Instance

{{< include "controller/add-existing-instance.md" >}}

## Create an Instance Using a Template

An [Instance Template]({{< ref "/controller/infrastructure/instances/manage-instance-templates.md" >}}) defines the parameters to use when creating a data plane instance. Instance Templates are ideal for cloud orchestration and make managing your cloud resources easy and quick.

{{< see-also >}}
For steps on how to deploy NGINX instances on Amazon Web Services or Microsoft Azure, see the following tutorials:

- [Add an AWS NGINX Instance]({{< ref "/controller/infrastructure/instances/add-aws-instance.md" >}})
- [Add an Azure NGINX Instance]({{< ref "/controller/infrastructure/instances/add-azure-instance.md" >}})

{{< /see-also >}}

Take the following steps to create an instance using an Instance Template:

1. Open the NGINX Controller user interface and log in.
1. Select the NGINX Controller menu icon, then select **Infrastructure**.
1. On the **Infrastructure** menu, select **Instances**.
1. On the **Instances** overview page, select **Create**.
1. Select **Create a new instance using a template**.
1. Add a name.
1. Select a **Location** in the list, or select **Create New** to [create a location]({{< ref "/controller/infrastructure/locations/manage-locations.md" >}}).
1. Select an **Instance Template** in the list, or select **Create New** to [create an instance template]({{< ref "/controller/infrastructure/instances/manage-instance-templates.md" >}}).
1. Select **Submit**.

## View or Edit an Instance

Take the following steps to view an instance's details or to edit an instance:

1. Open the NGINX Controller user interface and log in.
1. Select the NGINX Controller menu icon, then select **Infrastructure**.
1. On the **Infrastructure** menu, select **Instances** > **Overview**.
1. To view the configuration details for an instance select the radio button next to the instance name. This opens a side panel where you can see the instance's status, properties, and resource details.
1. To view the monitoring graphs for an instance -- including bytes in/out and CPU and memory usage -- select the instance name link.
1. To edit an instance, select the radio button next to the instance name, then select the edit (pencil) icon.

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

An instance group is a logically grouped set of instances that can be used as a placement for a gateway, rather than a single instance. This concept supports the ability to scale horizontally without having to update the gateway placement. As instances are added to a group, they receive an NGINX configuration identical to those instances in the group. Instances in an instance group can be stand-alone or clustered NGINX Plus instances.  Instances can also leave the group, with the remaining instances continuing to function as intended.

{{< important >}}
**Workload affinity with instance groups**: Similar to instances, instance groups are associated with a location. If a location is not explicitly specified, the unspecified location is assumed. Instances in an instance group should be configured to use the same location; however, this requirement is not currently enforced.

For the workload affinity feature, the location of the instance group must be specified using the optional `locationRef` field in the component's workload group API request. The locations of the instances in the instance group are ignored. The workload affinity feature uses this information and the workload groups to load balance traffic to the correct endpoints.
{{< /important >}}

{{< important >}}
Instance groups are supported on the following versions of NGINX Controller:

- NGINX Controller API Management module v3.18 and later
- NGINX Controller Application Delivery module v3.21 and later
{{< /important >}}

### Create an Instance Group

To add an instance group, take the following steps:

1. Open the NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select **Infrastructure**.
3. On the **Infrastructure** menu, select **Instance Groups** > **Overview**.
4. On the **Instance Groups** overview page, select **Create Instance Group**.
5. Add a name for the instance group.
6. (Optional) Provide a display name.
7. (Optional) Provide a description.
8. (Optional) Select the HA type for the instance group.
9. When ready, review the API Spec and then select **Submit** to create the instance group.

### Edit or Delete an Instance Group

To edit or delete an instance group, take the following steps:

1. Open the NGINX Controller user interface and log in.
1. Select the NGINX Controller menu icon, then select **Infrastructure**.
1. On the **Infrastructure** menu, select **Instance Groups** > **Overview**.
1. Select the Instance Group that you want to modify or delete.
1. To edit the Instance Group, select **Edit Config** on the **Quick Actions** menu.
1. To delete the Instance Group, select **Delete Config** on the **Quick Actions** menu.

### Add or Remove Instances from an Instance Group

To add an existing instance to an instance group, take the following steps:

1. Make sure that no [gateways]({{< ref "/controller/services/manage-gateways.md" >}}) are using the instance as a placement. Instances that are referenced by a gateway cannot be added to an instance group.
1. [Delete the instance]({{< ref "/controller/infrastructure/instances/manage-instances.md#delete-an-instance" >}}).
1. [Add the instance]({{< ref "/controller/admin-guides/install/install-nginx-controller-agent.md#install-the-nginx-controller-agent" >}}) back to NGINX Controller. Run the agent install script ([Step 11]({{< ref "/controller/admin-guides/install/install-nginx-controller-agent.md#install-the-nginx-controller-agent" >}})).

## Update the NGINX Controller Agent

When you [update NGINX Controller]({{< ref "/controller/admin-guides/install/install-nginx-controller.md#update-nginx-controller" >}}), you also need to update the NGINX Controller Agent software on each monitored NGINX Plus instance.

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

If an Instance is in a `Failed` state, the Controller Agent or NGINX service may not be running.

Take the following steps to troubleshoot the issue:

1. Open an SSH connection to the failed Instance.
1. Check the status of the Controller Agent service:

    ```bash
    sudo systemctl status controller-agent.service
    ```

    If the Controller Agent service isn't running, you can start the service by running the following command:

    ```bash
    sudo systemctl start controller-agent.service
    ```

1. Check the status of the NGINX service:

    ```bash
    sudo systemctl status nginx.service
    ```

    If the NGINX service isn't running, you can start the service by running the following command:

    ```bash
    sudo systemctl start nginx.service
    ```

1. If neither of these steps resolves the issue, inspect the following log files for errors:

    - `/var/log/nginx-controller/agent.log`
    - `/var/log/nginx/error.log`

## What's Next

- [Configure the NGINX Controller Agent]({{< ref "/controller/admin-guides/config-agent/configure-the-agent.md" >}})
- [Set up Metrics Collection]({{< ref "/controller/analytics/metrics/overview-metrics-metadata.md" >}})
- [Create and Manage Locations for your Instances]({{< ref "/controller/infrastructure/locations/manage-locations.md" >}})
- [Create and Manage Instance Templates]({{< ref "/controller/infrastructure/instances/manage-instance-templates.md" >}})
- [Add an AWS NGINX Instance]({{< ref "/controller/infrastructure/instances/add-aws-instance.md" >}})
- [Add an Azure NGINX Instance]({{< ref "/controller/infrastructure/instances/add-azure-instance.md" >}})
- [Add a VSphere NGINX Instance]({{< ref "/controller/infrastructure/instances/add-vsphere-instance.md" >}})

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
