---
description: How to install the F5 NGINX Controller Agent to run as a non-root user.
docs: DOCS-253
title: Install NGINX Controller Agent for Non-root Users
toc: true
weight: 205
type:
- tutorial
---

## Overview

This document provides the instructions to run F5 NGINX Controller Agent as a non-root user, by making a few adjustments to the deployment process.

&nbsp;

---

## Before You Begin

Before you follow the steps to deploy and run the Controller Agent as a non-root user, [install NGINX Controller]({{< ref "/controller/admin-guides/install/install-nginx-controller" >}}) following the normal installation process. Once you reach the step **Install NGINX Controller Agent** follow the steps in this guide instead.

&nbsp;

---

## Install NGINX Controller Agent to Run as a Non-root User

Take the following steps to add an instance to NGINX Controller:

1. Open the NGINX Controller user interface and log in.
1. Select the NGINX Controller menu icon, then select **Infrastructure**.
1. On the **Infrastructure** menu, select **Instances** > **Overview**.
1. On the **Instances** overview page, select **Create**.
1. On the **Create Instance** page, select **Add an existing instance**.
1. Add a name for the instance. If you don't provide a name, the hostname of the instance is used by default.
1. To add the instance to an existing Location, select a Location from the list. Or to create a Location, select **Create New**.

    {{< important >}}
Once set, the Location for an instance cannot be changed. If you need to change or remove the Location for an instance, you must [remove the instance from NGINX Controller]({{< ref "/controller/infrastructure/instances/manage-instances.md#delete-an-instance" >}}), and then add it back.
    {{< /important >}}

1. (Optional) By default, registration of NGINX Plus instances is performed over a secure connection. To use self-signed certificates with the Controller Agent, select **Allow insecure server connections to NGINX Controller using TLS**. For security purposes, we recommend that you secure the Controller Agent with signed certificates when possible.
1. Use SSH to connect and log in to the NGINX instance that you want to connect to NGINX Controller.
1. Copy the `curl` or `wget` command that's shown in the **Installation Instructions** section on the NGINX instance to download and install the Controller Agent package. When specified, the `-i` and `-l` options for the `install.sh` script refer to the instance name and Location, respectively. **You need to modify this command to use a non-root user**
1. Add the parameter `CONTROLLER_USER='<non-root user of your choice>'` to the `curl` or `wget` command, substituting the value in the brackets with your desired non-root user.
1. (Optional) Add the parameter `CONTROLLER_GROUP='<group choice>'` to the `curl` or `wget` command, substituting the value in the brackets with your desired group. If this parameter is not set, a new group with the same name as the user will be created.
1. The `curl` or `wget` command looks similar to this example after applying the required changes:

    ```bash
    curl -sS -L https://<controller FQDN>/install/controller-agent > install.sh && API_KEY='<API KEY>' CONTROLLER_USER='<non-root user>' CONTROLLER_GROUP='<optional group>' -i <instance name> -l <instance location>
    ```

    {{< note >}}

Make sure you enter the commands to download and run the `install.sh` script on the NGINX Plus system, and not on the NGINX Controller.

NGINX Controller 3.6 and earlier require Python 2.6 or 2.7. You'll be prompted to install Python if it's not installed already. Python is not required for NGINX Controller v3.7 and later.

If `CONTROLLER_USER` is not set, during the installation you will see the message `Installing agent to run as root` in red.

Running agent as non-root changes the nap-syslog port to `5114` in both containerized and non-containerized instances.

    {{< /note >}}

&nbsp;

After a few minutes, the NGINX instance will appear on the **Instances** overview page.

For the NGINX Agent to run properly, NGINX Plus **must** be running as the same user and group as the Agent. To change the user and group NGINX Plus is running as after installing the agent:

1. Manually edit the `/lib/systemd/system/nginx.service` file and under the `[Service]` block add the lines `User=<non-root-user>` and `Group=<optional group>` replacing the values in brackets with the values chosen during the installation.
1. Run `sudo chown -R <non-root-user>:<optional group> /etc/nginx/ /var/log/nginx/ /var/cache/nginx/` to change the permissions to your non-root user.
1. Ensure the ports NGINX is listening to are all above 1000: Check the NGINX `default.conf` file (usually `/etc/nginx/conf.d/default.conf`) and make sure that the `listen` values are all over `1000`.
1. (CentOS/RHEL) If you're installing the Controller Agent as a non-root user on CentOS or RHEL, make these additional changes:

    - In in the `[Service]` section of `/lib/systemd/system/nginx.service`, set the location for the `PIDfile` to:

       ```nginx
       [Service]
       PIDFile=/var/tmp/nginx.pid
       ```

    - In `/etc/nginx/nginx.conf`, set the `pid` directive to:

        ```nginx
        pid        /var/tmp/nginx.pid;
        ```


1. Run `sudo systemctl daemon-reload && sudo systemctl restart nginx` to pick up the new configuration.

&nbsp;

---

## Verification Steps

Run `top -u <non-root-user>` for your chosen user. The `/usr/bin/nginx-controller-agent` process will appear in the list of processes.


{{< versions "3.16" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
