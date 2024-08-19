---
description: Follow the steps in this guide to install the NGINX Plus dynamic metrics
  module and configure NGINX Agent to push app-centric metrics to NGINX Management
  Suite.
docs: DOCS-1099
doctypes:
- task
tags:
- docs
title: Install NGINX Plus Metrics Module
toc: true
weight: 110
---

## Overview

The NGINX Plus metrics module is a dynamic module that you can install on your NGINX Plus data plane instances. The metrics module reports advanced, app-centric metrics and dimensions like “application name” or “gateway” to the NGINX Agent, which then aggregates and publishes the data to the NGINX Management Suite. Advanced, app-centric metrics are used by particular NGINX Management Suite modules for features associated with HTTP requests.

---

## Before You Begin

Complete the following prerequisites before proceeding with the steps in this guide. This guide assumes that you have NGINX Management Suite installed and configured.

- Check that your NGINX data plane instances are running **NGINX Plus R24 or later**.

  To see which version of NGINX Plus is running on your instance, run the following command:

    ```bash
    ps aux | grep nginx
    ```

    <details open>
    <summary><i class="fa-solid fa-circle-info"></i> Supported distributions</summary>

    {{< include "agent/installation/advanced-metrics-distros.md" >}}

    </details>

- Verify that [NGINX Agent]({{< relref "/nms/nginx-agent/install-nginx-agent.md" >}}) is installed on each NGINX Plus instance.

---

## Stop NGINX Agent process

Before you install the NGINX Plus metrics module, you'll need to stop the NGINX Agent process on the data plane instance.
Do not push configuration changes to the impacted instance, or any instance group that contains the impacted instance, while the `nginx-agent` process is stopped.

1. Open an SSH connection to the data plane host and log in.
1. Run the following command to check whether NGINX Agent is running:

    ```bash
    ps aux | grep nginx-agent
    ```

1. Run the command below to stop NGINX Agent:

    ```bash
    sudo systemctl stop nginx-agent
    ```

---

## Install NGINX Plus Metrics Module

### Install from NGINX Management Suite Package Repository (Recommended)

{{< include "installation/add-nms-repo.md" >}}

3. Install the NGINX Plus metrics module using the appropriate command for your OS:

    - CentOS, RHEL, RPM-Based

        ```bash
        sudo yum update
        sudo yum install nginx-plus-module-metrics
        ```

    - Debian, Ubuntu, Deb-Based

        ```bash
        sudo apt update
        sudo apt install nginx-plus-module-metrics
        ```

### Install from NGINX Management Suite

To install the NGINX Plus metrics module from NGINX Management Suite, use a command-line tool like `curl` or `wget`.

We highly recommend that you encrypt all traffic between NGINX Agent and NGINX Management Suite. You can find instructions in the [Encrypt Agent Communications](https://docs.nginx.com/nginx-agent/configuration/encrypt-communication/) guide.

If your NGINX Management Suite deployment is non-production and doesn't have valid TLS certificates, you will need to use the tool's "insecure" option to complete the installation.

In the examples provided, the command shown downloads the package from the NGINX Management Suite host, then runs the installation script.
In the secure example, the `--skip-verify false` flag tells NGINX Agent to verify the validity of the certificates used for mTLS.

- Secure (recommended):

    ```bash
    curl https://<NMS_FQDN>/install/nginx-plus-module-metrics | sudo sh -s -- --skip-verify false
    ```

- Insecure:

    ```bash
    curl --insecure https://<NMS_FQDN>/install/nginx-plus-module-metrics | sudo sh
    ```

## Configure NGINX Agent to use Advanced Metrics

{{< include "agent/installation/enable-advanced-metrics.md" >}}

<br>

## Start NGINX Agent

After you install the NGINX Plus metrics module, run the command below to start the NGINX Agent:

```bash
sudo systemctl start nginx-agent
```

After completing the steps in this guide, you will start to see app-centric metrics displayed in the NGINX Management Suite user interface. You can also collect metrics by using the REST API. To learn more, refer to [Using the Metrics API]({{< relref "/nms/nim/tutorials/metrics/metrics-api" >}}).
