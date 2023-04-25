---
authors: []
categories:
- installation
- infrastructure
- platform management
date: "2020-10-26T15:32:41-06:00"
description: Steps to take to investigate and fix issues with NGINX Controller and
  the Controller Agent
docs: DOCS-376
doctypes:
- tutorial
- troubleshooting
draft: false
journeys:
- using
- self service
personas:
- devops
- netops
- secops
- support
roles:
- admin
- user
tags:
- docs
title: Troubleshoot NGINX Controller and the Controller Agent
toc: true
weight: 100
---

## Overview

If NGINX isn't behaving how you expect, you can take the following steps to troubleshoot issues. If you need to [contact NGINX Support]({{< relref "/support/contact-support.md" >}}), make sure to [create a support package](#create-a-support-package) first.

## Fix NGINX Controller Issues by Upgrading



{{< include "support/upgrade-to-fix-issues.md" >}}



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

{{< include "controller/installer/helper-script/support-package-details.md" >}}



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
- If you're [deploying an NGINX Plus instance on Amazon Web Services]({{< relref "/infrastructure/instances/add-aws-instance.md" >}}) using a template, ensure that the Amazon Machine Image (AMI) referenced in the `instance_template` has a cURL version of 7.32 or newer.
  
&nbsp;

---

## Controller Agent Asks for Password



{{< include "support/controller-agent-prompt-for-password.md" >}}



&nbsp;

---

## Controller Agent Isn't Reporting Metrics

<a name="troubleshooting-metrics"></a>



{{< include "support/controller-agent-no-metrics.md" >}}



&nbsp;

---

## Licensing



{{< include "licensing/troubleshoot-license.md" >}}



&nbsp;

---

## Events Don't Display in the Analytics User Interface



Certain content-filtering and ad-blocking web browser extensions may incorrectly block the elements on the NGINX Controller Analytics events page. As a result, when you access the **Analytics > Events** page using the NGINX Controller user interface, you may observe messages indicating missing events. Refer to the AskF5 KB article [K48603454](https://support.f5.com/csp/article/K48903454) to learn more about this issue and how to resolve it.



{{< versions "3.0" "latest" "ctrlvers" >}}
{{< versions "3.18" "latest" "apimvers" >}}
{{< versions "3.20" "latest" "adcvers" >}}
