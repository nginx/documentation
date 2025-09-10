---
description: How to install, upgrade, and uninstall the F5 Controller Agent.
nd-docs: DOCS-254
title: Install NGINX Controller Agent
toc: true
weight: 150
type:
- tutorial
---

## Overview

This page shows how to install, update, and uninstall the F5 NGINX Controller Agent.

You can use the NGINX Controller Agent to monitor your systems with the NGINX Controller.

## Objectives

- Install the NGINX Controller Agent
- Upgrade the NGINX Controller Agent to a newer version
- Uninstall the NGINX Controller Agent

## Install the NGINX Controller Agent

{{< call-out "note" >}} If you want to run the NGINX Controller Agent as a non-root user, follow the alternative instructions in the [Install NGINX Controller Agent for Non-root User]({{< ref "/controller/admin-guides/install/install-agent-non-root.md" >}}) guide instead of the steps provided in this section. {{< /call-out>}}

Take the following steps to add an instance to NGINX Controller:

1. Open the NGINX Controller user interface and log in.
2. Select the NGINX Controller menu icon, then select **Infrastructure**.
3. On the **Infrastructure** menu, select **Instances** > **Overview**.
4. On the **Instances** overview page, select **Create**.
5. On the **Create Instance** page, select **Add an existing instance**.
6. Add a name for the instance. If you don't provide a name, the hostname of the instance is used by default.
7. To add the instance to an existing [Instance Group]({{< ref "/controller/infrastructure/instances/manage-instances.md#instance-groups" >}}), select an Instance Group from the list. Or to create an Instance Group, select **Create New**.
8. To add the instance to an existing Location, select a Location from the list. Or to create a Location, select **Create New**.

    {{< call-out "important" >}}
Once set, the Location for an instance cannot be changed. If you need to change or remove the Location for an instance, you must [remove the instance from NGINX Controller]({{< ref "/controller/infrastructure/instances/manage-instances.md#delete-an-instance" >}}), and then add it back.
    {{< /call-out >}}

    {{< call-out "important" >}}
Instances and the instance groups they belong to should specify the same location; however, this requirement is not currently enforced. If different locations are specified, the instance group's location takes precedence. This is important to remember when [assigning locations to workload groups]({{< ref "/controller/app-delivery/manage-apps.md#workload-groups">}}).
    {{< /call-out >}}

9. (Optional) By default, registration of NGINX Plus instances is performed over a secure connection. To use self-signed certificates with the Controller Agent, select **Allow insecure server connections to NGINX Controller using TLS**. For security purposes, we recommend that you secure the Controller Agent with signed certificates when possible.
10. Use SSH to connect and log in to the NGINX instance that you want to connect to NGINX Controller.
11. Run the `curl` or `wget` command that's shown in the **Installation Instructions** section on the NGINX instance to download and install the Controller Agent package. When specified, the `-i` and `-l` options for the `install.sh` script refer to the instance name and Location, respectively.

    {{< call-out "note" >}}

Make sure you enter the commands to download and run the `install.sh` script on the NGINX Plus system, and not on the NGINX Controller.

NGINX Controller 3.6 and earlier require Python 2.6 or 2.7. You'll be prompted to install Python if it's not installed already. Python is not required for NGINX Controller v3.7 and later.

    {{< /call-out >}}

After a few minutes, the NGINX instance will appear on the **Instances** overview page.


## Update the NGINX Controller Agent

When you [update NGINX Controller]({{< ref "/controller/admin-guides/install/install-nginx-controller.md#update-nginx-controller" >}}), you also need to update the NGINX Controller Agent software on each monitored NGINX Plus instance.

To update the NGINX Controller Agent, take the following steps:

1. Open the NGINX Controller user interface and log in.
1. Select the NGINX Controller menu icon, then select **Infrastructure**.
1. On the **Infrastructure** menu, select **Instances** > **Overview**.
1. On the **Instances** overview page, select **Create**.
1. Follow the instructions in the **Install Instructions** pane to connect to the NGINX instance and install the updated Controller Agent package.

      {{< call-out "note" >}}

NGINX Controller 3.6 and earlier require Python 2.6 or 2.7. You'll be prompted to install Python if it's not installed already. Python is not required for NGINX Controller 3.7 and later.

      {{< /call-out >}}


## Uninstall the Analytics, Visibility, and Reporting Daemon (AVRD)

NGINX Controller uses an [Analytics, Visibility, and Reporting daemon (AVRD)]({{< ref "/controller/analytics/metrics/overview-metrics-metadata.md" >}}) to aggregate and report app-centric metrics. You can use these metrics to monitor your apps' performance and health.

To uninstall AVRD and the supporting modules, run the following command on each dataplane instance:

- Debian/Ubuntu

    ```bash
    sudo apt-get purge avrd nginx-plus-module-metrics avrd-libs
    ```

- RedHat/CentOS

    ```bash
    sudo yum remove avrd avrd-metrics nginx-plus-module-metrics
    ```


## Uninstall the NGINX Controller Agent and Delete an Instance

Take the following steps to uninstall the Controller Agent and delete an instance.

{{< call-out "important" >}}Be sure to uninstall the Controller Agent first, before you delete an instance. If you don't uninstall the Controller Agent first, the instance may reappear in NGINX Controller after it has been deleted.{{< /call-out >}}

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

    {{< call-out "note" >}}When you delete an instance, any related alerts for that instance are not deleted automatically. You can delete the alerts manually, however.{{< /call-out >}}

   1. Open the NGINX Controller user interface and log in.
   2. On the Analytics menu, select **Alerts > Alert Rules**.
   3. Select the alert rule that you want to delete.
   4. Select the delete (trash can) icon to delete the alert rule.
   5. Select **Delete** in the pop-up box to confirm that you want to proceed.


## What's Next

- [Customize how the NGINX Controller Agent collects metrics]({{< ref "/controller/admin-guides/config-agent/configure-the-agent.md" >}})
- [Start or Stop the Agent Service]({{< ref "/controller/admin-guides/install/agent-restart.md" >}})
- [Manage your NGINX Instances]({{< ref "/controller/infrastructure/instances/manage-instances.md" >}})
- [Manage Locations for your Instances]({{< ref "/controller/infrastructure/locations/manage-locations.md" >}})

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
