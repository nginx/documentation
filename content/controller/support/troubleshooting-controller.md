---
description: Steps to take to investigate and fix issues with F5 NGINX Controller
  and the Controller Agent.
docs: DOCS-376
title: Troubleshoot NGINX Controller and the Controller Agent
toc: true
weight: 100
type:
- tutorial
---

## Overview

If NGINX isn't behaving how you expect, you can take the following steps to troubleshoot issues. If you need to [contact F5 NGINX Support]({{< relref "/controller/support/contact-support.md" >}}), make sure to [create a support package](#create-a-support-package) first.

## Fix NGINX Controller Issues by Upgrading

We recommend you [upgrade NGINX Controller]({{< relref "/controller/admin-guides/install/install-nginx-controller.md#update-nginx-controller" >}}) as new versions become available. Upgrades include new features, feature improvements, or fixes for known issues.

To look up your version of NGINX Controller:

1. Open the NGINX Controller browser interface and log in.
1. Select the NGINX Controller menu icon, then select **Platform**.
1. On the Platform menu, select **Cluster** > **Overview**.

{{< see-also >}}Refer to the [NGINX Controller release notes]({{< relref "/controller/releases/" >}}) to see what's new in the latest release of NGINX Controller.{{< /see-also >}}

&nbsp;

---

## Create a Support Package

You can create a support package for NGINX Controller that you can use to diagnose issues.

