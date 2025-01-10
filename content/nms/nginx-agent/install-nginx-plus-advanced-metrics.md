---
title: Install NGINX Plus Metrics Module for API Connectivity Manager
description: Follow the steps in this guide to install the F5 NGINX Plus dynamic metrics
  module and configure NGINX Agent to push app-centric metrics to API Connectivity Manager.
weight: 110
toc: true
type: how-to
docs: DOCS-1099
---

{{< eol-call-out "warning" "End of Sale Notice:" >}} F5 NGINX is announcing the End of Sale (EoS) for NGINX Instance Manager API Connectivity Manager Module, effective January 1, 2024.

F5 maintains generous lifecycle policies that allow customers to continue support and receive product updates. Existing API Connectivity Manager Module customers can continue to use the product past the EoS date. License renewals are not available after September 30, 2024.

See our End of Sale announcement for more details. {{< /eol-call-out >}}

## Overview

The F5 NGINX Plus metrics module is a dynamic module that you can install on your NGINX Plus data plane instances for use with API Connectivity Manager. The metrics module reports advanced, app-centric metrics and dimensions like “application name” or “gateway” to the NGINX Agent, which then aggregates and publishes the data to API Connectivity Manager. Advanced, app-centric metrics are used by particular API Connectivity Manager for features associated with HTTP requests.

This module is not required or necessary for NGINX Instance Manager. 

---

## Before You Begin

Complete the following prerequisites before proceeding with the steps in this guide. This guide assumes that you have NGINX Management Suite installed and configured with the API Connectivity Manager module.

- Check that your NGINX data plane instances are running **NGINX Plus R24** (last supported version of this module is NGINX Plus R33).

  To see which version of NGINX Plus is running on your instance, run the following command:

    ```bash
    ps aux | grep nginx
    ```

    <details open>
    <summary><i class="fa-solid fa-circle-info"></i> Supported distributions</summary>

    The NGINX Plus metrics module works with the following Linux distributions:

    {{<bootstrap-table "table table-striped table-bordered">}}

    | Distribution | Version(s)                           |
    | ------------ | ------------------------------------ |
    | Amazon Linux | 2 LTS                                |
    | CentOS       | 7.4 and later in the 7.x family      |
    | Debian       | 10 _buster-slim_, 11 _bullseye-slim_ |
    | RHEL         | 8.x and later in the 8.x family      |
    | Ubuntu       | 18.08, 20.04, 22.04                  |

    {{</bootstrap-table>}}

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

### Install from NGINX Management Suite (only supported in version 2.18 or earlier)

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

NGINX Plus advanced metrics are application-centric metrics collected by the NGINX Agent.

To enable advanced metrics, edit the `/etc/nginx-agent/nginx-agent.conf` file and add the following directives:

```yaml
extensions:
  - advanced-metrics
advanced_metrics:
  socket_path: /var/run/nginx-agent/advanced-metrics.sock
  aggregation_period: 1s
  publishing_period: 3s
  table_sizes_limits:
    staging_table_max_size: 1000
    staging_table_threshold: 1000
    priority_table_max_size: 1000
    priority_table_threshold: 1000
```

{{< see-also >}} See the [NGINX Agent CLI Flags & Usage]({{< relref "/nms/nginx-agent/install-nginx-agent.md#nginx-agent-cli-flags--usage" >}}) topic for a description of each of these flags. {{< /see-also >}}

<br>

## Start NGINX Agent

After you install the NGINX Plus metrics module, run the command below to start the NGINX Agent:

```bash
sudo systemctl start nginx-agent
```

After completing the steps in this guide, you will start to see app-centric metrics displayed in the NGINX Management Suite user interface. You can also collect metrics by using the REST API. To learn more, refer to [Using the Metrics API]({{< relref "/nim/monitoring/metrics-api" >}}).
