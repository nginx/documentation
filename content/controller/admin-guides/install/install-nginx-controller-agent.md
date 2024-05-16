---
description: How to install, upgrade, and uninstall the NGINX Controller Agent.
docs: DOCS-254
doctypes:
- tutorial
- troubleshooting
tags:
- docs
title: Install NGINX Controller Agent
toc: true
weight: 150
---

## Overview

This page shows how to install, update, and uninstall the NGINX Controller Agent.

You can use the NGINX Controller Agent to monitor your systems with the NGINX Controller.

## Objectives

- Install the NGINX Controller Agent
- Upgrade the NGINX Controller Agent to a newer version
- Uninstall the NGINX Controller Agent

## Install the NGINX Controller Agent

{{< see-also >}} If you want to run the NGINX Controller Agent as a non-root user, follow the alternative instructions in the [Install NGINX Controller Agent for Non-root User]({{< relref "/controller/admin-guides/install/install-agent-non-root.md" >}}) guide instead of the steps provided in this section. {{< /see-also >}}

{{< include "controller/add-existing-instance.md" >}}

## Update the NGINX Controller Agent

When you [update NGINX Controller]({{< relref "/controller/admin-guides/install/install-nginx-controller.md#update-nginx-controller" >}}), you also need to update the NGINX Controller Agent software on each monitored NGINX Plus instance.

To update the NGINX Controller Agent, take the following steps:

1. Open the NGINX Controller user interface and log in.
1. Select the NGINX Controller menu icon, then select **Infrastructure**.
1. On the **Infrastructure** menu, select **Instances** > **Overview**.
1. On the **Instances** overview page, select **Create**.
1. Follow the instructions in the **Install Instructions** pane to connect to the NGINX instance and install the updated Controller Agent package.

      {{< note >}}

NGINX Controller 3.6 and earlier require Python 2.6 or 2.7. You'll be prompted to install Python if it's not installed already. Python is not required for NGINX Controller 3.7 and later.

      {{< /note >}}


## Uninstall the Analytics, Visibility, and Reporting Daemon (AVRD)

NGINX Controller uses an [Analytics, Visibility, and Reporting daemon (AVRD)]({{< relref "/controller/analytics/metrics/overview-metrics-metadata.md" >}}) to aggregate and report app-centric metrics. You can use these metrics to monitor your apps' performance and health.

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


## What's Next

- [Customize how the NGINX Controller Agent collects metrics]({{< relref "/controller/admin-guides/config-agent/configure-the-agent.md" >}})
- [Start or Stop the Agent Service]({{< relref "/controller/admin-guides/install/agent-restart.md" >}})
- [Manage your NGINX Instances]({{< relref "/controller/infrastructure/instances/manage-instances.md" >}})
- [Manage Locations for your Instances]({{< relref "/controller/infrastructure/locations/manage-locations.md" >}})

{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