{{< note >}}
You will need to provide a support package if you open a ticket with NGINX Support via the [MyF5 Customer Portal](https://account.f5.com/myf5).
{{< /note >}}&nbsp;

```bash
/opt/nginx-controller/helper.sh supportpkg [-o|--output <file name>] [-s|--skip-db-dump] [-t|--timeseries-dump <hours>]
```

<style>
table, th, td {
  border: 1px solid #CCC;
  border-collapse: collapse;
}
th, td {
  padding: 5px;
}
th {
  text-align: center;
}
</style>

| Options  | Description |
|----------|-------------|
| `-o` \| `--output`  | Save the support package file to `<file name>`. |
| `-s` \| `--skip-db-dump` | Don't include the database dump in the support package. |
| `-t` \| `--timeseries-dump <hours>` | Include the last `<n hours>` of timeseries data in the support package (default 12 hours). |

Take the following steps to create a support package:

1. Open a secure shell (SSH) connection to the NGINX Controller host and log in as an administrator.

1. Run the `helper.sh` utility with the `supportpkg` option:

    ```bash
    /opt/nginx-controller/helper.sh supportpkg
    ```

    The support package is saved to:

    `/var/tmp/supportpkg-<timestamp>.tar.gz`

    For example:

    `/var/tmp/supportpkg-20200127T063000PST.tar.gz`

1. Run the following command on the machine where you want to download the support package to:

    ``` bash
    scp <username>@<controller-host-ip>:/var/tmp/supportpkg-<timestamp>.tar.gz /local/path
    ```

### Support Package Details

{{< include "controller/helper-script-support-package-details.md" >}}



&nbsp;

---

## Security Events Not Available



If NGINX Controller isn't logging WAF Violation Security Events for an App Component that has WAF enabled, take the following steps:

1. Check the `agent.conf` security setting for every Instance referenced by the Gateway(s) associated with the App Component. You'll need to verify that the Extensions group contains the setting `security = True`.
2. Restart the NGINX Controller Agent.

To start, stop, and restart the NGINX Controller Agent, run the following commands on the NGINX Plus system where you installed the Agent.

Start the NGINX Controller Agent:

```bash
service controller-agent start
```

Stop the NGINX Controller Agent:

```bash
service controller-agent stop
```

Restart the NGINX Controller Agent:

```bash
service controller-agent restart
```



&nbsp;

---

## Signature Name missing in Security Violation Events



If you don't see **Signature Names** in **Security Violation Events**, restart the Controller Agent on the dataplane instance.

```bash
sudo systemctl restart controller-agent
```



&nbsp;

---

## Controller Agent Install Script Failed to Download

When deploying an NGINX Plus instance, the deployment may fail because the Controller Agent install script doesn't download. When this happens, an error similar to the following is logged to `/var/log/agent_install.log`: "Failed to download the install script for the agent."

Take the following steps to troubleshoot the issue:

- Ensure that ports 443 and 8443 are open between NGINX Controller and the network where the NGINX Plus instance is being deployed.
- Verify that you can communicate with NGINX Controller from the NGINX Plus instance using the NGINX Controller FQDN that you provided when you installed NGINX Controller.
- If you're [deploying an NGINX Plus instance on Amazon Web Services]({{< relref "/controller/infrastructure/instances/add-aws-instance.md" >}}) using a template, ensure that the Amazon Machine Image (AMI) referenced in the `instance_template` has a cURL version of 7.32 or newer.

&nbsp;

---

## Controller Agent Asks for Password

If the system asks you to provide a password when you're installing the Controller Agent, the cause may be that you are starting the install script from a non-root account. If so, you need sudo rights. Depending on your system configuration, sudo may ask you for a password if you're using a non-root account.

&nbsp;

---

## Controller Agent Isn't Reporting Metrics

<a name="troubleshooting-metrics"></a>

After you install and start the Controller Agent, it should begin reporting right away, pushing aggregated data to NGINX Controller at regular one-minute intervals. It takes about one minute for a new Instance to appear in the NGINX Controller user interface.

If you don't see the new Instance in the user interface or the Controller Agent isn't collecting metrics, make sure of the following:

1. The Controller Agent package -- `nginx-controller-agent` -- installed successfully without any warnings.
1. The controller-agent service is running and updating its log file. To check the status, run the following command:

    ```bash
    systemctl status controller-agent
    ```

    {{< see-also >}}
For troubleshooting purposes, you can turn on Controller Agent debug logging by editing the `agent.conf` file. For more information, refer to [K64001240: Enabling NGINX Controller Agent debug logging](https://support.f5.com/csp/article/K64001240).
    {{< /see-also >}}

1. The system DNS resolver is correctly configured, and the NGINX Controller server's fully qualified domain name (FQDN) can be resolved.
1. The controller-agent service can be running as `root` or a different user, chosen during the installation if the Controller Agent was [installed to run as a non-root user]({{< relref "/controller/admin-guides/install/install-agent-non-root.md" >}}). To view the user ID for the controller-agent service, run the following command:

    ```bash
    ps -ef | egrep 'agent'
    ```

    The output looks similar to the following (with a different user for non-root Agent installations):

    ```lang-none
    root     19132     1  1 Sep03 ?        00:23:45 /usr/bin/nginx-controller-agent
    ```

1. The Controller Agent and the NGINX Instance user IDs can both run the `ps` command to see all the system processes. If the `ps` command is restricted for non-privileged users, the Controller Agent won't detect the NGINX master process.
1. The system time is set correctly. If the time on the system where the Controller Agent is running is ahead or behind the NGINX Controller's system time, you won't be able to see data in  graphs. Make sure that NGINX Controller and any NGINX Instances have their time synchronized using [NTP](http://www.ntp.org).
1. The NGINX Plus API is set up correctly and working.

   Refer to the [Configuring the API](https://docs.nginx.com/nginx/admin-guide/monitoring/live-activity-monitoring/#configuring-the-api) section of the NGINX Plus Admin Guide for instructions.
1. All NGINX configuration files are readable by the Controller Agent user ID. Verify the owner, group, and permissions settings.
1. `selinux`, `apparmor`, or other third-party OS security tools are not interfering with the metrics collection. For example, for `selinux`, inspect  `/etc/selinux/config` and try `setenforce 0` temporarily to see if it improves the situation for certain metrics.
1. The virtual private server (VPS) provider has not used hardened Linux kernels that may restrict non-root users from accessing `/proc` and `/sys`. Metrics describing the system and NGINX disk I/O are usually affected. There is no easy workaround for this except to allow the Controller Agent to run as `root`. Fixing permissions for `/proc` and `/sys/block` may also help.

{{< see-also >}}

For more information on installing and configuring the Controller Agent, see the following topics:

- [Installing the NGINX Controller Agent]({{< relref "/controller/admin-guides/install/install-nginx-controller-agent.md" >}})
- [Installing the NGINX Controller Agent for non-root users]({{< relref "/controller/admin-guides/install/install-agent-non-root.md" >}})
- [Configuring the NGINX Controller Agent]({{< relref "/controller/admin-guides/config-agent/configure-the-agent.md" >}})
- [Configuring metrics collection for NGINX Controller]({{< relref "/controller/admin-guides/config-agent/configure-metrics-collection.md" >}})

{{< /see-also >}}

&nbsp;

---

## Licensing

If NGINX Controller appears to be unlicensed after a version upgrade, try the following options to resolve the issue.

- [Re-upload your NGINX Controller license]({{< relref "/controller/platform/licensing-controller.md#add-or-update-a-license" >}}).
- [Restore the NGINX Controller database from a backup]({{< relref "/controller/admin-guides/backup-restore/_index.md" >}}).

&nbsp;

---

## Events Don't Display in the Analytics User Interface



Certain content-filtering and ad-blocking web browser extensions may incorrectly block the elements on the NGINX Controller Analytics events page. As a result, when you access the **Analytics > Events** page using the NGINX Controller user interface, you may observe messages indicating missing events. Refer to the AskF5 KB article [K48603454](https://support.f5.com/csp/article/K48903454) to learn more about this issue and how to resolve it.



{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
